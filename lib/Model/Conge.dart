import 'package:erp_mob/Model/Employe.dart';
import 'package:intl/intl.dart';

enum TypeConge {
  ANNUEL,
  MALADIE,
  SANS_SOLDE,
}

TypeConge getTypeCongeFromString(String typeStr) {
  switch (typeStr) {
    case 'ANNUEL':
      return TypeConge.ANNUEL;
    case 'MALADIE':
      return TypeConge.MALADIE;
    case 'SANS_SOLDE':
      return TypeConge.SANS_SOLDE;
    default:
      throw Exception('Unknown type: $typeStr');
  }
}

String getStringFromTypeConge(TypeConge type) {
  return type.toString().split('.').last.toLowerCase();
}

enum StatutDemande {
  enAttente,
  approuvee,
  rejetee,
  acceptee,
  refusee,
}

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

String getStringFromStatutDemande(StatutDemande statut) {
  return statut.toString().split('.').last.toLowerCase();
}

class DemandeConge {
  int? id;
  DateTime? dateDebut;
  DateTime? dateFin;
  TypeConge? type;
  StatutDemande? statut;
  Employe? employe;

  DemandeConge({
    this.id,
    this.dateDebut,
    this.dateFin,
    this.type,
    this.statut,
    this.employe,
  });

  factory DemandeConge.fromJson(Map<String, dynamic> json) {
    return DemandeConge(
      id: json['id'] as int?,
      dateDebut:
          json['dateDebut'] == null ? null : DateTime.parse(json['dateDebut']),
      dateFin: json['dateFin'] == null ? null : DateTime.parse(json['dateFin']),
      type: json['type'] != null
          ? getTypeCongeFromString(json['type'] as String)
          : null,
      statut: json['statut'] != null
          ? getStatutDemandeFromString(json['statut'] as String)
          : null,
      employe: json['employe'] != null
          ? Employe.fromJson(json['employe'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateDebut': dateDebut != null
          ? DateFormat('yyyy-MM-dd').format(dateDebut!)
          : null,
      'dateFin':
          dateFin != null ? DateFormat('yyyy-MM-dd').format(dateFin!) : null,
      'type': type != null ? getStringFromTypeConge(type!) : null,
      'statut': statut != null ? getStringFromStatutDemande(statut!) : null,
      'employe': employe?.toJson(),
    };
  }
}
