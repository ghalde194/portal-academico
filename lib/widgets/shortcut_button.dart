import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Atalho circular da Home (Aulas, Notas, Faltas, Ver mais).
class ShortcutButton extends StatelessWidget {
  const ShortcutButton({super.key, required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
                child: Icon(icon, color: AppColors.primary, size: 28),
              ),
              const SizedBox(height: 10),
              Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
            ],
          ),
        ),
      ),
    );
  }
}
