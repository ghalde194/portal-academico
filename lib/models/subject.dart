/// Disciplina cursada pelo aluno.
class Subject {
  final String id;
  final String name;
  final String code;
  final String professor;
  final int workload; // carga horária em horas
  final String modality; // Presencial / EaD

  const Subject({
    required this.id,
    required this.name,
    required this.code,
    required this.professor,
    required this.workload,
    required this.modality,
  });

  bool get isOnline => modality.toLowerCase() == 'ead';

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
    id: json['id'] as String,
    name: json['name'] as String,
    code: json['code'] as String? ?? '',
    professor: json['professor'] as String? ?? '',
    workload: (json['workload'] as num?)?.toInt() ?? 0,
    modality: json['modality'] as String? ?? 'Presencial',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'professor': professor,
    'workload': workload,
    'modality': modality,
  };
}
