import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_chat/bloc/login.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null
  };

  void _submitForm(LoginPro login, context){
    if(!_formKey.currentState.validate()){
      return;
    }

    _formKey.currentState.save();

    login.startLoading();

    login.login(_formData['email'], _formData['password'])
    .then((response){
      login.stopLoading();
      
      if(!response['status']){
        showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text('Authentication failed'),
              content: Text("we couldn't sign you in with those credentials"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close'),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
        );
      }
      
      Navigator.of(context).pushReplacementNamed('/users');
    });
  }

  @override
  Widget build(BuildContext context) {
    final LoginPro login = Provider.of<LoginPro>(context);
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: targetWidth,
                child:Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20
                    ),
                    child:
                    Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildEmailTextField(),
                      SizedBox(height: 20,),
                      _buildPasswordTextField(),
                      SizedBox(height: 30,),
                      FractionallySizedBox(
                        widthFactor: 0.6,
                        child: FlatButton(
                          color: Colors.lightBlue,
                          disabledColor: Colors.black12,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                login.loading ?  Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: CupertinoActivityIndicator(),
                                ) : Text(''),
                                Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    letterSpacing: 2
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPressed: (){
                            _submitForm(login, context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailTextField(){
    return TextFormField(
      initialValue: 'admin@example.com',
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2
          )
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.lightBlue,
            width: 2
          )
        ),
        labelText: 'Email',
        filled: true,
        fillColor: Colors.white
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value){
        if(value.isEmpty){
          return 'Email field is required';
        }
        return null;
      },
      onSaved: (String value){
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField(){
    return TextFormField(
      initialValue: 'password',
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2
          )
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.lightBlue,
            width: 2
          )
        ),
        labelText: 'Password',
        filled: true,
        fillColor: Colors.white
      ),
      obscureText: true,
      validator: (String value){
        if(value.isEmpty){
          return 'Password field is required';
        }
        return null;
      },
      onSaved: (String value){
        _formData['password'] = value;
      },
    );
  }
}