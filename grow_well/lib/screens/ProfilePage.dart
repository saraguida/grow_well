import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart.';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  static const routeDisplayName = 'Profile';

  //static const route = '/profile/';
  //static const routename = 'ProfilePage';

  TextEditingController nameController = TextEditingController();  
  TextEditingController surnameController = TextEditingController(); 
  TextEditingController addressController = TextEditingController();   
  TextEditingController phoneController = TextEditingController();   

  DateTime date = DateTime(2000, 1, 1);
  

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
        body: Padding(  
            padding: EdgeInsets.all(15),  
            child: Column(  
              children: <Widget>[  
                Padding(  
                 padding: EdgeInsets.all(15),  
                  child: TextField(  
                    controller: nameController,  
                    decoration: InputDecoration(  
                      border: OutlineInputBorder(),  
                      labelText: 'Name',  
                      hintText: 'Enter Your Name',  
                   ),  
                  ),  
                ),  
                Padding(  
                  padding: EdgeInsets.all(15),  
                  child: TextField(  
                    controller: surnameController,  
                    decoration: InputDecoration(  
                      border: OutlineInputBorder(),  
                      labelText: 'Surname',  
                      hintText: 'Enter Your Surname',  
                    ),  
                    ),  
                ),   
                Padding(  
                  padding: EdgeInsets.all(15),  
                  child: Center(
                    child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Gender:'),
                              SizedBox(width: 20,),
                              DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  hint: Text(
                                    'Select',
                                  ),
                                  items: items
                                          .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                        ),
                                        ))
                                          .toList(),
                                  value: selectedValue,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value as String;
                                    });
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    height: 40,
                                    width: 90,
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                  ),
                                ),
                              ),
                              SizedBox(width: 15,),
                              const Text('Date of birth:'),
                              CupertinoButton(
                                // Display a CupertinoDatePicker in date picker mode.
                                onPressed: () => _showDialog(
                                  CupertinoDatePicker(
                                    initialDateTime: date,
                                    mode: CupertinoDatePickerMode.date,
                                    use24hFormat: true,
                                    // This shows day of week alongside day of month
                                    showDayOfWeek: true,
                                    // This is called when the user changes the date.
                                    onDateTimeChanged: (DateTime newDate) {
                                      setState(() => date = newDate);
                                    },
                                  ),
                                ),
                                // In this example, the date is formatted manually. You can
                                // use the intl package to format the value based on the
                                // user's locale settings.
                                child: Text(
                                  '${date.month}-${date.day}-${date.year}',
//                                  style: const TextStyle(
  //                                  fontSize: 22.0,
    //                              ),
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
                Padding(  
                  padding: EdgeInsets.all(15),  
                  child: TextField(  
                    controller: addressController,  
                    decoration: InputDecoration(  
                      border: OutlineInputBorder(),  
                      labelText: 'Address',  
                      hintText: 'Enter Your Address',  
                    ),  
                    ),  
                ),  
                Padding(  
                  padding: EdgeInsets.all(15),  
                  child: TextField(  
                    controller: phoneController,  
                    decoration: InputDecoration(  
                      border: OutlineInputBorder(),  
                      labelText: 'Phone Number',  
                      hintText: 'Enter Your Phone Number',  
                    ),  
                    ),  
                ),
              ],  
            )  
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
           // Navigator.push(
             // context,
          //    MaterialPageRoute(builder: (context) => LoginPage()),
          //  );
          },
          child:const Icon(Icons.logout, color:Color.fromARGB(255,59,81,33)),
          backgroundColor: Color.fromARGB(255,225,250,196),
          
        ),  
    );  
  }  
}

final List<String> items = [
  'Female',
  'Male',
  'Other'
];
String? selectedValue;