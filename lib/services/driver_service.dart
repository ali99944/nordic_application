import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DriverService {
  static String baseUrl = "https://test.bilsjekk.in";

  static Future<void> createNewDriver({required List<Map<String, dynamic>> driverData}) async {
    try {
      final Uri uri = Uri.parse("$baseUrl/api/drivers");

      var request = http.MultipartRequest('POST', uri);
      print("Yes Am Here");

      for (final entry in driverData) {
        if (entry['answerDataType'] == 'file' || entry['answerDataType'] == 'image') {

          if (entry['answerDataType'] == 'file') {
            String fieldName = entry['title'];
            String filePath = entry['value'];
            request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));
          } else if (entry['answerDataType'] == 'image') {
            String fieldName = entry['title'];
            List filePath = entry['value'];
            // Assuming image files, modify content type if required for other file types
            for(String path in filePath){
              request.files.add(await http.MultipartFile.fromPath(Uri.encodeComponent(fieldName), path));
            }
          }
        } else {
          // Add non-file data to the request as fields
          String fieldName = entry['id'];
          request.fields[fieldName] = Uri.encodeComponent(jsonEncode(entry));
        }
        final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        final String? token = sharedPreferences.getString('token');
        request.headers['token'] = token ?? '';
        String data = sharedPreferences.getString('data') ?? '';
        Map d = jsonDecode(data);
        print(d['date']);
        String full = Uri.encodeComponent(data);
        request.headers['data'] = full;
      }

      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Handle success response if needed
        print('Data and files/images uploaded successfully');
      } else {
        throw await response.stream.bytesToString();
      }
    } catch (error) {
      print(error.toString());
      throw error.toString();
    }
  }

  static Future<List> getFormFields({ required String formName }) async{
    try{
      final Uri uri = Uri.parse('https://test.bilsjekk.in/api/formFields/form/$formName');
      http.Response response = await http.get(uri);

      if(response.statusCode == 200){
        return jsonDecode(response.body);
      }else{
        return [];
      }
    }catch(error){
      return [];
    }
  }
}
