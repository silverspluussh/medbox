class MModel {
  int id;
  String medicinename;
  String dose;
  String medicinetype;
  String image;

  MModel({
    this.id,
    this.dose,
    this.medicinename,
    this.medicinetype,
    this.image,
  });

  MModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    medicinename = json['medicinename'];
    dose = json['dose'];
    medicinetype = json['medicinetype'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> inputdata = <String, dynamic>{};
    inputdata['id'] = id;
    inputdata['medicinename'] = medicinename;
    inputdata['dose'] = dose;
    inputdata['image'] = image;
    inputdata['medicinetype'] = medicinetype;

    return inputdata;
  }
}
