import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/app_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/grade_card.dart';
import '../widgets/period_selector.dart';

/// Tela 2 — Notas.
class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final period = app.selectedPeriod;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notas',
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
            if (period.grades.isEmpty)
              const EmptyState(
                icon: Icons.assignment_outlined,
                message: 'Nenhuma nota lançada neste período.',
              )
            else
              for (final grade in period.grades) ...[
                GradeCard(grade: grade, onTap: () => _showDetails(context, grade)),
                const SizedBox(height: 18),
              ],
          ],
        ),
      ),
    );
  }

  /// Explica as siglas (botão "?").
  void _showHelp(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Entenda suas notas'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HelpLine('AC1 / AC2', 'Avaliações contínuas do semestre.'),
            _HelpLine('AF', 'Avaliação final.'),
            _HelpLine('Sub', 'Prova substitutiva (substitui a menor AC).'),
            _HelpLine('AG', 'Avaliação geral / institucional.'),
            _HelpLine('Média', 'Média final, lançada pela instituição.'),
            SizedBox(height: 8),
            Text(
              '"-" indica nota ainda não lançada.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Entendi'))],
      ),
    );
  }

  /// Detalhes da disciplina ao tocar no bloco de notas.
  void _showDetails(BuildContext context, Grade grade) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              grade.subjectName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              '${grade.subject?.code ?? ''} • Prof. ${grade.subject?.professor ?? '-'}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            GradeCard(grade: grade),
          ],
        ),
      ),
    );
  }
}

class _HelpLine extends StatelessWidget {
  const _HelpLine(this.term, this.meaning);
  final String term;
  final String meaning;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$term: ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: meaning),
          ],
        ),
      ),
    );
  }
}
