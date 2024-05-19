class DemandeParticipationConvention {
  int? id;
  int? employeId;
  int? conventionId;
  bool estValidee;

  DemandeParticipationConvention({
    this.id,
    this.employeId,
    this.conventionId,
    this.estValidee = false, // Defaults to false
  });

  factory DemandeParticipationConvention.fromJson(Map<String, dynamic> json) {
    return DemandeParticipationConvention(
      id: json['id'],
      employeId: json['employe_id'],
      conventionId: json['convention_id'],
      estValidee:
          json['estValidee'] ?? false, // Ensure default to false if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employe_id': employeId,
      'convention_id': conventionId,
      'estValidee': estValidee,
    };
  }
}
