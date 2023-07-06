import 'package:intl/intl.dart';

class RestingHR {
  final DateTime time;
  final double value;

  RestingHR({required this.time, required this.value});

  // Named constructor of RestingHR class with input parameters:
  // date = date: 2023-05-04 (of type String)
  // json = data: {time: 00:00:00, value: 52.93, error: 6.83}
  // (MAP  with key of type String and values of type String, double, double respectively)
  RestingHR.fromJson(String date, Map<String, dynamic> json)
      : time = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
        value = json["value"];

  // In the end we obtain an object RestingHR with:
  // time = 2023-05-05 00:00:00.000 --> type DateTime
  // value = 52.93 --> type double

  @override
  String toString() {
    return 'RestingHR(time: ${time}, value: ${value})';
  } //toString

/*
  Map<String, dynamic> toMap() {
    return {
      'time': time.toString(),
      'value': value,
    };
  }

  static RestingHR fromMap(Map<String, dynamic> map) {
    return RestingHR(
      time: DateTime.parse(map['time']),
      value: map['value'],
    );
  } */
} //restingHR