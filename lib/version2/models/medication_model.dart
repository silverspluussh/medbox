typedef MedID = String;

class MModel {
  MedID? mid;
  MedID? did;

  String? medicinename;
  String? dose;
  String? medicinetype;
  String? image;

  MModel(
      {this.mid,
      this.dose,
      this.medicinename,
      this.medicinetype,
      this.image,
      this.did});

  factory MModel.fromJson(Map<String, dynamic> json, {required MedID mid}) {
    final medicinename = json['medicinename'];
    final dose = json['dose'];
    final medicinetype = json['medicinetype'];

    return MModel(
        mid: json['mid'],
        did: mid,
        dose: dose,
        image: json['image'],
        medicinename: medicinename,
        medicinetype: medicinetype);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> inputdata = <String, dynamic>{};
    inputdata['medicinename'] = medicinename;
    inputdata['dose'] = dose;
    inputdata['medicinetype'] = medicinetype;
    inputdata['mid'] = mid;
    inputdata["image"] = image;

    return inputdata;
  }
}
