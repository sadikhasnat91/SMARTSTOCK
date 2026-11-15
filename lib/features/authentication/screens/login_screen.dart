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
  final _emailCtrl = TextEditingController(text: 'sadik.hasnat@smartstock.com');
  final _passCtrl = TextEditingController(text: 'admin123');
  bool _obscurePass = true;
  bool _loading = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 650));
    setState(() => _loading = false);
    Get.offAllNamed(AppRoutes.executiveDashboard);
  }

  void _fillDemo(String email, String pass) {
    setState(() {
      _emailCtrl.text = email;
      _passCtrl.text = pass;
    });
    Get.snackbar(
      'Credentials Loaded',
      'Demo credentials applied for $email',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
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
        // Left 3D Showcase Panel
        Expanded(
          flex: 5,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0F261E), Color(0xFF091612)],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand Header
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.5),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.inventory_2_rounded, size: 24, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SmartStock',
                              style: AppTextStyles.h2.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Intelligent Inventory Platform',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.sidebarGroupLabel,
                                fontSize: 11,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 52),
                  // Hero Copy
                  Text(
                    'Intelligent Inventory\n& Supply Chain\nManagement',
                    style: AppTextStyles.displayLarge.copyWith(
                      color: Colors.white,
                      height: 1.18,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Streamline multi-warehouse operations with real-time stock levels, predictive demand forecasting, smart reordering, and automated fulfillment workflows.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.sidebarText,
                      height: 1.6,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 38),
                  const _FeatureItem(
                    icon: Icons.track_changes_rounded,
                    title: 'Precision Stock Tracking',
                    text: 'Hierarchical locations: Zones, Aisles, Racks, Shelves, and Bins.',
                  ),
                  const SizedBox(height: 18),
                  const _FeatureItem(
                    icon: Icons.auto_awesome_rounded,
                    title: 'AI Predictive Intelligence',
                    text: 'Real-time stockout risk alerts and automated smart reorder suggestions.',
                  ),
                  const SizedBox(height: 18),
                  const _FeatureItem(
                    icon: Icons.local_shipping_rounded,
                    title: 'End-to-End Procurement',
                    text: 'From PR requests and approvals to POs, QC, and receiving.',
                  ),
                  const SizedBox(height: 18),
                  const _FeatureItem(
                    icon: Icons.qr_code_scanner_rounded,
                    title: 'Barcode & Thermal Labels',
                    text: 'Code 128, EAN-13, QR code generation and hardware scanner input.',
                  ),
                  const SizedBox(height: 50),
                  Text(
                    '© 2026 SmartStock Technologies • Final Year CSE Project',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.sidebarGroupLabel,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Right Login Card Panel
        Expanded(
          flex: 6,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Container(
                  padding: const EdgeInsets.all(36),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.border, width: 1.2),
                    boxShadow: AppColors.shadow3DElevated,
                  ),
                  child: _buildForm(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Mobile Brand Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.inventory_2_rounded, size: 22, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text(
                'SmartStock',
                style: AppTextStyles.h1.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border, width: 1.2),
              boxShadow: AppColors.shadow3DCard,
            ),
            child: _buildForm(),
          ),
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
          Text(
            'Sign In',
            style: AppTextStyles.displayMedium.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Welcome back! Enter your enterprise credentials.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 26),
          AppTextField(
            label: 'Email Address',
            hint: 'user@smartstock.com',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (v) => (v?.isEmpty ?? true) ? 'Email is required' : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Password',
            hint: 'Enter your account password',
            controller: _passCtrl,
            obscureText: _obscurePass,
            prefixIcon: Icons.lock_outline_rounded,
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
          const SizedBox(height: 10),
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                child: Text(
                  'Forgot password?',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
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
          const SizedBox(height: 26),
          // One-Click Demo Credentials Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.secondaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Demo Credentials',
                        style: AppTextStyles.labelSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => _fillDemo('sadik.hasnat@smartstock.com', 'admin123'),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          'Auto-Fill',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _CredentialRow('Email:', _emailCtrl.text),
                const SizedBox(height: 4),
                _CredentialRow('Password:', _passCtrl.text),
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
  final String title;
  final String text;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: 0.35),
                AppColors.primary.withValues(alpha: 0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.primaryLight.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF6EE7B7)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                text,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.sidebarText,
                  height: 1.4,
                ),
              ),
            ],
          ),
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
          width: 72,
          child: Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.mono.copyWith(fontSize: 11.5, color: AppColors.textSecondary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
