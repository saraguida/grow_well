import 'package:grow_well/database/database.dart';
import 'package:grow_well/database/entities/data.dart';
import 'package:flutter/material.dart';

class DatabaseRepository extends ChangeNotifier{

  //The state of the database is just the AppDatabase
  final AppDatabase database;

  //Default constructor
  DatabaseRepository({required this.database});

  //This method wraps the findAllData() method of the DAO
  Future<List<Data>> findAllData() async{
    final results = await database.dataDao.findAllData();
    return results;
  }//findAllData

  //This method wraps the insertData() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> insertData(Data data)async {
    await database.dataDao.insertData(data);
    notifyListeners();
  }//insertData

  //This method wraps the deleteData() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> removeData(Data data) async{
    await database.dataDao.deleteData(data);
    notifyListeners();
  }//removeData
  
  //This method wraps the updateData() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> updateData(Data data) async{
    await database.dataDao.updateData(data);
    notifyListeners();
  }//updateData

}//DatabaseRepository