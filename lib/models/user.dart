/// Modelo do aluno logado.
///
/// Todos os modelos possuem `fromJson`/`toJson` para que, no futuro, a troca
/// do JSON local por uma API REST não exija nenhuma mudança nas telas.
class User {
  final String id;
  final String firstName;
  final String fullName;
  final String ra;
  final String course;
  final String email;
  final String phone;
  final String campus;
  final String semester;
  final String shift;
  final String enrollmentStatus;

  const User({
    required this.id,
    required this.firstName,
    required this.fullName,
    required this.ra,
    required this.course,
    required this.email,
    required this.phone,
    required this.campus,
    required this.semester,
    required this.shift,
    required this.enrollmentStatus,
  });

  /// Iniciais usadas no avatar fictício (ex.: "Leonardo Almeida" -> "LA").
  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    firstName: json['firstName'] as String,
    fullName: json['fullName'] as String,
    ra: json['ra'] as String,
    course: json['course'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String? ?? '',
    campus: json['campus'] as String? ?? '',
    semester: json['semester'] as String? ?? '',
    shift: json['shift'] as String? ?? '',
    enrollmentStatus: json['enrollmentStatus'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'fullName': fullName,
    'ra': ra,
    'course': course,
    'email': email,
    'phone': phone,
    'campus': campus,
    'semester': semester,
    'shift': shift,
    'enrollmentStatus': enrollmentStatus,
  };

  /// Cria uma cópia alterando apenas os campos informados (usado no Editar Perfil).
  User copyWith({String? firstName, String? fullName, String? email, String? phone}) => User(
    id: id,
    firstName: firstName ?? this.firstName,
    fullName: fullName ?? this.fullName,
    ra: ra,
    course: course,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    campus: campus,
    semester: semester,
    shift: shift,
    enrollmentStatus: enrollmentStatus,
  );
}
