import 'DemandeParticipationConvention.dart';

class Convention {
  int? id;
  String? nom;
  String? objet;
  DateTime? dateDebut;
  DateTime? dateFin;
  int? partenaireId;
  List<DemandeParticipationConvention>? demandeParticipationConventions;

  Convention({
    this.id,
    this.nom,
    this.objet,
    this.dateDebut,
    this.dateFin,
    this.partenaireId,
    this.demandeParticipationConventions,
  });

  factory Convention.fromJson(Map<String, dynamic> json) {
    var list = json['demandeParticipationConventions'] as List<dynamic>?;
    List<DemandeParticipationConvention> demandes = list != null
        ? list.map((i) => DemandeParticipationConvention.fromJson(i)).toList()
        : [];

    return Convention(
      id: json['id'],
      nom: json['nom'],
      objet: json['objet'],
      dateDebut:
          json['dateDebut'] != null ? DateTime.parse(json['dateDebut']) : null,
      dateFin: json['dateFin'] != null ? DateTime.parse(json['dateFin']) : null,
      partenaireId: json['partenaire_id'],
      demandeParticipationConventions: demandes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'objet': objet,
      'dateDebut': dateDebut?.toIso8601String(),
      'dateFin': dateFin?.toIso8601String(),
      'partenaire_id': partenaireId,
      'demandeParticipationConventions':
          demandeParticipationConventions?.map((x) => x.toJson()).toList(),
    };
  }
}
