class PharmacyModel {
  String pharmacyname;
  String whatsappid;
  String smsid;
  String pharmacyid;
  String location;
  String phonenumber;

  PharmacyModel(
      {this.pharmacyname,
      this.whatsappid,
      this.smsid,
      this.pharmacyid,
      this.location,
      this.phonenumber});

  PharmacyModel.fromJson(Map<String, dynamic> json) {
    pharmacyname = json['pharmacyname'];
    pharmacyid = json['pharmacyid'];
    smsid = json['smsid'];
    location = json['location'];
    whatsappid = json['whatsappid'];
    phonenumber = json['phonenumber'];
  }
}
