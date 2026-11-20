import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Cor de cada situação de faltas (verde / amarelo / vermelho).
Color absenceColor(AbsenceStatus status) => switch (status) {
  AbsenceStatus.ok => AppColors.success,
  AbsenceStatus.warning => AppColors.warning,
  AbsenceStatus.exceeded => AppColors.danger,
  AbsenceStatus.noLimit => AppColors.textMuted,
};

/// Card de faltas de uma disciplina:
///
///   Web Design
///   [██████████████████░░]   18/20  >
///   (!) Fique atento!
///   Acompanhe suas faltas! Ultrapassar 20 faltas nessa matéria pode causar reprovação.
class AbsenceCard extends StatelessWidget {
  const AbsenceCard({super.key, required this.absence, this.onTap});

  final Absence absence;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final status = absence.status;
    final color = absenceColor(status);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 14, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                absence.subjectName,
                style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _ProgressBar(value: absence.progress, color: color),
                  ),
                  const SizedBox(width: 18),
                  Text(
                    absence.label,
                    style: const TextStyle(fontSize: 18, color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                ],
              ),
              // Mensagens de alerta (só aparecem em amarelo/vermelho)
              if (status == AbsenceStatus.warning || status == AbsenceStatus.exceeded) ...[
                const SizedBox(height: 18),
                Row(
                  children: [
                    Icon(Icons.error_outline_rounded, color: color, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      status == AbsenceStatus.warning ? 'Fique atento!' : 'Atenção!',
                      style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  status == AbsenceStatus.warning
                      ? 'Acompanhe suas faltas! Ultrapassar ${absence.max} faltas '
                            'nessa matéria pode causar reprovação.'
                      : 'Você estourou o limite de faltas desta disciplina.',
                  style: const TextStyle(fontSize: 15, height: 1.45, color: AppColors.textPrimary),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Barra arredondada com animação de preenchimento.
class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value, required this.color});
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: v,
          minHeight: 11,
          color: color,
          backgroundColor: AppColors.progressTrack,
        ),
      ),
    );
  }
}
