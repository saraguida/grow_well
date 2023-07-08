import 'package:flutter/material.dart';
import 'package:grow_well/database/entities/data.dart';
import 'package:grow_well/repositories/databaseRepository.dart';
import 'package:grow_well/screens/NewData.dart';
import 'package:grow_well/utils/formats.dart';
import 'package:provider/provider.dart';

class RecapPage extends StatelessWidget {
  RecapPage({Key? key}) : super(key: key);

  static const route = '/';
  static const routeDisplayName = 'Recap';

  @override
  Widget build(BuildContext context) {
    //Print the route display name for debugging
    print('${RecapPage.routeDisplayName} built');
    
    return Scaffold(
      body: Center(
        child: Consumer<DatabaseRepository>(
          builder: (context, dbr, child) {
            return FutureBuilder(
              initialData: null,
              future: dbr.findAllData(),
              builder:(context, snapshot) {
                if(snapshot.hasData){
                  final dataList = snapshot.data as List<Data>;
                  //If the Data table is empty, show a simple Text, otherwise show the list of data using a ListView.
                  return dataList.length == 0 ? Text('The summary list is currently empty') : ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, dataIndex) {
                      return Card(
                        elevation: 5,
                        child: ListTile(
                          leading: Icon(Icons.description, color:Color.fromARGB(255,59,81,33)),
                          trailing: Icon(Icons.edit_note, color:Color.fromARGB(255,59,81,33)),
                          title:
                              Text('Height : ${dataList[dataIndex].height} cm\n'
                                   'Weight : ${dataList[dataIndex].weight} kg\n'
                                   'Hearth rate : ${dataList[dataIndex].hearthRate} bpm\n'
                                   'Height reference value :${dataList[dataIndex].ReferenceValueHFA} cm\n'
                                   'Weight reference value : ${dataList[dataIndex].ReferenceValueWFH} kg\n',
                              ),
                          subtitle: Text('${Formats.fullDateFormatNoSeconds.format(dataList[dataIndex].dateTime)}'),
                          onTap: () => _toNewDataPage(context, dataList[dataIndex]),
                        ), // ListTile
                      ); // Card
                    }); // ListView.builder
                } // if
                else{
                  return CircularProgressIndicator();
                }// else
              },// FutureBuilder builder 
            );
          }// Consumer-builder
        ), // Consumer
      ), // Center
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_outlined,color: Color.fromARGB(255, 59, 81, 33)),
        backgroundColor: Color.fromARGB(255, 225, 250, 196),
        onPressed: () => _toNewDataPage(context, null),
      ), // FloatingActionButton
    ); // Scaffold
  } //build

  //Utility method to navigate to NewDataPage
  void _toNewDataPage(BuildContext context, Data? data) {
    Navigator.push(context,MaterialPageRoute(builder: (context) => NewDataPage(data: data,HFAtable:[],WFHtable: [],)));
  } //_toNewDataPage
} //RecapPage