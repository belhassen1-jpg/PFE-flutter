import 'package:erp_mob/Model/Conge.dart';
import 'package:erp_mob/Model/JobOffer.dart';  

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

// JobApplication class with JobOffer included
class JobApplication {
  int? id;
  String? applicantName;
  String? applicantEmail;
  int? applicantPhone;
  String? applicantAddress;
  int? yearsOfExperience;
  String? resumePath;
  String? coverLetterPath;
  StatutDemande? status;
  JobOffer? jobOffer;  // Added JobOffer object
  int? applicantId;

  JobApplication({
    this.id,
    this.applicantName,
    this.applicantEmail,
    this.applicantPhone,
    this.applicantAddress,
    this.yearsOfExperience,
    this.resumePath,
    this.coverLetterPath,
    this.status,
    this.jobOffer,  // Added JobOffer to constructor
    this.applicantId,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'] as int?,
      applicantName: json['applicantName'] as String?,
      applicantEmail: json['applicantEmail'] as String?,
      applicantPhone: json['applicantPhone'] as int?,
      applicantAddress: json['applicantAddress'] as String?,
      yearsOfExperience: json['yearsOfExperience'] as int?,
      resumePath: json['resumePath'] as String?,
      coverLetterPath: json['coverLetterPath'] as String?,
      status: json['status'] != null ? getStatutDemandeFromString(json['status'] as String) : null,
      jobOffer: json['jobOffer'] != null ? JobOffer.fromJson(json['jobOffer']) : null,  // Parse JobOffer from JSON
      applicantId: json['applicantId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['applicantName'] = this.applicantName;
    data['applicantEmail'] = this.applicantEmail;
    data['applicantPhone'] = this.applicantPhone;
    data['applicantAddress'] = this.applicantAddress;
    data['yearsOfExperience'] = this.yearsOfExperience;
    data['resumePath'] = this.resumePath;
    data['coverLetterPath'] = this.coverLetterPath;
    data['status'] = this.status != null ? getStringFromStatutDemande(this.status!) : null;
    data['jobOffer'] = this.jobOffer != null ? this.jobOffer!.toJson() : null;  // Serialize JobOffer to JSON
    data['applicantId'] = this.applicantId;
    return data;
  }
}

// Make sure the JobOffer class is also equipped with fromJson and toJson methods
