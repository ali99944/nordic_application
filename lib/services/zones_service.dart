import 'dart:convert';

import 'package:http/http.dart' as http;

class ZoneService{
  static Future getAllZones() async{
    try{
      final Uri uri = Uri.parse('https://test.bilsjekk.in/api/zones');
      final response = await http.get(uri);

      if(response.statusCode == 200){
        return jsonDecode(response.body);
      }else{
        throw "Invalid Status Code";
      }
    }catch(error){
      throw error.toString();
    }
  }
}