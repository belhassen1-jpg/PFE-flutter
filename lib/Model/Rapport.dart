import 'package:erp_mob/Model/BulletinPaie.dart';
import 'package:erp_mob/Model/Employe.dart';
import 'package:intl/intl.dart';

class Rapport {
  int? id;
  Employe? employe;
  int? totalHeuresTravaillees;
  int? totalJoursConges;
  int? nombreFormationsParticipees;
  int? nombreEvenementsParticipes;
  String? evaluationPerformanceRecente;
  double? dernierSalaireBrut;
  double? dernierSalaireNet;
  DateTime? dateRapport;
  BulletinPaie? dernierBulletinPaie;

  Rapport({
    this.id,
    this.employe,
    this.totalHeuresTravaillees,
    this.totalJoursConges,
    this.nombreFormationsParticipees,
    this.nombreEvenementsParticipes,
    this.evaluationPerformanceRecente,
    this.dernierSalaireBrut,
    this.dernierSalaireNet,
    this.dateRapport,
    this.dernierBulletinPaie,
  });

  factory Rapport.fromJson(Map<String, dynamic> json) {
    return Rapport(
      id: json['id'] as int?,
      employe: json['employe'] == null ? null : Employe.fromJson(json['employe']),
      totalHeuresTravaillees: json['totalHeuresTravaillees'] as int?,
      totalJoursConges: json['totalJoursConges'] as int?,
      nombreFormationsParticipees: json['nombreFormationsParticipees'] as int?,
      nombreEvenementsParticipes: json['nombreEvenementsParticipes'] as int?,
      evaluationPerformanceRecente: json['evaluationPerformanceRecente'] as String?,
      dernierSalaireBrut: (json['dernierSalaireBrut'] as num?)?.toDouble(),
      dernierSalaireNet: (json['dernierSalaireNet'] as num?)?.toDouble(),
      dateRapport: json['dateRapport'] == null ? null : DateTime.parse(json['dateRapport']),
      dernierBulletinPaie: json['dernierBulletinPaie'] == null ? null : BulletinPaie.fromJson(json['dernierBulletinPaie']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employe': employe?.toJson(),
      'totalHeuresTravaillees': totalHeuresTravaillees,
      'totalJoursConges': totalJoursConges,
      'nombreFormationsParticipees': nombreFormationsParticipees,
      'nombreEvenementsParticipes': nombreEvenementsParticipes,
      'evaluationPerformanceRecente': evaluationPerformanceRecente,
      'dernierSalaireBrut': dernierSalaireBrut,
      'dernierSalaireNet': dernierSalaireNet,
      'dateRapport': dateRapport != null ? DateFormat('yyyy-MM-dd').format(dateRapport!) : null,
      'dernierBulletinPaie': dernierBulletinPaie?.toJson(),
    };
  }
}
