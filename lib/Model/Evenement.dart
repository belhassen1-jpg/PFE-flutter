import 'DemandeParticipationEvenement.dart';

class Evenement {
  int? id;
  String? titre;
  String? description;
  DateTime? dateHeure;
  String? lieu;
  int? partenaireId;
  List<DemandeParticipationEvenement>? demandeParticipations;

  Evenement({
    this.id,
    this.titre,
    this.description,
    this.dateHeure,
    this.lieu,
    this.partenaireId,
    this.demandeParticipations,
  });

  factory Evenement.fromJson(Map<String, dynamic> json) {
    var list = json['demandeParticipationevenments'] as List<dynamic>?;
    List<DemandeParticipationEvenement> demandes = list != null
        ? list.map((i) => DemandeParticipationEvenement.fromJson(i)).toList()
        : [];

    return Evenement(
      id: json['id'],
      titre: json['titre'],
      description: json['description'],
      dateHeure:
          json['dateHeure'] != null ? DateTime.parse(json['dateHeure']) : null,
      lieu: json['lieu'],
      partenaireId: json['partenaire_id'],
      demandeParticipations: demandes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'dateHeure': dateHeure?.toIso8601String(),
      'lieu': lieu,
      'partenaire_id': partenaireId,
      'demandeParticipationevenments':
          demandeParticipations?.map((x) => x.toJson()).toList(),
    };
  }
}
