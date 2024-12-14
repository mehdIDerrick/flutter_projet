import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<Map<String, dynamic>> getData(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<Map<String, dynamic>> postData(
      String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('https://chatbot-api-rpgu.onrender.com/api/chatbot'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    print("HTTP Response Code: ${response.statusCode}");
    print("HTTP Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }
}
