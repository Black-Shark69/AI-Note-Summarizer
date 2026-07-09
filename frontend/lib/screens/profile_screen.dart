import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';
import '../services/api_service.dart';
import 'landing_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = '';
  String _email = '';
  String _role = '';
  List _summaries = [];
  bool _isLoading = true;
  bool _isEditing = false;

  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final name = await AuthService.getUserName();
    final email = await AuthService.getUserEmail();
    final role = await AuthService.getUserRole();
    final token = await AuthService.getToken();
    setState(() {
      _name = name ?? '';
      _email = email ?? '';
      _role = role ?? '';
      _nameController.text = _name;
      _emailController.text = _email;
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

  Future<void> _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LandingScreen()));
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
      await _loadProfile();
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

  void _showSummaryDetail(Map s) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEDFE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.description_outlined,
                  color: Color(0xFF534AB7), size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                s['note_title'] ?? 'Summary',
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEDFE),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  (s['length_type'] ?? 'short').toUpperCase(),
                  style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF534AB7),
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFEB),
                  borderRadius: BorderRadius.circular(8),
                  border: const Border(
                      left:
                      BorderSide(color: Color(0xFF534AB7), width: 3)),
                ),
                child: Text(
                  s['summary_text'] ?? 'No summary available',
                  style:
                  const TextStyle(fontSize: 13, height: 1.7, color: Color(0xFF1A1A18)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteSummary(s['id']);
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
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE0DED8)),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: const Color(0xFF534AB7),
                  child: Text(
                    _name.isNotEmpty ? _name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                Text(_name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(_email,
                    style: const TextStyle(
                        color: Color(0xFF5F5E5A), fontSize: 13)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEDFE),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    _role.toUpperCase(),
                    style: const TextStyle(
                        color: Color(0xFF534AB7),
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Stats
          Row(
            children: [
              _statCard('${_summaries.length}', 'Total summaries',
                  const Color(0xFFEEEDFE), const Color(0xFF534AB7)),
              const SizedBox(width: 10),
              _statCard('3.2h', 'Time saved', const Color(0xFFE1F5EE),
                  const Color(0xFF0F6E56)),
            ],
          ),
          const SizedBox(height: 12),

          // Info rows with edit
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0DED8)),
            ),
            child: Column(
              children: [
                // Edit toggle header
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      const Text('Profile info',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() => _isEditing = !_isEditing);
                          if (!_isEditing) {
                            setState(() {
                              _name = _nameController.text;
                              _email = _emailController.text;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile updated!'),
                                backgroundColor: Color(0xFF0F6E56),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: _isEditing
                                ? const Color(0xFF534AB7)
                                : const Color(0xFFEEEDFE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _isEditing ? 'Save' : 'Edit',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _isEditing
                                  ? Colors.white
                                  : const Color(0xFF534AB7),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE0DED8)),

                // Name
                _isEditing
                    ? _editRow(Icons.person_outline, 'Name', _nameController)
                    : _infoRow(Icons.person_outline, 'Name', _name),
                _divider(),

                // Email
                _isEditing
                    ? _editRow(Icons.email_outlined, 'Email', _emailController)
                    : _infoRow(Icons.email_outlined, 'Email', _email),
                _divider(),

                _infoRow(Icons.school_outlined, 'Institution', 'NUBT Khulna'),
                _divider(),
                _infoRow(Icons.calendar_today_outlined, 'Joined', 'January 2025'),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // History
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0DED8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Summary history',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('${_summaries.length} total',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF5F5E5A))),
                  ],
                ),
                const SizedBox(height: 10),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _summaries.isEmpty
                    ? Container(
                  padding: const EdgeInsets.all(20),
                  child: const Center(
                    child: Column(
                      children: [
                        Icon(Icons.note_alt_outlined,
                            size: 36, color: Color(0xFF9C9A92)),
                        SizedBox(height: 8),
                        Text('No summaries yet',
                            style: TextStyle(
                                color: Color(0xFF5F5E5A))),
                      ],
                    ),
                  ),
                )
                    : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _summaries.length,
                  separatorBuilder: (_, __) => const Divider(
                      height: 1, color: Color(0xFFE0DED8)),
                  itemBuilder: (_, i) {
                    final s = _summaries[i];
                    return ListTile(
                      onTap: () => _showSummaryDetail(s),
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEDFE),
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                        child: const Icon(
                            Icons.description_outlined,
                            color: Color(0xFF534AB7),
                            size: 18),
                      ),
                      title: Text(
                          s['note_title'] ?? 'Untitled',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                      subtitle: Text(
                          s['length_type'] ?? 'short',
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF5F5E5A))),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                                Icons.delete_outline,
                                color: Color(0xFFA32D2D),
                                size: 18),
                            onPressed: () =>
                                _deleteSummary(s['id']),
                          ),
                          const Icon(Icons.chevron_right,
                              color: Color(0xFF9C9A92)),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Logout button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout, color: Color(0xFFA32D2D)),
              label: const Text('Sign out',
                  style: TextStyle(color: Color(0xFFA32D2D))),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Color(0xFFF09595)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _editRow(IconData icon, String label, TextEditingController ctrl) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF5F5E5A)),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF5F5E5A))),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: ctrl,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 8),
                filled: true,
                fillColor: const Color(0xFFEFEFEB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: Color(0xFF534AB7)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: Color(0xFF534AB7), width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, Color bg, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color)),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF5F5E5A))),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF5F5E5A)),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF5F5E5A))),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _divider() =>
      const Divider(height: 1, color: Color(0xFFE0DED8));
}