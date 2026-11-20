import 'package:flutter/material.dart';

import '../services/app_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/custom_app_bar.dart';
import 'edit_profile_screen.dart';

/// Tela 4 — Perfil do aluno.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final user = app.user;

    return Scaffold(
      appBar: CustomAppBar(title: 'Perfil', onBack: () => app.setTab(0)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          // Foto fictícia + nome + curso
          Center(child: ProfileAvatar(initials: user.initials)),
          const SizedBox(height: 16),
          Text(
            user.fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            user.course,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user.enrollmentStatus,
                style: const TextStyle(
                  color: AppColors.success,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 26),

          // Dados acadêmicos e de contato
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            ),
            child: Column(
              children: [
                InfoTile(icon: Icons.badge_outlined, label: 'RA', value: user.ra),
                const Divider(indent: 76),
                InfoTile(icon: Icons.school_outlined, label: 'Curso', value: user.course),
                const Divider(indent: 76),
                InfoTile(
                  icon: Icons.timelapse_rounded,
                  label: 'Semestre • Turno',
                  value: '${user.semester} • ${user.shift}',
                ),
                const Divider(indent: 76),
                InfoTile(icon: Icons.location_on_outlined, label: 'Campus', value: user.campus),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            ),
            child: Column(
              children: [
                InfoTile(icon: Icons.mail_outline_rounded, label: 'E-mail', value: user.email),
                const Divider(indent: 76),
                InfoTile(icon: Icons.phone_outlined, label: 'Telefone', value: user.phone),
              ],
            ),
          ),
          const SizedBox(height: 28),

          FilledButton.icon(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: (_) => const EditProfileScreen())),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Editar Perfil'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _confirmLogout(context),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair da conta?'),
        content: const Text('Esta é uma versão de demonstração — nenhum dado será perdido.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(88, 44)),
            onPressed: () {
              Navigator.pop(ctx);
              showComingSoon(context, 'O login');
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}
