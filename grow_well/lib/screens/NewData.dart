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
import 'dart:convert';
import 'dart:io';
import 'package:grow_well/models/RestingHR.dart';
import 'package:grow_well/utils/impact.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:intl/intl.dart';

class NewDataPage extends StatefulWidget {
  final Data? data;
  final List<List<double>> HFAtable;
  final List<List<double>> WFHtable;

  //NewDataPage constructors
  NewDataPage(
      {Key? key,
      required this.data,
      required this.HFAtable,
      required this.WFHtable})
      : super(key: key);

  NewDataPage.fromHomePage()
      : data = null,
        HFAtable = [],
        WFHtable = [];

  static const routeDisplayName = 'New Data page';

  @override
  State<NewDataPage> createState() => _NewDataPageState();
}

class _NewDataPageState extends State<NewDataPage> {
  final formKey = GlobalKey<FormState>();

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

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _hearthRateController.dispose();
    super.dispose();
  } // dispose

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(NewDataPage.routeDisplayName),
        actions: [
          IconButton(
              onPressed: () => [_validateAndSave(context)],
              icon: Icon(Icons.done))
        ],
      ),
      body: Center(
        child: _buildForm(context),
      ),
      floatingActionButton: widget.data == null
          ? null
          : FloatingActionButton(
              onPressed: () => _deleteAndPop(context),
              child: Icon(Icons.delete),
            ),
    );
  } //build

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
          initialTime:
              TimeOfDay(hour: _selectedDate.hour, minute: _selectedDate.minute),
        );
        return pickedTime != null
            ? value.add(
                Duration(hours: pickedTime.hour, minutes: pickedTime.minute))
            : null;
      }
      return null;
    });
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  } //_selectDate

  Future<double> _HFAReferenceValue() async {
    final sp = await SharedPreferences.getInstance();
    String? gender = sp.getString('gender');
    String? date = sp.getString('date')!;
    DateTime dateOfBirth = DateTime.parse(date);
    DateTime currentDate = DateTime.now();
    final int ActualMonths = (currentDate.year - dateOfBirth.year) * 12 +
        (currentDate.month - dateOfBirth.month);
    List<List<double>> HFAtable = await readExcelFileHFA();

    int rowIndexHFA = 0;
    int columnIndexHFA = 0;

    for (int i = 0; i < HFAtable.length; i++) {
      List<double> rowHFA = HFAtable[i];
      if (rowHFA.contains(ActualMonths)) {
        rowIndexHFA = i;
        break;
      }
    }
    if (rowIndexHFA != -1) {
      if (gender == 'Male') {
        columnIndexHFA = 1;
      } else if (gender == 'Female') {
        columnIndexHFA = 2;
      }
    }
    double ReferenceValueHFA = HFAtable[rowIndexHFA][columnIndexHFA];
    sp.setDouble('referencevalueHFA', ReferenceValueHFA);
    return (ReferenceValueHFA);
  }

  Future<double> _WFHReferenceValue(String heightText) async {
    final sp = await SharedPreferences.getInstance();
    String? gender = sp.getString('gender');
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

    int rowIndexWFH = 0;
    int columnIndexWFH = 0;

    for (int i = 0; i < WFHtable.length; i++) {
      List<double> rowWFH = WFHtable[i];
      if (rowWFH.contains(ActualHeight)) {
        rowIndexWFH = i;
        break;
      }
    }
    if (rowIndexWFH != -1) {
      if (gender == 'Male') {
        columnIndexWFH = 1;
      } else if (gender == 'Female') {
        columnIndexWFH = 2;
      }
    }
    double ReferenceValueWFH = WFHtable[rowIndexWFH][columnIndexWFH];
    sp.setDouble('referencevalueWFH', ReferenceValueWFH);
    return (ReferenceValueWFH);
  }

  Future<void> _validateAndSave(BuildContext context) async {
    final result = await _requestData();
    double resultHR = 0;

    if (result != null) {
      print("Request successful!");
      resultHR = result[result.length - 1].value;
    } else {
      print("Request failed.");
    }
    ;

    if (formKey.currentState!.validate()) {
      String heightText = _heightController.text;

      double referenceValueWFH = await _WFHReferenceValue(heightText);
      double referenceValueHFA = await _HFAReferenceValue();

      if (widget.data == null) {
        Data newData = Data(
          null,
          double.parse(_heightController.text),
          double.parse(_weightController.text),
          resultHR,
          _selectedDate,
          referenceValueHFA,
          referenceValueWFH,
        );
        await Provider.of<DatabaseRepository>(context, listen: false)
            .insertData(newData);
      } else {
        Data updatedData = Data(
          widget.data!.id,
          double.parse(_heightController.text),
          double.parse(_weightController.text),
          resultHR,
          _selectedDate,
          referenceValueHFA,
          referenceValueWFH,
        );
        await Provider.of<DatabaseRepository>(context, listen: false)
            .updateData(updatedData);
      }
      final sp = await SharedPreferences.getInstance();
      sp.setDouble('actualHeight', double.parse(_heightController.text));
      sp.setDouble('actualWeight', double.parse(_weightController.text));
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } // if
  } // _validateAndSave

  void _deleteAndPop(BuildContext context) async {
    await Provider.of<DatabaseRepository>(context, listen: false)
        .removeData(widget.data!);
    Navigator.pop(context);
  } //_deleteAndPop

  /// IMPACT
  Future<List<RestingHR>?> _requestData() async {
    List<RestingHR>? result;

    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    if (JwtDecoder.isExpired(access!)) {
      await _refreshTokens();
      access = sp.getString('access');
    } //if

    DateTime now = _selectedDate;
    DateTime yesterday = now.subtract(Duration(days: 1));
    DateTime sevendaysago = yesterday.subtract(Duration(days: 6));
    final start_date = DateFormat('yyyy-MM-dd').format(sevendaysago).toString();
    final end_date = DateFormat('yyyy-MM-dd').format(yesterday).toString();

    final url = Impact.baseUrl +
        Impact.restingHREndpoint +
        Impact.patientUsername +
        '/daterange/start_date/$start_date/end_date/$end_date/';

    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      /*
      {
        status: success, 
        code: 200, 
        message: Request successful., 
        data: [
          {date: 2023-05-04, data: {time: 00:00:00, value: 52.93, error: 6.83}}, 
          {date: 2023-05-05, data: {time: 00:00:00, value: 52.85, error: 6.8}}
        ]
      }
      */

      result = [];
      for (var i = 0; i < decodedResponse['data'].length; i++) {
        if (decodedResponse['data'][i]['data']['value'] != null) {
          result.add(RestingHR.fromJson(decodedResponse['data'][i]['date'],
              decodedResponse['data'][i]['data']));
        } else {
          var decodedResponse2 = decodedResponse;
          decodedResponse2['data'][i]['data']['value'] = 0;
          result.add(RestingHR.fromJson(decodedResponse2['data'][i]['date'],
              decodedResponse2['data'][i]['data']));
        }

        /*
        result.add(RestingHR.fromJson(decodedResponse['data'][i]['date'],
            decodedResponse['data'][i]['data'])); */
      } //for

      print(result);

      // Save all the 7 values in sp
      sp.setDouble("0", result[0].value);
      sp.setDouble("1", result[1].value);
      sp.setDouble("2", result[2].value);
      sp.setDouble("3", result[3].value);
      sp.setDouble("4", result[4].value);
      sp.setDouble("5", result[5].value);
      sp.setDouble("6", result[6].value);
      sp.setStringList("dates", [
        result[0].time.toString(),
        result[1].time.toString(),
        result[2].time.toString(),
        result[3].time.toString(),
        result[4].time.toString(),
        result[5].time.toString(),
        result[6].time.toString()
      ]);
    } else {
      result = null;
    } //else

    return result;
  } //_requestData

  Future<int> _refreshTokens() async {
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');
    final body = {'refresh': refresh};

    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      sp.setString('access', decodedResponse['access']);
      sp.setString('refresh', decodedResponse['refresh']);
    } //if

    return response.statusCode;
  } //_refreshTokens
} //NewDataPage
