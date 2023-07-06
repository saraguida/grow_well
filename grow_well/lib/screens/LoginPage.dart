import 'package:flutter/material.dart';
import 'package:grow_well/screens/HomePage.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

/////// for authorization
import 'dart:convert';
import 'package:grow_well/utils/impact.dart';
import 'package:http/http.dart' as http;
///////

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
    //Check if the user is already logged in before rendering the login page
    _checkLogin();
  } //initState

  void _checkLogin() async {
    //Get the SharedPreference instance and check if the value of the 'username' filed is set or not
    final sp = await SharedPreferences.getInstance();
    if (sp.getString('username') != null) {
      //If 'username is set, push the HomePage
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
  }

  // _loginUser
  Future<String> _signUpUser(SignupData data) async {
    return 'To be implemented';
  }

  // _signUpUser
  Future<String> _recoverPassword(String email) async {
    return 'Recover password functionality needs to be implemented';
  }

  // _recoverPassword
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

          // rettangolo interiore
          cardTheme: CardTheme(
              color: Colors.yellow.shade100,
              elevation: 10,
              margin: EdgeInsets.only(top: 20),
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),

          // finestre di inserimento email e password
          inputTheme: InputDecorationTheme(
            filled: true,
            fillColor: Color.fromARGB(255, 59, 81, 33).withOpacity(.1),
            labelStyle:
                TextStyle(fontSize: 19, color: Color.fromARGB(255, 59, 81, 33)),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10)),
          ),

          // LOGIN button
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

/*
  void _toHomePage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  } //_toHomePage */

  Future<void> _toHomePage(BuildContext context) async {
    final result = await _authorize(); // return statusCode
    final message = result == 200 ? 'Request successful' : 'Request failed';
    print(message);

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  } //_toHomePage

  // AUTHORIZATION
  //This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
  Future<int?> _authorize() async {
    //Create the request
    final url = Impact.baseUrl + Impact.tokenEndpoint;
    final body = {'username': Impact.username, 'password': Impact.password};

    //Get the response
    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    //If 200, set the token
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      sp.setString('access', decodedResponse['access']);
      sp.setString('refresh', decodedResponse['refresh']);
    } //if

    //Just return the status code
    return response.statusCode;
  } //_authorize
} // LoginScreen