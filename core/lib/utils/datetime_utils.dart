part of '../core.dart';

class DateTimeUtils {
  // 'HH:mm, dd/MM/yyyy'
  static const String standardWithHourMinutes = 'HH:mm, dd/MM/yyyy';

  //'HH:mm:ss - dd/MM/yyyy'
  static const String standardWithHourMinutesSeconds = 'HH:mm:ss - dd/MM/yyyy';

  // 'dd/MM/yyyy'
  static const String standard = 'dd/MM/yyyy';

  // 'HH:mm'
  static const String justHourMinutes = 'HH:mm';

  // 'MM/yyyy'
  static const String justMonthYear = 'MM/yyyy';

  static String? formatDateTime(int? time, String s) {
    if (time == null) return null;

    final date = DateTime.fromMillisecondsSinceEpoch(time);

    return DateFormat(s).format(date);
  }

  static String? formatDateTimeToLocal(int? time, String s) {
    if (time == null) return null;

    final date = DateTime.fromMillisecondsSinceEpoch(time).toUtc();

    return DateFormat(s).format(date);
  }

  static String convertDateReverse(String? date) {
    const String formatDate = 'dd/MM/yyyy';
    const String formatDateApi = 'yyyy-MM-dd';

    if (date != null && date.isNotEmpty) {
      DateTime dateTime = DateFormat(formatDate).parse(date);
      var inputDate = DateTime.parse(dateTime.toString());
      var outputFormat = DateFormat(formatDateApi);
      var outputDate = outputFormat.format(inputDate);
      return outputDate;
    } else {
      return '';
    }
  }

  static formatTime({required int time}) {
    int sec = time % 60;
    int min = (time / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return " $minute:$second";
  }

  static secondsToDate(int time) {
    var date = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    return DateFormat('HH:mm - dd/MM/yyyy').format(date); // 31/12/2000, 22:00
  }

  static timePrint() {
    DateTime now = DateTime.now();
    return '${now.hour}:${now.minute}:${now.second}.${now.millisecond}';
  }

  static String timeStampToTime(int? time) {
    String formatTime = 'HH:mm';

    return formatDateTime(time, formatTime) ?? '';
  }

  static String timeStampToDate(int? time) {
    String formatDate = 'dd/MM/yyyy';

    return formatDateTime(time, formatDate) ?? '';
  }

  static String convertDate(date, [format]) {
    String formatDate = 'dd/MM/yyyy';
    if (format != null) {
      formatDate = format;
    }

    if (date is String && date.isNotEmpty) {
      DateTime dateTime = DateTime.parse(date);
      return formatDateTime(dateTime.millisecondsSinceEpoch, formatDate) ?? '';
    } else if (date is DateTime) {
      return formatDateTime(date.millisecondsSinceEpoch, formatDate) ?? '';
    } else {
      return '';
    }
  }

  static String fomatHourDateMonth(int? millis) {
// 12 Hour format:
    return DateFormat('HH:mm, dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(millis!));
  }

  // static List<RowItem> getMonthList() {
  //   List<RowItem> list = [];
  //   for (int i = 1; i <= 12; i++) {
  //     list.add(RowItem(
  //       id: i.toString(),
  //       name: DateTimeUtils.formatDateTime(
  //         DateTime(DateTime.now().year, i).millisecondsSinceEpoch,
  //         'MM/yyyy',
  //       ),
  //       value: DateTime(DateTime.now().year, i),
  //     ));
  //   }
  //   return list;
  // }

  static String convertMillisecondsToHours(
    int? millis, {
    bool isShowSecond = false,
  }) {
    if (millis != null) {
      final int hour = (millis / 3600000).floor();
      final int minute = ((millis % 3600000) / 60000).floor();
      final int second = ((millis % 3600000) % 60000 / 1000).floor();

      final String hourStr = hour < 10 ? '0$hour' : '$hour';
      final String minuteStr = minute < 10 ? '0$minute' : '$minute';
      final String secondStr = second < 10 ? '0$second' : '$second';

      if (isShowSecond) {
        return '$hourStr:$minuteStr:$secondStr';
      } else {
        return '$hourStr:$minuteStr';
      }
    }
    return '- -';
  }

  static String convertDateInit(String? date) {
    const String formatDate = 'dd/MM/yyyy';
    const String formatDateApi = 'yyyy-MM-dd';

    if (date != null && date.isNotEmpty) {
      DateTime dateTime = DateFormat(formatDateApi).parse(date);
      var outputFormat = DateFormat(formatDate);
      var outputDate = outputFormat.format(dateTime);
      return outputDate;
    } else {
      return '';
    }
  }

  static int sinceEpochToMilliseconds(int? time) {
    if (time == null) return 0;

    final date = DateTime.fromMillisecondsSinceEpoch(time);

    return date.hour * 3600000 + date.minute * 60000;
  }

  static int millisecondsToSinceEpoch(int? time) {
    if (time == null) return 0;

    final int hour = (time / 3600000).floor();
    final int minute = ((time % 3600000) / 60000).floor();
    final int second = ((time % 3600000) % 60000 / 1000).floor();

    final DateTime date = DateTime.now();

    return DateTime(date.year, date.month, date.day, hour, minute, second).millisecondsSinceEpoch;
  }

  static bool compareDateTimeAndNow(dynamic date, dynamic time) {
    DateTime d;
    DateTime t;

    if (Utils.isNullOrEmpty(date)) {
      d = DateTime.now().toUtc();
    } else if (date is DateTime) {
      d = date.toUtc();
    } else {
      d = DateTime.fromMillisecondsSinceEpoch(date).toUtc();
    }
    if (Utils.isNullOrEmpty(time)) {
      t = DateTime.now().toUtc();
    } else if (time is DateTime) {
      t = time.toUtc();
    } else {
      t = DateTime.fromMillisecondsSinceEpoch(time).toUtc();
    }

    final now = DateTime.now().toUtc();
    final checkDate = DateTime(
      d.year,
      d.month,
      d.day,
      t.hour,
      t.minute,
    );

    return checkDate.millisecondsSinceEpoch > now.millisecondsSinceEpoch;
  }

  static int getCurrentTimeStamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static int getAge(date) {
    if (date is String && date.isNotEmpty) {
      DateTime dateTime = DateTime.parse(date);
      return DateTime.now().year - dateTime.year - 1;
    } else if (date is DateTime) {
      return DateTime.now().year - date.year - 1;
    } else {
      return 1;
    }
  }

  static DateTime stringToDate(String d) {
    return DateFormat("dd/MM/yyyy").parse(d);
  }

  static String getFirstDay(DateTime month) {
    return DateFormat('dd/MM/yyyy').format(DateTime(month.year, month.month, 1));
  }

  static String getLastDay(DateTime month) {
    return DateFormat('dd/MM/yyyy').format(DateTime(month.year, month.month + 1, 0));
  }
}
