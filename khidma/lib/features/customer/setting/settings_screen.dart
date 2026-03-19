// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khidma/core/app_routes.dart';
import 'package:khidma/core/bloc/user_bloc/user_bloc.dart';
import 'package:khidma/core/bloc/user_bloc/user_event.dart';
import 'package:khidma/core/bloc/user_bloc/user_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool appUpdatesEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // عشان تخطيط عربي
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF3B5998),
          title: const Text('الإعدادات'),
        ),
        body: ListView(
          children: [
            const SizedBox(height: 8),

            // اللغة
            ListTile(
              title: const Text('اللغة'),
              subtitle: const Text('العربية'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.languageSettings);
              },
            ),

            // المظهر (Dark/Light)
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                bool isDark = false;
                if (state is UserProfileLoaded) {
                  isDark = state.isDarkMode;
                }
                return SwitchListTile(
                  title: const Text('الوضع الليلي'),
                  secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                  value: isDark,
                  onChanged: (val) {
                    context.read<UserBloc>().add(ToggleThemeEvent());
                  },
                );
              },
            ),

            // الإشعارات (سويتش عام)
            SwitchListTile(
              title: const Text('الإشعارات'),
              value: notificationsEnabled,
              onChanged: (val) {
                setState(() => notificationsEnabled = val);
              },
            ),

            // تحديثات التطبيق التلقائية
            SwitchListTile(
              title: const Text('تحديثات التطبيق التلقائية'),
              value: appUpdatesEnabled,
              onChanged: (val) {
                setState(() => appUpdatesEnabled = val);
              },
            ),

            // إعدادات الإشعارات التفصيلية
            ListTile(
              title: const Text('إعدادات الإشعارات'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.notificationSettings);
              },
            ),

            const Divider(),

            // إدارة الحساب → صفحة تعديل الملف الشخصي
            ListTile(
              title: const Text('إدارة الحساب'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.editProfile);
              },
            ),

            // الخصوصية → سياسة الخصوصية
            ListTile(
              title: const Text('الخصوصية'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.privacyPolicy);
              },
            ),

            // حول التطبيق
            ListTile(
              title: const Text('حول التطبيق'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.aboutUs);
              },
            ),

            const Divider(),

            // المساعدة والدعم → الأسئلة الشائعة
            ListTile(
              title: const Text('المساعدة والدعم'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.faq);
              },
            ),

            // التواصل معنا → صفحة الدعم / الاتصال
            ListTile(
              title: const Text('التواصل معنا'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.contactSupport);
              },
            ),

            // تقييم التطبيق (لسه مفيش Route، نعمله حاليًا Dialog بسيط)
            ListTile(
              title: const Text('تقييم التطبيق'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('تقييم التطبيق'),
                    content: const Text(
                      'سيتم ربط هذه الخاصية بمتجر التطبيقات لاحقاً.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('حسناً'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
