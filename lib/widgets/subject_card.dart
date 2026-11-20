import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Card de disciplina na grade de horários (tela "Aulas").
///
/// Mostra horário (início/fim) numa coluna azul à esquerda e, à direita,
/// nome, professor, sala e modalidade.
class SubjectCard extends StatelessWidget {
  const SubjectCard({super.key, required this.schedule, this.isNow = false, this.onTap});

  final ClassSchedule schedule;

  /// Destaca o card quando a aula está acontecendo agora.
  final bool isNow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final subject = schedule.subject;

    return Material(
      color: isNow ? AppColors.primarySoft : AppColors.surface,
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Coluna de horário
              Container(
                width: 70,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(
                      schedule.start,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      schedule.end,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            schedule.subjectName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (isNow) const _NowChip(),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _line(Icons.co_present_outlined, schedule.professor),
                    const SizedBox(height: 4),
                    _line(
                      Icons.push_pin,
                      '${schedule.room}  •  ${subject?.modality ?? 'Presencial'}',
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

  Widget _line(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 16, color: AppColors.textSecondary),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
      ),
    ],
  );
}

class _NowChip extends StatelessWidget {
  const _NowChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(20)),
      child: const Text(
        'Agora',
        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
