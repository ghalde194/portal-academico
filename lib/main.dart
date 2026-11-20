import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/main_shell.dart';
import 'services/app_controller.dart';
import 'services/local_academic_repository.dart';
import 'theme/app_theme.dart';
import 'widgets/common.dart';

/// Ponto de entrada do app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // App apenas em retrato, como a maioria dos apps acadêmicos.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Status bar transparente; cada tela define se os ícones são claros/escuros.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const PortalAcademicoApp());
}

/// Widget raiz: cria o controller e o disponibiliza para todo o app.
class PortalAcademicoApp extends StatefulWidget {
  const PortalAcademicoApp({super.key});

  @override
  State<PortalAcademicoApp> createState() => _PortalAcademicoAppState();
}

class _PortalAcademicoAppState extends State<PortalAcademicoApp> {
  // 👉 Para usar uma API no futuro, troque LocalAcademicRepository por
  //    uma implementação própria de AcademicRepository.
  late final AppController _controller = AppController(const LocalAcademicRepository())..load();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      controller: _controller,
      child: MaterialApp(
        title: 'Portal Acadêmico',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const _RootGate(),
      ),
    );
  }
}

/// Decide o que mostrar conforme o estado de carregamento.
class _RootGate extends StatelessWidget {
  const _RootGate();

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: switch (app.state) {
        LoadState.loading => const LoadingView(key: ValueKey('loading')),
        LoadState.error => ErrorView(
          key: const ValueKey('error'),
          message: app.errorMessage ?? 'Erro desconhecido',
          onRetry: app.load,
        ),
        LoadState.ready => const MainShell(key: ValueKey('ready')),
      },
    );
  }
}
