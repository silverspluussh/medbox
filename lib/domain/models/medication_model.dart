class MModel {
  int? id;
  String? medicinename;
  String? dose;
  String? medicinetype;
  String? image;

  MModel({
    this.id,
    this.dose,
    this.medicinename,
    this.medicinetype,
    this.image,
  });

  MModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 'none';
    medicinename = json['medicinename'] ?? 'none';
    dose = json['dose'] ?? 'none';
    medicinetype = json['medicinetype'] ?? 'none';
    image = json['image'] ?? 'none';
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
