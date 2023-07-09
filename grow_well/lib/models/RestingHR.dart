import 'package:intl/intl.dart';

class RestingHR {
  final DateTime time;
  final double value;

  RestingHR({required this.time, required this.value});

  // Named constructor of RestingHR class with input parameters:
  // date = date: 2023-05-04 (of type String)
  // json = data: {time: 00:00:00, value: 52.93, error: 6.83}
  RestingHR.fromJson(String date, Map<String, dynamic> json)
      : time = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
        value = json["value"];

  @override
  String toString() {
    return 'RestingHR(time: ${time}, value: ${value})';
  } //toString
} //RestingHR