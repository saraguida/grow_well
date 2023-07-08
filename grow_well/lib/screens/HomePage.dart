import 'package:flutter/material.dart';
import 'package:grow_well/database/entities/data.dart';
import 'package:grow_well/screens/AboutPage.dart';
import 'package:grow_well/screens/InfoPage.dart';
import 'package:grow_well/screens/NewData.dart';
import 'package:grow_well/screens/ProfilePage.dart';
import 'package:grow_well/screens/RecapPage.dart';
import 'package:intl/intl.dart';
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
    body: Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child:Container(
            child:Align(
            alignment: Alignment.center,
            child: FutureBuilder<String>(
              future: getLastDates(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return Text(
                    '${snapshot.data}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  );
                } else {
                  return Text(
                    'Errore durante il recupero del valore',
                    style: TextStyle(fontSize: 24),
                  );
                }
              },
            ),
          ),
          )
          ),
          Expanded(
            flex: 5,
            child: LineChartContent(),
          ),
          Expanded(
            child: Container(
            child:
            Text('Your resting HR should be between 101.03 and 108.28 bpm.\n',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16,
            color: Colors.black,),
            textAlign: TextAlign.justify,)  
            )),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "HEIGHT FOR AGE AND\nWEIGHT FOR HEIGHT",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 35),
            child:Align(
            alignment: Alignment.topCenter,
            child: FutureBuilder<String>(
              future: getValuesComparison(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return Text(
                    '${snapshot.data}',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.justify,
                  );
                } else {
                  return Text(
                    'Errore durante il recupero del valore',
                    style: TextStyle(fontSize: 24),
                  );
                }
              },
            ),
          ),
          )
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add_outlined,
          color: Color.fromARGB(255, 59, 81, 33)),
      backgroundColor: Color.fromARGB(255, 225, 250, 196),
      onPressed: () => _toNewDataPage(context, null),
    ),
  );
}



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
          'Based on your age, your height should be greater than $referencevalueHFA cm. '
          'Your current height is $actualHeight cm so you are ${stuntingString}  of stunting.\n\n'
          'Based on your height, your weight should be greater than $referencevalueWFH kg. '
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
Future<String> getLastDates() async {
    final sp = await SharedPreferences.getInstance();
    List <String>? dates =sp.getStringList('dates');
    String value = '';
  if (dates != null) {
     String first_date=dates[0].substring(0,10);
     String last_date=dates[6].substring(0,10);
      value ='RESTING HEART RATE [bpm]\nfrom $first_date to $last_date';
    } else {
      value =
          'RESTING HEART RATE [bpm]';
    }
    return value;
  }
}//HomePageWidget
