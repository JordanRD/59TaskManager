import 'package:intl/intl.dart';

String dateTimeToyyyyMMdd(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

enum StatusDate { unknown, late, today,completed }

enum Detail { all, today, late, active, done,justAdd }
