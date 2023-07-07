import 'package:flutter/material.dart';
import 'package:grow_well/database/entities/data.dart';
import 'package:grow_well/screens/AboutPage.dart';
import 'package:grow_well/screens/InfoPage.dart';
import 'package:grow_well/screens/NewData.dart';
import 'package:grow_well/screens/ProfilePage.dart';
import 'package:grow_well/screens/RecapPage.dart';
//import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Per grafico
import 'package:grow_well/models/LineChartContent.dart';
//

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePageWidget(),
    ProfilePage(),
    RecapPage(),
    InfoPageWidget(),
  ];

  final List<String> _titles = [
    'Welcome to GrowWell!',
    'Your profile',
    'Recap of your data',
    'Information',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex],
            style: TextStyle(
                color: Color.fromARGB(255, 59, 81, 33),
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline,
                color: Color.fromARGB(255, 59, 81, 33)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        showUnselectedLabels: true,
        selectedItemColor: Color.fromARGB(255, 59, 81, 33),
        unselectedItemColor: Color.fromARGB(255, 59, 81, 33),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.lightGreen,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.lightGreen,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Recap',
            backgroundColor: Colors.lightGreen,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
            backgroundColor: Colors.lightGreen,
          ),
        ],
      ),
    );
  }
}

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({super.key});

  //////// GRAFICO formattato dal pacchetto
/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: LayoutBuilder(builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                    child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: LineChartContent(),
                ));
              }))),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_outlined,
            color: Color.fromARGB(255, 59, 81, 33)),
        backgroundColor: Color.fromARGB(255, 225, 250, 196),
        onPressed: () => _toNewDataPage(context, null),
      ),
    );
  } //build
*/
//////////////

  ////// BUILD ORIGINALE
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
                child: Text("RESTING HEART RATE\n(the last 7 days)",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                    textAlign: TextAlign.center)),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
                child: LineChartContent()),
            //LineChartContent(),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
              child: FutureBuilder<String>(
                future: getValuesComparison(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Se il valore è ancora in attesa, mostra un indicatore di caricamento
                    return CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    // Se il valore è stato ottenuto con successo, mostralo nel testo
                    return Text('${snapshot.data}',
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.black),
                        textAlign: TextAlign.justify);
                  } else {
                    // Se si verifica un errore durante l'ottenimento del valore, mostra un messaggio di errore
                    return Text(
                      'Errore durante il recupero del valore',
                      style: TextStyle(fontSize: 24),
                    );
                  }
                  ;
                },
              ),
            ),
          ], // children
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_outlined,
            color: Color.fromARGB(255, 59, 81, 33)),
        backgroundColor: Color.fromARGB(255, 225, 250, 196),
        onPressed: () => _toNewDataPage(context, null),
      ),
    );
  } //build
  ///////////////////////////////////////

  void _toNewDataPage(BuildContext context, Data? data) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => NewDataPage.fromHomePage()));
  } //_toNewDataPage

  Future<String> getValuesComparison() async {
    final sp = await SharedPreferences.getInstance();
    String value = '';
    double? actualHeight = sp.getDouble('actualHeight');
    double? actualWeight = sp.getDouble('actualWeight');
    double? referencevalueHFA = sp.getDouble('referencevalueHFA');
    double? referencevalueWFH = sp.getDouble('referencevalueWFH');

    if (sp.getDouble('actualHeight') != null) {
      String stuntingString = 'NOT AT RISK';
      if (actualHeight! < referencevalueHFA!) {
        stuntingString = 'AT RISK';
      }
      String wastingString = 'NOT AT RISK';
      if (actualWeight! < referencevalueWFH!) {
        wastingString = 'AT RISK';
      }
      value =
          'Based on your age, your height should be greater than $referencevalueHFA cm.\n'
          'Your current height is $actualHeight cm so you are ${stuntingString}  of stunting.\n\n'
          'Based on your height, your weight should be greater than $referencevalueWFH kg.\n'
          'Your current weight is $actualWeight kg so you are ${wastingString} of wasting.\n';
    } else {
      value =
          'Enter your personal data in the Profile and add your current anthropometric data.';
    }
    return value;
  } //getValuesComparison

  Future<List<double?>> get() async {
    final sp = await SharedPreferences.getInstance();

    List<double?> listDataPoints = [
      sp.getDouble('0'),
      sp.getDouble("1"),
      sp.getDouble("2"),
      sp.getDouble("3"),
      sp.getDouble("4"),
      sp.getDouble("5"),
      sp.getDouble("6")
    ];

    return listDataPoints;
  } //getGraph
}//HomePageWidget
