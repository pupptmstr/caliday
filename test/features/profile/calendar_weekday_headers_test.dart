import 'package:caliday/features/profile/screens/workout_calendar_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

/// The calendar header names the weekdays in the language of the app, Monday
/// first like the month grid.
void main() {
  setUpAll(() async {
    await initializeDateFormatting('ru');
    await initializeDateFormatting('en');
  });

  test('Russian: Пн … Вс', () {
    expect(calendarWeekdayHeaders('ru'),
        ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс']);
  });

  test('English: Mon … Sun', () {
    expect(calendarWeekdayHeaders('en'),
        ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']);
  });
}
