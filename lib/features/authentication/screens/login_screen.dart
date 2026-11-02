import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../app/routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController(text: 'ahmed.rahman@smartstock.com');
  final _passCtrl = TextEditingController(text: 'password123');
  bool _obscurePass = true;
  bool _loading = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _loading = false);
    Get.offAllNamed(AppRoutes.executiveDashboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveLayout(
        desktop: _buildDesktopLayout(),
        mobile: _buildMobileLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left panel
        Expanded(
          child: Container(
            color: AppColors.sidebarBackground,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.inventory_2_rounded, size: 22, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Text('SmartStock', style: AppTextStyles.h2.copyWith(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 36),
                  Text(
                    'Intelligent Inventory\n& Supply Chain\nManagement',
                    style: AppTextStyles.displayLarge.copyWith(
                      color: Colors.white,
                      height: 1.2,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Streamline your operations with real-time inventory tracking, smart forecasting, and end-to-end supply chain visibility.',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.sidebarText, height: 1.6),
                  ),
                  const SizedBox(height: 32),
                  const _FeatureItem(icon: Icons.track_changes_outlined, text: 'Real-time inventory tracking'),
                  const SizedBox(height: 14),
                  const _FeatureItem(icon: Icons.auto_awesome_outlined, text: 'AI-powered demand forecasting'),
                  const SizedBox(height: 14),
                  const _FeatureItem(icon: Icons.local_shipping_outlined, text: 'End-to-end procurement workflow'),
                  const SizedBox(height: 14),
                  const _FeatureItem(icon: Icons.bar_chart_outlined, text: 'Advanced analytics & reporting'),
                  const SizedBox(height: 40),
                  Text(
                    '© 2026 SmartStock Technologies. All rights reserved.',
                    style: AppTextStyles.caption.copyWith(color: AppColors.sidebarGroupLabel),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Right panel
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(48),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: _buildForm(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.inventory_2_rounded, size: 24, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text('SmartStock', style: AppTextStyles.h1),
            ],
          ),
          const SizedBox(height: 40),
          _buildForm(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Welcome back', style: AppTextStyles.h1),
          const SizedBox(height: 6),
          Text(
            'Sign in to your SmartStock account',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 32),
          AppTextField(
            label: 'Email Address',
            hint: 'you@company.com',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (v) => (v?.isEmpty ?? true) ? 'Email is required' : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Password',
            hint: 'Enter your password',
            controller: _passCtrl,
            obscureText: _obscurePass,
            prefixIcon: Icons.lock_outline,
            suffix: IconButton(
              icon: Icon(
                _obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 18,
                color: AppColors.textMuted,
              ),
              onPressed: () => setState(() => _obscurePass = !_obscurePass),
            ),
            validator: (v) => (v?.isEmpty ?? true) ? 'Password is required' : null,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                child: Text(
                  'Forgot password?',
                  style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Sign In',
              onPressed: _login,
              loading: _loading,
              expanded: true,
              height: 44,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondaryBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Demo Credentials', style: AppTextStyles.labelSmall),
                const SizedBox(height: 8),
                _CredentialRow('Email:', 'ahmed.rahman@smartstock.com'),
                const SizedBox(height: 4),
                _CredentialRow('Password:', 'password123'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FeatureItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.sidebarText)),
        ),
      ],
    );
  }
}

class _CredentialRow extends StatelessWidget {
  final String label;
  final String value;
  const _CredentialRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(label, style: AppTextStyles.caption),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.mono.copyWith(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

