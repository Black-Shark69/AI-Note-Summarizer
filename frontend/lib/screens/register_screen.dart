import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _error = '';

  Future<void> _register() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _error = 'All fields are required');
      return;
    }
    if (_passwordController.text.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters');
      return;
    }
    setState(() { _isLoading = true; _error = ''; });
    try {
      final res = await ApiService.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (res['message'] == 'User registered successfully') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registered successfully! Please login.'), backgroundColor: Color(0xFF0F6E56)),
          );
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
        }
      } else {
        setState(() => _error = res['message'] ?? 'Registration failed');
      }
    } catch (e) {
      setState(() => _error = 'Connection error. Is server running?');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEDFE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.person_add_outlined, color: Color(0xFF534AB7), size: 28),
              ),
              const SizedBox(height: 16),
              const Text('Create account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Start summarizing your notes today', style: TextStyle(color: Color(0xFF5F5E5A))),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE0DED8)),
                ),
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Full name',
                      hint: 'Sheikh Shamun Ishmam',
                      controller: _nameController,
                      prefixIcon: Icons.person_outline,
                    ),
                    CustomTextField(
                      label: 'Email address',
                      hint: 'student@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                    ),
                    CustomTextField(
                      label: 'Password',
                      hint: 'Min. 6 characters',
                      controller: _passwordController,
                      obscureText: true,
                      prefixIcon: Icons.lock_outline,
                    ),
                    if (_error.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCEBEB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Color(0xFFA32D2D), size: 16),
                            const SizedBox(width: 8),
                            Expanded(child: Text(_error, style: const TextStyle(color: Color(0xFFA32D2D), fontSize: 13))),
                          ],
                        ),
                      ),
                    CustomButton(text: 'Create account', onPressed: _register, isLoading: _isLoading),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? ', style: TextStyle(color: Color(0xFF5F5E5A))),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                    child: const Text('Login', style: TextStyle(color: Color(0xFF534AB7), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}