import 'subject.dart';

/// Um horário de aula na grade semanal.
class ClassSchedule {
  final String subjectId;

  /// Dia da semana no padrão do Dart: 1 = segunda ... 7 = domingo.
  final int weekday;
  final String start; // "19:00"
  final String end; // "20:40"
  final String room;
  final Subject? subject;

  const ClassSchedule({
    required this.subjectId,
    required this.weekday,
    required this.start,
    required this.end,
    required this.room,
    this.subject,
  });

  String get subjectName => subject?.name ?? subjectId;
  String get professor => subject?.professor ?? '';

  /// Minutos desde 00:00 do horário de início (usado para ordenar/comparar).
  int get startMinutes => _toMinutes(start);
  int get endMinutes => _toMinutes(end);

  static int _toMinutes(String hhmm) {
    final p = hhmm.split(':');
    return int.parse(p[0]) * 60 + int.parse(p[1]);
  }

  factory ClassSchedule.fromJson(Map<String, dynamic> json) => ClassSchedule(
    subjectId: json['subjectId'] as String,
    weekday: (json['weekday'] as num).toInt(),
    start: json['start'] as String,
    end: json['end'] as String,
    room: json['room'] as String,
  );

  Map<String, dynamic> toJson() => {
    'subjectId': subjectId,
    'weekday': weekday,
    'start': start,
    'end': end,
    'room': room,
  };

  ClassSchedule withSubject(Subject? s) => ClassSchedule(
    subjectId: subjectId,
    weekday: weekday,
    start: start,
    end: end,
    room: room,
    subject: s,
  );
}
