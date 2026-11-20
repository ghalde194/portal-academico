import 'package:flutter/material.dart';

import '../services/app_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/absence_card.dart';
import '../widgets/common.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/period_selector.dart';
import 'absence_detail_screen.dart';

/// Tela 3 — Faltas.
class AbsencesScreen extends StatelessWidget {
  const AbsencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final period = app.selectedPeriod;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Faltas',
        onBack: () => app.setTab(0),
        onHelp: () => _showHelp(context),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: app.refresh,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            PeriodSelector(
              period: period.id,
              lastSync: period.lastSync,
              onPrevious: app.canGoToPreviousPeriod ? app.previousPeriod : null,
              onNext: app.canGoToNextPeriod ? app.nextPeriod : null,
            ),
            const SizedBox(height: 22),
            if (period.absences.isEmpty)
              const EmptyState(
                icon: Icons.front_hand_outlined,
                message: 'Nenhuma falta registrada neste período.',
              )
            else
              for (final absence in period.absences) ...[
                AbsenceCard(
                  absence: absence,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => AbsenceDetailScreen(absence: absence, periodId: period.id),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
          ],
        ),
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Como funcionam as faltas'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Legend(color: AppColors.success, text: 'Até 70% do limite'),
            _Legend(color: AppColors.warning, text: 'Acima de 70% — fique atento'),
            _Legend(color: AppColors.danger, text: 'Limite ultrapassado'),
            SizedBox(height: 12),
            Text(
              'Ultrapassar o limite de faltas pode causar reprovação na disciplina, '
              'independentemente das notas.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Entendi'))],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.text});
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 10,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
