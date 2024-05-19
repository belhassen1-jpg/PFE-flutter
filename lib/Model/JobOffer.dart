import 'package:erp_mob/Model/JobApplication.dart';

class JobOffer {
  int? id;
  String? title;
  String? description;
  double? salary;
  String? location;
  int? requiredExperienceYears;
  String? projectDetails;
  String? category;
  List<JobApplication>? applications; // Liste des applications pour cette offre
  Set<String>? keywords; // Ensemble des mots-clés associés à l'offre

  JobOffer({
    this.id,
    this.title,
    this.description,
    this.salary,
    this.location,
    this.requiredExperienceYears,
    this.projectDetails,
    this.category,
    this.applications,
    this.keywords,
  });

  factory JobOffer.fromJson(Map<String, dynamic> json) {
    return JobOffer(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      salary: (json['salary'] as num?)?.toDouble(),
      location: json['location'] as String?,
      requiredExperienceYears: json['requiredExperienceYears'] as int?,
      projectDetails: json['projectDetails'] as String?,
      category: json['category'] as String?,
      applications: (json['applications'] as List<dynamic>?)
          ?.map((e) => JobApplication.fromJson(e as Map<String, dynamic>))
          .toList(),
      keywords:
          (json['keywords'] as List<dynamic>?)?.map((e) => e as String).toSet(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['salary'] = this.salary;
    data['location'] = this.location;
    data['requiredExperienceYears'] = this.requiredExperienceYears;
    data['projectDetails'] = this.projectDetails;
    data['category'] = this.category;
    if (this.applications != null) {
      data['applications'] = this.applications!.map((v) => v.toJson()).toList();
    }
    if (this.keywords != null) {
      data['keywords'] = this.keywords!.toList();
    }
    return data;
  }
}
