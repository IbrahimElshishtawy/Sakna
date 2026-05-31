import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';
import '../controllers/live_tracking_controller.dart';
import '../../domain/entities/tracking_task.dart';
import '../widgets/active_job_card_widget.dart';
import '../widgets/task_list_item_widget.dart';
import '../widgets/live_updates_widget.dart';

class LiveTrackingScreen extends ConsumerWidget {
  const LiveTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final trackingState = ref.watch(liveTrackingControllerProvider);
    final t = ref.watch(translationProvider);

    return Scaffold(
      backgroundColor: themeColors.background,
      body: SafeArea(
        child: _buildBody(context, ref, trackingState, themeColors, t),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    dynamic state,
    dynamic themeColors,
    dynamic t,
  ) {
    // 1. Loading State with smooth pulse
    if (state.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: themeColors.accent,
                strokeWidth: 3.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              t.isArabic ? 'جاري تحميل تفاصيل العمل...' : 'Loading job details...',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Cairo',
                color: themeColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    // 2. Error State
    if (state.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 54, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                state.errorMessage!,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Cairo',
                  color: themeColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => ref
                    .read(liveTrackingControllerProvider.notifier)
                    .fetchTrackingData('active_booking_1'),
                child: Text(t.translate('retry'), style: const TextStyle(fontFamily: 'Cairo')),
              ),
            ],
          ),
        ),
      );
    }

    final job = state.jobTracking;
    if (job == null) {
      return const SizedBox.shrink();
    }

    // Calculate completed task count
    final totalTasks = job.tasks.length;
    final completedTasks = job.tasks
        .where((t) => t.status == TrackingTaskStatus.completed)
        .length;

    // 3. Success state - Scrollable tracking layout
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Responsive Top Header (Hamburger on right, Bell on left in RTL)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Right side in RTL: Menu hamburger icon
                _buildHeaderIcon(
                  context,
                  themeColors,
                  icon: Icons.menu_rounded,
                  onTap: () {
                    // Open drawer action
                  },
                ),
                // Centered App/Company Branding Logo
                Text(
                  'KHEDMA',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: themeColors.textPrimary,
                    letterSpacing: 1.5,
                  ),
                ),
                // Left side in RTL: Bell Notifications icon
                _buildHeaderIcon(
                  context,
                  themeColors,
                  icon: Icons.notifications_none_rounded,
                  onTap: () {},
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Ticking Active Job status card
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: ActiveJobCardWidget(job: job),
            ),
            
            const SizedBox(height: 32),
            
            // Tasks Section Title & Completed counter tag
            FadeIn(
              duration: const Duration(milliseconds: 500),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.translate('tasks'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: themeColors.textPrimary,
                    ),
                  ),
                  Text(
                    '$completedTasks / $totalTasks ${t.translate('completed_out_of')}',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                      color: themeColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 18),
            
            // List / Column of task checklist steps
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: job.tasks.length,
              itemBuilder: (context, index) {
                final task = job.tasks[index];
                return FadeInLeft(
                  duration: Duration(milliseconds: 400 + (index * 150)),
                  child: TaskListItemWidget(task: task),
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // Live Updates (images + floating actions)
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: LiveUpdatesWidget(images: job.liveImages),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(
    BuildContext context,
    dynamic themeColors, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: themeColors.surface,
        border: Border.all(
          color: themeColors.border.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: themeColors.isDark ? 0.15 : 0.02,
            ),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Center(
            child: Icon(
              icon,
              color: themeColors.textPrimary,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
