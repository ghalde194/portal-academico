import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/app_controller.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';
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
            _HelpLine('Média', 'AC1×0,15 + AC2×0,30 + AG×0,10 + AF×0,45'),
            SizedBox(height: 8),
            Text(
              'Enquanto a AF não sai, a média mostrada é parcial (AF conta como 0). '
              '"-" indica nota ainda não lançada.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Entendi'))],
      ),
    );
  }

  /// Detalhes da disciplina ao tocar no bloco de notas: média, situação e
  /// quanto falta tirar na AF.
  void _showDetails(BuildContext context, Grade grade) {
    final avg = grade.average;
    final pass = GradeRules.passingGrade;
    final needed = grade.neededOnAf;

    final (String status, Color color, String detail) = switch (avg) {
      null => ('Em andamento', AppColors.textSecondary, 'Nenhuma nota lançada ainda.'),
      _ when grade.isPartial && needed <= 0 => (
        'Média já garantida',
        AppColors.success,
        'Mesmo com 0 na AF você atinge ${Formatters.grade(pass)}.',
      ),
      _ when grade.isPartial && needed > 10 => (
        'Em risco',
        AppColors.danger,
        'Nem com 10 na AF é possível chegar a ${Formatters.grade(pass)}.',
      ),
      _ when grade.isPartial => (
        'Aguardando AF',
        AppColors.warning,
        'Você precisa de ${Formatters.grade(needed)} na AF para atingir '
            'média ${Formatters.grade(pass)}.',
      ),
      final a when a >= pass => (
        'Aprovado',
        AppColors.success,
        'Média final ${Formatters.grade(a)}.',
      ),
      final a => ('Reprovado', AppColors.danger, 'Média final ${Formatters.grade(a)}.'),
    };

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
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.circle, size: 12, color: color),
                const SizedBox(width: 8),
                Text('Situação: $status', style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 6),
            Text(detail, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            Text(
              grade.isPartial
                  ? 'Média parcial = AC1×0,15 + AC2×0,30 + AG×0,10 (AF ainda não lançada)'
                  : 'Média = AC1×0,15 + AC2×0,30 + AG×0,10 + AF×0,45',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
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
