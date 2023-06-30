typedef Pid = String;

class PharmacyModel {
  String? pharmacyname;
  Pid? pid;
  String? location;
  String? contact;

  PharmacyModel({this.pharmacyname, this.pid, this.location, this.contact});

  PharmacyModel.fromJson(Map<String, dynamic> json) {
    pharmacyname = json['pharmacyname'];
    pid = json['pid'];
    location = json['location'];
    contact = json['contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> inputdata = <String, dynamic>{};
    inputdata['pid'] = pid;
    inputdata['pharmacyname'] = pharmacyname;
    inputdata['location'] = location;
    inputdata['contact'] = contact;

    return inputdata;
  }
}
