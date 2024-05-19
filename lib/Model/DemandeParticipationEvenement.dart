class DemandeParticipationEvenement {
  int? id;
  bool? estValidee;
  int? employeId;
  int? evenementId;

  DemandeParticipationEvenement({
    this.id,
    this.estValidee,
    this.employeId,
    this.evenementId,
  });

  factory DemandeParticipationEvenement.fromJson(Map<String, dynamic> json) {
    return DemandeParticipationEvenement(
      id: json['id'],
      estValidee: json['est_validee'],
      employeId: json['employe_id'],
      evenementId: json['evenement_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'est_validee': estValidee,
      'employe_id': employeId,
      'evenement_id': evenementId,
    };
  }
}
