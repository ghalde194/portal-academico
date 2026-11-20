import 'subject.dart';

/// Regras de cálculo da média (centralizadas para facilitar ajustes).
///
/// Fórmula oficial da Facens:
///   MF = AC1 × 0,15 + AC2 × 0,30 + AG × 0,10 + AF × 0,45
class GradeRules {
  GradeRules._();

  static const double weightAc1 = 0.15;
  static const double weightAc2 = 0.30;
  static const double weightAg = 0.10;
  static const double weightAf = 0.45;

  /// Média mínima para aprovação — ajuste se a sua regra for diferente.
  static const double passingGrade = 6.0;
}

/// Notas de uma disciplina em um período.
///
/// AC1 / AC2 = avaliações contínuas, AF = avaliação final,
/// Sub = substitutiva, AG = avaliação geral. Valores nulos aparecem como "-".
///
/// A média NÃO vem do JSON: é sempre calculada por [average].
class Grade {
  final String subjectId;
  final double? ac1;
  final double? ac2;
  final double? af;
  final double? sub;
  final double? ag;

  /// Disciplina associada (preenchida pelo repositório após o carregamento).
  final Subject? subject;

  const Grade({
    required this.subjectId,
    this.ac1,
    this.ac2,
    this.af,
    this.sub,
    this.ag,
    this.subject,
  });

  String get subjectName => subject?.name ?? subjectId;

  /// AC1 e AC2 efetivas: se houver Sub, ela substitui a MENOR das duas
  /// (somente se for maior que ela).
  (double, double) get _effectiveAcs {
    var a1 = ac1 ?? 0;
    var a2 = ac2 ?? 0;
    final s = sub;
    if (s != null) {
      if (a1 <= a2 && s > a1) {
        a1 = s;
      } else if (a2 < a1 && s > a2) {
        a2 = s;
      }
    }
    return (a1, a2);
  }

  /// Soma das notas já lançadas, sem a AF (o que o aluno já "garantiu").
  double get pointsWithoutAf {
    final (a1, a2) = _effectiveAcs;
    return a1 * GradeRules.weightAc1 + a2 * GradeRules.weightAc2 + (ag ?? 0) * GradeRules.weightAg;
  }

  /// Média final: AC1×0,15 + AC2×0,30 + AG×0,10 + AF×0,45.
  /// Só é calculada depois que a AF é lançada; antes disso fica null ("-"),
  /// igual ao app original.
  double? get average {
    if (af == null) return null;
    return _round2(pointsWithoutAf + af! * GradeRules.weightAf);
  }

  /// true enquanto a AF ainda não foi lançada.
  bool get isPartial => af == null;

  /// Nota necessária na AF para atingir a média mínima.
  /// Pode ser <= 0 (já garantido) ou > 10 (impossível).
  double get neededOnAf =>
      _round2((GradeRules.passingGrade - pointsWithoutAf) / GradeRules.weightAf);

  static double _round2(double v) => (v * 100).roundToDouble() / 100;

  static double? _num(dynamic v) => v == null ? null : (v as num).toDouble();

  factory Grade.fromJson(Map<String, dynamic> json) => Grade(
    subjectId: json['subjectId'] as String,
    ac1: _num(json['ac1']),
    ac2: _num(json['ac2']),
    af: _num(json['af']),
    sub: _num(json['sub']),
    ag: _num(json['ag']),
  );

  Map<String, dynamic> toJson() => {
    'subjectId': subjectId,
    'ac1': ac1,
    'ac2': ac2,
    'af': af,
    'sub': sub,
    'ag': ag,
  };

  Grade withSubject(Subject? s) =>
      Grade(subjectId: subjectId, ac1: ac1, ac2: ac2, af: af, sub: sub, ag: ag, subject: s);
}
