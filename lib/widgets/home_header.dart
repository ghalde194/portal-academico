import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/formatters.dart';

/// Header azul da Home: menu, sino com badge, "Olá, Leonardo" e a data.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.firstName,
    required this.date,
    required this.unreadCount,
    required this.onMenu,
    required this.onNotifications,
  });

  final String firstName;
  final DateTime date;
  final int unreadCount;
  final VoidCallback onMenu;
  final VoidCallback onNotifications;

  /// Sol de dia, lua à noite (detalhe do app original).
  bool get _isDay => date.hour >= 6 && date.hour < 18;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: EdgeInsets.fromLTRB(20, topPadding + 8, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Linha de ícones: menu (esq.) e notificações (dir.)
          Row(
            children: [
              IconButton(
                tooltip: 'Menu',
                onPressed: onMenu,
                icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Notificações',
                onPressed: onNotifications,
                icon: Badge(
                  isLabelVisible: unreadCount > 0,
                  backgroundColor: Colors.white,
                  smallSize: 9,
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Saudação + ícone com brilho
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    'Olá, $firstName',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                _GlowIcon(icon: _isDay ? Icons.wb_sunny_outlined : Icons.nightlight_outlined),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_outlined, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Text(
                  Formatters.headerDate(date),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Ícone branco com um halo suave, como o sol do app de referência.
class _GlowIcon extends StatelessWidget {
  const _GlowIcon({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Color(0x88FFFFFF), blurRadius: 22, spreadRadius: 2)],
      ),
      child: Icon(icon, color: Colors.white, size: 30),
    );
  }
}
