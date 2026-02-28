import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class TemplateSelectorScreen extends StatefulWidget {
  const TemplateSelectorScreen({super.key});

  @override
  State<TemplateSelectorScreen> createState() =>
      _TemplateSelectorScreenState();
}

class _TemplateSelectorScreenState extends State<TemplateSelectorScreen> {
  int _selectedTemplate = AppConstants.templateBlueCorporate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Template'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _selectedTemplate),
            child: const Text('Apply',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: AppConstants.templates.length,
        itemBuilder: (_, i) {
          final template = AppConstants.templates[i];
          final id = template['id'] as int;
          final isSelected = _selectedTemplate == id;

          return GestureDetector(
            onTap: () => setState(() => _selectedTemplate = id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryBlue
                      : AppTheme.dividerColor,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ]
                    : [],
              ),
              child: Column(
                children: [
                  // Template Preview
                  _TemplatePreview(templateId: id),

                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                template['name'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? AppTheme.primaryBlue
                                      : AppTheme.textDark,
                                ),
                              ),
                              Text(
                                template['description'] as String,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textMedium),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle,
                              color: AppTheme.primaryBlue),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Mini Template Preview ─────────────────────────────────────────────
class _TemplatePreview extends StatelessWidget {
  final int templateId;
  const _TemplatePreview({required this.templateId});

  @override
  Widget build(BuildContext context) {
    switch (templateId) {
      case AppConstants.templateBlueCorporate:
        return _BlueCorporatePreview();
      case AppConstants.templateModernMinimal:
        return _ModernMinimalPreview();
      case AppConstants.templateBoldBusiness:
        return _BoldBusinessPreview();
      default:
        return _CleanCorporatePreview();
    }
  }
}

class _BlueCorporatePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            height: 45,
            color: const Color(0xFF0D1B5E),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 60, height: 6, color: Colors.white),
                    const SizedBox(height: 3),
                    Container(width: 40, height: 4, color: Colors.white54),
                  ],
                ),
                const Text('INVOICE',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2)),
              ],
            ),
          ),
          // Body
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 50, height: 5, color: Colors.grey.shade300),
                        const SizedBox(height: 3),
                        Container(width: 70, height: 7, color: Colors.grey.shade500),
                        const SizedBox(height: 3),
                        Container(width: 55, height: 4, color: Colors.grey.shade300),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: List.generate(
                          4,
                          (_) => Container(
                              margin: const EdgeInsets.only(bottom: 3),
                              height: 4,
                              color: Colors.grey.shade300)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Table indicator
          Container(
            height: 20,
            color: const Color(0xFF283593).withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}

class _ModernMinimalPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 50, height: 8, color: Colors.black87),
              Text('INVOICE',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600)),
            ],
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              height: 1.5,
              color: const Color(0xFF1A237E)),
          ...List.generate(
              4,
              (_) => Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  height: 4,
                  color: Colors.grey.shade200)),
        ],
      ),
    );
  }
}

class _BoldBusinessPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('BOLD\nBUSINESS',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        height: 1.1)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: Colors.orange,
                  child: const Text('INV',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 9)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8),
              child: Column(
                children: List.generate(
                    4,
                    (_) => Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        height: 5,
                        color: Colors.grey.shade200)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CleanCorporatePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            color: const Color(0xFFE8EAF6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 40, height: 6, color: Colors.grey.shade600),
                const Text('INVOICE',
                    style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF1A237E),
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(
              4,
              (_) => Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  height: 4,
                  color: Colors.grey.shade200)),
        ],
      ),
    );
  }
}
