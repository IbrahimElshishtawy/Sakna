import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../../core/presentation/widgets/primary_button.dart';
import '../providers/booking_flow_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';

class AddOrderDetailsScreen extends ConsumerStatefulWidget {
  const AddOrderDetailsScreen({super.key});

  @override
  ConsumerState<AddOrderDetailsScreen> createState() => _AddOrderDetailsScreenState();
}

class _AddOrderDetailsScreenState extends ConsumerState<AddOrderDetailsScreen> {
  final _notesController = TextEditingController();
  
  // Voice note interactive state
  bool _isPlaying = false;
  int _seconds = 14;
  Timer? _playbackTimer;
  double _playbackProgress = 0.5; // Starts at 0.5 for 14 seconds

  // List of mock image URLs for attachment simulation
  final List<String> _mockUploadedPhotos = [
    'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=400&q=80'
  ];

  @override
  void initState() {
    super.initState();
    final currentDetails = ref.read(bookingFlowProvider);
    _notesController.text = currentDetails.writtenNotes ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    _playbackTimer?.cancel();
    super.dispose();
  }

  void _togglePlayback() {
    if (_isPlaying) {
      _playbackTimer?.cancel();
      setState(() {
        _isPlaying = false;
      });
    } else {
      setState(() {
        _isPlaying = true;
      });
      _playbackTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        setState(() {
          if (_seconds <= 0) {
            _isPlaying = false;
            _seconds = 14;
            _playbackProgress = 0.0;
            timer.cancel();
          } else {
            _seconds--;
            _playbackProgress = (14 - _seconds) / 14;
          }
        });
      });
    }
  }

  void _resetPlayback() {
    _playbackTimer?.cancel();
    setState(() {
      _isPlaying = false;
      _seconds = 14;
      _playbackProgress = 0.0;
    });
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);
    final bookingFlowNotifier = ref.read(bookingFlowProvider.notifier);

    final isAr = t.isArabic;

    return Scaffold(
      backgroundColor: themeColors.background,
      appBar: AppBar(
        backgroundColor: themeColors.primary,
        foregroundColor: Colors.white,
        title: Text(
          t.translate('add_order_details'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(isAr ? Icons.arrow_forward : Icons.arrow_back),
          onPressed: () {
            bookingFlowNotifier.updateWrittenNotes(_notesController.text);
            context.pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              bookingFlowNotifier.updateWrittenNotes('');
              context.push('/select-address');
            },
            child: Text(
              t.translate('skip'),
              style: TextStyle(
                color: themeColors.accent,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Progress Step Indicator
            Container(
              color: themeColors.surface,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                children: [
                  _buildStep(1, t.translate('step_service'), true, false, themeColors),
                  _buildLine(true, themeColors),
                  _buildStep(2, t.translate('step_schedule'), true, false, themeColors),
                  _buildLine(true, themeColors),
                  _buildStep(3, t.translate('step_details'), false, true, themeColors),
                  _buildLine(false, themeColors),
                  _buildStep(4, t.translate('step_payment'), false, false, themeColors),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // 2. Title & Description
                    Text(
                      t.translate('have_additional_details'),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: themeColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t.translate('details_desc'),
                      style: TextStyle(
                        fontSize: 14,
                        color: themeColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3. Written Notes Section
                    Text(
                      t.translate('written_notes'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: themeColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _notesController,
                      maxLines: 4,
                      onChanged: (val) {
                        bookingFlowNotifier.updateWrittenNotes(val);
                      },
                      style: TextStyle(color: themeColors.textPrimary, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: t.translate('written_notes_hint'),
                        hintStyle: TextStyle(color: themeColors.textSecondary.withValues(alpha: 0.7)),
                        contentPadding: const EdgeInsets.all(16),
                        fillColor: themeColors.surface,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: themeColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: themeColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: themeColors.accent, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 4. Attach Photos Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t.translate('attach_photos'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: themeColors.textPrimary,
                          ),
                        ),
                        Text(
                          t.translate('max_photos_limit'),
                          style: TextStyle(
                            fontSize: 12,
                            color: themeColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: Row(
                        children: [
                          // Add Button
                          GestureDetector(
                            onTap: () {
                              if (_mockUploadedPhotos.length < 4) {
                                setState(() {
                                  _mockUploadedPhotos.add(
                                    'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?auto=format&fit=crop&w=400&q=80',
                                  );
                                });
                                bookingFlowNotifier.addPhoto(_mockUploadedPhotos.last);
                              }
                            },
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: themeColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: themeColors.border, style: BorderStyle.values[1]), // Dashed-like or thin border
                              ),
                              child: Center(
                                child: Icon(Icons.add, color: themeColors.accent, size: 28),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // List of uploaded photos
                          Expanded(
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _mockUploadedPhotos.length,
                              separatorBuilder: (context, index) => const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final photoUrl = _mockUploadedPhotos[index];
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        photoUrl,
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _mockUploadedPhotos.removeAt(index);
                                          });
                                          bookingFlowNotifier.removePhoto(index);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.close, color: Colors.white, size: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 5. Voice Note Section
                    Text(
                      t.translate('voice_note'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: themeColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: themeColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: themeColors.border),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.mic, color: themeColors.accent, size: 24),
                              const SizedBox(width: 12),
                              Text(
                                _formatDuration(_seconds),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: themeColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Waveform simulator
                              Expanded(
                                child: SizedBox(
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: List.generate(15, (index) {
                                      // Dynamic height based on whether it is playing and timer state
                                      double barHeight = 4.0 + (index % 4) * 5.0;
                                      if (_isPlaying) {
                                        barHeight = 4.0 + ((index + _seconds) % 5) * 6.0;
                                      }
                                      return Container(
                                        width: 3,
                                        height: barHeight,
                                        decoration: BoxDecoration(
                                          color: _isPlaying && index / 15 < _playbackProgress
                                              ? themeColors.accent
                                              : themeColors.textSecondary.withValues(alpha: 0.4),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Play Button
                              GestureDetector(
                                onTap: _togglePlayback,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: themeColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      _isPlaying ? Icons.pause : Icons.play_arrow,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24, thickness: 0.5),
                          // Re-record Button
                          GestureDetector(
                            onTap: _resetPlayback,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.refresh, color: themeColors.textSecondary, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  t.translate('re_record'),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: themeColors.textSecondary,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // 6. Bottom Review Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: themeColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: PrimaryButton(
                text: t.translate('review_order_summary'),
                color: themeColors.primary,
                textColor: Colors.white,
                icon: isAr ? Icons.arrow_back : Icons.arrow_forward,
                iconFirst: false,
                onPressed: () {
                  bookingFlowNotifier.updateWrittenNotes(_notesController.text);
                  bookingFlowNotifier.updateVoiceNote(_mockUploadedPhotos.isNotEmpty ? 'simulated_audio_path' : null);
                  context.push('/select-address');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int stepNum, String title, bool isDone, bool isActive, ThemeColors colors) {
    final circleColor = isDone
        ? colors.primary
        : (isActive ? colors.primary : colors.border);
    final borderColor = isDone
        ? colors.accent
        : (isActive ? colors.accent : colors.border);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor,
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text(
                    stepNum.toString(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.white : colors.textSecondary,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive || isDone ? FontWeight.bold : FontWeight.normal,
            color: isActive || isDone ? colors.textPrimary : colors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLine(bool isDone, ThemeColors colors) {
    return Expanded(
      child: Container(
        height: 2,
        color: isDone ? colors.primary : colors.border,
        margin: const EdgeInsets.only(bottom: 16),
      ),
    );
  }
}
