import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:erp_mob/Controller/Environnement.dart';

class StatisticsController with ChangeNotifier {
  final String baseUrl = "${Environnement.baseUrl}api/statistics";

  Map<String, Map<int, double>> _participationStatistics = {};

  Map<String, Map<int, double>> get participationStatistics => _participationStatistics;

  Future<void> getParticipationStatistics(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/participation'));
      log(response.body); // Logging the response for debugging
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        _participationStatistics = data.map((key, value) {
          // Parsing the nested map
          Map<int, double> innerMap =
              (value as Map<String, dynamic>).map((k, v) {
            return MapEntry(int.parse(k), (v as int).toDouble()); // Converting Long to double
          });
          return MapEntry(key, innerMap);
        });
        notifyListeners();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Failed to load participation statistics: ${response.statusCode}")));
      }
    } catch (e) {
      print('Error loading participation statistics: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error loading participation statistics: $e")));
    }
  }
}
