class User {
  int? id;
  String? username;
  String? password;
  String? email;
  String? firstName;
  String? lastName;
  String? address;
  DateTime? birthDate;
  int? phone;
  int? cin;
  int? isVerified;
  String? verificationToken;
  String? verificationCode;
  int? age;
  DateTime? createdAt;
  String? preferencesCategory;
  String? preferencesLocation;
  String? userJob;

  User({
    this.id,
    this.username,
    this.password,
    this.email,
    this.firstName,
    this.lastName,
    this.address,
    this.birthDate,
    this.phone,
    this.cin,
    this.isVerified,
    this.verificationToken,
    this.verificationCode,
    this.age,
    this.createdAt,
    this.preferencesCategory,
    this.preferencesLocation,
    this.userJob,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['idUser'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    address = json['address'];
    birthDate =
        json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null;
    phone = json['phone'];
    cin = json['cin'];
    isVerified = json['isVerified'];
    verificationToken = json['verificationToken'];
    verificationCode = json['verificationCode'];
    age = json['age'];
    createdAt =
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    preferencesCategory = json['preferencesCategory'];
    preferencesLocation = json['preferencesLocation'];
    userJob = json['userJob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['password'] = this.password;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['address'] = this.address;
    data['birthDate'] = this.birthDate?.toIso8601String();
    data['phone'] = this.phone;
    data['cin'] = this.cin;
    data['isVerified'] = this.isVerified;
    data['verificationToken'] = this.verificationToken;
    data['verificationCode'] = this.verificationCode;
    data['age'] = this.age;
    data['createdAt'] = this.createdAt?.toIso8601String();
    data['preferencesCategory'] = this.preferencesCategory;
    data['preferencesLocation'] = this.preferencesLocation;
    data['userJob'] = this.userJob;
    return data;
  }
}
