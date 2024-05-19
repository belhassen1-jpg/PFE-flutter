import 'package:erp_mob/Controller/Environnement.dart';
import 'package:erp_mob/Model/Conge.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DemandeCongeController with ChangeNotifier {
  bool loading = false;
  final String baseUrlDemandeConge =
      "${Environnement.baseUrl}api/demandes-conge";
  List<DemandeConge> _demandesConge = [];

  List<DemandeConge> get demandesConge => _demandesConge;
  set demandesConge(List<DemandeConge> newDemandesConge) {
    _demandesConge = newDemandesConge;
    notifyListeners();
  }

  // Créer une demande de congé
 Future<void> createDemandeConge({
  required int? userId,
  required Map<String, dynamic> body,
  required BuildContext context, 
}) async {
  loading = true;
  notifyListeners();
  try {
    var modifiedBody = body.map((key, value) {
      if (value is Enum) {
        return MapEntry(key, value.toString().split('.').last);
      }
      return MapEntry(key, value);
    });

    final json = jsonEncode(modifiedBody);
    final response = await http.post(
      Uri.parse('$baseUrlDemandeConge/$userId'),
      body: json,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      final newDemandeConge = DemandeConge.fromJson(jsonDecode(response.body));
      _demandesConge.add(newDemandeConge);
      notifyListeners();

      // Display a success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Success"),
          content: Text("Demande de congé créée avec succès."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
            )
          ],
        ),
      );
    } else {
      // Display an error dialog if the status code is not 201
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Failed to create demande de congé."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
    }
  } catch (e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exception"),
        content: Text('Create Demande Conge Error: ${e.toString()}'),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
    throw Exception('Create Demande Conge Error: ${e.toString()}');
  } finally {
    loading = false;
    notifyListeners();
  }
}

  // Calculer total des jours de congés pour un employé
  Future<int> calculerTotalJoursCongesPourEmploye(int employeId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrlDemandeConge/$employeId/total-jours-conges'));
      if (response.statusCode == 200) {
        return int.parse(response.body);
      }
      return 0;
    } catch (e) {
      throw Exception('Calculate Total Jours Conges Error: ${e.toString()}');
    }
  }
}
