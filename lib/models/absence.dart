import 'subject.dart';

/// Situação de faltas — define a cor da barra e a mensagem do card.
enum AbsenceStatus {
  /// Até 70% do limite (verde).
  ok,

  /// Acima de 70% até atingir o limite (amarelo) -> "Fique atento!".
  warning,

  /// Passou do limite (vermelho) -> "Você estourou o limite...".
  exceeded,

  /// Disciplina sem limite definido (ex.: EaD) -> barra vazia e "0/-".
  noLimit,
}

/// Regras de cor das faltas centralizadas em um único lugar.
///
/// Igual ao app de referência: 20/20 ainda é amarelo ("Fique atento!") e só
/// fica vermelho quando PASSA do limite. Se quiser que 100% já seja vermelho,
/// troque `exceededFromPercent` para 100 e use `>=` em [Absence.status].
class AbsenceRules {
  static const double warningFromPercent = 70; // > 70% = amarelo
  static const double exceededFromPercent = 100; // > 100% = vermelho
}

/// Um registro de falta em uma data específica.
class AbsenceRecord {
  final DateTime date;
  final int count;

  const AbsenceRecord({required this.date, required this.count});

  factory AbsenceRecord.fromJson(Map<String, dynamic> json) => AbsenceRecord(
    date: DateTime.parse(json['date'] as String),
    count: (json['count'] as num).toInt(),
  );

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String().substring(0, 10),
    'count': count,
  };
}

/// Total de faltas de uma disciplina em um período.
class Absence {
  final String subjectId;
  final int total;
  final int? max; // limite de faltas; null = sem limite
  final List<AbsenceRecord> records;
  final Subject? subject;

  const Absence({
    required this.subjectId,
    required this.total,
    required this.max,
    this.records = const [],
    this.subject,
  });

  String get subjectName => subject?.name ?? subjectId;

  /// Percentual do limite já utilizado (0 a ∞).
  double get percent {
    if (max == null || max == 0) return 0;
    return total / max! * 100;
  }

  /// Valor 0..1 para a barra de progresso (limitado a 1).
  double get progress => (percent / 100).clamp(0.0, 1.0);

  AbsenceStatus get status {
    if (max == null) return AbsenceStatus.noLimit;
    if (percent > AbsenceRules.exceededFromPercent) return AbsenceStatus.exceeded;
    if (percent > AbsenceRules.warningFromPercent) return AbsenceStatus.warning;
    return AbsenceStatus.ok;
  }

  /// Texto "18/20" ou "0/-".
  String get label => '$total/${max ?? '-'}';

  /// Faltas restantes antes de estourar o limite.
  int? get remaining => max == null ? null : (max! - total);

  factory Absence.fromJson(Map<String, dynamic> json) => Absence(
    subjectId: json['subjectId'] as String,
    total: (json['total'] as num).toInt(),
    max: (json['max'] as num?)?.toInt(),
    records: (json['records'] as List<dynamic>? ?? [])
        .map((e) => AbsenceRecord.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'subjectId': subjectId,
    'total': total,
    'max': max,
    'records': records.map((r) => r.toJson()).toList(),
  };

  Absence withSubject(Subject? s) =>
      Absence(subjectId: subjectId, total: total, max: max, records: records, subject: s);
}
