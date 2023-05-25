import 'package:flutter/material.dart';
import 'package:grow_well/models/dataDB.dart';
import 'package:grow_well/screens/NewData.dart';
import 'package:grow_well/utils/formats.dart';
import 'package:provider/provider.dart';

class RecapPage extends StatelessWidget {
  RecapPage({Key? key}) : super(key: key);

  static const routeDisplayName = 'Recap';

  @override
  Widget build(BuildContext context) {
    //Print the route display name for debugging
    print('${RecapPage.routeDisplayName} built');
    
    return Scaffold(
      body: Center(
        child: Consumer<DataDB>(
          builder: (context, dataDB, child) {
            return dataDB.dataList.isEmpty
                ? Text('The summary list is currently empty')
                : ListView.builder(
                    itemCount: dataDB.dataList.length,
                    itemBuilder: (context, dataIndex) {
                      return Card(
                        elevation: 5,
                        child: ListTile(
                          leading: Icon(Icons.description, color:Color.fromARGB(255,59,81,33)),
                          trailing: Icon(Icons.edit_note, color:Color.fromARGB(255,59,81,33)),
                          title:
                              Text('Height : ${dataDB.dataList[dataIndex].height} cm\n'
                                   'Weight : ${dataDB.dataList[dataIndex].weight} kg\n'
                                   'Hearth rate : ${dataDB.dataList[dataIndex].hearthRate} bpm\n'
                                   'Height for age : formula\n'
                                   'Weight for height : formula\n',
                              ),
                          subtitle: Text('${Formats.fullDateFormatNoSeconds.format(dataDB.dataList[dataIndex].dateTime)}'),
                          onTap: () => _toNewDataPage(context, dataDB, dataIndex),
                        ),
                      );
                    });
                     },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_outlined,color: Color.fromARGB(255, 59, 81, 33)),
        backgroundColor: Color.fromARGB(255, 225, 250, 196),
        onPressed: () => _toNewDataPage(context, Provider.of<DataDB>(context, listen: false), -1),
      ),
    );
  } //build

  //Utility method to navigate to NewDataPage
  void _toNewDataPage(BuildContext context, DataDB dataDB, int dataIndex) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewDataPage(dataDB: dataDB, dataIndex: dataIndex,)));
  } //_toNewDataPage
} //RecapPage