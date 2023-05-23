import 'package:flutter/material.dart';
import 'package:grow_well/screens/AboutPage.dart';
import 'package:grow_well/screens/InfoPage.dart';
import 'package:grow_well/screens/NewData.dart';
import 'package:grow_well/screens/ProfilePage.dart';
import 'package:grow_well/screens/RecapPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePageWidget(),
    ProfilePageWidget(),
    RecapPageWidget(),
    InfoPageWidget(),
  ];

  final List<String> _titles = [
    'Welcome to GrowWell!',
    'YOUR PROFILE',
    'RECAP OF YOUR DATA',
    'INFORMATION',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex],style:  TextStyle(color: Color.fromARGB(255, 59, 81, 33), fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Color.fromARGB(255, 59, 81, 33)),
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
        selectedItemColor:Color.fromARGB(255, 59, 81, 33),
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
            backgroundColor:Colors.lightGreen,
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
          children: const [
            Text(
              'Grafico del battito cardiaco',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Tabella con i valori di PA e AE',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewDataPage()),
          );
        },
        child: const Icon(Icons.add_outlined,color: Color.fromARGB(255, 59, 81, 33)),
        backgroundColor: Color.fromARGB(255, 225, 250, 196),
        
      ),
    );
  }
}