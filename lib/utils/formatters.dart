/// Funções de formatação em português (sem depender do pacote `intl`).
class Formatters {
  Formatters._();

  static const _monthsShort = [
    'jan.',
    'fev.',
    'mar.',
    'abr.',
    'mai.',
    'jun.',
    'jul.',
    'ago.',
    'set.',
    'out.',
    'nov.',
    'dez.',
  ];

  static const _weekdays = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo',
  ];

  static const _weekdaysShort = ['seg', 'ter', 'qua', 'qui', 'sex', 'sáb', 'dom'];

  /// "20 nov. 2026" — mesmo formato do header do app de referência.
  static String headerDate(DateTime d) => '${d.day} ${_monthsShort[d.month - 1]} ${d.year}';

  /// "12/08/2026"
  static String date(DateTime d) => '${_two(d.day)}/${_two(d.month)}/${d.year}';

  /// "qua, 12/08"
  static String shortDateWithWeekday(DateTime d) =>
      '${_weekdaysShort[d.weekday - 1]}, ${_two(d.day)}/${_two(d.month)}';

  /// 1 -> "Segunda-feira"
  static String weekdayName(int weekday) => _weekdays[weekday - 1];

  /// "há 2 h", "ontem", "14/11"...
  static String relative(DateTime d, {DateTime? now}) {
    final ref = now ?? DateTime.now();
    final diff = ref.difference(d);
    if (diff.inMinutes < 1) return 'agora';
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'há ${diff.inHours} h';
    if (diff.inDays == 1) return 'ontem';
    if (diff.inDays < 7) return 'há ${diff.inDays} dias';
    return '${_two(d.day)}/${_two(d.month)}';
  }

  /// Nota no padrão brasileiro: 7.68 -> "7,68", 6.0 -> "6", 8.5 -> "8,5",
  /// null -> "-".
  static String grade(double? value) {
    if (value == null) return '-';
    if (value == value.roundToDouble()) return value.toInt().toString();
    var s = value.toStringAsFixed(2);
    if (s.endsWith('0')) s = s.substring(0, s.length - 1);
    return s.replaceAll('.', ',');
  }

  static String _two(int n) => n.toString().padLeft(2, '0');
}
