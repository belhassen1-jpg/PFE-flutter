import 'package:erp_mob/Model/Planning.dart';

class FeuilleTemps {
  int? id;
  DateTime? jour;
  DateTime? heureDebut;
  DateTime? heureFin;
  bool? estApprouve;
  int? planningId;
  String? planningName;

  FeuilleTemps(
      {this.id,
      this.jour,
      this.heureDebut,
      this.heureFin,
      this.estApprouve,
      this.planningId,
      this.planningName});

  factory FeuilleTemps.fromJson(Map<String, dynamic> json) {
    return FeuilleTemps(
      id: json['id'],
      jour: json['jour'] != null ? _parseDate(json['jour']) : null,
      heureDebut:
          json['heureDebut'] != null ? _parseTime(json['heureDebut']) : null,
      heureFin: json['heureFin'] != null ? _parseTime(json['heureFin']) : null,
      estApprouve: json['estApprouve'],
      planningId: json['planning'] != null ? json['planning']['id'] : null,
      planningName:
          json['planning'] != null ? json['planning']['nomProjet'] : null,
    );
  }

  static DateTime? _parseDate(String? dateString) {
    if (dateString == null) return null;
    // Custom date parsing logic based on your backend format
    return DateTime.tryParse(dateString);
  }

  static DateTime? _parseTime(String? timeString) {
    if (timeString == null) return null;
    // Custom time parsing logic based on your backend format
    return DateTime.tryParse(
        '2000-01-01 $timeString'); // Assuming date part is not provided
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['jour'] = this.jour?.toIso8601String();
    data['heureDebut'] = this.heureDebut?.toIso8601String();
    data['heureFin'] = this.heureFin?.toIso8601String();
    data['estApprouve'] = this.estApprouve;
    data['planningId'] = this.planningId;
    data["planningName"] = this.planningName;
    return data;
  }
}
