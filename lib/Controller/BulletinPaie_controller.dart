import 'package:erp_mob/Controller/Environnement.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:erp_mob/Model/BulletinPaie.dart';  // Ensure you have a BulletinPaie model with a fromJson constructor

class PaieController with ChangeNotifier {
  final String baseUrl = "${Environnement.baseUrl}api/paie";
  
  List<BulletinPaie> _bulletins = [];

  List<BulletinPaie> get bulletins => _bulletins;

  Future<void> fetchBulletinsForUser(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/bulletinsForUser/$userId'));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        _bulletins = jsonData.map((data) => BulletinPaie.fromJson(data)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to fetch bulletins');
      }
    } catch (e) {
      throw Exception('Fetch Bulletins Error: ${e.toString()}');
    }
  }

  Future<BulletinPaie> fetchLatestBulletinForUser(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/dernierBulletinPaieForUser/$userId'));
      if (response.statusCode == 200) {
        // Convert the JSON response into a BulletinPaie object
        return BulletinPaie.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch latest bulletin');
      }
    } catch (e) {
      // If an error occurs, log it and rethrow it
      print(e.toString());
      throw Exception('Fetch Latest Bulletin Error: ${e.toString()}');
    }
  }
}
