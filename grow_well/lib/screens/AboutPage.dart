import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "About GrowWell",
            style: TextStyle(
                color: Color.fromARGB(255, 59, 81, 33),
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 1°
              Container(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
                child: const Text(
                    "GrowWell is a novel solution with one goal in mind: to help ending malnutrition by providing a simple and intuitive interface. You can easily track heart rate and keep an eye on two indicators for stunting and wasting. You'll receive a prompt warning when the values go out of range and medical attention is needed. Our mission is to give our contribution for achieving the internationally agreed targets on stunting and wasting in children under 5 years of age.",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: Colors.black),
                    textAlign: TextAlign.justify),
              ),

              // 2°
              _elencoPuntato(0xe318, "Home",
                  "In your home page you'll find the three indicators: heart rate, hight-for-age indicator for stunting, weight-for-height for malnutrition"),

              // 3°
              _elencoPuntato(0xe491, "Profile",
                  "The profile page will give you a recap of the child's personal data"),

              // 4°
              _elencoPuntato(0xf06bb, "Recap",
                  "You'll also have a recap page with a calendar where all the past data are shown"),

              // 5°
              _elencoPuntato(0xe33c, "Info",
                  "In the info page you'll find all the important information about who to call and where to go when you need medical assistance")
            ],
          ),
        ));
  }

  Widget _elencoPuntato(int iconCode, String pageName, String testo) {
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                width: 45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(IconData(iconCode, fontFamily: 'MaterialIcons'),
                        color: Color.fromARGB(255, 59, 81, 33)),
                    Text(pageName)
                  ],
                )),
            SizedBox(width: 20),
            SizedBox(
              width: 300,
              child: Text(testo,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Colors.black),
                  textAlign: TextAlign.justify),
            )
          ],
        ));
  }
}
