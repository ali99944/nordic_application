
import 'package:http/http.dart' as http;


class DataService{
  static final String baseUrl = 'https://test.bilsjekk.in/api';
  static Future<String?> getInformationData({required String part}) async{
    try{
      final url = Uri.parse('$baseUrl/info/$part');

      print(url);

      final response = await http.get(
        url,
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    }catch(error){
      print(error.toString());
      return null;
    }
  }
}