import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:erp_mob/Model/JobApplication.dart';
import 'package:erp_mob/Controller/Environnement.dart';
import 'package:async/async.dart'; // Import this package for file uploading
import 'package:dio/dio.dart';
import 'dart:io';

class JobApplicationController with ChangeNotifier {
  final String baseUrl = "${Environnement.baseUrl}applications";

  Future<JobApplication?> submitApplication({
    required int jobOfferId,
    required int userId,
    required File resume,
    required File coverLetter,
    required Map<String, dynamic> applicationDto,
  }) async {
    log("*****************************");
    log("*****************************");
    Dio dio = Dio();

    var formData = FormData.fromMap({
      "jobOfferId": jobOfferId.toString(),
      "userId": userId.toString(),
      ...applicationDto,
      "resume":
          await MultipartFile.fromFile(resume.path, filename: "resume.pdf"),
      "coverLetter": await MultipartFile.fromFile(coverLetter.path,
          filename: "cover_letter.pdf"),
    });
    formData.fields.forEach((element) {
      log("Field: ${element.key} Value: ${element.value}");
    });
    formData.files.forEach((element) {
      log("File: ${element.key} Filename: ${element.value.filename}");
    });
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    try {
      var response = await dio.post(
        "$baseUrl/submit",
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
        data: formData,
      );
      log("*****************************");
      log(response.data);
      log("*****************************");

      if (response.statusCode == 201) {
        return JobApplication.fromJson(response.data);
      } else {
        print('Failed to submit application: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      if (e is DioError) {
        log('DioError Received: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        log('Non-DioError: $e');
      }
      return null;
    }
  }

  Future<List<JobApplication>> getApplicationsByUserId(int userId) async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/user/$userId'));
      log(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((model) => JobApplication.fromJson(model)).toList();
      } else {
        print('Failed to fetch applications: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error in getApplicationsByUserId: $e');
      return [];
    }
  }

  /// Helper function to convert a Map<String, dynamic> to a Map<String, String>
  Map<String, String> _stringifyMap(Map<String, dynamic> map) {
    return map.map((key, value) => MapEntry(key, value.toString()));
  }
}
