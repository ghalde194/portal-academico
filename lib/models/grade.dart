import 'subject.dart';

/// Notas de uma disciplina em um período.
///
/// AC1 / AC2 = avaliações contínuas, AF = avaliação final,
/// Sub = substitutiva, AG = avaliação geral. Valores nulos aparecem como "-".
class Grade {
  final String subjectId;
  final double? ac1;
  final double? ac2;
  final double? af;
  final double? sub;
  final double? ag;
  final double? average;

  /// Disciplina associada (preenchida pelo repositório após o carregamento).
  final Subject? subject;

  const Grade({
    required this.subjectId,
    this.ac1,
    this.ac2,
    this.af,
    this.sub,
    this.ag,
    this.average,
    this.subject,
  });

  String get subjectName => subject?.name ?? subjectId;

  static double? _num(dynamic v) => v == null ? null : (v as num).toDouble();

  factory Grade.fromJson(Map<String, dynamic> json) => Grade(
    subjectId: json['subjectId'] as String,
    ac1: _num(json['ac1']),
    ac2: _num(json['ac2']),
    af: _num(json['af']),
    sub: _num(json['sub']),
    ag: _num(json['ag']),
    average: _num(json['average']),
  );

  Map<String, dynamic> toJson() => {
    'subjectId': subjectId,
    'ac1': ac1,
    'ac2': ac2,
    'af': af,
    'sub': sub,
    'ag': ag,
    'average': average,
  };

  Grade withSubject(Subject? s) => Grade(
    subjectId: subjectId,
    ac1: ac1,
    ac2: ac2,
    af: af,
    sub: sub,
    ag: ag,
    average: average,
    subject: s,
  );
}
