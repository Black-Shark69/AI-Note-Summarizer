import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List _summaries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final token = await AuthService.getToken();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA32D2D),
        title: const Row(
          children: [
            Icon(Icons.shield_outlined, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Admin Panel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.red.shade900, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats
            Row(
              children: [
                _statCard('${_summaries.length}', 'Summaries', Icons.text_snippet_outlined, const Color(0xFFEEEDFE), const Color(0xFF534AB7)),
                const SizedBox(width: 10),
                _statCard('1', 'Users', Icons.people_outline, const Color(0xFFE1F5EE), const Color(0xFF0F6E56)),
                const SizedBox(width: 10),
                _statCard('Active', 'Status', Icons.check_circle_outline, const Color(0xFFFAEEDA), const Color(0xFF633806)),
              ],
            ),
            const SizedBox(height: 16),

            // Summary logs
            const Text('Summary logs', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
              child: const Center(child: Text('No summaries found')),
            )
                : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0DED8)),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _summaries.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final s = _summaries[i];
                  return ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEDFE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.description_outlined, color: Color(0xFF534AB7), size: 18),
                    ),
                    title: Text(s['note_title'] ?? 'Untitled', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: Text('Length: ${s['length_type']}', style: const TextStyle(fontSize: 11, color: Color(0xFF5F5E5A))),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEDFE),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        s['length_type'] ?? 'short',
                        style: const TextStyle(fontSize: 10, color: Color(0xFF534AB7), fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String value, String label, IconData icon, Color bgColor, Color iconColor) {
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
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: iconColor)),
            Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF5F5E5A))),
          ],
        ),
      ),
    );
  }
}