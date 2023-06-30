class ProfileModel {
  String? fullname;
  String? email;
  String? id;
  String? homeAddress;
  List<dynamic>? allergies;
  String? bloodGroup;
  String? dob;
  List<dynamic>? healthConditions;

  ProfileModel(
      {this.fullname,
      this.id,
      this.email,
      this.homeAddress,
      this.allergies,
      this.bloodGroup,
      this.dob,
      this.healthConditions});

  factory ProfileModel.fromJson(Map<String, dynamic> json,
      {required String tid}) {
    final fullname = json['fullname'];
    final email = json['email'];
    final homeAddress = json['homeAddress'];
    final allergies = json['allergies'];
    final bloodGroup = json['bloodGroup'];
    final dob = json['dob'];
    final healthConditions = json['healthConditions'];

    return ProfileModel(
        fullname: fullname,
        email: email,
        id: tid,
        homeAddress: homeAddress,
        allergies: allergies,
        bloodGroup: bloodGroup,
        dob: dob,
        healthConditions: healthConditions);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['healthConditions'] = healthConditions;
    json['email'] = email;
    json['allergies'] = allergies;
    json['dob'] = dob;
    json['bloodGroup'] = bloodGroup;
    json['fullname'] = fullname;
    json['homeAddress'] = homeAddress;

    return json;
  }
}
