import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/app_shell.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../shared/controllers/intelligence_controller.dart';

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
      'text': 'Hello! I am your **SmartStock AI Operations Copilot** powered by **Gemini 3.8 Flash**.\n\nI continuously monitor real-time telemetry across our warehouse facilities, vendor lead times, and inventory replenishment triggers. How can I assist your supply chain decisions today?',
    },
    {
      'role': 'user',
      'text': 'Which warehouse has the highest capacity bottleneck right now?',
    },
    {
      'role': 'assistant',
      'text': 'Based on real-time spatial telemetry, **WH-Main** is currently operating at **65.6% capacity** with 248 active bin locations.\n\n⚠️ Recommendation:\n1. Re-route high-volume non-perishable inventory to East regional overflow.\n2. Keep safety buffers for fast-moving electronics items.',
    },
  ];

  final List<String> _suggestedPrompts = [
    'Analyze low stock risks for next 7 days',
    'Calculate total inventory valuation',
    'Summarize warehouse capacity bottlenecks',
    'Review commercial sales orders and revenue',
  ];

  void _send([String? customText]) async {
    final txt = customText ?? _inputCtrl.text.trim();
    if (txt.isEmpty) return;
    final intelCtrl = Get.find<IntelligenceController>();

    setState(() {
      _messages.add({'role': 'user', 'text': txt});
      if (customText == null) _inputCtrl.clear();
      _messages.add({
        'role': 'assistant',
        'text': 'Thinking with Gemini 3.8 Flash...',
      });
    });

    _scrollToBottom();

    // Query Gemini with zero-lag fallback
    final aiAnswer = await intelCtrl.queryGemini(txt);

    if (mounted) {
      setState(() {
        if (_messages.isNotEmpty && _messages.last['role'] == 'assistant' && _messages.last['text'] == 'Thinking with Gemini 3.8 Flash...') {
          _messages.removeLast();
        }
        _messages.add({
          'role': 'assistant',
          'text': aiAnswer,
        });
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showApiKeyDialog(IntelligenceController intelCtrl) {
    final keyCtrl = TextEditingController(text: intelCtrl.geminiApiKey.value);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.vpn_key_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Gemini API Key Setup'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your Google Gemini API key to activate cloud conversational intelligence. (Leave empty to use SmartStock built-in ERP engine).',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: keyCtrl,
              decoration: const InputDecoration(
                labelText: 'API Key',
                hintText: 'Paste Gemini key here',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              intelCtrl.geminiApiKey.value = keyCtrl.text.trim();
              Navigator.of(ctx).pop();
              Get.snackbar(
                'Gemini Configured',
                intelCtrl.geminiApiKey.value.isNotEmpty
                    ? 'Connected to Gemini Cloud API'
                    : 'Switched to Built-in Contextual ERP Engine',
                backgroundColor: AppColors.success,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Save Key'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final intelCtrl = Get.find<IntelligenceController>();

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
                InkWell(
                  onTap: () => _showApiKeyDialog(intelCtrl),
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Gemini 3.8 Flash Active',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 11.5,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.settings_outlined, size: 14, color: AppColors.primary),
                      ],
                    ),
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
                          physics: const ClampingScrollPhysics(),
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
                                hint: 'Ask Gemini: e.g. "কম স্টক হওয়া প্রোডাক্টগুলো কী কী?" or "Summarize sales orders"',
                                controller: _inputCtrl,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Obx(() => AppButton(
                              label: 'Send',
                              prefixIcon: Icons.send_rounded,
                              loading: intelCtrl.isThinking.value,
                              onPressed: intelCtrl.isThinking.value ? null : () => _send(),
                              height: 42,
                            )),
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
