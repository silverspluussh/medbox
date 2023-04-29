class PharmacyModel {
  String? pharmacyname;
  String? whatsappid;
  String? smsid;
  String? pharmacyid;
  String? location;
  String? phonenumber;

  PharmacyModel(
      {this.pharmacyname,
      this.whatsappid,
      this.smsid,
      this.pharmacyid,
      this.location,
      this.phonenumber});

  PharmacyModel.fromJson(Map<String, dynamic> json) {
    pharmacyname = json['fname'];
    pharmacyid = json['lname'];
    smsid = json['dob'];
    location = json['email'];
    whatsappid = json['email'];
    phonenumber = json['email'];
  }
}
