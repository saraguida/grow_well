import 'package:flutter/material.dart';
import 'package:simple_line_chart/simple_line_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LineChartContent extends StatefulWidget {
  LineChartContent({Key? key}) : super(key: key);

  @override
  _LineChartContentState createState() => _LineChartContentState();
}

class _LineChartContentState extends State<LineChartContent> {
  LineChartData _data =
      LineChartData(datasets: [Dataset(label: 'First', dataPoints:[DataPoint(x: 1, y: 0), DataPoint(x: 2, y: 0),DataPoint(x: 3, y: 0),DataPoint(x: 4, y: 0),DataPoint(x: 5, y: 0),DataPoint(x: 6, y: 0),DataPoint(x: 7, y: 0)])]);

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    List<DataPoint> dataPoints = await _createDataPoints();
    if (dataPoints.isNotEmpty) {
      setState(() {
        _data = LineChartData(datasets: [
          Dataset(label: 'Resting Heart Rate [bpm]', dataPoints: dataPoints),
        ]);
      });
    }
  }
  String formatLabel(dynamic value) {
  if (value is DataPoint) {
    return value.y.toStringAsFixed(1);
  }
  return '';
}

  @override
Widget build(BuildContext context) {
  final template = LineChartStyle.fromTheme(context);
  final style = template.copyWithAxes(
    bottomAxisStyle: template.bottomAxisStyle?.copyWith(
      labelIncrementMultiples: 1,
      labelOnDatapoints: true,
    ),
    leftAxisStyle: template.leftAxisStyle?.copyWith(
      labelOnDatapoints: true,
      labelProvider: (value) => formatLabel(value),
      marginAbove: 0,
      marginBelow: 0,
    ),
  ).copyWith(
    datasetStyles: [
      DatasetStyle(
        color: Colors.yellow.shade900,
        fillOpacity: 0,
        lineSize: 2,
      ),
    ],
  ).copyWithoutLegend();

  return Scaffold(
    body: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: LineChart(
            style: style,
            seriesHeight: 300,
            data: _data,
          ),
        ),
      ],
    ),
  );
}


Future<List<DataPoint>> _createDataPoints() async {
  List<DataPoint> dataPoints = [];

  final sp = await SharedPreferences.getInstance();

  if (sp.getStringList("dates") != null) {
    List<double?> listDataPoints = [
      sp.getDouble('0'),
      sp.getDouble("1"),
      sp.getDouble("2"),
      sp.getDouble("3"),
      sp.getDouble("4"),
      sp.getDouble("5"),
      sp.getDouble("6"),
    ];

    dataPoints = listDataPoints
        .asMap()
        .entries
        .map((entry) => DataPoint(x: entry.key + 1, y: entry.value!.toDouble()))
        .toList();
  }

  return dataPoints;
}
}