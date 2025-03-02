import 'package:flutter/material.dart';

String getDateFromDateTime(DateTime dateTime) {
  return dateTime.toString().split(' ')[0];
}

DateTime getDateTimeFromDate(String date) {
  return DateTime.parse(date);
}

String getTimeFromTimeOfDay(TimeOfDay timeOfDay) {
  return '${timeOfDay.hour} : ${timeOfDay.minute}';
}

TimeOfDay getTimeOfDayFromTime(String time) {
  final int hours = int.parse(time.split(':')[0]);
  final int minutes = int.parse(time.split(':')[1]);
  return TimeOfDay(hour: hours, minute: minutes);
}
