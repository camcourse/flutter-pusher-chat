import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_chat/bloc/login.dart';
import 'package:simple_chat/models/user.dart';
import 'package:simple_chat/screens/chat_screen.dart';
import 'package:simple_chat/services/web_services.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoginPro login = Provider.of<LoginPro>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: (){
              login.signOut(context);
            },
          )
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: Webservice.load(User.all),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  User user = snapshot.data[index];

                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                          ChatScreen(user)
                        )
                      );
                    },
                  );
                },
              );
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}