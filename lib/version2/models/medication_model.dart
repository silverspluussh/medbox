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
    final medicinename = json['medicinename'] ?? 'none';
    final dose = json['dose'] ?? 'none';
    final medicinetype = json['medicinetype'] ?? 'none';
    final image = json['image'] ?? 'none';

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
