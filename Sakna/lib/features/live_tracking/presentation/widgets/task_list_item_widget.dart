import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';
import '../../domain/entities/tracking_task.dart';

class TaskListItemWidget extends ConsumerWidget {
  final TrackingTask task;

  const TaskListItemWidget({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);
    final isArabic = t.isArabic;

    // Design attributes according to task status
    Color statusColor;
    String? statusText;
    IconData statusIcon;
    bool isCompleted = task.status == TrackingTaskStatus.completed;
    bool isInProgress = task.status == TrackingTaskStatus.inProgress;
    bool hasRibbon = isCompleted || isInProgress;

    if (isCompleted) {
      statusColor = const Color(0xFF3B82F6); // Clean slate blue
      statusText = t.translate('completed');
      statusIcon = Icons.check;
    } else if (isInProgress) {
      statusColor = const Color(0xFFF59E0B); // Vibrant gold
      statusText = t.translate('in_progress');
      statusIcon = Icons.engineering_rounded;
    } else {
      statusColor = themeColors.textSecondary.withValues(alpha: 0.5);
      statusText = null;
      statusIcon = Icons.access_time_rounded;
    }

    final thinBorderSide = BorderSide(
      color: themeColors.border.withValues(alpha: 0.3),
      width: 1.5,
    );
    final thickBorderSide = BorderSide(
      color: statusColor,
      width: 4.5,
    );

    // RTL-aware leading thick vertical border ribbon
    final border = Border(
      right: isArabic && hasRibbon ? thickBorderSide : thinBorderSide,
      left: !isArabic && hasRibbon ? thickBorderSide : thinBorderSide,
      top: thinBorderSide,
      bottom: thinBorderSide,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: themeColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: border,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: themeColors.isDark ? 0.2 : 0.02,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            // Left content: Status tag (for completed / in-progress) + title & subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge (only if defined)
                  if (statusText != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  
                  // Task Title (with line-through if completed)
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: isCompleted
                          ? themeColors.textSecondary.withValues(alpha: 0.6)
                          : themeColors.textPrimary,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: themeColors.textSecondary.withValues(alpha: 0.6),
                      decorationThickness: 1.8,
                    ),
                  ),
                  
                  const SizedBox(height: 6),
                  
                  // Task Subtitle
                  Text(
                    task.description,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Cairo',
                      color: isCompleted
                          ? themeColors.textSecondary.withValues(alpha: 0.5)
                          : themeColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Right content: Toggled status circular icon (RTL swap aware)
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor.withValues(alpha: 0.1),
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  statusIcon,
                  color: statusColor,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
