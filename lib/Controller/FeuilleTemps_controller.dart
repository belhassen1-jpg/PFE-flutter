import 'dart:convert';
import 'dart:developer';
import 'package:erp_mob/Model/Planning.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:erp_mob/Model/FeuilleTemps.dart';
import 'package:erp_mob/Controller/Environnement.dart';

class FeuilleTempsController with ChangeNotifier {
  final String baseUrl = "${Environnement.baseUrl}api/plannings";
  List<FeuilleTemps> _feuilleTempsList = [];
  Planning p = Planning();
  List<FeuilleTemps> get feuilleTempsList => _feuilleTempsList;

  Future<List<FeuilleTemps>?> getFeuilleTempsForUser(
      int userId, BuildContext context) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/feuillestempsForUser?userId=$userId'));
      log('$baseUrl/feuillestempsForUser?userId=$userId');

      if (response.statusCode == 200) {
        Iterable data = json.decode(response.body);
        _feuilleTempsList = List<FeuilleTemps>.from(
            data.map((model) => FeuilleTemps.fromJson(model)));
        log("getFeuilleTempsForUser : " + _feuilleTempsList.length.toString());

        notifyListeners();
        return _feuilleTempsList;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to load time sheets")));
      }
    } catch (e) {
      print('Failed to load time sheets: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error loading time sheets")));
    }
    return null;
  }

  Future<FeuilleTemps?> createAndAssociateFeuilleTemps(int planningId,
      int userId, FeuilleTemps feuilleTemps, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/feuilleTemps/planning/$planningId/employe/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(feuilleTemps.toJson()),
      );
      if (response.statusCode == 201) {
        FeuilleTemps newFeuilleTemps =
            FeuilleTemps.fromJson(json.decode(response.body));
        _feuilleTempsList.add(newFeuilleTemps);
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Time sheet added successfully")));
        return newFeuilleTemps;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to create time sheet")));
      }
    } catch (e) {
      print('Failed to create and associate time sheet: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error creating time sheet")));
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getEmployeeRankingByProjectName(
      String projectName, BuildContext context) async {
    try {
      final encodedProjectName = Uri.encodeComponent(projectName);
      final response = await http.get(Uri.parse(
          '$baseUrl/planning/by-project-name/$encodedProjectName/employee-ranking'));
      log(response.body);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> rankings =
            List<Map<String, dynamic>>.from(data);
        return rankings;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("Failed to load employee rankings: ${response.body}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Network error: $e")));
    }
    return null;
  }
}
