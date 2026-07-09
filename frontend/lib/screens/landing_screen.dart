import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top navbar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF534AB7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NoteAI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('Smart summarizer', style: TextStyle(fontSize: 11, color: Color(0xFF5F5E5A))),
                      ],
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                      child: const Text('Login', style: TextStyle(color: Color(0xFF534AB7))),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF534AB7),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),

              // Hero section
              Container(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEDFE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.psychology, color: Color(0xFF534AB7), size: 36),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Turn long notes into\nsmart summaries',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1A1A18)),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'AI-powered summarization for students.\nUpload notes, PDFs or paste text — get\nconcise summaries in seconds.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Color(0xFF5F5E5A), height: 1.6),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                          icon: const Icon(Icons.rocket_launch, size: 18),
                          label: const Text('Get started free'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF534AB7),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                          icon: const Icon(Icons.login, size: 18, color: Color(0xFF534AB7)),
                          label: const Text('Sign in', style: TextStyle(color: Color(0xFF534AB7))),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            side: const BorderSide(color: Color(0xFF534AB7)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Feature cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _featureCard(Icons.auto_awesome, 'AI Summarization', 'Powered by Gemini AI for accurate, context-aware summaries'),
                    const SizedBox(height: 12),
                    _featureCard(Icons.label, 'Keyword Extraction', 'Auto-identify key terms for quick exam revision'),
                    const SizedBox(height: 12),
                    _featureCard(Icons.history, 'Summary History', 'Access, download and manage all your past summaries'),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // About section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0DED8)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('About this project', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text(
                      'AI Note Summarizer is a web-based academic assistant designed for students at Northern University of Business & Technology, Khulna.\n\nCourse: CSE 4104 | Section: 7C | Team: CSE4104-7C-T06\nMembers: Jinat Rafia Jeba · Md. Rasik Zaman · Sheikh Shamun Ishmam',
                      style: TextStyle(fontSize: 13, color: Color(0xFF5F5E5A), height: 1.6),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureCard(IconData icon, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0DED8)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEEEDFE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF534AB7), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 12, color: Color(0xFF5F5E5A))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}