import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simple_chat/models/message.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:pusher_websocket_flutter/pusher.dart';
import 'package:flutter/services.dart';
import 'package:simple_chat/services/web_services.dart';

class Conversation extends ChangeNotifier{
  String _message;
  Channel _channel;

  String get message => _message;

  List<Message> messages = [];

  void sendMessage(String text, String uuid) {
    final String time = DateFormat('mm:ss a').format(DateTime.now());

    if(text != ''){
      messages.insert(0,
        Message(
          sender: 'Me',
          time: time,
          text: text
        ),
      );
      Webservice.broadcast(Message.to(uuid, text, time));
      notifyListeners();
    }
  }

  void bindEvent(String channelName, String eventName) async{
    await initPusher();
    Pusher.connect();
    _channel = await Pusher.subscribe(channelName);
    _channel.bind(eventName, (last) {
      final String data = last.data;

      var json = jsonDecode(data);

      messages.insert(0,
        Message(sender: json['sender'],time: json['time'], text: json['text'])
      );
      notifyListeners();
    });
    
  }

  Future<void> initPusher() async {
    try {
      await Pusher.init('f4f7e3b55b94eb599c11', PusherOptions(cluster: 'ap1'));
    } on PlatformException catch (e) {
      print(e.message);
    }
  }
}