import 'package:flutter/widgets.dart';

import '../models/models.dart';
import 'academic_repository.dart';

/// Estado de carregamento do app.
enum LoadState { loading, ready, error }

/// Aulas a exibir na Home e o rótulo do dia ("Hoje", "Amanhã", "Segunda"...).
class UpcomingClasses {
  final String dayLabel;
  final List<ClassSchedule> classes;
  const UpcomingClasses(this.dayLabel, this.classes);
}

/// Controlador central (gerência de estado sem pacotes externos).
///
/// É um [ChangeNotifier]: quando algo muda, chama `notifyListeners()` e
/// todas as telas que usam `AppScope.of(context)` são reconstruídas.
class AppController extends ChangeNotifier {
  AppController(this._repository);

  final AcademicRepository _repository;

  LoadState state = LoadState.loading;
  String? errorMessage;
  AcademicData? _data;

  /// Aba atual da BottomNavigationBar (0 Home, 1 Notas, 2 Faltas, 3 Perfil).
  int currentTab = 0;

  /// Índice do período selecionado (compartilhado entre Notas e Faltas).
  int _periodIndex = 0;

  late User user;
  List<AppNotification> notifications = [];

  // ---------------------------------------------------------------------------
  // Carregamento
  // ---------------------------------------------------------------------------

  Future<void> load() async {
    state = LoadState.loading;
    notifyListeners();
    try {
      final data = await _repository.load();
      _data = data;
      user = data.user;
      notifications = List.of(data.notifications);
      _periodIndex = data.periods.isEmpty ? 0 : data.periods.length - 1; // mais recente
      state = LoadState.ready;
    } catch (e) {
      errorMessage = 'Não foi possível carregar os dados.\n$e';
      state = LoadState.error;
    }
    notifyListeners();
  }

  /// Recarrega os dados sem mostrar a tela de loading (puxar para atualizar).
  /// Mantém o período selecionado.
  Future<void> refresh() async {
    final currentId = state == LoadState.ready ? selectedPeriod.id : null;
    final data = await _repository.load();
    _data = data;
    user = data.user.id == user.id ? user : data.user; // preserva edições locais
    notifications = List.of(data.notifications);
    final idx = data.periods.indexWhere((p) => p.id == currentId);
    _periodIndex = idx >= 0 ? idx : data.periods.length - 1;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Getters de conveniência para as telas
  // ---------------------------------------------------------------------------

  AcademicData get data => _data!;
  List<AcademicPeriod> get periods => data.periods;
  AcademicPeriod get selectedPeriod => periods[_periodIndex];
  bool get canGoToPreviousPeriod => _periodIndex > 0;
  bool get canGoToNextPeriod => _periodIndex < periods.length - 1;
  int get unreadNotifications => notifications.where((n) => !n.read).length;

  /// Aulas do dia (ou do próximo dia com aula) a partir de [now].
  UpcomingClasses upcomingClasses(DateTime now) {
    const names = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'];
    final nowMinutes = now.hour * 60 + now.minute;

    for (var offset = 0; offset < 7; offset++) {
      final weekday = (now.weekday - 1 + offset) % 7 + 1;
      var list = data.schedule.where((c) => c.weekday == weekday).toList()
        ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
      if (offset == 0) {
        // Hoje: só as aulas que ainda não terminaram.
        list = list.where((c) => c.endMinutes > nowMinutes).toList();
      }
      if (list.isNotEmpty) {
        final label = switch (offset) {
          0 => 'Hoje',
          1 => 'Amanhã',
          _ => names[weekday - 1],
        };
        return UpcomingClasses(label, list);
      }
    }
    return const UpcomingClasses('Sem aulas', []);
  }

  // ---------------------------------------------------------------------------
  // Ações
  // ---------------------------------------------------------------------------

  void setTab(int index) {
    if (index == currentTab) return;
    currentTab = index;
    notifyListeners();
  }

  void previousPeriod() {
    if (!canGoToPreviousPeriod) return;
    _periodIndex--;
    notifyListeners();
  }

  void nextPeriod() {
    if (!canGoToNextPeriod) return;
    _periodIndex++;
    notifyListeners();
  }

  void markAllNotificationsAsRead() {
    notifications = notifications.map((n) => n.markAsRead()).toList();
    notifyListeners();
  }

  Future<void> updateProfile({
    required String fullName,
    required String email,
    required String phone,
  }) async {
    final firstName = fullName.trim().split(RegExp(r'\s+')).first;
    final updated = user.copyWith(
      fullName: fullName.trim(),
      firstName: firstName,
      email: email.trim(),
      phone: phone.trim(),
    );
    user = await _repository.updateUser(updated);
    notifyListeners();
  }
}

/// Disponibiliza o [AppController] para toda a árvore de widgets.
class AppScope extends InheritedNotifier<AppController> {
  const AppScope({super.key, required AppController controller, required super.child})
    : super(notifier: controller);

  /// Lê o controller e se inscreve para reconstruir quando ele mudar.
  static AppController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope não encontrado na árvore de widgets');
    return scope!.notifier!;
  }

  /// Lê o controller SEM se inscrever (use em callbacks como onPressed).
  static AppController read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope não encontrado na árvore de widgets');
    return scope!.notifier!;
  }
}
