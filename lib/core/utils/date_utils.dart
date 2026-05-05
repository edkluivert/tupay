import 'package:intl/intl.dart';

class FormatDateUtils {
  static String dayMonthYear(DateTime dateTime) {
    final formatter = DateFormat('dd MMM, yyyy');
    return formatter.format(dateTime);
  }
}

class FormatDateAndTime {
  static String dayMonthYearTime(DateTime dateTime) {
    final formatter = DateFormat('dd MMM yyyy - h:mm a');
    return formatter.format(dateTime);
  }

  static String date(DateTime dateTime) {
    final formatter = DateFormat('dd MMM, yyyy');
    return formatter.format(dateTime);
  }

  static String time(DateTime dateTime) {
    final formatter = DateFormat(' h:mm a');
    return formatter.format(dateTime);
  }
}
