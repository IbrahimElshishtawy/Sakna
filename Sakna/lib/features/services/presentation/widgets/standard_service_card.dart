import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/service_item.dart';

class StandardServiceCard extends StatelessWidget {
  final ServiceItem item;

  const StandardServiceCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isEmergency
              ? Colors.red.withValues(alpha: 0.3)
              : AppColors.greyLight.withValues(alpha: 0.6),
          width: item.isEmergency ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (item.icon != null)
                        Icon(item.icon, color: item.isEmergency ? Colors.red : AppColors.primary, size: 20)
                      else
                        Icon(Icons.check_circle_outline, color: item.isEmergency ? Colors.red : AppColors.accent, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            fontFamily: 'Cairo',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                if (item.isEmergency)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'طوارئ فوري 🚨',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              item.description,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontFamily: 'Cairo',
                height: 1.4,
              ),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'التكلفة التقديرية',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          item.priceEstimate,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: item.isEmergency ? Colors.red : AppColors.primary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        if (item.duration != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            '(${item.duration})',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _simulateBookingFlow(context, item),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item.isEmergency ? Colors.red : AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  ),
                  child: Text(
                    item.isEmergency ? 'إرسال فوري' : 'احجز الآن',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _simulateBookingFlow(BuildContext context, ServiceItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            item.isEmergency ? 'تأكيد إرسال الطوارئ 🚨' : 'تأكيد حجز الخدمة',
            style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.isEmergency ? Icons.warning_amber_rounded : Icons.calendar_month,
                color: item.isEmergency ? Colors.red : AppColors.primary,
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                'لقد اخترت: ${item.name}',
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                item.isEmergency
                    ? 'سيتم إرسال فني الطوارئ فوراً إلى موقعك المسجل الآن وتتبع حركته مباشرة.'
                    : 'التكلفة التقديرية للخدمة هي ${item.priceEstimate} وسيتواصل معك فني الصيانة لتنسيق موعد دقيق.',
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء', style: TextStyle(color: Colors.grey, fontFamily: 'Cairo')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      item.isEmergency
                          ? '🚨 جاري التوجيه الفوري للفني إليك الآن وتحديث بطاقة التتبع!'
                          : '✅ تم حجز الخدمة بنجاح وسيتصل بك الفني قريباً!',
                      style: const TextStyle(fontFamily: 'Cairo'),
                    ),
                    backgroundColor: item.isEmergency ? Colors.red : AppColors.primary,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: item.isEmergency ? Colors.red : AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'تأكيد الموعد',
                style: TextStyle(color: Colors.white, fontFamily: 'Cairo', fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
