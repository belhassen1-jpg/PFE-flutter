import 'package:intl/intl.dart';

class Depense {
  int? id;
  String? categorie;
  double? montant; // Converted from BigDecimal to double
  String? description;
  DateTime? dateDepense;
  int? employeId; // Assuming Employe ID is needed as an integer

  Depense({
    this.id,
    this.categorie,
    this.montant,
    this.description,
    this.dateDepense,
    this.employeId,
  });

  factory Depense.fromJson(Map<String, dynamic> json) {
    return Depense(
      id: json['id'],
      categorie: json['categorie'],
      montant: (json['montant'] as num?)?.toDouble(),
      description: json['description'],
      dateDepense: json['dateDepense'] != null ? DateTime.parse(json['dateDepense']) : null,
      employeId: json['employe_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categorie': categorie,
      'montant': montant,
      'description': description,
      'dateDepense': dateDepense?.toIso8601String(),
      'employe_id': employeId,
    };
  }
}
