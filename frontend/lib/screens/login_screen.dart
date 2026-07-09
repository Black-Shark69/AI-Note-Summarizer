import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'dashboard_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _error = '';

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _error = 'All fields are required');
      return;
    }
    setState(() { _isLoading = true; _error = ''; });
    try {
      final res = await ApiService.login(_emailController.text.trim(), _passwordController.text);
      if (res['token'] != null) {
        final user = UserModel.fromJson(res['user']);
        await AuthService.saveUser(res['token'], user);
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
        }
      } else {
        setState(() => _error = res['message'] ?? 'Login failed');
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
                child: const Icon(Icons.lock_outline, color: Color(0xFF534AB7), size: 28),
              ),
              const SizedBox(height: 16),
              const Text('Welcome back', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Sign in to your NoteAI account', style: TextStyle(color: Color(0xFF5F5E5A))),
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
                      label: 'Email address',
                      hint: 'student@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                    ),
                    CustomTextField(
                      label: 'Password',
                      hint: '••••••••',
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
                            Text(_error, style: const TextStyle(color: Color(0xFFA32D2D), fontSize: 13)),
                          ],
                        ),
                      ),
                    CustomButton(text: 'Login', onPressed: _login, isLoading: _isLoading),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: Color(0xFF5F5E5A))),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: const Text('Register', style: TextStyle(color: Color(0xFF534AB7), fontWeight: FontWeight.bold)),
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