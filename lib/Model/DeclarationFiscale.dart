import 'package:erp_mob/Model/BulletinPaie.dart';
import 'package:intl/intl.dart';

class DeclarationFiscale {
  int? id;
  DateTime? dateDeclaration;
  double? totalRevenuImposable;
  double? montantImpotDu;
  double? montantCotisationsSocialesDu;
  String? referenceDeclaration;
  String? autoriteFiscale;
  BulletinPaie? bulletinPaie;

  DeclarationFiscale({
    this.id,
    this.dateDeclaration,
    this.totalRevenuImposable,
    this.montantImpotDu,
    this.montantCotisationsSocialesDu,
    this.referenceDeclaration,
    this.autoriteFiscale,
    this.bulletinPaie,
  });

  factory DeclarationFiscale.fromJson(Map<String, dynamic> json) {
    return DeclarationFiscale(
      id: json['id'] as int?,
      dateDeclaration: json['dateDeclaration'] == null ? null : DateTime.parse(json['dateDeclaration']),
      totalRevenuImposable: (json['totalRevenuImposable'] as num?)?.toDouble(),
      montantImpotDu: (json['montantImpotDu'] as num?)?.toDouble(),
      montantCotisationsSocialesDu: (json['montantCotisationsSocialesDu'] as num?)?.toDouble(),
      referenceDeclaration: json['referenceDeclaration'] as String?,
      autoriteFiscale: json['autoriteFiscale'] as String?,
      bulletinPaie: json['bulletinPaie'] == null ? null : BulletinPaie.fromJson(json['bulletinPaie']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateDeclaration': dateDeclaration != null ? DateFormat('yyyy-MM-dd').format(dateDeclaration!) : null,
      'totalRevenuImposable': totalRevenuImposable,
      'montantImpotDu': montantImpotDu,
      'montantCotisationsSocialesDu': montantCotisationsSocialesDu,
      'referenceDeclaration': referenceDeclaration,
      'autoriteFiscale': autoriteFiscale,
      'bulletinPaie': bulletinPaie?.toJson(),
    };
  }
}
