import 'package:flutter/material.dart';
import 'package:grow_well/models/data.dart';
import 'package:grow_well/models/dataDB.dart';
import 'package:grow_well/widgets/formTiles.dart';
import 'package:grow_well/widgets/formSeparator.dart';
import 'package:grow_well/utils/formats.dart';


class NewDataPage extends StatefulWidget {

  final int dataIndex;
  final DataDB dataDB;

  //NewDataPage constructor
  NewDataPage({Key? key, required this.dataDB, required this.dataIndex}) : super(key: key);

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
  
  @override
  void initState() {
    _heightController.text = widget.dataIndex == -1 ? '' : widget.dataDB.dataList[widget.dataIndex].height.toString();
    _weightController.text = widget.dataIndex == -1 ? '' : widget.dataDB.dataList[widget.dataIndex].weight.toString();
    _hearthRateController.text = widget.dataIndex == -1 ? '' : widget.dataDB.dataList[widget.dataIndex].hearthRate.toString();
    _selectedDate = widget.dataIndex == -1 ? DateTime.now() : widget.dataDB.dataList[widget.dataIndex].dateTime;
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
          IconButton(onPressed: () => _validateAndSave(context), icon: Icon(Icons.done))
        ],
      ),
      body: Center(
        child: _buildForm(context),
      ),
      floatingActionButton: widget.dataIndex == -1 ? null : FloatingActionButton(onPressed: () => _deleteAndPop(context), child: Icon(Icons.delete),),
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
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }//_selectDate

  //Utility method that validate the form and, if it is valid, save the new data.
  void _validateAndSave(BuildContext context) {
    if(formKey.currentState!.validate()){
      Data newData = Data(height: double.parse(_heightController.text),weight: double.parse(_weightController.text),hearthRate: double.parse(_hearthRateController.text), dateTime: _selectedDate);
      widget.dataIndex == -1 ? widget.dataDB.addData(newData) : widget.dataDB.editData(widget.dataIndex, newData);
      Navigator.pop(context);
    }
  } // _validateAndSave

  //Utility method that deletes a meal entry.
  void _deleteAndPop(BuildContext context){
    widget.dataDB.deleteData(widget.dataIndex);
    Navigator.pop(context);
  }//_deleteAndPop

} //NewDataPage