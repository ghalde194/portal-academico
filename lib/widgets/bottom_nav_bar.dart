import 'package:flutter/material.dart';

/// Barra de navegação inferior (Material 3): Home, Notas, Faltas, Perfil.
///
/// As cores e o indicador vêm do `navigationBarTheme` em `app_theme.dart`.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  /// Itens da barra — mantenha na mesma ordem das telas do `MainShell`.
  static const destinations = <NavigationDestination>[
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.description_outlined),
      selectedIcon: Icon(Icons.description_rounded),
      label: 'Notas',
    ),
    NavigationDestination(
      icon: Icon(Icons.front_hand_outlined),
      selectedIcon: Icon(Icons.front_hand_rounded),
      label: 'Faltas',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline_rounded),
      selectedIcon: Icon(Icons.person_rounded),
      label: 'Perfil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      // Linha sutil separando a barra do conteúdo
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFEDEDED))),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        destinations: destinations,
      ),
    );
  }
}
