import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:erp_mob/Model/DemandeParticipationEvenement.dart';
import 'package:erp_mob/Model/Evenement.dart';
import 'package:erp_mob/Controller/Environnement.dart';

class EvenementController with ChangeNotifier {
  final String baseUrl = "${Environnement.baseUrl}api/evenements";
  List<Evenement> _evenements = [];
  List<Evenement> get evenements => _evenements;

  Future<List<Evenement>?> listEvenementsWithParticipants() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/etParticipants'));
      if (response.statusCode == 200) {
        Iterable data = json.decode(response.body);
        _evenements = List<Evenement>.from(
            data.map((model) => Evenement.fromJson(model)));
        notifyListeners(); // Notify listeners to update UI
        return _evenements;
      } else {
        print(
            'Failed to fetch events and participants: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in listEvenementsWithParticipants: $e');
    }
    return null;
  }

  Future<DemandeParticipationEvenement?> createDemandeParticipation(
      int userId, int evenementId) async {
    String url =
        '$baseUrl/demandeParticipation?userId=$userId&evenementId=$evenementId';

    try {
      final response = await http
          .post(Uri.parse(url), headers: {'Content-Type': 'application/json'});
      log(response.body); // Log the response body to debug
      log(url); // Log the full URL to ensure it's correct

      if (response.statusCode == 201) {
        DemandeParticipationEvenement newParticipation =
            DemandeParticipationEvenement.fromJson(jsonDecode(response.body));
        notifyListeners(); // Notify listeners if you update any related state
        return newParticipation;
      } else {
        print('Failed to create participation request: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in createDemandeParticipation: $e');
    }
    return null;
  }

  Future<int?> obtenirNombreEvenementsParticipesForUser(int userId) async {
    String url = '$baseUrl/nombreEvenementsParticipesForUser/$userId';

    try {
      final response = await http.get(Uri.parse(url));
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        int nombreEvenements = jsonDecode(response.body);
        return nombreEvenements;
      } else {
        print(
            'Failed to fetch number of participated events: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in obtenirNombreEvenementsParticipesForUser: $e');
    }
    return null;
  }
}
