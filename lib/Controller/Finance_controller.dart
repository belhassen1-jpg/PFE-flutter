import 'dart:convert';
import 'dart:developer';
import 'package:erp_mob/Model/Analyse_Financiere.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:erp_mob/Model/Depense.dart';
import 'package:erp_mob/Model/ObjectifEpargne.dart';
import 'package:erp_mob/Controller/Environnement.dart';

class FinanceController with ChangeNotifier {
  final String baseUrl = "${Environnement.baseUrl}api/finances";
  List<Depense> _depenses = [];
  List<ObjectifEpargne> _objectifsEpargne = [];

  List<Depense> get depenses => _depenses;
  List<ObjectifEpargne> get objectifsEpargne => _objectifsEpargne;

  Future<Depense?> ajouterDepense(
      int userId, Depense depense, BuildContext context) async {
    String url = '$baseUrl/depenses?userId=$userId';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(depense.toJson()),
      );
      if (response.statusCode == 200) {
        Depense newDepense = Depense.fromJson(jsonDecode(response.body));
        _depenses.add(newDepense); // Add the new expense to the list
        notifyListeners(); // Notify listeners to update the UI
        listerDepenses(userId); // Optionally refresh the entire list if needed

        // Show a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Votre dépense est ajoutée avec succès")));

        return newDepense;
      }
    } catch (e) {
      print('Error adding expense: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de l'ajout de la dépense")));
    }
    return null;
  }

  Future<ObjectifEpargne?> ajouterObjectifEpargne(
      int userId, ObjectifEpargne objectif, BuildContext context) async {
    String url = '$baseUrl/objectifs-epargne?userId=$userId';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(objectif.toJson()),
      );
      if (response.statusCode == 200) {
        ObjectifEpargne newObjectif =
            ObjectifEpargne.fromJson(jsonDecode(response.body));

        // Assuming you have a list for objectifs in your controller
        _objectifsEpargne.add(newObjectif); // Add the new objective to the list
        notifyListeners(); // Notify listeners to update the UI
        listerObjectifsEpargne(userId); // Refresh the entire list if needed

        // Show a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Votre objectif d'épargne est ajouté avec succès")));

        return newObjectif;
      }
    } catch (e) {
      print('Error setting savings goal: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Erreur lors de l'ajout de l'objectif d'épargne")));
    }
    return null;
  }

  Future<AnalyseFinanciere?> obtenirAnalyseFinanciere(int userId) async {
    String url = '$baseUrl/analyses/$userId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return AnalyseFinanciere.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('Error fetching financial analysis: $e');
    }
    return null;
  }

  Future<List<Depense>?> listerDepenses(int userId) async {
    String url = '$baseUrl/depenses/$userId';
    try {
      final response = await http.get(Uri.parse(url));
      log(response.body);
      if (response.statusCode == 200) {
        Iterable data = jsonDecode(response.body);
        _depenses =
            List<Depense>.from(data.map((model) => Depense.fromJson(model)));
        notifyListeners(); // Notifying listeners after updating the list
        return _depenses;
      }
    } catch (e) {
      print('Error listing expenses: $e');
    }
    return null;
  }

  Future<List<ObjectifEpargne>?> listerObjectifsEpargne(int userId) async {
    String url = '$baseUrl/objectifs-epargne/$userId';
    try {
      final response = await http.get(Uri.parse(url));
      log(response
          .body); // Useful for debugging and logging the raw JSON response
      if (response.statusCode == 200) {
        Iterable data = jsonDecode(response.body);
        _objectifsEpargne = List<ObjectifEpargne>.from(
            data.map((model) => ObjectifEpargne.fromJson(model)));
        notifyListeners(); // Notify listeners to update the UI
        return _objectifsEpargne; // Return the updated list
      }
    } catch (e) {
      print('Error listing savings goals: $e');
      // Optionally, you could handle errors more gracefully here, e.g., by using UI elements or additional logging
    }
    return null;
  }
}
