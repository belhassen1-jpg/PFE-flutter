import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:erp_mob/Model/DemandeParticipationConvention.dart';
import 'package:erp_mob/Model/Convention.dart';
import 'package:erp_mob/Controller/Environnement.dart';

class ConventionController with ChangeNotifier {
  final String baseUrl = "${Environnement.baseUrl}api/conventions";
  List<Convention> _conventions = [];
  List<Convention> get conventions => _conventions;

  Future<List<Convention>?> listerConventionsAvecParticipants() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/etParticipants'));
      if (response.statusCode == 200) {
        Iterable data = json.decode(response.body);
        _conventions = List<Convention>.from(
            data.map((model) => Convention.fromJson(model)));
        notifyListeners(); 
        return _conventions;
      } else {
        print(
            'Failed to fetch conventions and participants: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in listerConventionsAvecParticipants: $e');
    }
    return null;
  }

  Future<DemandeParticipationConvention?> creerDemandeParticipation(
      int userId, int conventionId) 
      async {
         String url =
        '$baseUrl/demandeParticipation?userId=$userId&conventionId=$conventionId';

    try {
      final response = await http
          .post(Uri.parse(url), headers: {'Content-Type': 'application/json'});
      log(response.body); // Log the response body to debug
      log(url); // Log the full URL to ensure it's correct

      if (response.statusCode == 201) {
        DemandeParticipationConvention newParticipation =
            DemandeParticipationConvention.fromJson(jsonDecode(response.body));
        notifyListeners(); // Notify listeners if you update any related state
        return newParticipation;
      } else {
        print('Failed to create participation request: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in creerDemandeParticipation: $e');
    }
    return null;
  }
}
