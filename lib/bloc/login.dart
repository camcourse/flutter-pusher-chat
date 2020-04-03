import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_chat/models/user.dart';
import 'package:simple_chat/services/web_services.dart';

class LoginPro extends ChangeNotifier{
  bool _loading = false;
  bool _loggedIn = false;

  bool get loading => _loading;
  bool get loggedIn => _loggedIn;

  void startLoading(){
    _loading = true;
    notifyListeners();
  }

  void stopLoading(){
    _loading = false;
    notifyListeners();
  }

  void signinWithToken(String token, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('access_token', token);
    prefs.setString('user_name', name);
  }

  void signOut(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await Webservice.get(User.logout(prefs.getString('access_token')));
    prefs.setString('access_token', '');
    prefs.setString('user_name', '');

    Navigator.of(context).pushReplacementNamed('/login');
  }

  void checkAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    
    if(token == null){
      _loggedIn = false;
      notifyListeners();
    }

    if(token != null){
      _loggedIn = true;
      notifyListeners();
    }

  }

  Future<bool> checkToken(String token) async {
    final User response = await Webservice.get(User.me(token));
    
    if(response.message == 'Unauthorized'){
      return false;
    }

    return true;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final User response = await Webservice.post(User.login(email, password)); 

    if(response.accessToken == null){
      return {
        'status': false,
        'message': response.message
      };
    }

    prefs.setString('access_token', response.accessToken);
    prefs.setString('user_name', response.name);

    return {
      'access_token': response.accessToken,
      'status': true,
    };
  }

}