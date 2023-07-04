import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:excel/excel.dart';

Future<List<List<double>>> readExcelFileHFA() async {
  // Costruisci il percorso completo per i file Excel
  String filePathHFA = 'tables/HFAtable.xlsx';

  ByteData dataHFA = await rootBundle.load(filePathHFA);
  var bytesHFA = dataHFA.buffer.asUint8List();
  var excelHFA = Excel.decodeBytes(bytesHFA);

  // Prendi il primo foglio di lavoro
  var sheetHFA = excelHFA.tables[excelHFA.tables.keys.first];

  // Crea la matrice dai dati del foglio di lavoro
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
  // Costruisci il percorso completo per i file Excel
  String filePathWFH = 'tables/WFHtable.xlsx';

  ByteData dataWFH = await rootBundle.load(filePathWFH);
  var bytesWFH = dataWFH.buffer.asUint8List();
  var excelWFH = Excel.decodeBytes(bytesWFH);

  // Prendi il primo foglio di lavoro
  var sheetWFH = excelWFH.tables[excelWFH.tables.keys.first];

  // Crea la matrice dai dati del foglio di lavoro
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
