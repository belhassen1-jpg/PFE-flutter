import 'package:erp_mob/Model/FeuilleTemps.dart';


class Planning {
  int? id;
  String? nomProjet;
  DateTime? dateDebutValidite;
  DateTime? dateFinValidite;
  List<FeuilleTemps>? feuillesDeTemps;
  List<int>? employesAffectesIds; 

  Planning({
    this.id,
    this.nomProjet,
    this.dateDebutValidite,
    this.dateFinValidite,
    this.feuillesDeTemps,
    this.employesAffectesIds,
  });

  factory Planning.fromJson(Map<String, dynamic> json) {
    return Planning(
      id: json['id'],
      nomProjet: json['nomProjet'],
      dateDebutValidite: json['dateDebutValidite'] != null
          ? DateTime.parse(json['dateDebutValidite'])
          : null,
      dateFinValidite: json['dateFinValidite'] != null
          ? DateTime.parse(json['dateFinValidite'])
          : null,
      feuillesDeTemps: json['feuillesDeTemps'] != null
          ? List<FeuilleTemps>.from(json['feuillesDeTemps'].map((x) => FeuilleTemps.fromJson(x)))
          : null,
      employesAffectesIds: json['employesAffectesIds'] != null
          ? List<int>.from(json['employesAffectesIds'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['nomProjet'] = this.nomProjet;
    data['dateDebutValidite'] = this.dateDebutValidite?.toIso8601String();
    data['dateFinValidite'] = this.dateFinValidite?.toIso8601String();
    data['feuillesDeTemps'] = this.feuillesDeTemps?.map((x) => x.toJson()).toList();
    data['employesAffectesIds'] = this.employesAffectesIds;
    return data;
  }
}
