import 'dart:convert';

import 'package:car_app/models/issue_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class IssueService {
  static String baseUrl = "https://test.bilsjekk.in";

  static Future getAllNotifications() async {
    try {
      final Uri uri =
          Uri.parse('https://test.bilsjekk.in/api/issueNotifications');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw "Invalid Status Code";
      }
    } catch (error) {
      throw error.toString();
    }
  }

  static Future<List> getAllCurrentIssues() async {
    try {
      final Uri uri = Uri.parse('https://test.bilsjekk.in/api/issues/current');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List issues = jsonDecode(response.body);
        print(issues);
        return issues;
      } else {
        throw response.body;
      }
    } catch (error) {
      throw error.toString();
    }
  }

  static Future<List> getAllCompletedIssues() async {
    try {
      final Uri uri = Uri.parse('https://test.bilsjekk.in/api/issues/complete');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw response.body;
      }
    } catch (error) {
      throw error.toString();
    }
  }

  static Future uploadMachineIssueFixReport(
      IssueData issueData, String imagePath, Map<String, String> data) async {
    try {
      final Uri uri = Uri.parse("$baseUrl/api/issues/${issueData.id}/report");
      var request = http.MultipartRequest('POST', uri);

      request.files.add(await http.MultipartFile.fromPath('report', imagePath));

      request.fields.addAll(data);

      print(issueData.serial);
      print(issueData.zone);
      print(issueData.zoneLocation);

      request.fields.addAll({
        'zone': issueData.zone,
        'zoneLocation': issueData.zoneLocation,
        'serial': issueData.serial
      });

      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final String? token = sharedPreferences.getString('token');
      request.headers['token'] = token ?? '';

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

  static Future notifyExternalSource(String reason, String id) async {
    try {
      final Uri uri = Uri.parse('$baseUrl/api/issues/$id/external/notify');
      final response = await http.post(uri,
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode({'reason': reason}));

      if (response.statusCode == 200) {
        return;
      } else {
        throw response.body;
      }
    } catch (error) {
      throw error.toString();
    }
  }
}
