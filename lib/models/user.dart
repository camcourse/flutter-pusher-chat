import 'dart:convert';
import 'package:simple_chat/services/resource.dart';

class User
{
  String name;
  String email;
  String password;
  String uuid;
  String message;
  String accessToken;

  User({
    this.name,
    this.email,
    this.password,
    this.uuid,
    this.message,
    this.accessToken,
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      uuid: json['uuid'],
      message: json['message'],
      accessToken: json['access_token'],
    );
  }

  static Resource me(String token) {
    return Resource(
      url: 'me',
      token: token,
      parse: (response){
        return User.fromJson(
          json.decode(response.body)
        );
      }
    );
  }

  static Resource logout(String token) {
    return Resource(
      url: 'logout',
      token: token,
      parse: (response){
        return User.fromJson(
          json.decode(response.body)
        );
      }
    );
  }

  static Resource get all {
    return Resource(
      url: 'users',
      parse: (response){
        Iterable list = json.decode(response.body)['data'];

        return list.map((users) {
          return User.fromJson(users);
        }).toList();
      }
    );
  }

  static Resource login(String email, String password){
    return Resource(
      url: 'login',
      data: {
        'email': email,
        'password': password
      },
      parse: (response){
        return User.fromJson(
          json.decode(response.body)
        );
      }
    );
  }
}