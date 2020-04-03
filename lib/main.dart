import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_chat/bloc/conversation.dart';
import 'package:simple_chat/bloc/login.dart';
import 'package:simple_chat/models/user.dart';
import 'package:simple_chat/screens/login.dart';
import 'package:simple_chat/screens/users_screen.dart';
import 'package:simple_chat/services/web_services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _authenticated = false;

  Future<bool> checkAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    final User response = await Webservice.get(User.me(token));
    if(response.message == 'Unauthorized'){
      return false;
    }
    return true;
  }

  @override
  void initState() {
    checkAuthenticated().then((response) {
      setState(() {
        _authenticated = response;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginPro>.value(
          value: LoginPro(),
        ),
        ChangeNotifierProvider<Conversation>.value(
          value: Conversation(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Chat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (BuildContext context) => _authenticated ? UserScreen() : LoginScreen(),
          '/login': (BuildContext context) => LoginScreen(),
          '/users': (BuildContext context) => UserScreen(),
        },
      ),
    );
  }
}