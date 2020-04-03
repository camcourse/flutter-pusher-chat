import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_chat/services/resource.dart';

class Webservice
{
  static Future load(Resource resource) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    
    http.Response response = await http.get(
      'https://pusher-chat-api.herokuapp.com/api/${resource.url}',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'bearer '+ token
      },
    );

    return resource.parse(response);
  }

  static Future post(Resource resource) async{
    http.Response response = await http.post(
      'https://pusher-chat-api.herokuapp.com/api/${resource.url}',
      body: resource.data
    );

    return resource.parse(response);
  }

  static Future broadcast(Resource resource) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');

    http.Response response = await http.post(
      'https://pusher-chat-api.herokuapp.com/api/${resource.url}',
      body: resource.data,
      headers: {
        'Authorization': 'bearer '+ token
      },
    );

    return resource.parse(response);
  }

  static Future get(Resource resource) async{
    http.Response response = await http.get(
      'https://pusher-chat-api.herokuapp.com/api/${resource.url}',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'bearer '+ resource.token
      },
    );

    return resource.parse(response);
  }
}