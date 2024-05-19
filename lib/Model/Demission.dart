// Définition de l'énumération StatutDemande en Dart

import 'package:erp_mob/Model/Employe.dart';

enum StatutDemande {
  enAttente,
  approuvee,
  rejetee,
  acceptee,
  refusee,
}

// Fonction pour convertir une chaîne en une valeur énumérée
StatutDemande getStatutDemandeFromString(String statutStr) {
  switch (statutStr.toLowerCase()) {
    case 'en_attente':
      return StatutDemande.enAttente;
    case 'approuvee':
      return StatutDemande.approuvee;
    case 'rejetee':
      return StatutDemande.rejetee;
    case 'acceptee':
      return StatutDemande.acceptee;
    case 'refusee':
      return StatutDemande.refusee;
    default:
      throw Exception('Unknown status: $statutStr');
  }
}

// Fonction pour convertir une valeur énumérée en chaîne
String getStringFromStatutDemande(StatutDemande statut) {
  return statut.toString().split('.').last.toLowerCase();
}

class Demission {
  int? id;
  String? motif;
  StatutDemande? statut; 
  String? dateDemande;
  Employe? employe;

  Demission({
    this.id,
    this.motif,
    this.statut,
    this.dateDemande,
    this.employe,
  });

  // Constructeur pour la désérialisation à partir d'un objet JSON
  Demission.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    motif = json['motif'] as String?;
    statut = json['statut'] != null
        ? getStatutDemandeFromString(json['statut'] as String)
        : null;
    dateDemande = json['dateDemande'] as String?;
    employe = json['employe'] != null
        ? Employe.fromJson(json['employe'] as Map<String, dynamic>)
        : null;
  }

  // Méthode pour convertir l'instance en un objet JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['motif'] = this.motif;
    data['statut'] = this.statut != null
        ? getStringFromStatutDemande(this.statut!)
        : null; // Conversion de l'énumération en chaîne
    data['dateDemande'] = this.dateDemande;
    if (this.employe != null) {
      data['employe'] = this.employe!.toJson();
    }
    return data;
  }
}
