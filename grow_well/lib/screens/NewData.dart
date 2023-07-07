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

//// for refresh and fetching data
import 'dart:convert';
import 'dart:io';

import 'package:grow_well/models/RestingHR.dart';
import 'package:grow_well/utils/impact.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:intl/intl.dart'; // for current date
////

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

//Class that manages the state of NewDataPage
class _NewDataPageState extends State<NewDataPage> {
  //Form globalkey: this is required to validate the form fields.
  final formKey = GlobalKey<FormState>();

  //Variables that maintain the current form fields values in memory.
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _hearthRateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  double _ReferenceValueHFA = 1;
  double _ReferenceValueWFH = 1;

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
            /*
            FormNumberTile(
              labelText: 'Hearth Rate (bpm)',
              controller: _hearthRateController,
              icon: Icons.monitor_heart,
            ),
            */
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

  //HFA indicator
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

    // Trova l'indice di riga corrispondente a ActualMonths
    for (int i = 0; i < HFAtable.length; i++) {
      List<double> rowHFA = HFAtable[i];
      if (rowHFA.contains(ActualMonths)) {
        rowIndexHFA = i;
        break;
      }
    }
    // Se l'indice di riga è stato trovato, cerca l'indice di colonna in base al genere
    if (rowIndexHFA != -1) {
      //List rowHFA = HFAtable[rowIndexHFA];
      if (gender == 'Male') {
        columnIndexHFA = 1; // Indice di colonna per il genere maschile
      } else if (gender == 'Female') {
        columnIndexHFA = 2; // Indice di colonna per il genere femminile
      } else {
        columnIndexHFA = -1;
        print('No selected gender');
      }
    }
    double ReferenceValueHFA = HFAtable[rowIndexHFA][columnIndexHFA];
    setState(() {
      _ReferenceValueHFA = ReferenceValueHFA;
    });
    sp.setDouble('referencevalueHFA', ReferenceValueHFA);
    return (ReferenceValueHFA);
  }

  //WFH indicator
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
      } else {
        columnIndexWFH = -1;
        print('No selected gender');
      }
    }
    double ReferenceValueWFH = WFHtable[rowIndexWFH][columnIndexWFH];
    setState(() {
      _ReferenceValueWFH = ReferenceValueWFH;
    });
    sp.setDouble('referencevalueWFH', ReferenceValueWFH);
    return (ReferenceValueWFH);
  }

  // Utility method that validate the form and, if it is valid, save the new data.
  Future<void> _validateAndSave(BuildContext context) async {
    final result = await _requestData();
    double resultHR = 0;

    if (result != null) {
      print("Request successful!");
      resultHR = result[result.length - 1].value;
      //print("Value requested: $resultHR");
    } else {
      print("Request failed.");
    }
    ;

    if (formKey.currentState!.validate()) {
      String heightText = _heightController
          .text; // Salva il valore di _heightController.text in una variabile temporanea

      // Calcola il valore di riferimento per l'indicatore WFH utilizzando _WFHReferenceValue
      double referenceValueWFH = await _WFHReferenceValue(heightText);

      // Se l'originale Data passato a NewDataPage era nullo, allora aggiungi una nuova Data...
      if (widget.data == null) {
        Data newData = Data(
          null,
          double.parse(_heightController.text),
          double.parse(_weightController.text),
          //double.parse(_hearthRateController.text),
          resultHR,
          _selectedDate,
          _ReferenceValueHFA,
          referenceValueWFH, // Utilizza il valore di riferimento WFH calcolato
        );
        await Provider.of<DatabaseRepository>(context, listen: false)
            .insertData(newData);
      } // if
      // ...altrimenti, modificalo.
      else {
        Data updatedData = Data(
          widget.data!.id,
          double.parse(_heightController.text),
          double.parse(_weightController.text),
          //double.parse(_hearthRateController.text),
          resultHR,
          _selectedDate,
          _ReferenceValueHFA,
          referenceValueWFH, // Utilizza il valore di riferimento WFH calcolato
        );
        await Provider.of<DatabaseRepository>(context, listen: false)
            .updateData(updatedData);
      } // else
      final sp = await SharedPreferences.getInstance();
      sp.setDouble('actualHeight', double.parse(_heightController.text));
      sp.setDouble('actualWeight', double.parse(_weightController.text));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } // if
  } // _validateAndSave

  //Utility method that deletes a data entry.
  void _deleteAndPop(BuildContext context) async {
    await Provider.of<DatabaseRepository>(context, listen: false)
        .removeData(widget.data!);
    Navigator.pop(context);
  } //_deleteAndPop

  /////////////////////////////////////
  /// IMPACT
  Future<List<RestingHR>?> _requestData() async {
    //Initialize the result
    List<RestingHR>? result; // lista di elementi di type RestingHR

    //Get the stored access token (Note that this code does not work if the tokens are null)
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    //If access token is expired, refresh it
    if (JwtDecoder.isExpired(access!)) {
      await _refreshTokens(); // ritorna status code
      access = sp.getString('access');
    } //if

    //Create the (representative) request
    /*
    final end_date =
        '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
    final start_date =
        '${_selectedDate.subtract(Duration(days: 7)).year}-${_selectedDate.subtract(Duration(days: 7)).month.toString().padLeft(2, '0')}-${_selectedDate.subtract(Duration(days: 7)).day.toString().padLeft(2, '0')}';
    */

    DateTime now = _selectedDate;
    //DateTime yesterday = now.subtract(Duration(days: 1));
    DateTime sevendaysago = now.subtract(Duration(days: 7));
    final start_date = DateFormat('yyyy-MM-dd').format(sevendaysago).toString();
    final end_date = DateFormat('yyyy-MM-dd').format(now).toString();

    final url = Impact.baseUrl +
        Impact.restingHREndpoint +
        Impact.patientUsername +
        '/daterange/start_date/$start_date/end_date/$end_date/';

    // autorizzazione nei request headers
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);

    //if OK parse the response, otherwise return null
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      //print("decoded response stampa: ");
      //print(decodedResponse);
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
      ///////
      print(
          "decodedResponse['data'].length è il numero di giorni per cui ho il dato: ${decodedResponse['data'].length}");
      print("${decodedResponse['data']}"); // entrambi i giorni
      print("${decodedResponse['data'][0]}"); //1° giorno
      // ogni giorno è una Map type
      print("${decodedResponse['data'][0]['date']}"); // data del 1° giorno
      print("${decodedResponse['data'][0]['data']}"); // valori del 1° giorno
      // ogni data è una Map type a sua volta
      print("${decodedResponse['data'][0]['data']['value']}");
      // ho fatto l'accesso al valore della key "value"

      // controllo la type delle varie variabili
      print("Type of date: ${decodedResponse['data'][0]['date'].runtimeType}");
      print(
          "Type of time: ${decodedResponse['data'][0]['data']['time'].runtimeType}");
      print(
          "Type of value: ${decodedResponse['data'][0]['data']['value'].runtimeType}");
      print(
          "Type of error: ${decodedResponse['data'][0]['data']['error'].runtimeType}");
*/

      result = [];
      for (var i = 0; i < decodedResponse['data'].length; i++) {
        // aggiunge un elemento di classe RestingHR alla volta alla lista
        // invocando il named constructor
        //result.add(RestingHR.fromJson(decodedResponse['data']['date'],decodedResponse['data']['data'][i]));

        result.add(RestingHR.fromJson(decodedResponse['data'][i]['date'],
            decodedResponse['data'][i]['data']));

        /*
        print("Stampo oggetto json numero $i");
        print(RestingHR.fromJson(decodedResponse['data'][i]['date'],
            decodedResponse['data'][i]['data'])); */

        // invoca il named method " Steps.fromJson" della classe
      } //for

      print(result);
      // [RestingHR(time: 2023-05-04 00:00:00.000, value: 52.93),
      // RestingHR(time: 2023-05-05 00:00:00.000, value: 52.85)]
      //print("Risultato 0 --> ${result[0].value}");

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
    } //if
    else {
      result = null;
    } //else

    //Return the result
    return result;
  } //_requestData

  //This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
  Future<int> _refreshTokens() async {
    //Create the request
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');
    final body = {'refresh': refresh};

    //Get the respone
    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    //If 200 set the tokens
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      sp.setString('access', decodedResponse['access']);
      sp.setString('refresh', decodedResponse['refresh']);
    } //if

    //Return just the status code
    return response.statusCode;
  } //_refreshTokens
  ////////////////////////////////////
} //NewDataPage
