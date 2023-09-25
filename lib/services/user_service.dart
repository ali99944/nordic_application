import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserServices{
  static final String baseUrl = 'https://test.bilsjekk.in/api';

  static Future login({ required String email, required String password }) async{
    try{
      final url = Uri.parse('$baseUrl/users/login');

      final response = await http.post(
        url,
        body: jsonEncode({'accountId': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

    print(response.statusCode);
      if (response.statusCode == 200) {
        Map<String,dynamic> dec = jsonDecode(response.body);
        print(dec);


        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.setString('token', dec['token']);
        await sharedPreferences.setString('userId', dec['user']['accountId']);
        await sharedPreferences.setString('username', dec['user']['name']);
        return true;
      } else {
        print(response.body);
        return false;
      }
    }catch(error){
      print(error.toString());
      return false;
    }
  }

  static Future register({ required String name,required String phone,
    required String password,required String email
  }) async{
    final url = Uri.parse('$baseUrl/users');
    final response = await http.post(
      url,
      body: jsonEncode({'name': name, 'email': email, 'password': password,'phone':phone}),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );

    print(response.statusCode);



    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      return true;
    } else {
      throw response.body;
    }
  }
}