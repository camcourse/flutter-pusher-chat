import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_chat/bloc/conversation.dart';
import 'package:simple_chat/models/message.dart';
import 'package:simple_chat/models/user.dart';

class ChatScreen extends StatefulWidget {
    final User user;
    ChatScreen(this.user);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final ScrollController _scrollController = new ScrollController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {'message': ''};

  void sendMessage(conversation, controller, user){
    _formKey.currentState.save();

    conversation.sendMessage(_formData['message'], user.uuid);
    controller.clear();

    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Conversation conversation = Provider.of<Conversation>(context);
    final TextEditingController _controller = new TextEditingController();

    conversation.bindEvent(widget.user.uuid, 'onMessage');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: EdgeInsets.only(top: 15.0),
                  itemCount: conversation.messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Message message = conversation.messages[index];
                    
                    return ListTile(
                      title: Text(message.text),
                      subtitle: Text(message.sender +' · '+message.time),
                    );
                  },
                ),
              ),
            ),
            
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              height: 70.0,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                      controller: _controller,
                      textCapitalization: TextCapitalization.sentences,
                      onSaved: (String value){
                        _formData['message'] = value;
                      },
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type a message...',
                      ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    iconSize: 25.0,
                    color: Colors.blue,
                    onPressed: () {
                      sendMessage(conversation, _controller, widget.user);
                    },
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

}