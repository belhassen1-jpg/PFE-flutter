import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/User.dart';

class UserController with ChangeNotifier {
      User? loggedInUser;

  Future<User?> getMe() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8090/GRH/retrieve-user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      log(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        User userData = User.fromJson(responseData);
        loggedInUser = userData;
        notifyListeners();

        return userData; // Returning the full response data
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }
}
