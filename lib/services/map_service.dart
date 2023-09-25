import 'dart:convert';

import 'package:http/http.dart' as http;

class MapService{
  static Future downloadMapFeatures(String zoneId) async{
    try{
      final Uri uri = Uri.parse('https://test.bilsjekk.in/api/maps/zone/$zoneId');
      final response = await http.get(uri);

      if(response.statusCode == 200){
        return jsonDecode(response.body);
      }else{
        throw response.body.toString();
      }
    }catch(error){
      throw error.toString();
    }
  }
}