import 'package:flutter/material.dart';

class InfoPageWidget extends StatelessWidget {
  const InfoPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
              "Some helpful phone numbers to call when medical assistance is needed.",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                  color: Colors.black),
              textAlign: TextAlign.justify),

          SizedBox(height: 40),
          // 1st contact
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: 175,
                  child: Text("Your doctor",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
              SizedBox(width: 20),
              SizedBox(
                  width: 100,
                  child: Text("3265771001",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16))),
              SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.call, color: Colors.orange),
                  Text("Call")
                ],
              )
            ],
          ),
          SizedBox(height: 40),

          // 2nd contact
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: 175,
                  child: Text("Emergency doctor",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
              SizedBox(width: 20),
              SizedBox(
                  width: 100,
                  child: Text("3988129220",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16))),
              SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.call, color: Colors.orange),
                  Text("Call")
                ],
              )
            ],
          ),
          SizedBox(height: 40),

          // 3rd contact
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: 175,
                  child: Text("Emergency number",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
              SizedBox(width: 20),
              SizedBox(
                  width: 100,
                  child: Text("112",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16))),
              SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.call, color: Colors.orange),
                  Text("Call")
                ],
              )
            ],
          ),
          SizedBox(height: 40),

          // 4th contact
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: 175,
                  child: Text("Nearest Hospital",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
              SizedBox(width: 20),
              SizedBox(
                  width: 100,
                  child: Text("0498211111",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16))),
              SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.call, color: Colors.orange),
                  Text("Call")
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
