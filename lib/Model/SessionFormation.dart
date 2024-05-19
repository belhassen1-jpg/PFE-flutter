import 'Employe.dart';

class SessionFormation {
  int? id;
  String? intitule;
  String? description;
  DateTime? dateHeure;
  String? lieu;
  List<Employe>? participants;

  SessionFormation({
    this.id,
    this.intitule,
    this.description,
    this.dateHeure,
    this.lieu,
    this.participants,
  });

  factory SessionFormation.fromJson(Map<String, dynamic> json) {
    return SessionFormation(
      id: json['id'] as int?,
      intitule: json['intitule'] as String?,
      description: json['description'] as String?,
      dateHeure: json['dateHeure'] == null
          ? null
          : DateTime.parse(json['dateHeure'] as String),
      lieu: json['lieu'] as String?,
      participants: json['participants'] == null
          ? []
          : (json['participants'] as List)
              .map((e) => Employe.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['intitule'] = this.intitule;
    data['description'] = this.description;
    data['dateHeure'] = this.dateHeure?.toIso8601String();
    data['lieu'] = this.lieu;
    if (this.participants != null) {
      data['participants'] = this.participants!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}
