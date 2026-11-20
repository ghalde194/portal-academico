import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

/// AppBar das telas internas: "<  Notas                    (?)"
///
/// Reproduz o visual do app de referência: seta fina à esquerda, título
/// cinza e botão de ajuda azul redondo à direita.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title, this.onBack, this.onHelp, this.actions});

  final String title;

  /// Se nulo, usa `Navigator.maybePop`.
  final VoidCallback? onBack;

  /// Se informado, mostra o botão "?" azul.
  final VoidCallback? onHelp;

  /// Ações extras (substituem o botão de ajuda se informadas).
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 72,
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      leadingWidth: 64,
      leading: IconButton(
        tooltip: 'Voltar',
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24),
        color: AppColors.textPrimary,
        onPressed: onBack ?? () => Navigator.of(context).maybePop(),
      ),
      titleSpacing: 0,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        ...?actions,
        if (actions == null && onHelp != null)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _HelpButton(onPressed: onHelp!),
          ),
      ],
    );
  }
}

/// Círculo azul com "?" (igual ao app).
class _HelpButton extends StatelessWidget {
  const _HelpButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Ajuda',
      child: Material(
        color: AppColors.primary,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: const SizedBox(
            width: 32,
            height: 32,
            child: Center(
              child: Text(
                '?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
