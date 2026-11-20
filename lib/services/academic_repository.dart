import '../models/models.dart';

/// Pacote com todos os dados acadêmicos carregados de uma vez.
class AcademicData {
  final User user;
  final List<Subject> subjects;
  final List<ClassSchedule> schedule;
  final List<AcademicPeriod> periods;
  final List<Notice> notices;
  final List<AppNotification> notifications;
  final List<PromoBannerData> banners;

  const AcademicData({
    required this.user,
    required this.subjects,
    required this.schedule,
    required this.periods,
    required this.notices,
    required this.notifications,
    required this.banners,
  });
}

/// Contrato da camada de dados.
///
/// As telas NUNCA leem o JSON diretamente: elas conversam com o
/// [AppController], que usa um [AcademicRepository]. Hoje a implementação é
/// `LocalAcademicRepository` (JSON em `lib/data`). Para integrar com uma API,
/// basta criar, por exemplo, um `ApiAcademicRepository implements
/// AcademicRepository` (usando `http` ou `dio`) e trocá-lo no `main.dart`.
abstract class AcademicRepository {
  /// Carrega tudo o que o app precisa para abrir.
  Future<AcademicData> load();

  /// Atualiza os dados do perfil do aluno.
  Future<User> updateUser(User user);
}
