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
  final List<Map<String, String>> _messages = [
    {
      'role': 'assistant',
      'text': 'Hello Ahmed! I am your SmartStock AI Copilot. I continuously monitor inventory runways, vendor delivery delays, and warehouse congestion. How can I assist your operations today?',
    },
    {
      'role': 'user',
      'text': 'Which warehouse has the highest capacity bottleneck right now?',
    },
    {
      'role': 'assistant',
      'text': 'Based on real-time spatial telemetry, **WH-Cold (Gazipur Facility)** is at **86.0% capacity** (2,408 m² utilized of 2,800 m²). I project Zone A will reach maximum threshold in 8 days.\n\nRecommended mitigation: Re-route upcoming perishable shipments to East regional cold zone or arrange outbound cross-docking.',
    },
  ];

  void _send() {
    final txt = _inputCtrl.text.trim();
    if (txt.isEmpty) return;
    setState(() {
      _messages.add({'role': 'user', 'text': txt});
      _inputCtrl.clear();
      _messages.add({
        'role': 'assistant',
        'text': 'Analyzing inventory metrics for "$txt"... Based on the latest telemetry across our 4 hubs, safety stock compliance is currently at 94.2% and fulfillment run-rate is normal.',
      });
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enterprise AI Operations Copilot', style: AppTextStyles.h1),
                const SizedBox(height: 4),
                Text('Natural language query interface for inventory diagnostics, supply chain simulations, and logistics recommendations', style: AppTextStyles.bodySmall),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _messages.length,
                        itemBuilder: (context, idx) {
                          final msg = _messages[idx];
                          final isUser = msg['role'] == 'user';
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                              children: [
                                if (!isUser) ...[
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: AppColors.primarySurface,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.auto_awesome_rounded, size: 20, color: AppColors.primary),
                                  ),
                                  const SizedBox(width: 12),
                                ],
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isUser ? AppColors.primary : AppColors.secondaryBackground,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      msg['text']!,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: isUser ? Colors.white : AppColors.textPrimary,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                                if (isUser) const SizedBox(width: 12),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              hint: 'Ask AI copilot: e.g. "What is our current stock-out risk for electronics?"',
                              controller: _inputCtrl,
                            ),
                          ),
                          const SizedBox(width: 12),
                          AppButton(
                            label: 'Ask Copilot',
                            prefixIcon: Icons.send_rounded,
                            onPressed: _send,
                          ),
                        ],
                      ),
                    ),
                  ],
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
    super.dispose();
  }
}

