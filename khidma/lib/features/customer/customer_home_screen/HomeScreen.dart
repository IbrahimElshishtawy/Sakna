// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:khidma/features/customer/customer_home_screen/widget/buildAppBar.dart';
import 'package:khidma/models/service.dart';

import '../../../mock/mock_data.dart';
import '../../task/create_task_page.dart'; // <- تأكد من المسار الفعلي لصفحة إنشاء المهمة

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  // لو حبيت ترجع تستخدم الـ services بعدين
  List<Service_model> filteredServices = mockServices.cast<Service_model>();

  void _filterServices(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredServices = mockServices.cast<Service_model>();
      } else {
        filteredServices = mockServices
            .where(
              (serviceModel) =>
                  serviceModel.title.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  serviceModel.description.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .cast<Service_model>()
            .toList();
      }
    });
  }

  void _openCreateTask(String category) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CreateTaskPage(category: category)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: buildAppBar(
          isSearching: isSearching,
          searchController: searchController,
          onSearchToggle: (bool value) {
            setState(() {
              isSearching = value;
            });
          },
          onSearchChanged: _filterServices,
          context: context,
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// هيدر
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'مرحبا بك 👋',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'اختر نوع الخدمة لبدء إنشاء مهمة جديدة بسهولة وسرعة.',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: theme.colorScheme.primary.withOpacity(
                      0.12,
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// عرض موسمي (Seasonal Offer)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE91E63), Color(0xFFFFC107)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.celebration, color: Colors.white, size: 40),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'عروض رمضان المبارك 🌙',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'خصم 20% على خدمات التنظيف العميق',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'خدماتنا الأساسية',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              /// كارت: خدمات داخلية
              _CategoryCard(
                title: 'خدمات داخلية',
                subtitle: 'تنظيف، ترتيب، مساعدة داخل المنزل والمكتب.',
                icon: Icons.home_repair_service_outlined,
                onTap: () => _openCreateTask('خدمات داخلية'),
              ),
              const SizedBox(height: 16),

              /// كارت: خدمات خارجية
              _CategoryCard(
                title: 'خدمات خارجية',
                subtitle: 'مشاوير، تسوق، وإنهاء طلبات خارجية متنوعة.',
                icon: Icons.directions_walk_outlined,
                onTap: () => _openCreateTask('خدمات خارجية'),
              ),
              const SizedBox(height: 16),

              /// كارت: أخرى
              _CategoryCard(
                title: 'أخرى',
                subtitle: 'أي نوع خدمة مختلف يناسب احتياجك الخاص.',
                icon: Icons.more_horiz_outlined,
                onTap: () => _openCreateTask('أخرى'),
              ),

              const SizedBox(height: 32),

              /// مقدمو خدمة مميزون
              const Text(
                'مقدمو خدمة مميزون (Pro) 🌟',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 100,
                      margin: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircleAvatar(
                            radius: 24,
                            child: Icon(Icons.person),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'أحمد فوزي',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star, size: 12, color: Colors.amber),
                              Text(' 4.9', style: TextStyle(fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// كارت احترافي لاختيار نوع الخدمة (أكبر وأوضح)
class _CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 110, // تكبير ارتفاع الكارت
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                theme.colorScheme.primary.withOpacity(0.06),
                theme.colorScheme.primary.withOpacity(0.02),
              ],
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Row(
            children: [
              // أيقونة داخل دائرة أكبر
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withOpacity(0.12),
                ),
                child: Icon(icon, size: 30, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.bolt,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'ابدأ الآن',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // سهم صغير
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
