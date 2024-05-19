class AnalyseFinanciere {
  int? id;
  String? resume;
  String? recommandations;
  DateTime? dateAnalyse;
  int? employeId;
  double? tauxEpargneMensuel; // Converted from BigDecimal to double
  double? depenseMoyenneMensuelle; // Converted from BigDecimal to double
  double? epargneMoyenneMensuelle; // Converted from BigDecimal to double

  AnalyseFinanciere({
    this.id,
    this.resume,
    this.recommandations,
    this.dateAnalyse,
    this.employeId,
    this.tauxEpargneMensuel,
    this.depenseMoyenneMensuelle,
    this.epargneMoyenneMensuelle,
  });

  factory AnalyseFinanciere.fromJson(Map<String, dynamic> json) {
    return AnalyseFinanciere(
      id: json['id'],
      resume: json['resume'],
      recommandations: json['recommandations'],
      dateAnalyse: json['dateAnalyse'] != null ? DateTime.parse(json['dateAnalyse']) : null,
      employeId: json['employe_id'],
      tauxEpargneMensuel: json['tauxEpargneMensuel']?.toDouble(),
      depenseMoyenneMensuelle: json['depenseMoyenneMensuelle']?.toDouble(),
      epargneMoyenneMensuelle: json['epargneMoyenneMensuelle']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resume': resume,
      'recommandations': recommandations,
      'dateAnalyse': dateAnalyse?.toIso8601String(),
      'employe_id': employeId,
      'tauxEpargneMensuel': tauxEpargneMensuel,
      'depenseMoyenneMensuelle': depenseMoyenneMensuelle,
      'epargneMoyenneMensuelle': epargneMoyenneMensuelle,
    };
  }
}
