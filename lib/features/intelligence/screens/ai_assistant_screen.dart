import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  final List<Map<String, String>> _messages = [
    {
      'role': 'assistant',
      'text': 'Hello Sadik! I am your SmartStock AI Operations Copilot.\n\nI continuously monitor real-time telemetry across our 4 warehouse facilities, vendor lead-time drifts, and replenishment triggers. How can I assist your logistics decision-making today?',
    },
    {
      'role': 'user',
      'text': 'Which warehouse has the highest capacity bottleneck right now?',
    },
    {
      'role': 'assistant',
      'text': 'Based on real-time spatial telemetry, **WH-Cold (Gazipur Facility)** is at **86.0% capacity** (2,408 m² utilized of 2,800 m²).\n\n⚠️ Projection: Cold Zone A will reach critical threshold in **8 days**.\n\nRecommended Action:\n1. Re-route 12 upcoming perishable shipments to East regional overflow zone.\n2. Initiate outbound cross-docking for fast-moving dairy batches.',
    },
  ];

  final List<String> _suggestedPrompts = [
    'Analyze low stock risks for next 7 days',
    'Summarize pending purchase order approvals',
    'Evaluate supplier on-time delivery rates',
    'Suggest inter-warehouse transfers',
  ];

  void _send([String? customText]) {
    final txt = customText ?? _inputCtrl.text.trim();
    if (txt.isEmpty) return;
    setState(() {
      _messages.add({'role': 'user', 'text': txt});
      if (customText == null) _inputCtrl.clear();
      _messages.add({
        'role': 'assistant',
        'text': 'Diagnostic analysis for "$txt":\n\nCross-referencing historical SKU demand patterns, current warehouse inventory registers, and vendor commitments. Overall inventory health is nominal (98.4% fulfillment rate). Safety stock parameters are well-balanced.',
      });
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      breadcrumbs: const ['Intelligence', 'AI Business Assistant'],
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 10,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Enterprise AI Operations Copilot', style: AppTextStyles.h1.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(
                      'Natural language reasoning for supply chain diagnostics, risk prevention, and intelligent automated actions',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Neural Model Active',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Chat Window Container
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border, width: 1.2),
                  boxShadow: AppColors.shadow3DCard,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Column(
                    children: [
                      // Message Stream
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollCtrl,
                          padding: const EdgeInsets.all(22),
                          itemCount: _messages.length,
                          itemBuilder: (context, idx) {
                            final msg = _messages[idx];
                            final isUser = msg['role'] == 'user';
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                                children: [
                                  if (!isUser) ...[
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        gradient: AppColors.primaryGradient,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary.withValues(alpha: 0.35),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(Icons.auto_awesome_rounded, size: 20, color: Colors.white),
                                    ),
                                    const SizedBox(width: 14),
                                  ],
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                      decoration: BoxDecoration(
                                        gradient: isUser ? AppColors.primaryGradient : null,
                                        color: isUser ? null : const Color(0xFFF7FAF8),
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(16),
                                          topRight: const Radius.circular(16),
                                          bottomLeft: Radius.circular(isUser ? 16 : 4),
                                          bottomRight: Radius.circular(isUser ? 4 : 16),
                                        ),
                                        border: isUser
                                            ? null
                                            : Border.all(color: AppColors.border, width: 1),
                                        boxShadow: [
                                          BoxShadow(
                                            color: isUser
                                                ? AppColors.primary.withValues(alpha: 0.25)
                                                : Colors.black.withValues(alpha: 0.03),
                                            offset: const Offset(0, 3),
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        msg['text']!,
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: isUser ? Colors.white : AppColors.textPrimary,
                                          height: 1.55,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (isUser) ...[
                                    const SizedBox(width: 12),
                                    CircleAvatar(
                                      radius: 17,
                                      backgroundColor: AppColors.primarySurface,
                                      child: Text(
                                        'SH',
                                        style: AppTextStyles.labelSmall.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      // Suggested Prompts Chips
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF9FBFA),
                          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: _suggestedPrompts.map((prompt) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: InkWell(
                                  onTap: () => _send(prompt),
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(color: AppColors.border, width: 1),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.02),
                                          offset: const Offset(0, 1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.bolt_rounded, size: 14, color: AppColors.warning),
                                        const SizedBox(width: 4),
                                        Text(
                                          prompt,
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      // Input Bar
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: AppColors.surface,
                          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                hint: 'Ask AI copilot: e.g. "Forecast demand surge for USB-C hubs next month"',
                                controller: _inputCtrl,
                              ),
                            ),
                            const SizedBox(width: 12),
                            AppButton(
                              label: 'Send',
                              prefixIcon: Icons.send_rounded,
                              onPressed: () => _send(),
                              height: 42,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }
}
