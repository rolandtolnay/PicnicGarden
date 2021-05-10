import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringUtility on String {
  String get capitalized => this[0].toUpperCase() + substring(1);

  /// Removes all white-space in the string
  String sanitized() => trim().replaceAll(' ', '');

  _Name asName() => _Name.from(this);
}

class _Name {
  late String first;
  String? last;

  _Name.from(String fullName) {
    first = '';
    last = '';
    final nameList = fullName.split(' ');
    if (nameList.isNotEmpty) {
      first = nameList[0];
    }
    if (nameList.length > 1) {
      last = fullName.substring(first.length).trim();
    }
  }
}

extension Utility on DateTime {
  bool isSameDayAs(DateTime date) =>
      year == date.year && month == date.month && day == date.day;

  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get endOfDay => DateTime(year, month, day, 23, 59);

  DateTime get firstDayOfWeek =>
      subtract(Duration(days: weekday - 1)).startOfDay;

  DateTime withTimeOfDay(TimeOfDay timeOfDay) =>
      DateTime(year, month, day, timeOfDay.hour, timeOfDay.minute);

  /// 01.09 09:41
  String get consoleDescription =>
      '${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')} '
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  /// 9 jan. 09:41
  String get fullDescription =>
      '${DateFormat.MMMd().format(this)} ${DateFormat.Hm().format(this)}';

  /// 09:41
  String get timeDescription => '${DateFormat.Hm().format(this)}';

  /// 9 jan.
  String get dateDescription => '${DateFormat.MMMMd().format(this)}';

  TimeOfDay get timeOfDay => TimeOfDay.fromDateTime(this);
}

extension Compare on TimeOfDay {
  bool operator >=(TimeOfDay timeOfDay) {
    if (hour == timeOfDay.hour) {
      return minute >= timeOfDay.minute;
    } else {
      return hour > timeOfDay.hour;
    }
  }

  bool operator <=(TimeOfDay timeOfDay) {
    if (hour == timeOfDay.hour) {
      return minute <= timeOfDay.minute;
    } else {
      return hour < timeOfDay.hour;
    }
  }

  bool operator >(TimeOfDay timeOfDay) {
    if (hour == timeOfDay.hour) {
      return minute > timeOfDay.minute;
    } else {
      return hour > timeOfDay.hour;
    }
  }

  bool operator <(TimeOfDay timeOfDay) {
    if (hour == timeOfDay.hour) {
      return minute < timeOfDay.minute;
    } else {
      return hour < timeOfDay.hour;
    }
  }

  Duration durationTo(TimeOfDay timeOfDay) {
    return Duration(
      hours: timeOfDay.hour - hour,
      minutes: timeOfDay.minute - minute,
    );
  }

  TimeOfDay addingDuration(Duration duration) {
    final addedMinutes = duration.inMinutes + hour * 60 + minute;
    var resultHours = addedMinutes ~/ 60;
    if (resultHours > 23) {
      resultHours -= 24;
    }
    return TimeOfDay(hour: resultHours, minute: addedMinutes % 60);
  }

  TimeOfDay roundToNearestMinute(int roundToMinute) {
    var minutes = (minute / roundToMinute).round() * roundToMinute;
    var hours = hour;
    if (minutes >= 60) {
      hours += 1;
      if (hours >= 24) {
        hours = 0;
      }
      minutes -= 60;
    }
    return TimeOfDay(hour: hours, minute: minutes);
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

extension Unique<T> on List<T> {
  List<T> get uniqueElements => List.from(Set<T>.from(this));
}
