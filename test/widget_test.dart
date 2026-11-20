import 'package:flutter_test/flutter_test.dart';
import 'package:portal_academico/models/models.dart';
import 'package:portal_academico/utils/formatters.dart';

/// Testes das regras de negócio do front-end.
void main() {
  group('Formatters.grade', () {
    test('formata no padrão brasileiro', () {
      expect(Formatters.grade(7.68), '7,68');
      expect(Formatters.grade(8.5), '8,5');
      expect(Formatters.grade(6), '6');
      expect(Formatters.grade(null), '-');
    });
  });

  group('Absence.status', () {
    Absence a(int total, int? max) => Absence(subjectId: 'x', total: total, max: max);

    test('verde até 70%', () => expect(a(14, 20).status, AbsenceStatus.ok));
    test('amarelo entre 71% e 100%', () {
      expect(a(15, 20).status, AbsenceStatus.warning);
      expect(a(18, 20).status, AbsenceStatus.warning);
      expect(a(20, 20).status, AbsenceStatus.warning);
    });
    test('vermelho acima do limite', () => expect(a(22, 20).status, AbsenceStatus.exceeded));
    test('sem limite', () {
      expect(a(0, null).status, AbsenceStatus.noLimit);
      expect(a(0, null).label, '0/-');
    });
  });

  test('Formatters.headerDate', () {
    expect(Formatters.headerDate(DateTime(2026, 11, 20)), '20 nov. 2026');
  });
}
