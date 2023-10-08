import 'package:flutter/material.dart';

class MyDateUtil {
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    date = date.subtract(Duration(hours: 3));

    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMessageTime(
      {required BuildContext context, required String time}) {
    DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    sent = sent.subtract(Duration(hours: 3));
    DateTime now = DateTime.now();
    now = now.subtract(Duration(hours: 3));

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }

    return '${sent.day} ${_getMonth(sent)}';
  }

  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Fev';
      case 3:
        return 'Mar';
      case 4:
        return 'Abr';
      case 5:
        return 'Mai';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Ago';
      case 9:
        return 'Set';
      case 10:
        return 'Out';
      case 11:
        return 'Nov';
      case 12:
        return 'Dez';
    }

    return 'NA';
  }
}
