// Calendar-day arithmetic that is safe across DST changes.
//
// Why not `DateTime.difference` / `subtract` / `add(Duration(days: n))` on
// local dates: those work on elapsed time. A local day is 23 or 25 hours long
// on a DST change, so `inDays` truncates 14 days to 13, and `subtract(…)`
// lands on 23:00 or 01:00 of the neighbouring day. Anything keyed by date
// (streaks, rank decay, heatmap cells) then misses its match.

/// Whole calendar days from [from] to [to]; the time of day is ignored and
/// the result is negative when [to] is earlier.
int calendarDaysBetween(DateTime from, DateTime to) =>
    DateTime.utc(to.year, to.month, to.day)
        .difference(DateTime.utc(from.year, from.month, from.day))
        .inDays;

/// Local midnight of the day [days] calendar days after [date] (before it for
/// a negative [days]). The time of day of [date] is dropped.
DateTime addCalendarDays(DateTime date, int days) =>
    DateTime(date.year, date.month, date.day + days);
