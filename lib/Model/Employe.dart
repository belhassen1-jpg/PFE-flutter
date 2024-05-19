import 'package:intl/intl.dart';

class Employe {
  int? empId;
  String? firstName;
  String? lastName;
  DateTime? startDate;
  DateTime? endDate;
  String? title;
  double? tauxHoraire;
  double? tauxHeuresSupplementaires;
  double? montantPrimes;
  double? montantDeductions;

  Employe({
    this.empId,
    this.firstName,
    this.lastName,
    this.startDate,
    this.endDate,
    this.title,
    this.tauxHoraire,
    this.tauxHeuresSupplementaires,
    this.montantPrimes,
    this.montantDeductions,
  });

  // Factory constructor for creating a new Employe instance from a map. Use this when parsing JSON from an API or similar.
  factory Employe.fromJson(Map<String, dynamic> json) {
    return Employe(
      empId: json['empId'] as int?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      startDate:
          json['startDate'] == null ? null : DateTime.parse(json['startDate']),
      endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']),
      title: json['title'] as String?,
      tauxHoraire: (json['tauxHoraire'] as num?)?.toDouble(),
      tauxHeuresSupplementaires:
          (json['tauxHeuresSupplementaires'] as num?)?.toDouble(),
      montantPrimes: (json['montantPrimes'] as num?)?.toDouble(),
      montantDeductions: (json['montantDeductions'] as num?)?.toDouble(),
    );
  }

  // Method for converting the current instance of Employe to a map. Useful when encoding to JSON before sending to an API.
  Map<String, dynamic> toJson() {
    return {
      'empId': empId,
      'firstName': firstName,
      'lastName': lastName,
      'startDate': startDate != null
          ? DateFormat('yyyy-MM-dd').format(startDate!)
          : null,
      'endDate':
          endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : null,
      'title': title,
      'tauxHoraire': tauxHoraire,
      'tauxHeuresSupplementaires': tauxHeuresSupplementaires,
      'montantPrimes': montantPrimes,
      'montantDeductions': montantDeductions,
    };
  }
}
