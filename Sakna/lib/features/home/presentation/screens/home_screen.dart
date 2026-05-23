import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../presentation/providers/order_providers.dart';
import '../../../search/presentation/widgets/filters_bottom_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeOrder = ref.watch(activeOrderProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Sticky Header Block
            _buildHeader(context),

            // Main Content Area Scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Conditional Order Tracking Card
                    if (activeOrder != null) ...[
                      _buildOrderTrackingCard(context, ref, activeOrder),
                      const SizedBox(height: 20),
                    ],

                    // Persistent Search Bar
                    _buildSearchBar(context),
                    const SizedBox(height: 24),

                    // Quick navigation icons grid
                    _buildQuickActionIcons(),
                    const SizedBox(height: 28),

                    // Categories Block ("الخدمات الأساسية")
                    _buildCategoriesBlock(),
                    const SizedBox(height: 28),

                    // Seasonal Banners Block
                    _buildSeasonalBanners(),
                    const SizedBox(height: 28),

                    // Elite Technicians ("نخبة الفنيين")
                    _buildEliteTechniciansBlock(),
                    const SizedBox(height: 28),

                    // Emergency floating block ("طلب طوارئ؟")
                    _buildEmergencyBlock(),
                    const SizedBox(height: 40),

                    // Developer reset buttons to show/hide order card easily
                    if (activeOrder == null)
                      Center(
                        child: TextButton.icon(
                          onPressed: () => ref.read(activeOrderProvider.notifier).resetOrder(),
                          icon: const Icon(Icons.refresh, color: AppColors.accent),
                          label: const Text(
                            'إظهار بطاقة تتبع الطلب للتجربة',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // User profile avatar & Welcoming
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 0.2),
                  border: Border.all(color: AppColors.accent, width: 1.5),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أهلاً بك،',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  Text(
                    'أحمد محمد',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Brand Centered
          const Text(
            'KHEDMA',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              letterSpacing: 1.5,
            ),
          ),

          // Notifications button
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.greyLight),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none_outlined,
                color: AppColors.textPrimary,
                size: 22,
              ),
              onPressed: () {
                // Navigate to notifications screen
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTrackingCard(BuildContext context, WidgetRef ref, dynamic order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Truck icon container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.local_shipping,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              
              // Progress text and status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.description,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        // Small gold status badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'جاري التوصيل',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'وقت الوصول المتوقع: ${order.arrivalTime}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),

              // Dismiss / Cancel order tracking visual (conditionally hides)
              IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
                onPressed: () {
                  // Interactive dismiss order card action
                  ref.read(activeOrderProvider.notifier).dismissOrder();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'تم إنهاء تتبع الطلب الحالي بنجاح',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontFamily: 'Cairo'),
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: 18),
          
          // Shipping progress indicator line
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.accent, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.6,
                    minHeight: 6,
                    backgroundColor: AppColors.greyLight,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.home_outlined, color: AppColors.textSecondary, size: 18),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/search'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Settings filter button (clicking opens FiltersBottomSheet)
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const FiltersBottomSheet(),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.tune,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'ابحث عن خدمة، فني، أو رقم طلب...',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            const Icon(
              Icons.search,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionIcons() {
    final List<Map<String, dynamic>> items = [
      {'icon': Icons.history, 'label': 'السجلات'},
      {'icon': Icons.account_balance_wallet_outlined, 'label': 'المحفظة'},
      {'icon': Icons.home_work_outlined, 'label': 'الدعم'},
      {'icon': Icons.apps, 'label': 'المزيد'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((item) {
        return Expanded(
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(item['icon'], color: AppColors.primary, size: 26),
              ),
              const SizedBox(height: 8),
              Text(
                item['label'],
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoriesBlock() {
    // Categories ordered exactly like the screenshot: سباكة, كهرباء, تمريض, تنظيف
    final List<Map<String, dynamic>> categories = [
      {'icon': Icons.plumbing, 'label': 'سباكة', 'color': Colors.orange.shade50},
      {'icon': Icons.electric_bolt, 'label': 'كهرباء', 'color': Colors.blue.shade50},
      {'icon': Icons.medical_services_outlined, 'label': 'تمريض', 'color': Colors.red.shade50},
      {'icon': Icons.cleaning_services_outlined, 'label': 'تنظيف', 'color': Colors.green.shade50},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'الخدمات الأساسية',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'عرض الكل',
                style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: categories.map((cat) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6.0),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.01),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cat['color'],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(cat['icon'], color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      cat['label'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSeasonalBanners() {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            Color(0xFF0C244C),
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
      ),
      child: Stack(
        children: [
          // Background subtle design elements
          Positioned(
            left: -20,
            bottom: -20,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          
          // Content block RTL
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'عرض محدود',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'خصم 20% على تعقيم المنازل',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'استخدم كود: STER20',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEliteTechniciansBlock() {
    final List<Map<String, dynamic>> technicians = [
      {
        'name': 'م. خالد عباس',
        'rating': '4.8',
        'reviews': '124 تقييم',
        'bio': 'خبير صيانة كهربائية منذ 10 سنوات',
        'price': '50 ر.س',
      },
      {
        'name': 'أ. عماد السعدني',
        'rating': '4.9',
        'reviews': '98 تقييم',
        'bio': 'فني سباكة وتركيبات متكاملة',
        'price': '75 ر.s',
      }
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'نخبة الفنيين',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 16),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: technicians.length,
            itemBuilder: (context, index) {
              final tech = technicians[index];
              return Container(
                width: 280,
                margin: const EdgeInsets.only(left: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Technician avatar details
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.greyLight.withValues(alpha: 0.3),
                          ),
                          child: const Center(
                            child: Icon(Icons.person, color: AppColors.primary, size: 36),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          tech['price'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    
                    // Bio details & button
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tech['name'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${tech['rating']} (${tech['reviews']})',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            tech['bio'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                              height: 1.4,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: 110,
                            height: 34,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {},
                              child: const Text(
                                'حجز الآن',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyBlock() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFC62828), // High-fidelity dark red container matching screenshot
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC62828).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Emergency icon circle
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sensors,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'طلب طوارئ؟',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'وصول في أقل من 30 دقيقة',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Action arrow button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
