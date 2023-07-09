import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:grow_well/screens/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const routeDisplayName = 'Profile';

  final List<String> items = ['Female', 'Male'];
  String? selectedValue;
  DateTime date = DateTime(2018, 1, 1);
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  } //initState

  void _checkLogin() async {
    final sp = await SharedPreferences.getInstance();
    if (sp.getString('name') != null) {
      nameController.text = sp.getString('name')!;
    } //name check
    if (sp.getString('surname') != null) {
      surnameController.text = sp.getString('surname')!;
    } //surname check
    if (sp.getString('gender') != null) {
      selectedValue = sp.getString('gender')!;
      setState(() {
        selectedValue = selectedValue;
      });
    } //gender check
    if (sp.getString('date') == null) {
      String stringDate = date.toString();
      sp.setString('date', stringDate);
    } else {
      String stringDate = sp.getString('date')!;
      DateTime updatedDate = DateTime.parse(stringDate);
      setState(() {
        date = updatedDate;
      });
    } //date of birth check
    if (sp.getString('address') != null) {
      addressController.text = sp.getString('address')!;
    } //address check
    if (sp.getString('phone') != null) {
      phoneController.text = sp.getString('phone')!;
    } //phone number check
  } //_checkLogin

  void _saveName(TextEditingController controller) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString('name', controller.text);
  } //_saveName

  void _saveSurname(TextEditingController controller) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString('surname', controller.text);
  } //_saveSurname

  void _saveGender(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString('gender', value);
  } //_saveGender

  void _saveDate(DateTime datetime) async {
    String stringDate = datetime.toString();
    final sp = await SharedPreferences.getInstance();
    await sp.setString('date', stringDate);
    setState(() {
      date = datetime;
    });
  } //_saveDate

  void _saveAddress(TextEditingController controller) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString('address', controller.text);
  } //_saveAddress

  void _savePhone(TextEditingController controller) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString('phone', controller.text);
  } //_savePhone

  Future<void> _showDialog(Widget child) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
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
      body: Center(
        child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                      onChanged: (text) {
                        _saveName(nameController);
                      }),
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
                      onChanged: (text) {
                        _saveSurname(surnameController);
                      }),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Gender:'),
                        SizedBox(
                          width: 20,
                        ),
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
                              _saveGender(selectedValue!);
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
                        SizedBox(
                          width: 10,
                        ),
                        const Text('Date of birth:'),
                        CupertinoButton(
                          onPressed: () => _showDialog(
                            CupertinoDatePicker(
                              initialDateTime: date,
                              mode: CupertinoDatePickerMode.date,
                              use24hFormat: true,
                              onDateTimeChanged: (DateTime newDate) {
                                setState(() => date = newDate);
                                _saveDate(date);
                              },
                            ),
                          ),
                          child: Text(
                            '${date.month}-${date.day}-${date.year}',
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
                      onChanged: (text) {
                        _saveAddress(addressController);
                      }),
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
                      onChanged: (text) {
                        _savePhone(phoneController);
                      }),
                ),
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _toLoginPage(context),
        child: const Icon(Icons.logout, color: Color.fromARGB(255, 59, 81, 33)),
        backgroundColor: Color.fromARGB(255, 225, 250, 196),
      ),
    );
  } //build

  void _toLoginPage(BuildContext context) async {
    final sp = await SharedPreferences.getInstance();
    sp.remove('username');

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  } //_toLoginPage
}
