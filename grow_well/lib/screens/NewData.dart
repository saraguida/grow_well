import 'package:flutter/material.dart';
import 'package:grow_well/database/entities/data.dart';
import 'package:grow_well/repositories/databaseRepository.dart';
import 'package:grow_well/widgets/formTiles.dart';
import 'package:grow_well/widgets/formSeparator.dart';
import 'package:grow_well/utils/formats.dart';
import 'package:provider/provider.dart';
import 'package:grow_well/models/tables.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';



class NewDataPage extends StatefulWidget {

  final Data? data;
  final List<List<double>> HFAtable;
  final List<List<double>> WFHtable;

  //NewDataPage constructors
  NewDataPage({Key? key, required this.data, required this.HFAtable,required this.WFHtable}) : super(key: key);

  NewDataPage.fromHomePage():
  data=null,
  HFAtable=[],
  WFHtable=[];

  static const routeDisplayName = 'New Data page';

  @override
  State<NewDataPage> createState() => _NewDataPageState();
}

//Class that manages the state of NewDataPage
class _NewDataPageState extends State<NewDataPage> {

  //Form globalkey: this is required to validate the form fields.
  final formKey = GlobalKey<FormState>();

  //Variables that maintain the current form fields values in memory.
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _hearthRateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  double _ReferenceValueHFA=1;
  double _ReferenceValueWFH=1;
  
  @override
  void initState() {
    
    _heightController.text =
        widget.data == null ? '' : widget.data!.height.toString();
    _weightController.text =
        widget.data == null ? '' : widget.data!.weight.toString();
    _hearthRateController.text =
        widget.data == null ? '' : widget.data!.hearthRate.toString();
    _selectedDate =
        widget.data == null ? DateTime.now() : widget.data!.dateTime;
    _HFAReferenceValue();
    _WFHReferenceValue(_heightController.text);
    super.initState();
  } // initState

  //Form controllers need to be manually disposed. So, here we need also to override the dispose() method.
  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _hearthRateController.dispose();
    super.dispose();
  } // dispose

  @override
  Widget build(BuildContext context) {    

    print('${NewDataPage.routeDisplayName} built');

    return Scaffold(
      appBar: AppBar(
        title: Text(NewDataPage.routeDisplayName),
        actions: [
          IconButton(onPressed: () => [_validateAndSave(context)], icon: Icon(Icons.done))
        ],
      ),
      body: Center(
        child: _buildForm(context),
      ),
      floatingActionButton: widget.data == null ? null : FloatingActionButton(onPressed: () => _deleteAndPop(context), child: Icon(Icons.delete),),
    );
  }//build

  Widget _buildForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 8, left: 20, right: 20),
        child: ListView(
          children: <Widget>[
            FormSeparator(label: 'Data content'),
            FormNumberTile(
              labelText: 'Height (cm)',
              controller: _heightController,
              icon: Icons.straighten,
            ),
            FormNumberTile(
              labelText: 'Weight (kg)',
              controller: _weightController,
              icon: Icons.scale,
            ),
            FormNumberTile(
              labelText: 'Hearth Rate (bpm)',
              controller: _hearthRateController,
              icon: Icons.monitor_heart,
            ),
            FormSeparator(label: 'Acquisition time'),
            FormDateTile(
              labelText: 'Data Time',
              date: _selectedDate,
              icon: Icons.calendar_today,
              onPressed: () {
                _selectDate(context);
              },
              dateFormat: Formats.fullDateFormatNoSeconds,
            ),
          ],
        ),
      ),
    );
  } // _buildForm

  //Utility method that implements a Date+Time picker. 
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(2010),
            lastDate: DateTime(2101))
        .then((value) async {
      if (value != null) {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
              hour: _selectedDate.hour, minute: _selectedDate.minute),
        );
        return pickedTime != null ? value.add(
              Duration(hours: pickedTime.hour, minutes: pickedTime.minute)) : null;
      }
      return null;
    });
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }//_selectDate

  //HFA indicator
  Future <double> _HFAReferenceValue() async{
    final sp = await SharedPreferences.getInstance();
    String? gender=sp.getString('gender');
    String? date = sp.getString('date')!;
    DateTime dateOfBirth = DateTime.parse(date);
    DateTime currentDate=DateTime.now();
    final int ActualMonths=(currentDate.year-dateOfBirth.year)*12+(currentDate.month-dateOfBirth.month);
    List<List<double>> HFAtable = await readExcelFileHFA();

    int rowIndexHFA = 0;
    int columnIndexHFA = 0;

    // Trova l'indice di riga corrispondente a ActualMonths
    for (int i = 0; i < HFAtable.length; i++) {
      List<double> rowHFA = HFAtable[i];
    if (rowHFA.contains(ActualMonths)) {
    rowIndexHFA = i;
    break;
    }
    }
    // Se l'indice di riga è stato trovato, cerca l'indice di colonna in base al genere
    if (rowIndexHFA !=-1) {
      //List rowHFA = HFAtable[rowIndexHFA];
      if (gender == 'Male') {
        columnIndexHFA = 1; // Indice di colonna per il genere maschile
      } else if (gender == 'Female') {
        columnIndexHFA = 2; // Indice di colonna per il genere femminile
      } else{
        columnIndexHFA=-1;
        print('No selected gender');
      }
    }
    double ReferenceValueHFA = HFAtable[rowIndexHFA][columnIndexHFA];
    setState(() {
        _ReferenceValueHFA = ReferenceValueHFA;
      });
    sp.setDouble('referencevalueHFA', ReferenceValueHFA);
    return(ReferenceValueHFA);
  }

  //WFH indicator
  Future <double> _WFHReferenceValue(String heightText) async{
    final sp = await SharedPreferences.getInstance();
    String? gender=sp.getString('gender');
    double ActualHeight = 0.0;
    if (heightText.isNotEmpty) {
      try {
        ActualHeight = double.parse(heightText);
      } catch (e) {
        print('Invalid height value: $heightText');
      }
    } else {
      print('Height value is empty');
    }
    List<List<double>> WFHtable = await readExcelFileWFH();

    int rowIndexWFH = 0 ;
    int columnIndexWFH = 0;

    // Trova l'indice di riga corrispondente all'altezza inserita
    for (int i = 0; i < WFHtable.length; i++) {
      List<double> rowWFH = WFHtable[i];
    if (rowWFH.contains(ActualHeight)) {
    rowIndexWFH = i;
    break;
    }
    }
    // Se l'indice di riga è stato trovato, cerca l'indice di colonna in base al genere
    if (rowIndexWFH != -1) {
      //List rowWFH = WFHtable[rowIndexWFH];
      if (gender == 'Male') {
        columnIndexWFH = 1; // Indice di colonna per il genere maschile
      } else if (gender == 'Female') {
        columnIndexWFH = 2; // Indice di colonna per il genere femminile
      } else{
        columnIndexWFH=-1;
        print('No selected gender');
      }
    }
    double ReferenceValueWFH = WFHtable[rowIndexWFH][columnIndexWFH];
    setState(() {
        _ReferenceValueWFH = ReferenceValueWFH;
      });
    sp.setDouble('referencevalueWFH', ReferenceValueWFH);
    return(ReferenceValueWFH);
  }

  // Utility method that validate the form and, if it is valid, save the new data.
void _validateAndSave(BuildContext context) async {
  if (formKey.currentState!.validate()) {
    String heightText = _heightController.text; // Salva il valore di _heightController.text in una variabile temporanea

    // Calcola il valore di riferimento per l'indicatore WFH utilizzando _WFHReferenceValue
    double referenceValueWFH = await _WFHReferenceValue(heightText);

    // Se l'originale Data passato a NewDataPage era nullo, allora aggiungi una nuova Data...
    if (widget.data == null) {
      Data newData = Data(
        null,
        double.parse(_heightController.text),
        double.parse(_weightController.text),
        double.parse(_hearthRateController.text),
        _selectedDate,
        _ReferenceValueHFA,
        referenceValueWFH, // Utilizza il valore di riferimento WFH calcolato
      );
      await Provider.of<DatabaseRepository>(context, listen: false).insertData(newData);
      
    } // if
    // ...altrimenti, modificalo.
    else {
      Data updatedData = Data(
        widget.data!.id,
        double.parse(_heightController.text),
        double.parse(_weightController.text),
        double.parse(_hearthRateController.text),
        _selectedDate,
        _ReferenceValueHFA,
        referenceValueWFH, // Utilizza il valore di riferimento WFH calcolato
      );
      await Provider.of<DatabaseRepository>(context, listen: false).updateData(updatedData);
    } // else
      final sp = await SharedPreferences.getInstance();
      sp.setDouble('actualHeight', double.parse(_heightController.text));
      sp.setDouble('actualWeight', double.parse(_weightController.text));
    Navigator.pushReplacement(context,
    MaterialPageRoute(builder: (context) => HomePage()),);
  } // if
} // _validateAndSave


  //Utility method that deletes a data entry.
  void _deleteAndPop(BuildContext context) async{
    await Provider.of<DatabaseRepository>(context, listen: false)
              .removeData(widget.data!);
    Navigator.pop(context);
  } //_deleteAndPop

} //NewDataPage