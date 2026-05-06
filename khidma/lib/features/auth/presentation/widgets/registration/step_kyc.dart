import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:animate_do/animate_do.dart';

import '../../bloc/register_bloc.dart';
import '../../bloc/register_event.dart';
import '../../bloc/register_state.dart';
import 'terms_dialog.dart';

class StepKyc extends StatelessWidget {
  const StepKyc({super.key});

  Future<void> _pickFile(BuildContext context, bool isNationalId) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      context.read<RegisterBloc>().add(
            RegisterFilePicked(
              file: File(result.files.single.path!),
              isNationalId: isNationalId,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: const Text(
                  'التحقق من الهوية',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 100),
                child: Text(
                  'قم برفع المستندات المطلوبة لإكمال التسجيل',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // National ID Picker
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 200),
                child: _FileUploader(
                  title: 'صورة الهوية الوطنية',
                  icon: Icons.badge_rounded,
                  file: state.formData.nationalIdFile,
                  error: state.fieldErrors['nationalId'],
                  onTap: () => _pickFile(context, true),
                ),
              ),
              const SizedBox(height: 20),

              // Selfie Picker
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 300),
                child: _FileUploader(
                  title: 'صورة شخصية (سيلفي)',
                  icon: Icons.face_rounded,
                  file: state.formData.selfieFile,
                  error: state.fieldErrors['selfie'],
                  onTap: () => _pickFile(context, false),
                ),
              ),

              // Linear Progress Bar for upload
              if (state.uploadProgress > 0 && state.uploadProgress < 100)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: FadeIn(
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: state.uploadProgress / 100,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'جاري الرفع... ${state.uploadProgress.toInt()}%',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 32),

              // Terms & Conditions Checkbox
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 400),
                child: InkWell(
                  onTap: () {
                    context.read<RegisterBloc>().add(const RegisterTermsToggled());
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: state.fieldErrors.containsKey('terms')
                                ? Colors.redAccent
                                : Colors.white.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                          color: state.formData.agreedToTerms
                              ? Colors.white
                              : Colors.transparent,
                        ),
                        child: state.formData.agreedToTerms
                            ? const Icon(Icons.check, size: 16, color: Color(0xFF0F64FF))
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              'أوافق على ',
                              style: TextStyle(color: Colors.white),
                            ),
                            InkWell(
                              onTap: () => _showTermsDialog(context),
                              child: const Text(
                                'الشروط والأحكام',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state.fieldErrors.containsKey('terms'))
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 36),
                  child: Text(
                    state.fieldErrors['terms']!,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const TermsDialog(),
    );
  }
}

class _FileUploader extends StatelessWidget {
  final String title;
  final IconData icon;
  final File? file;
  final String? error;
  final VoidCallback onTap;

  const _FileUploader({
    required this.title,
    required this.icon,
    this.file,
    this.error,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = file != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: hasFile ? 0.2 : 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: error != null
                    ? Colors.redAccent.withValues(alpha: 0.8)
                    : hasFile
                        ? Colors.white.withValues(alpha: 0.8)
                        : Colors.white.withValues(alpha: 0.2),
                width: hasFile ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    hasFile ? Icons.check_circle_rounded : icon,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (hasFile) ...[
                        const SizedBox(height: 4),
                        Text(
                          file!.path.split('/').last,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ] else ...[
                        const SizedBox(height: 4),
                        Text(
                          'اضغط للرفع',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 12),
            child: Text(
              error!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
