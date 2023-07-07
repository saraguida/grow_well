import 'package:flutter/material.dart';
import 'package:simple_line_chart/simple_line_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LineChartContent extends StatefulWidget {
  LineChartContent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LineChartContentState();
  }
}

class _LineChartContentState extends State<LineChartContent> {
  LineChartData _data =
      LineChartData(datasets: [Dataset(label: 'First', dataPoints: [])]);

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    // Perform asynchronous operations
    List<DataPoint> dataPoints = await _createDataPoints();
    List<DataPoint> dataPoints_upper = [
      DataPoint(x: 0, y: 80),
      DataPoint(x: 1, y: 80),
      DataPoint(x: 2, y: 80),
      DataPoint(x: 3, y: 80),
      DataPoint(x: 4, y: 80),
      DataPoint(x: 5, y: 80),
      DataPoint(x: 6, y: 80)
    ];

    List<DataPoint> dataPoints_lower = [
      DataPoint(x: 0, y: 30),
      DataPoint(x: 1, y: 30),
      DataPoint(x: 2, y: 30),
      DataPoint(x: 3, y: 30),
      DataPoint(x: 4, y: 30),
      DataPoint(x: 5, y: 30),
      DataPoint(x: 6, y: 30)
    ];

    if (dataPoints.length != 0) {
      setState(() {
        // Update the state of the widget
        _data = LineChartData(datasets: [
          Dataset(label: 'Resting Heart Rate', dataPoints: dataPoints),
          Dataset(label: 'Upper bound', dataPoints: dataPoints_upper),
          Dataset(label: 'Lower bound', dataPoints: dataPoints_lower)
        ]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final template = LineChartStyle.fromTheme(context);
    final style = template
        .copyWithAxes(
            bottomAxisStyle: template.bottomAxisStyle?.copyWith(
              labelIncrementMultiples: 1,
              labelOnDatapoints: true,
              //labelProvider: (p0) {},
            ),
            leftAxisStyle: template.leftAxisStyle?.copyWith(
              labelIncrementMultiples: 1,
              marginAbove: 10,
              marginBelow: 10,
            ))
        .copyWith(datasetStyles: [
      DatasetStyle(color: Colors.black, fillOpacity: 0, lineSize: 2),
      DatasetStyle(color: Colors.red, fillOpacity: 0, lineSize: 2),
      DatasetStyle(color: Colors.orange.shade800, fillOpacity: 0, lineSize: 2)
    ]);

    return Column(children: [
      Padding(
          padding: EdgeInsets.only(top: 20),
          child: LineChart(
              // chart is styled
              //style: LineChartStyle.fromTheme(context),
              style: style,
              seriesHeight: 300,
              // chart has data
              data: _data))
    ]);
  }
} //_LineChartContentState

// METHOD FOR DATAPOINTS
Future<List<DataPoint>> _createDataPoints() async {
  //final listDataPoints = await getDataPoints();

  // dataPoints è una lista di DataPoint con due variabili di instance, x e y
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
      sp.getDouble("6")
    ];

    List<DataPoint> dataPoints = [
      DataPoint(x: 0, y: listDataPoints[0]!.toDouble()),
      DataPoint(x: 1, y: listDataPoints[1]!.toDouble()),
      DataPoint(x: 2, y: listDataPoints[2]!.toDouble()),
      DataPoint(x: 3, y: listDataPoints[3]!.toDouble()),
      DataPoint(x: 4, y: listDataPoints[4]!.toDouble()),
      DataPoint(x: 5, y: listDataPoints[5]!.toDouble()),
      DataPoint(x: 6, y: listDataPoints[6]!.toDouble())
    ];
    return dataPoints;
  } else {
    return dataPoints;
  }
} //_createDataPoints



//////////////////////////////////////////////////////
/// NOT USED ANYMORE 
/*
Future<List<double?>> getDataPoints() async {
  final sp = await SharedPreferences.getInstance();
  List<double?> listDataPoints = [
    sp.getDouble('0'),
    sp.getDouble("1"),
    sp.getDouble("2"),
    sp.getDouble("3"),
    sp.getDouble("4"),
    sp.getDouble("5"),
    sp.getDouble("6")
  ];

  return listDataPoints;
}
*/