import 'dart:convert';
import 'dart:developer';
import 'package:erp_mob/Controller/Environnement.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:erp_mob/Model/Planning.dart';

class PlanningController with ChangeNotifier {
  final String baseUrl =
      "${Environnement.baseUrl}api/plannings"; // Utilisation de la base URL similaire à l'exemple fourni
  List<Planning> _plannings = [];

  List<Planning> get plannings => _plannings;

  Future<List<Planning>?> obtenirTousLesPlanningsAvecDetails() async {
    String url = '$baseUrl/allDetails';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Iterable data = jsonDecode(response.body);
        _plannings =
            List<Planning>.from(data.map((model) => Planning.fromJson(model)));
        notifyListeners();
        return _plannings;
      }
    } catch (e) {
      print('Erreur lors de la récupération des plannings: $e');
    }
    return null;
  }
}
