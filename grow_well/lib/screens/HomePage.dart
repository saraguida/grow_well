import 'package:flutter/material.dart';
import 'package:grow_well/database/entities/data.dart';
import 'package:grow_well/screens/AboutPage.dart';
import 'package:grow_well/screens/InfoPage.dart';
import 'package:grow_well/screens/NewData.dart';
import 'package:grow_well/screens/ProfilePage.dart';
import 'package:grow_well/screens/RecapPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Grafico del battito cardiaco',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            FutureBuilder<String>(
              future: getValuesComparison(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Se il valore è ancora in attesa, mostra un indicatore di caricamento
                  return CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  // Se il valore è stato ottenuto con successo, mostralo nel testo
                  return Text(
                    '${snapshot.data}',
                    //style: TextStyle(fontSize: 24),
                  );
                } else {
                  // Se si verifica un errore durante l'ottenimento del valore, mostra un messaggio di errore
                  return Text(
                    'Errore durante il recupero del valore',
                    style: TextStyle(fontSize: 24),
                  );
                };
              },
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
  }

  void _toNewDataPage(BuildContext context, Data? data) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewDataPage.fromHomePage()));
  } //_toNewDataPage

  Future<String> getValuesComparison() async {
    final sp = await SharedPreferences.getInstance();
    String value='';
    double? actualHeight = sp.getDouble('actualHeight');
    double? actualWeight = sp.getDouble('actualWeight');
    double? referencevalueHFA = sp.getDouble('referencevalueHFA');
    double? referencevalueWFH = sp.getDouble('referencevalueWFH');
    print(sp.getDouble('actualHeight'));
    if (sp.getDouble('actualHeight') != null){
      String stuntingString = 'NOT AT RISK';
      if (actualHeight!<referencevalueHFA!){
        stuntingString = 'AT RISK';
      }
      String wastingString = 'NOT AT RISK';
      if (actualWeight!<referencevalueWFH!){
        wastingString = 'AT RISK';
      }
      value ='Based on your age, your height should be greater than $referencevalueHFA cm.\n'
                    'Your current height is $actualHeight cm so you are ${stuntingString}  of stunting.\n\n'
                    'Based on your height, your weight should be greater than $referencevalueWFH kg.\n'
                    'Your current weight is $actualWeight kg so you are ${wastingString} of wasting.\n';
    }
    else{
      value = 'Enter your personal data in the Profile and add your current anthropometric data.';
    }
    return value;
  }

}
