class ProfileModel {
  String? fullname;
  String? pNumber;
  String? pAge;
  String? deviceID;
  String? pType;
  String? conditionType;
  String? medicalDoc;
  String? pEmail;
  String? id;
  String? homeAddress;
  List<dynamic>? allergies;
  String? bloodGroup;
  String? dob;
  List<dynamic>? healthConditions;

  ProfileModel(
      {this.fullname,
      this.id,
      this.pEmail,
      this.homeAddress,
      this.allergies,
      this.bloodGroup,
      this.dob,
      this.healthConditions,
      this.conditionType,
      this.deviceID,
      this.medicalDoc,
      this.pAge,
      this.pNumber,
      this.pType});

  factory ProfileModel.fromJson(Map<String, dynamic> json,
      {required String tid}) {
    final fullname = json['fullname'] ?? 'Not set';
    final email = json['email'] ?? 'Not set';
    final homeAddress = json['homeAddress'] ?? 'Not set';
    final allergies = json['allergies'] ?? [];
    final bloodGroup = json['bloodGroup'] ?? 'Not set';
    final dob = json['dob'] ?? 'Not set';
    final healthConditions = json['healthConditions'] ?? [];

    return ProfileModel(
      fullname: fullname,
      pEmail: email,
      id: tid,
      homeAddress: homeAddress,
      allergies: allergies,
      bloodGroup: bloodGroup,
      dob: dob,
      healthConditions: healthConditions,
      conditionType: json["conditionType"] ?? 'Not set',
      deviceID: json["deviceID"] ?? 'Not set',
      medicalDoc: json["medicalDoc"] ?? 'Not set',
      pAge: json["pAge"] ?? 'Not set',
      pNumber: json["pNumber"] ?? 'Not set',
      pType: json["pType"] ?? 'Not set',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['healthConditions'] = healthConditions;
    json['pEmail'] = pEmail;
    json['allergies'] = allergies;
    json['dob'] = dob;
    json['bloodGroup'] = bloodGroup;
    json['fullname'] = fullname;
    json['homeAddress'] = homeAddress;
    json["keys"] = [id, pEmail, fullname, pAge, pNumber];
    json["medicalDoc"] = medicalDoc;
    json["deviceID"] = deviceID;
    json["pNumber"] = pNumber;
    json["pType"] = pType;
    json["pAge"] = pAge;
    json["conditionType"] = conditionType;

    return json;
  }
}
