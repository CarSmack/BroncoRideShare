import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';


const baseUrl = "https://jsonplaceholder.typicode.com";

class GetRequest {
  static Future getUsers() {
    var url = baseUrl + "/users";
    return http.get(url);
  }
}
class User {
  int id;
  String name;
  String email;

  User(int id, String name, String email) {
    this.id = id;
    this.name = name;
    this.email = email;
  }

  User.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        email = json['email'];

  Map toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}