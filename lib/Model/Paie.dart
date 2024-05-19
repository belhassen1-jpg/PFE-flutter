import 'package:erp_mob/Model/Employe.dart';
import 'package:intl/intl.dart';

class Paie {
  int? id;
  DateTime? datePaie;
  double? tauxHoraire;
  double? heuresTravaillees;
  double? heuresSupplementaires;
  double? tauxHeuresSupplementaires;
  double? montantPrimes;
  double? montantDeductions;
  double? cotisationsSociales;
  double? impotSurRevenu;
  double? salaireNet;
  double? salaireBrut;
  Employe? employe;

  Paie({
    this.id,
    this.datePaie,
    this.tauxHoraire,
    this.heuresTravaillees,
    this.heuresSupplementaires,
    this.tauxHeuresSupplementaires,
    this.montantPrimes,
    this.montantDeductions,
    this.cotisationsSociales,
    this.impotSurRevenu,
    this.salaireNet,
    this.salaireBrut,
    this.employe,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'datePaie': datePaie != null ? DateFormat('yyyy-MM-dd').format(datePaie!) : null,
      'tauxHoraire': tauxHoraire,
      'heuresTravaillees': heuresTravaillees,
      'heuresSupplementaires': heuresSupplementaires,
      'tauxHeuresSupplementaires': tauxHeuresSupplementaires,
      'montantPrimes': montantPrimes,
      'montantDeductions': montantDeductions,
      'cotisationsSociales': cotisationsSociales,
      'impotSurRevenu': impotSurRevenu,
      'salaireNet': salaireNet,
      'salaireBrut': salaireBrut,
      'employe': employe?.toJson(),
    };
  }
}