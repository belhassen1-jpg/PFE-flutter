import 'dart:developer';

import 'package:erp_mob/Controller/Environnement.dart';
import 'package:erp_mob/Model/SessionFormation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SessionFormationController with ChangeNotifier {
  final String baseUrl = "${Environnement.baseUrl}api/sessionformations";
  List<SessionFormation> _sessions = [];

  List<SessionFormation> get sessions => _sessions;

  Future<void> fetchAllSessions() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        _sessions =
            jsonData.map((data) => SessionFormation.fromJson(data)).toList();
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Fetch Sessions Error: ${e.toString()}');
    }
  }

  Future<void> inscribeEmployeeToSession(int sessionId, int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$sessionId/inscrire/$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final updatedSession =
            SessionFormation.fromJson(jsonDecode(response.body));
        _sessions[_sessions.indexWhere((s) => s.id == sessionId)] =
            updatedSession;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Inscribe Employee Error: ${e.toString()}');
    }
  }

  Future<int> getNumberOfSessionsParticipated(int employeId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/nombreFormations/$employeId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get number of participations');
      }
    } catch (e) {
      throw Exception('Get Number of Sessions Error: ${e.toString()}');
    }
  }
}
