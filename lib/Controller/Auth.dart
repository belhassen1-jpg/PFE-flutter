import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl;
  AuthService({required this.baseUrl});

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8090/GRH/authenticate'),
        body: jsonEncode({'username': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData; // Returning the full response data
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }
}
