import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';
import '../services/api_service.dart';
import 'landing_screen.dart';
import 'summarize_screen.dart';
import 'profile_screen.dart';
import 'admin_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _name = '';
  String _role = '';
  List _summaries = [];
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final name = await AuthService.getUserName();
    final role = await AuthService.getUserRole();
    final token = await AuthService.getToken();
    setState(() {
      _name = name ?? '';
      _role = role ?? '';
    });
    if (token != null) {
      try {
        final res = await ApiService.getSummaries(token);
        setState(() {
          _summaries = res['summaries'] ?? [];
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteSummary(int id) async {
    final token = await AuthService.getToken();
    if (token == null) return;
    try {
      await http.delete(
        Uri.parse('http://localhost:5000/api/summaries/$id'),
        headers: {'authorization': token},
      );
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Summary deleted successfully'),
            backgroundColor: Color(0xFF0F6E56),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete summary')),
        );
      }
    }
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LandingScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF534AB7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Text('NoteAI',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A18))),
          ],
        ),
        actions: [
          if (_role == 'admin')
            IconButton(
              icon: const Icon(Icons.shield_outlined, color: Color(0xFFA32D2D)),
              tooltip: 'Admin Panel',
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AdminScreen())),
            ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF5F5E5A)),
            onPressed: _logout,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE0DED8), height: 1),
        ),
      ),
      body: _selectedIndex == 0
          ? _buildDashboard()
          : _selectedIndex == 1
          ? const SummarizeScreen()
          : const ProfileScreen(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) {
          setState(() => _selectedIndex = i);
          if (i == 0) _loadData();
        },
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFEEEDFE),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Color(0xFF534AB7)),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_note_outlined),
            selectedIcon: Icon(Icons.edit_note, color: Color(0xFF534AB7)),
            label: 'Summarize',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFF534AB7)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF534AB7), Color(0xFF3C3489)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back,',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14)),
                      Text(_name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(_role.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.school, color: Colors.white, size: 48),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Stats row
          Row(
            children: [
              _statCard('${_summaries.length}', 'Summaries',
                  Icons.text_snippet_outlined,
                  const Color(0xFFEEEDFE), const Color(0xFF534AB7)),
              const SizedBox(width: 10),
              _statCard('3.2h', 'Time saved', Icons.timer_outlined,
                  const Color(0xFFE1F5EE), const Color(0xFF0F6E56)),
              const SizedBox(width: 10),
              _statCard('84%', 'Reduction', Icons.trending_down,
                  const Color(0xFFFAEEDA), const Color(0xFF633806)),
            ],
          ),
          const SizedBox(height: 16),

          // Admin panel quick access
          if (_role == 'admin') ...[
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AdminScreen())),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCEBEB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF09595)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_outlined,
                        color: Color(0xFFA32D2D), size: 20),
                    SizedBox(width: 10),
                    Text('Open Admin Panel',
                        style: TextStyle(
                            color: Color(0xFFA32D2D),
                            fontWeight: FontWeight.bold)),
                    Spacer(),
                    Icon(Icons.chevron_right, color: Color(0xFFA32D2D)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Upload button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => setState(() => _selectedIndex = 1),
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload note & summarize'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF534AB7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Recent summaries
          const Text('Recent summaries',
              style:
              TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _summaries.isEmpty
              ? Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0DED8)),
            ),
            child: const Center(
              child: Column(
                children: [
                  Icon(Icons.note_alt_outlined,
                      size: 40, color: Color(0xFF9C9A92)),
                  SizedBox(height: 8),
                  Text('No summaries yet',
                      style:
                      TextStyle(color: Color(0xFF5F5E5A))),
                ],
              ),
            ),
          )
              : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _summaries.length > 5
                ? 5
                : _summaries.length,
            separatorBuilder: (_, __) =>
            const SizedBox(height: 8),
            itemBuilder: (_, i) =>
                _summaryCard(_summaries[i]),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, IconData icon,
      Color bgColor, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: iconColor)),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF5F5E5A))),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(Map summary) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      color: const Color(0xFFEEEDFE),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.description_outlined,
                      color: Color(0xFF534AB7), size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(summary['note_title'] ?? 'Summary',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: const Color(0xFFEEEDFE),
                        borderRadius: BorderRadius.circular(99)),
                    child: Text(
                        (summary['length_type'] ?? 'short')
                            .toUpperCase(),
                        style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF534AB7),
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEFEB),
                      borderRadius: BorderRadius.circular(8),
                      border: const Border(
                          left: BorderSide(
                              color: Color(0xFF534AB7), width: 3)),
                    ),
                    child: Text(
                        summary['summary_text'] ??
                            'No summary available',
                        style: const TextStyle(
                            fontSize: 13, height: 1.7)),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  await _deleteSummary(summary['id']);
                },
                icon: const Icon(Icons.delete_outline,
                    color: Color(0xFFA32D2D), size: 16),
                label: const Text('Delete',
                    style: TextStyle(color: Color(0xFFA32D2D))),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close',
                    style: TextStyle(color: Color(0xFF534AB7))),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0DED8)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEDFE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.description_outlined,
                  color: Color(0xFF534AB7), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    summary['note_title'] ?? 'Untitled',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    summary['length_type'] ?? 'short',
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF5F5E5A)),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEEEDFE),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                summary['length_type'] ?? 'short',
                style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF534AB7),
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right,
                color: Color(0xFF9C9A92), size: 18),
          ],
        ),
      ),
    );
  }
}