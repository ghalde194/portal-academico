import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/absence_card.dart';
import '../widgets/common.dart';
import '../widgets/custom_app_bar.dart';

/// Detalhe das faltas de uma disciplina (aberto pela seta ">" do card).
class AbsenceDetailScreen extends StatelessWidget {
  const AbsenceDetailScreen({super.key, required this.absence, required this.periodId});

  final Absence absence;
  final String periodId;

  @override
  Widget build(BuildContext context) {
    final color = absenceColor(absence.status);
    final records = [...absence.records]..sort((a, b) => b.date.compareTo(a.date));
    final remaining = absence.remaining;

    return Scaffold(
      appBar: CustomAppBar(title: absence.subjectName),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
        children: [
          // Resumo com indicador circular
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 92,
                  height: 92,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: absence.progress,
                        strokeWidth: 9,
                        color: color,
                        backgroundColor: Colors.white,
                        strokeCap: StrokeCap.round,
                      ),
                      Center(
                        child: Text(
                          absence.label,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 22),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Período $periodId',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        absence.max == null
                            ? 'Sem limite de faltas'
                            : '${absence.percent.toStringAsFixed(0)}% do limite utilizado',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 6),
                      if (remaining != null)
                        Text(
                          remaining >= 0
                              ? 'Você ainda pode faltar $remaining ${remaining == 1 ? 'aula' : 'aulas'}.'
                              : 'Limite ultrapassado em ${-remaining} ${remaining == -1 ? 'falta' : 'faltas'}.',
                          style: TextStyle(color: remaining >= 0 ? AppColors.textSecondary : color),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Histórico',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          if (records.isEmpty)
            const EmptyState(
              icon: Icons.verified_outlined,
              message: 'Nenhuma falta registrada. Continue assim!',
            )
          else
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < records.length; i++) ...[
                    if (i > 0) const Divider(indent: 20, endIndent: 20),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      leading: const Icon(Icons.event_busy_outlined, color: AppColors.primary),
                      title: Text(Formatters.date(records[i].date)),
                      subtitle: Text(Formatters.weekdayName(records[i].date.weekday)),
                      trailing: Text(
                        '${records[i].count} ${records[i].count == 1 ? 'falta' : 'faltas'}',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
