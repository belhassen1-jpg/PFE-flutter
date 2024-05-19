import 'dart:developer';

import 'package:erp_mob/Controller/Environnement.dart';
import 'package:erp_mob/Model/Demission.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DemissionController with ChangeNotifier {
  bool loading = false;
  final String baseUrlDemission =
      "${Environnement.baseUrl}api/demissions/creer";
  List<Demission> _demissions = [];

  List<Demission> get demissions => _demissions;
  set demissions(List<Demission> newDemissions) {
    _demissions = newDemissions;
    notifyListeners();
  }

  // Creating a demission request
  Future<void> createDemission({
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
        Uri.parse('$baseUrlDemission/$userId'),
        body: json,
        headers: {'Content-Type': 'application/json'},
      );
      log(response.body);
      if (response.statusCode == 201) {
        final newDemission = Demission.fromJson(jsonDecode(response.body));
        _demissions.add(newDemission);
        notifyListeners();

        // Display a success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Success"),
            content: Text("Demission request created successfully."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () =>
                    Navigator.of(context).pop(), // Close the dialog
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
            content: Text("Failed to create demission request."),
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
          content: Text('Create Demission Error: ${e.toString()}'),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
      throw Exception('Create Demission Error: ${e.toString()}');
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
