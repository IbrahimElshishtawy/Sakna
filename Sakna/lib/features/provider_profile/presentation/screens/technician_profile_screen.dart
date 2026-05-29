import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khidma/config/theme/theme_provider.dart';
import 'package:khidma/config/theme/theme_state.dart';

/// A highly modular and responsive Technician Profile Screen built following Clean Architecture
/// and SOLID principles. Features RTL localization support, premium visual components, and adaptive styling.
class TechnicianProfileScreen extends ConsumerWidget {
  const TechnicianProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);

    return Scaffold(
      backgroundColor: themeColors.background,
      appBar: const _ProfileAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _ProfileHeaderSection(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SizedBox(height: 24),
                          _StatisticsRow(),
                          SizedBox(height: 24),
                          _AboutSection(),
                          SizedBox(height: 24),
                          _ServicesAndPricesSection(),
                          SizedBox(height: 24),
                          _PortfolioGrid(),
                          SizedBox(height: 24),
                          _ReviewsSection(),
                          SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const _BottomActionNav(),
          ],
        ),
      ),
    );
  }
}

/// Custom AppBar component implementing modern clean layout, responsive actions, and RTL direction.
class _ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ProfileAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
      // Custom leading with modern design for back button, utilizing system pop or GoRouter
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color?.withOpacity(0.8),
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.08),
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16,
            color: Colors.black87,
          ),
        ),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            // Default fallback
            Navigator.of(context).maybePop();
          }
        },
      ),
      title: Text(
        'الملف الشخصي',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color?.withOpacity(0.8),
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.08),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.share_outlined,
              size: 18,
              color: Colors.black87,
            ),
          ),
          onPressed: () {
            // Share functionality placeholder
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Profile Header Section featuring interlocking cover picture, profile avatar, custom verified badge, and technician details.
class _ProfileHeaderSection extends ConsumerWidget {
  const _ProfileHeaderSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Cover Image
            Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/tech_cover.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Semi-transparent overlay to match screenshot gradient aesthetic
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Profile Avatar overlapping the cover
            Positioned(
              bottom: -50,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: themeColors.surface,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 54,
                      backgroundImage: AssetImage('assets/images/tech_avatar.png'),
                    ),
                  ),
                  // Premium Gold Verified Badge
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: themeColors.accent, // Gold color
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: themeColors.surface,
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.verified_user_rounded,
                        size: 14,
                        color: themeColors.primary, // Dark navy icon
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 60), // Space to clear the overlapping avatar
        // Technician Name
        Text(
          'أحمد محمود',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: themeColors.textPrimary,
              ),
        ),
        const SizedBox(height: 6),
        // Subtitle & Profession Icon
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_rounded,
              size: 16,
              color: themeColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              'خبير سباكة وصيانة عامة',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: themeColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Statistics Row featuring three responsive summary cards for Rating, Bookings, and Experience.
class _StatisticsRow extends ConsumerWidget {
  const _StatisticsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);

    return Row(
      children: [
        _buildStatCard(
          context,
          themeColors,
          title: '4.9',
          subtitle: 'التقييم',
          icon: Icon(Icons.star_rounded, color: themeColors.accent, size: 20),
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          context,
          themeColors,
          title: '+150',
          subtitle: 'حجز مكتمل',
          icon: Icon(Icons.check_circle_outline_rounded, color: themeColors.primary, size: 18),
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          context,
          themeColors,
          title: '8',
          subtitle: 'سنوات خبرة',
          icon: Icon(Icons.history_edu_rounded, color: themeColors.primary, size: 18),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    ThemeColors colors, {
    required String title,
    required String subtitle,
    required Widget icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colors.border,
            width: colors.isDark ? 1 : 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 4),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// About Section containing short description of the technician's professional background.
class _AboutSection extends ConsumerWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: themeColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: themeColors.border,
          width: themeColors.isDark ? 1 : 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: themeColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'نبذة عن الفني',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: themeColors.textPrimary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'متخصص في جميع أعمال السباكة المنزلية والتجارية بخبرة تتجاوز 8 سنوات. ألتزم بتقديم أعلى معايير الجودة والدقة في المواعيد. حاصل على شهادات معتمدة في الصيانة الحديثة واستخدام أحدث المعدات للكشف عن الأعطال بدون تكسير، مما يضمن راحة البال لعملائي.',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 13.5,
                  height: 1.65,
                  color: themeColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

/// Services & Prices list component, fully responsive and styled with custom RTL alignments.
class _ServicesAndPricesSection extends ConsumerWidget {
  const _ServicesAndPricesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الخدمات والأسعار',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: themeColors.textPrimary,
              ),
        ),
        const SizedBox(height: 12),
        _buildServiceItem(
          context,
          themeColors,
          title: 'إصلاح تسربات المياه',
          description: 'فحص وإصلاح التسربات بأجهزة حديثة',
          price: '150',
          unit: 'زيارة',
          icon: Icons.plumbing_rounded,
        ),
        const SizedBox(height: 12),
        _buildServiceItem(
          context,
          themeColors,
          title: 'تركيب أطقم حمامات',
          description: 'تركيب احترافي لجميع الماركات العالمية',
          price: '200',
          unit: 'طقم',
          icon: Icons.bathtub_rounded,
        ),
      ],
    );
  }

  Widget _buildServiceItem(
    BuildContext context,
    ThemeColors colors, {
    required String title,
    required String description,
    required String price,
    required String unit,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.border,
          width: colors.isDark ? 1 : 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Service Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.background.withOpacity(colors.isDark ? 0.4 : 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.border.withOpacity(0.5),
                width: 0.5,
              ),
            ),
            child: Icon(
              icon,
              color: colors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: colors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Price Info (left-aligned in RTL)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: colors.textPrimary,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                'ر.س / $unit',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Portfolio Grid showcasing previous work in a responsive, beautiful 2x2 grid layout.
class _PortfolioGrid extends ConsumerWidget {
  const _PortfolioGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);

    // List of generated premium portfolio assets
    final List<String> portfolioImages = [
      'assets/images/portfolio_1.png',
      'assets/images/portfolio_2.png',
      'assets/images/portfolio_3.png',
      'assets/images/portfolio_4.png',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'معرض الأعمال',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: themeColors.textPrimary,
              ),
        ),
        const SizedBox(height: 12),
        // Grid View
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: themeColors.border,
                  width: 0.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  portfolioImages[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Customer Reviews list featuring customer information, dates, rating stars, and testimonial text.
class _ReviewsSection extends ConsumerWidget {
  const _ReviewsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'آراء العملاء',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: themeColors.textPrimary,
                  ),
            ),
            TextButton(
              onPressed: () {
                // View all reviews action
              },
              child: Text(
                'عرض الكل',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: themeColors.accent, // Gold highlight for action text
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        _buildReviewCard(
          context,
          themeColors,
          userName: 'محمد عبدالله',
          dateText: 'قبل يومين',
          avatarLetter: 'م',
          rating: 5,
          comment: 'خدمة ممتازة واحترافية عالية. وصل في الموعد المحدد وقام بحل المشكلة في وقت قياسي وبسعر معقول. أنصح بالتعامل معه بشدة.',
        ),
        const SizedBox(height: 12),
        _buildReviewCard(
          context,
          themeColors,
          userName: 'سارة الفهد',
          dateText: 'قبل أسبوع',
          avatarLetter: 'س',
          rating: 4,
          comment: 'شغل نظيف جداً ومحترم. تم إصلاح تسريب الحمام بدون أي تكسير مزعج. شكراً جزيلاً لجهودكم.',
        ),
      ],
    );
  }

  Widget _buildReviewCard(
    BuildContext context,
    ThemeColors colors, {
    required String userName,
    required String dateText,
    required String avatarLetter,
    required int rating,
    required String comment,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.border,
          width: colors.isDark ? 1 : 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Letter Avatar with beautiful styling
              CircleAvatar(
                radius: 18,
                backgroundColor: colors.background,
                child: Text(
                  avatarLetter,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        color: colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(width: 10),
              // User Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 11,
                            color: colors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              // Star Rating Display
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star_rounded,
                    size: 15,
                    color: index < rating ? colors.accent : colors.border,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Testimonial Text
          Text(
            comment,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12.5,
                  height: 1.6,
                  color: colors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

/// Bottom Action Navigation Bar fixed to the bottom, containing the main "احجز الآن" (Book Now) action button and chat trigger.
class _BottomActionNav extends ConsumerWidget {
  const _BottomActionNav();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);

    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
        top: 14,
      ),
      decoration: BoxDecoration(
        color: themeColors.surface,
        border: Border(
          top: BorderSide(
            color: themeColors.border,
            width: 0.8,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          // "احجز الآن" (Book Now) Button
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // Direct booking action triggers
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColors.primary, // Dark luxury navy
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'احجز الآن',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Chat Icon Button
          GestureDetector(
            onTap: () {
              // Open Chat Session
            },
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: themeColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: themeColors.border,
                  width: 1.2,
                ),
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                color: themeColors.primary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
