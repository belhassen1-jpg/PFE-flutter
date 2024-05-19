import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:erp_mob/Model/JobOffer.dart';  
import 'package:erp_mob/Controller/Environnement.dart';

class JobOfferController with ChangeNotifier {
  final String baseUrl = "${Environnement.baseUrl}api/joboffers";
  List<JobOffer> _jobOffers = [];
  List<JobOffer> get jobOffers => _jobOffers;

  Future<List<JobOffer>?> getAllJobOffers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all'));
      if (response.statusCode == 200) {
        Iterable data = json.decode(response.body);
        _jobOffers = List<JobOffer>.from(data.map((model) => JobOffer.fromJson(model)));
        notifyListeners(); // Notify listeners to update UI
        return _jobOffers;
      } else {
        print('Failed to fetch job offers: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAllJobOffers: $e');
    }
    return null;
  }

  Future<List<JobOffer>?> findJobOffersWithFilters(String? category, String? location) async {
    String url = '$baseUrl/filter';
    Map<String, String> queryParams = {};
    if (category != null) queryParams['category'] = category;
    if (location != null) queryParams['location'] = location;
    String queryString = Uri(queryParameters: queryParams).query;
    try {
      final response = await http.get(Uri.parse('$url?$queryString'));
      if (response.statusCode == 200) {
        Iterable data = json.decode(response.body);
        _jobOffers = List<JobOffer>.from(data.map((model) => JobOffer.fromJson(model)));
        notifyListeners();
        return _jobOffers;
      } else {
        print('Failed to fetch filtered job offers: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in findJobOffersWithFilters: $e');
    }
    return null;
  }
}
