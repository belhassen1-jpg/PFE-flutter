class ApplicationDto {
  final int? jobOfferId;
  final int? userId;
  final String? applicantName;
  final String? applicantEmail;
  final int? applicantPhone;
  final String? applicantAddress;
  final int? yearsOfExperience;
  final String? resumePath;
  final String? coverLetterPath;
  final String? status; // Assuming status is a string representation of the status enum


  ApplicationDto({
    this.jobOfferId,
    this.userId,
    this.applicantName,
    this.applicantEmail,
    this.applicantPhone,
    this.applicantAddress,
    this.yearsOfExperience,
    this.resumePath,
    this.coverLetterPath,
    this.status,
  });

  factory ApplicationDto.fromJson(Map<String, dynamic> json) {
    return ApplicationDto(
      jobOfferId: json['jobOfferId'],
      userId: json['userId'],
      applicantName: json['applicantName'],
      applicantEmail: json['applicantEmail'],
      applicantPhone: json['applicantPhone'],
      applicantAddress: json['applicantAddress'],
      yearsOfExperience: json['yearsOfExperience'],
      resumePath: json['resumePath'],
      coverLetterPath: json['coverLetterPath'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobOfferId': jobOfferId,
      'userId': userId,
      'applicantName': applicantName,
      'applicantEmail': applicantEmail,
      'applicantPhone': applicantPhone,
      'applicantAddress': applicantAddress,
      'yearsOfExperience': yearsOfExperience,
      'resumePath': resumePath,
      'coverLetterPath': coverLetterPath,
      'status': status,
    };
  }
}
