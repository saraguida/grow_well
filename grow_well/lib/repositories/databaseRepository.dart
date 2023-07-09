import 'package:grow_well/database/database.dart';
import 'package:grow_well/database/entities/data.dart';
import 'package:flutter/material.dart';

class DatabaseRepository extends ChangeNotifier {
  final AppDatabase database;

  DatabaseRepository({required this.database});

  Future<List<Data>> findAllData() async {
    final results = await database.dataDao.findAllData();
    return results;
  } //findAllData

  Future<void> insertData(Data data) async {
    await database.dataDao.insertData(data);
    notifyListeners();
  } //insertData

  Future<void> removeData(Data data) async {
    await database.dataDao.deleteData(data);
    notifyListeners();
  } //removeData

  Future<void> updateData(Data data) async {
    await database.dataDao.updateData(data);
    notifyListeners();
  } //updateData
}//DatabaseRepository