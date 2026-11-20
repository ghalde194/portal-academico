import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';

/// Bloco de notas de uma disciplina:
///
/// Banco de Dados
/// ┌─────┬─────┬────┬─────┬─────┬───────┐
/// │ AC1 │ AC2 │ AF │ Sub │ AG  │ Média │  <- "Média" em azul
/// │7,68 │5,94 │ -  │  -  │ 8,5 │ 6,71  │
/// └─────┴─────┴────┴─────┴─────┴───────┘
class GradeCard extends StatelessWidget {
  const GradeCard({super.key, required this.grade, this.onTap});

  final Grade grade;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cells = <(String, double?)>[
      ('AC1', grade.ac1),
      ('AC2', grade.ac2),
      ('AF', grade.af),
      ('Sub', grade.sub),
      ('AG', grade.ag),
    ];

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            grade.subjectName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          // Grid compacta: 6 colunas de mesma largura
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (label, value) in cells) ...[
                  Expanded(
                    child: _GradeCell(label: label, value: Formatters.grade(value)),
                  ),
                  const SizedBox(width: 3),
                ],
                const Expanded(
                  child: _GradeCell(
                    label: 'Média',
                    // Média não é calculada pelo app: fica "-" (igual ao app oficial).
                    value: '-',
                    highlighted: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Uma célula da grid (rótulo em negrito + valor).
class _GradeCell extends StatelessWidget {
  const _GradeCell({required this.label, required this.value, this.highlighted = false});

  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final fg = highlighted ? Colors.white : AppColors.textPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 2),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: TextStyle(fontSize: 14, color: fg)),
          ),
        ],
      ),
    );
  }
}
