import 'package:flutter/material.dart';
import 'package:grow_well/models/data.dart';

//This class extends ChangeNotifier. 
//It will act as data repository for the data and will be shared thorugh the application.
class DataDB extends ChangeNotifier{

  //The DataDB can be represented here as list of data.
  List<Data> dataList = [];

  //Method to use to add data.
  void addData(Data toAdd){
    dataList.add(toAdd);
    //Call the notifyListeners() method to alert that something happened.
    notifyListeners();
  }//addData

  //Method to use to edit data.
  void editData(int index, Data newData){
    dataList[index] = newData;
    //Call the notifyListeners() method to alert that something happened.
    notifyListeners();
  }//editData

  //Method to use to delete data.
  void deleteData(int index){
    dataList.removeAt(index);
    //Call the notifyListeners() method to alert that something happened.
    notifyListeners();
  }//deleteData
  
}//DataDB