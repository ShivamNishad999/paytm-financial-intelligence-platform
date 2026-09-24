import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/primary_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await ref.read(authProvider.notifier).login(
          identifier: _identifierController.text,
          password: _passwordController.text,
        );
    if (!mounted) return;
    if (ref.read(authProvider).isAuthenticated) {
      context.go('/home/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.trending_up_rounded, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 24),
              Text('Welcome back', style: AppTextStyles.h1),
              const SizedBox(height: 6),
              Text(
                'Log in to see how your business is doing today.',
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 28),
              Text('Mobile number or email', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _identifierController,
                decoration: const InputDecoration(hintText: 'e.g. 9876543210'),
              ),
              const SizedBox(height: 18),
              Text('Password', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password reset isn’t available in this preview.')),
                    );
                  },
                  child: const Text('Forgot password?'),
                ),
              ),
              if (authState.error != null) ...[
                const SizedBox(height: 8),
                Text(authState.error!, style: AppTextStyles.caption.copyWith(color: AppColors.red)),
              ],
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Log In',
                isLoading: authState.isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.navy),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${AppConstants.appName} is running in preview mode. Any mobile number/email and password will log you in.',
                        style: AppTextStyles.caption,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
