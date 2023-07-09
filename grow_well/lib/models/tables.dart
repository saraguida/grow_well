import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:excel/excel.dart';

Future<List<List<double>>> readExcelFileHFA() async {
  String filePathHFA = 'tables/HFAtable.xlsx';

  ByteData dataHFA = await rootBundle.load(filePathHFA);
  var bytesHFA = dataHFA.buffer.asUint8List();
  var excelHFA = Excel.decodeBytes(bytesHFA);

  var sheetHFA = excelHFA.tables[excelHFA.tables.keys.first];

  List<List<double>> HFAtable = [];
  for (var row in sheetHFA!.rows) {
    List<double> rowData = [];
    for (var cell in row) {
      rowData.add(double.tryParse(cell!.value.toString()) ?? 0.0);
    }
    HFAtable.add(rowData);
  }
  return HFAtable;
}

Future<List<List<double>>> readExcelFileWFH() async {
  String filePathWFH = 'tables/WFHtable.xlsx';

  ByteData dataWFH = await rootBundle.load(filePathWFH);
  var bytesWFH = dataWFH.buffer.asUint8List();
  var excelWFH = Excel.decodeBytes(bytesWFH);

  var sheetWFH = excelWFH.tables[excelWFH.tables.keys.first];

  List<List<double>> WFHtable = [];
  for (var row in sheetWFH!.rows) {
    List<double> rowData = [];
    for (var cell in row) {
      rowData.add(double.tryParse(cell!.value.toString()) ?? 0.0);
    }
    WFHtable.add(rowData);
  }
  return WFHtable;
}
