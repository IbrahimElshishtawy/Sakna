import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
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
            // Share action
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
