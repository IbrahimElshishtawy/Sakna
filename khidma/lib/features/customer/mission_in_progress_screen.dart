import 'package:flutter/material.dart';
import '../../core/app_routes.dart';

class MissionInProgressScreen extends StatelessWidget {
  const MissionInProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المهمة قيد التقدم')),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'تتبع حالة المهمة',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Stepper status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStep(Icons.check_circle, 'تم الطلب', true),
                        _buildDivider(true),
                        _buildStep(Icons.person_pin, 'في الطريق', true),
                        _buildDivider(false),
                        _buildStep(Icons.home_repair_service, 'قيد التنفيذ', false),
                        _buildDivider(false),
                        _buildStep(Icons.star, 'مكتمل', false),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'صور التنفيذ (مباشر)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildPhotoPlaceholder(),
                      _buildPhotoPlaceholder(),
                      _buildPhotoPlaceholder(isAdd: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black12,
                  image: const DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/400x200?text=Live+Map+Tracking'),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.center,
                child: Container(
                   padding: const EdgeInsets.all(8),
                   color: Colors.white70,
                   child: const Text('تتبع حي للمساعد على الخريطة'),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.ratingPayment);
                },
                child: const Text('إنهاء المهمة'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(IconData icon, String label, bool isDone) {
    return Column(
      children: [
        Icon(icon, color: isDone ? Colors.green : Colors.grey, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDone ? Colors.black : Colors.grey,
            fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDone) {
    return Container(
      width: 30,
      height: 2,
      color: isDone ? Colors.green : Colors.grey.shade300,
    );
  }

  Widget _buildPhotoPlaceholder({bool isAdd = false}) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Icon(
        isAdd ? Icons.add_a_photo : Icons.image,
        color: Colors.grey,
      ),
    );
  }
}
