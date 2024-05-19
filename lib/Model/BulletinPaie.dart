import 'package:erp_mob/Model/DeclarationFiscale.dart';
import 'package:erp_mob/Model/Employe.dart';
import 'package:erp_mob/Model/Paie.dart';
import 'package:erp_mob/Model/Rapport.dart';
import 'package:intl/intl.dart';

class BulletinPaie extends Paie {
  DateTime? dateEmission;
  DateTime? periodeDebut;
  DateTime? periodeFin;
  String? commentaire;
  String? nomEntreprise;
  String? adresseEntreprise;
  Rapport? rapport;
  DeclarationFiscale? declarationFiscale;

  BulletinPaie({
    int? id,
    DateTime? datePaie,
    double? tauxHoraire,
    double? heuresTravaillees,
    double? heuresSupplementaires,
    double? tauxHeuresSupplementaires,
    double? montantPrimes,
    double? montantDeductions,
    double? cotisationsSociales,
    double? impotSurRevenu,
    double? salaireNet,
    double? salaireBrut,
    Employe? employe,
    this.dateEmission,
    this.periodeDebut,
    this.periodeFin,
    this.commentaire,
    this.nomEntreprise,
    this.adresseEntreprise,
    this.rapport,
    this.declarationFiscale,
  }) : super(
          id: id,
          datePaie: datePaie,
          tauxHoraire: tauxHoraire,
          heuresTravaillees: heuresTravaillees,
          heuresSupplementaires: heuresSupplementaires,
          tauxHeuresSupplementaires: tauxHeuresSupplementaires,
          montantPrimes: montantPrimes,
          montantDeductions: montantDeductions,
          cotisationsSociales: cotisationsSociales,
          impotSurRevenu: impotSurRevenu,
          salaireNet: salaireNet,
          salaireBrut: salaireBrut,
          employe: employe,
        );

  factory BulletinPaie.fromJson(Map<String, dynamic> json) {
    return BulletinPaie(
      id: json['id'] as int?,
      datePaie: json['datePaie'] == null ? null : DateTime.parse(json['datePaie']),
      tauxHoraire: (json['tauxHoraire'] as num?)?.toDouble(),
      heuresTravaillees: (json['heuresTravaillees'] as num?)?.toDouble(),
      heuresSupplementaires: (json['heuresSupplementaires'] as num?)?.toDouble(),
      tauxHeuresSupplementaires: (json['tauxHeuresSupplementaires'] as num?)?.toDouble(),
      montantPrimes: (json['montantPrimes'] as num?)?.toDouble(),
      montantDeductions: (json['montantDeductions'] as num?)?.toDouble(),
      cotisationsSociales: (json['cotisationsSociales'] as num?)?.toDouble(),
      impotSurRevenu: (json['impotSurRevenu'] as num?)?.toDouble(),
      salaireNet: (json['salaireNet'] as num?)?.toDouble(),
      salaireBrut: (json['salaireBrut'] as num?)?.toDouble(),
      employe: json['employe'] == null ? null : Employe.fromJson(json['employe']),
      dateEmission: json['dateEmission'] == null ? null : DateTime.parse(json['dateEmission']),
      periodeDebut: json['periodeDebut'] == null ? null : DateTime.parse(json['periodeDebut']),
      periodeFin: json['periodeFin'] == null ? null : DateTime.parse(json['periodeFin']),
      commentaire: json['commentaire'] as String?,
      nomEntreprise: json['nomEntreprise'] as String?,
      adresseEntreprise: json['adresseEntreprise'] as String?,
      rapport: json['rapport'] == null ? null : Rapport.fromJson(json['rapport']),
      declarationFiscale: json['declarationFiscale'] == null ? null : DeclarationFiscale.fromJson(json['declarationFiscale']),
    );
  }
}
