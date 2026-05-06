import 'dart:ui';
import 'package:flutter/material.dart';

class TermsDialog extends StatefulWidget {
  const TermsDialog({super.key});

  @override
  State<TermsDialog> createState() => _TermsDialogState();
}

class _TermsDialogState extends State<TermsDialog> {
  int _currentIndex = 1; // 0: English, 1: Formal Arabic, 2: Ammiya

  final List<String> _languages = ['English', 'الفصحى', 'العامية'];

  final List<String> _titles = [
    'Terms & Conditions',
    'شروط وأحكام الاستخدام',
    'شروطنا اللي لازم توافق عليها'
  ];

  final List<String> _contents = [
    '''
1. Acceptance of Terms: By accessing and using KhidmaHub, you accept and agree to be bound by the terms and provision of this agreement.
2. User Conduct: You agree to use the service only for lawful purposes.
3. Data Privacy: Your personal data will be protected according to our Privacy Policy.
4. Termination: We reserve the right to terminate your access if you violate these terms.
    ''',
    '''
١. قبول الشروط: من خلال الوصول إلى تطبيق خدمة واستخدامه، فإنك تقبل وتوافق على الالتزام بشروط وأحكام هذه الاتفاقية.
٢. سلوك المستخدم: توافق على استخدام الخدمة للأغراض القانونية فقط.
٣. خصوصية البيانات: ستتم حماية بياناتك الشخصية وفقًا لسياسة الخصوصية الخاصة بنا.
٤. الإنهاء: نحتفظ بالحق في إنهاء وصولك إذا انتهكت هذه الشروط.
    ''',
    '''
١. الموافقة: لما تستخدم تطبيق خدمة، ده معناه إنك موافق على شروطنا وأحكامنا.
٢. الاستخدام: لازم تستخدم التطبيق في الحاجات الصح والقانونية بس، بلاش أي مخالفات.
٣. بياناتك في أمان: متقلقش، بياناتك الشخصية محمية ومحدش هيشوفها غيرنا.
٤. قفل الحساب: لو خلفت الشروط دي، من حقنا نقفل حسابك في أي وقت.
    '''
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            color: Colors.white.withValues(alpha: 0.1),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _titles[_currentIndex],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Language Toggle
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: List.generate(
                      3,
                      (index) => Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _currentIndex = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _currentIndex == index
                                  ? Colors.white.withValues(alpha: 0.25)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _languages[index],
                              style: TextStyle(
                                color: _currentIndex == index
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.6),
                                fontWeight: _currentIndex == index
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Content
                Flexible(
                  child: SingleChildScrollView(
                    child: Text(
                      _contents[_currentIndex],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.8,
                      ),
                      textDirection: _currentIndex == 0
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Agree Button
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0F64FF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _currentIndex == 0 ? 'I Understand' : 'مفهوم',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
