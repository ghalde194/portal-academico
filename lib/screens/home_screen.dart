import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/models.dart';
import '../services/app_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/home_header.dart';
import '../widgets/promo_banner.dart';
import '../widgets/shortcut_button.dart';
import 'notifications_screen.dart';
import 'schedule_screen.dart';

/// Tela 1 — Dashboard / Home.
///
/// Header azul → cards das próximas aulas → atalhos → banner → mural.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late DateTime _now = DateTime.now();
  Timer? _clock;

  @override
  void initState() {
    super.initState();
    // Atualiza a cada minuto (data, ícone sol/lua e "próxima aula").
    _clock = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  void _openSchedule() =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const ScheduleScreen()));

  void _openNotifications() => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const NotificationsScreen()));

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final upcoming = app.upcomingClasses(_now);
    final cardWidth = MediaQuery.sizeOf(context).width * 0.78;

    // Ícones da status bar brancos sobre o header azul.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const AppDrawer(),
        body: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: app.refresh,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              HomeHeader(
                firstName: app.user.firstName,
                date: _now,
                unreadCount: app.unreadNotifications,
                onMenu: () => _scaffoldKey.currentState?.openDrawer(),
                onNotifications: _openNotifications,
              ),

              // --- Próximas aulas -------------------------------------------
              if (upcoming.dayLabel != 'Hoje' && upcoming.classes.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                  child: Text(
                    'Próximas aulas • ${upcoming.dayLabel}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ),
              const SizedBox(height: 18),
              SizedBox(
                height: 172,
                child: upcoming.classes.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma aula programada 🎉',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        itemCount: upcoming.classes.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 14),
                        itemBuilder: (_, i) => DashboardCard(
                          schedule: upcoming.classes[i],
                          width: cardWidth,
                          onTap: _openSchedule,
                        ),
                      ),
              ),

              // --- Atalhos circulares ---------------------------------------
              const SizedBox(height: 26),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ShortcutButton(icon: Icons.schedule, label: 'Aulas', onTap: _openSchedule),
                    ShortcutButton(
                      icon: Icons.assignment_outlined,
                      label: 'Notas',
                      onTap: () => app.setTab(1),
                    ),
                    ShortcutButton(
                      icon: Icons.front_hand_outlined,
                      label: 'Faltas',
                      onTap: () => app.setTab(2),
                    ),
                    ShortcutButton(
                      icon: Icons.add_rounded,
                      label: 'Ver mais',
                      onTap: () => _showMoreSheet(context),
                    ),
                  ],
                ),
              ),

              // --- Banner promocional ---------------------------------------
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PromoBannerCarousel(
                  banners: app.data.banners,
                  onTap: (b) => showComingSoon(context, b.title),
                ),
              ),

              // --- Mural ------------------------------------------------------
              const SizedBox(height: 26),
              const Divider(height: 1),
              const SizedBox(height: 10),
              SectionHeader(
                title: 'Mural',
                onTap: () => showComingSoon(context, 'O mural completo'),
              ),
              SizedBox(
                height: 128,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  itemCount: app.data.notices.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => NoticeCard(
                    notice: app.data.notices[i],
                    width: cardWidth,
                    onTap: () => _showNotice(context, app.data.notices[i]),
                  ),
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  /// Detalhe simples de um aviso do mural.
  void _showNotice(BuildContext context, Notice notice) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notice.category.toUpperCase(),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            Text(notice.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(notice.subtitle, style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  /// Bottom sheet "Ver mais" com outros serviços do portal.
  void _showMoreSheet(BuildContext context) {
    final app = AppScope.read(context);
    final items = <(IconData, String, VoidCallback)>[
      (Icons.schedule, 'Horários', _openSchedule),
      (Icons.notifications_none_rounded, 'Avisos', _openNotifications),
      (Icons.person_outline_rounded, 'Perfil', () => app.setTab(3)),
      (Icons.event_note_outlined, 'Calendário', () => showComingSoon(context, 'Calendário')),
      (
        Icons.account_balance_wallet_outlined,
        'Financeiro',
        () => showComingSoon(context, 'Financeiro'),
      ),
      (Icons.folder_open_outlined, 'Documentos', () => showComingSoon(context, 'Documentos')),
      (Icons.local_library_outlined, 'Biblioteca', () => showComingSoon(context, 'Biblioteca')),
      (Icons.support_agent_outlined, 'Suporte', () => showComingSoon(context, 'Suporte')),
    ];

    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            mainAxisSpacing: 8,
            childAspectRatio: 0.82,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (final (icon, label, action) in items)
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    action();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: AppColors.primary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        label,
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
