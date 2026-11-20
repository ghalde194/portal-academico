import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/models.dart';
import 'academic_repository.dart';

/// Implementação que lê o arquivo `lib/data/mock_data.json` empacotado no app.
///
/// Funciona 100% offline: não há backend nem chamadas de rede.
class LocalAcademicRepository implements AcademicRepository {
  static const String assetPath = 'lib/data/mock_data.json';

  /// Atraso artificial para simular uma requisição e exibir o loading.
  final Duration simulatedLatency;

  const LocalAcademicRepository({this.simulatedLatency = const Duration(milliseconds: 600)});

  @override
  Future<AcademicData> load() async {
    final raw = await rootBundle.loadString(assetPath);
    await Future<void>.delayed(simulatedLatency);
    final json = jsonDecode(raw) as Map<String, dynamic>;

    // 1) Disciplinas indexadas por id para "ligar" notas/faltas/horários.
    final subjects = (json['subjects'] as List<dynamic>)
        .map((e) => Subject.fromJson(e as Map<String, dynamic>))
        .toList();
    final byId = {for (final s in subjects) s.id: s};

    // 2) Horários semanais.
    final schedule = (json['schedule'] as List<dynamic>)
        .map((e) => ClassSchedule.fromJson(e as Map<String, dynamic>))
        .map((c) => c.withSubject(byId[c.subjectId]))
        .toList();

    // 3) Períodos letivos com notas e faltas.
    final periods =
        (json['periods'] as List<dynamic>).map((e) {
            final p = AcademicPeriod.fromJson(e as Map<String, dynamic>);
            final grades = p.grades.map((g) => g.withSubject(byId[g.subjectId])).toList()
              ..sort((a, b) => a.subjectName.compareTo(b.subjectName));
            return AcademicPeriod(
              id: p.id,
              label: p.label,
              lastSync: p.lastSync,
              grades: grades,
              absences: p.absences.map((a) => a.withSubject(byId[a.subjectId])).toList(),
            );
          }).toList()
          // Ordena do mais antigo para o mais recente (2026/01, 2026/02...).
          ..sort((a, b) => a.id.compareTo(b.id));

    return AcademicData(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      subjects: subjects,
      schedule: schedule,
      periods: periods,
      notices: (json['notices'] as List<dynamic>? ?? [])
          .map((e) => Notice.fromJson(e as Map<String, dynamic>))
          .toList(),
      notifications: (json['notifications'] as List<dynamic>? ?? [])
          .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
          .toList(),
      banners: (json['banners'] as List<dynamic>? ?? [])
          .map((e) => PromoBannerData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<User> updateUser(User user) async {
    // Sem backend: apenas simula a latência e devolve o mesmo usuário.
    // Com API, aqui seria um PUT /users/{id}.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return user;
  }
}
