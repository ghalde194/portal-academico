import 'package:flutter/material.dart';

import '../services/app_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/common.dart';
import '../widgets/custom_app_bar.dart';

/// Lista de notificações (aberta pelo sino do header).
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final items = app.notifications;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notificações',
        actions: [
          if (app.unreadNotifications > 0)
            TextButton(
              onPressed: app.markAllNotificationsAsRead,
              child: const Text('Marcar lidas'),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: items.isEmpty
          ? const EmptyState(
              icon: Icons.notifications_off_outlined,
              message: 'Você não tem notificações.',
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final n = items[i];
                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: n.read ? AppColors.surface : AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    n.title,
                                    style: TextStyle(
                                      fontWeight: n.read ? FontWeight.w500 : FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  Formatters.relative(n.date),
                                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              n.body,
                              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
