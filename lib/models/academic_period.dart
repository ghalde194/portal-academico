import 'absence.dart';
import 'grade.dart';

/// Um período letivo (ex.: "2026/02") com suas notas e faltas.
class AcademicPeriod {
  final String id; // "2026/02"
  final String label; // "2º semestre de 2026"
  final String lastSync; // "11:58"
  final List<Grade> grades;
  final List<Absence> absences;

  const AcademicPeriod({
    required this.id,
    required this.label,
    required this.lastSync,
    required this.grades,
    required this.absences,
  });

  factory AcademicPeriod.fromJson(Map<String, dynamic> json) => AcademicPeriod(
    id: json['id'] as String,
    label: json['label'] as String? ?? json['id'] as String,
    lastSync: json['lastSync'] as String? ?? '--:--',
    grades: (json['grades'] as List<dynamic>? ?? [])
        .map((e) => Grade.fromJson(e as Map<String, dynamic>))
        .toList(),
    absences: (json['absences'] as List<dynamic>? ?? [])
        .map((e) => Absence.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'lastSync': lastSync,
    'grades': grades.map((g) => g.toJson()).toList(),
    'absences': absences.map((a) => a.toJson()).toList(),
  };
}
