import 'package:http/http.dart';

class Resource
{
  String url;
  String token;
  Function(Response response) parse;
  final Map<String, dynamic> data;

  Resource({ this.url, this.parse, this.data, this.token});
}
