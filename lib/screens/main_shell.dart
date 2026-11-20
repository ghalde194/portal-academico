import 'package:flutter/material.dart';

import '../services/app_controller.dart';
import '../widgets/bottom_nav_bar.dart';
import 'absences_screen.dart';
import 'grades_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

/// Estrutura principal: as 4 abas + BottomNavigationBar.
///
/// Usa [IndexedStack] para manter o estado (scroll, carrossel) de cada aba
/// ao alternar entre elas.
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const _pages = <Widget>[HomeScreen(), GradesScreen(), AbsencesScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    // Botão "voltar" do Android: em qualquer aba que não seja a Home,
    // volta para a Home em vez de fechar o app.
    return PopScope(
      canPop: app.currentTab == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) app.setTab(0);
      },
      child: Scaffold(
        body: IndexedStack(index: app.currentTab, children: _pages),
        bottomNavigationBar: BottomNavBar(currentIndex: app.currentTab, onTap: app.setTab),
      ),
    );
  }
}
