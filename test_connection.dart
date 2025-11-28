import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final url = 'https://221784457686/api/v1/auth/initiate-login';
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({'numeroTelephone': '+221784457686'});

  print('Testing connection to: $url');
  print('Headers: $headers');
  print('Body: $body');

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print('\nResponse Status Code: ${response.statusCode}');
    print('Response Headers: ${response.headers}');
    print('Response Body: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('\n✅ Connection successful! Data sent and received response.');
    } else {
      print('\n❌ Connection failed with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('\n❌ Connection error: $e');
  }
}