import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// import 'package:unique_identifier/unique_identifier.dart';

class NotificationService{
  static Future getAllNotifications() async{
    final platform = const MethodChannel('unique_id');

    Future<String> getAndroidId() async {
      try {
        final String androidId = await platform.invokeMethod('getAndroidId');
        return androidId;
      } catch (e) {
        print("Error: $e");
        return "";
      }
    }

    String serial = await getAndroidId();

    try{
      final Uri uri = Uri.parse('https://test.bilsjekk.in/api/notifications/imei/$serial');
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