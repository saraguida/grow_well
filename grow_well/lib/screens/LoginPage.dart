import 'package:flutter/material.dart';
import 'package:grow_well/screens/HomePage.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:grow_well/utils/impact.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routename = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  } //initState

  void _checkLogin() async {
    final sp = await SharedPreferences.getInstance();
    if (sp.getString('username') != null) {
      _toHomePage(context);
    } //if
  } //_checkLogin

  Future<String> _loginUser(LoginData data) async {
    if (data.name == 'user1@gmail.com' && data.password == '1234') {
      final sp = await SharedPreferences.getInstance();
      sp.setString('username', data.name);

      return '';
    } else {
      return 'Wrong credentials';
    }
  } //_loginUser

  Future<String> _signUpUser(SignupData data) async {
    return 'To be implemented';
  } //_signUpUser

  Future<String> _recoverPassword(String email) async {
    return 'To be implemented';
  } //_recoverPassword

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      theme: LoginTheme(
          primaryColor: Colors.lightGreen,
          titleStyle: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 59, 81, 33),
              fontWeight: FontWeight.bold),
          logoWidth: 1,
          cardTheme: CardTheme(
              color: Colors.yellow.shade100,
              elevation: 10,
              margin: EdgeInsets.only(top: 20),
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          inputTheme: InputDecorationTheme(
            filled: true,
            fillColor: Color.fromARGB(255, 59, 81, 33).withOpacity(.1),
            labelStyle:
                TextStyle(fontSize: 19, color: Color.fromARGB(255, 59, 81, 33)),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10)),
          ),
          buttonTheme: LoginButtonTheme(
            backgroundColor: Colors.yellow.shade700,
            elevation: 9.0,
            highlightElevation: 6.0,
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          )),
      logo: AssetImage('images/logo.png'),
      title: 'Login',
      onLogin: _loginUser,
      onSignup: _signUpUser,
      onRecoverPassword: _recoverPassword,
      onSubmitAnimationCompleted: () async {
        _toHomePage(context);
      },
    );
  } // build

  Future<void> _toHomePage(BuildContext context) async {
    final result = await _authorize(); // return statusCode
    final message = result == 200 ? 'Request successful' : 'Request failed';
    print(message);

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  } //_toHomePage

  // AUTHORIZATION
  Future<int?> _authorize() async {
    final url = Impact.baseUrl + Impact.tokenEndpoint;
    final body = {'username': Impact.username, 'password': Impact.password};

    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      sp.setString('access', decodedResponse['access']);
      sp.setString('refresh', decodedResponse['refresh']);
    } //if

    return response.statusCode;
  } //_authorize
} // LoginScreen