import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Seletor de período:   <   [ 2026/02 ]   >
///
/// Mais abaixo mostra "Última sincronização às 11:58".
class PeriodSelector extends StatelessWidget {
  const PeriodSelector({
    super.key,
    required this.period,
    required this.lastSync,
    this.onPrevious,
    this.onNext,
  });

  final String period;
  final String lastSync;

  /// Nulo = seta desabilitada (não há período anterior/próximo).
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Arrow(
              icon: Icons.chevron_left_rounded,
              onTap: onPrevious,
              tooltip: 'Período anterior',
            ),
            const SizedBox(width: 12),
            // Pill cinza com o período (animação suave ao trocar)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                child: Text(
                  period,
                  key: ValueKey(period),
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            _Arrow(icon: Icons.chevron_right_rounded, onTap: onNext, tooltip: 'Próximo período'),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          'Última sincronização às $lastSync',
          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({required this.icon, required this.onTap, required this.tooltip});
  final IconData icon;
  final VoidCallback? onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      icon: Icon(icon, size: 28),
      color: AppColors.textSecondary,
      disabledColor: AppColors.textMuted.withValues(alpha: 0.35),
    );
  }
}
