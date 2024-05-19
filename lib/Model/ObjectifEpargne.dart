class ObjectifEpargne {
  int? id;
  double? objectifMontant; // Converted from BigDecimal to double
  double? montantActuel; // Converted from BigDecimal to double
  String? description;
  DateTime? dateDebut;
  DateTime? dateFin;
  int? employeId; // Assuming Employe ID is needed as an integer
  double? progression; // Representing as double to keep percentage calculation simpler

  ObjectifEpargne({
    this.id,
    this.objectifMontant,
    this.montantActuel,
    this.description,
    this.dateDebut,
    this.dateFin,
    this.employeId,
    this.progression,
  });

  factory ObjectifEpargne.fromJson(Map<String, dynamic> json) {
    return ObjectifEpargne(
      id: json['id'],
      objectifMontant: (json['objectifMontant'] as num?)?.toDouble(),
      montantActuel: (json['montantActuel'] as num?)?.toDouble(),
      description: json['description'],
      dateDebut: json['dateDebut'] != null ? DateTime.parse(json['dateDebut']) : null,
      dateFin: json['dateFin'] != null ? DateTime.parse(json['dateFin']) : null,
      employeId: json['employe_id'],
      progression: (json['progression'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'objectifMontant': objectifMontant,
      'montantActuel': montantActuel,
      'description': description,
      'dateDebut': dateDebut?.toIso8601String(),
      'dateFin': dateFin?.toIso8601String(),
      'employe_id': employeId,
      'progression': progression,
    };
  }
}
