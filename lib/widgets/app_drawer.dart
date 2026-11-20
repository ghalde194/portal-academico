import 'package:flutter/material.dart';

import '../screens/notifications_screen.dart';
import '../screens/schedule_screen.dart';
import '../services/app_controller.dart';
import '../theme/app_colors.dart';
import 'common.dart';

/// Menu lateral aberto pelo ícone ☰ do header da Home.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final user = app.user;

    void goTab(int i) {
      Navigator.of(context).pop(); // fecha o drawer
      app.setTab(i);
    }

    void push(Widget page) {
      Navigator.of(context)
        ..pop()
        ..push(MaterialPageRoute<void>(builder: (_) => page));
    }

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Cabeçalho azul com avatar
          Container(
            width: double.infinity,
            color: AppColors.primary,
            padding: EdgeInsets.fromLTRB(24, MediaQuery.paddingOf(context).top + 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileAvatar(initials: user.initials, size: 72),
                const SizedBox(height: 14),
                Text(
                  user.fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'RA ${user.ra} • ${user.course}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _item(Icons.home_outlined, 'Início', () => goTab(0)),
                _item(Icons.schedule, 'Aulas', () => push(const ScheduleScreen())),
                _item(Icons.description_outlined, 'Notas', () => goTab(1)),
                _item(Icons.front_hand_outlined, 'Faltas', () => goTab(2)),
                _item(
                  Icons.notifications_none_rounded,
                  'Notificações',
                  () => push(const NotificationsScreen()),
                ),
                _item(Icons.person_outline_rounded, 'Perfil', () => goTab(3)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Divider(),
                ),
                _item(Icons.info_outline_rounded, 'Sobre o app', () {
                  Navigator.of(context).pop();
                  showAboutDialog(
                    context: context,
                    applicationName: 'Portal Acadêmico',
                    applicationVersion: '1.0.0',
                    applicationIcon: const Icon(
                      Icons.school_rounded,
                      color: AppColors.primary,
                      size: 40,
                    ),
                    children: const [
                      Text('Aplicativo acadêmico de demonstração com dados fictícios.'),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String label, VoidCallback onTap) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    leading: Icon(icon, color: AppColors.primary),
    title: Text(label, style: const TextStyle(fontSize: 15)),
    onTap: onTap,
  );
}
