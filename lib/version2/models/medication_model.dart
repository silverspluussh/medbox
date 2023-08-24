typedef MedID = String;

class MModel {
  MedID? mid;
  String? medicinename;
  String? dose;
  String? medicinetype;
  String? image;

  MModel({
    this.mid,
    this.dose,
    this.medicinename,
    this.medicinetype,
    this.image,
  });

  factory MModel.fromJson(Map<String, dynamic> json, {required MedID mid}) {
    final medicinename = json['medicinename'];
    final dose = json['dose'];
    final medicinetype = json['medicinetype'];
    final image = json['image'];

    return MModel(
        mid: mid,
        dose: dose,
        image: image,
        medicinename: medicinename,
        medicinetype: medicinetype);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> inputdata = <String, dynamic>{};
    inputdata['medicinename'] = medicinename;
    inputdata['dose'] = dose;
    inputdata['image'] = image;
    inputdata['medicinetype'] = medicinetype;

    return inputdata;
  }
}
