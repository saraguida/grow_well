import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:grow_well/database/entities/data.dart';
import 'package:grow_well/repositories/databaseRepository.dart';
import 'package:grow_well/widgets/formTiles.dart';
import 'package:grow_well/widgets/formSeparator.dart';
import 'package:grow_well/utils/formats.dart';
import 'package:provider/provider.dart';



class NewDataPage extends StatefulWidget {

  final Data? data;

  //NewDataPage constructor
  NewDataPage({Key? key, required this.data}) : super(key: key);

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
    _heightController.text =
        widget.data == null ? '' : widget.data!.height.toString();
    _weightController.text =
        widget.data == null ? '' : widget.data!.weight.toString();
    _hearthRateController.text =
        widget.data == null ? '' : widget.data!.hearthRate.toString();
    _selectedDate =
        widget.data == null ? DateTime.now() : widget.data!.dateTime;
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
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }//_selectDate

  //Utility method that validate the form and, if it is valid, save the new data.
  void _validateAndSave(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      //If the original Data passed to the NewDataPage was null, then add a new Data...
      if(widget.data == null){
        Data newData =
          Data(null, double.parse(_heightController.text), double.parse(_weightController.text), double.parse(_hearthRateController.text), _selectedDate);
          await Provider.of<DatabaseRepository>(context, listen: false)
              .insertData(newData);
      }//if
      //...otherwise, edit it.
      else{
        Data updatedData =
          Data(widget.data!.id, double.parse(_heightController.text), double.parse(_weightController.text), double.parse(_hearthRateController.text), _selectedDate);
          await Provider.of<DatabaseRepository>(context, listen: false)
              .updateData(updatedData);
      }//else
      Navigator.pop(context);
    }//if
  } // _validateAndSave

  //Utility method that deletes a data entry.
  void _deleteAndPop(BuildContext context) async{
    await Provider.of<DatabaseRepository>(context, listen: false)
              .removeData(widget.data!);
    Navigator.pop(context);
  } //_deleteAndPop

} //NewDataPage