import 'package:flutter/material.dart';

import '../services/app_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/subject_card.dart';

/// Tela "Aulas" — grade semanal de horários (atalho da Home).
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  static const _days = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];

  /// Começa no dia de hoje (domingo abre na segunda).
  int _weekday = DateTime.now().weekday == DateTime.sunday ? 1 : DateTime.now().weekday;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;

    final classes = app.data.schedule.where((c) => c.weekday == _weekday).toList()
      ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));

    return Scaffold(
      appBar: const CustomAppBar(title: 'Aulas'),
      body: Column(
        children: [
          // Seletor de dia da semana
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _days.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final weekday = i + 1;
                final selected = weekday == _weekday;
                final isToday = weekday == now.weekday;
                return ChoiceChip(
                  label: Text(isToday ? '${_days[i]} • hoje' : _days[i]),
                  selected: selected,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _weekday = weekday),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.textPrimary,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: classes.isEmpty
                ? const EmptyState(
                    icon: Icons.free_breakfast_outlined,
                    message: 'Sem aulas neste dia.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                    itemCount: classes.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final c = classes[i];
                      final isNow =
                          c.weekday == now.weekday &&
                          nowMinutes >= c.startMinutes &&
                          nowMinutes < c.endMinutes;
                      return SubjectCard(schedule: c, isNow: isNow);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
