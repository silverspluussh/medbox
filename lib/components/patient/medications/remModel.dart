class RModel {
  int? id;
  String? medicinename;
  String? timeformat;
  String? setdate;
  bool? status;

  RModel({
    this.id,
    this.timeformat,
    this.medicinename,
    this.status,
    this.setdate,
  });

  RModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 'none';
    medicinename = json['medicinename'] ?? 'none';
    setdate = json['setdate'] ?? 'none';
    timeformat = json['timeformat'] ?? 'none';
    status = json['status'] ?? true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> inputdata = <String, dynamic>{};
    inputdata['id'] = id;
    inputdata['medicinename'] = medicinename;
    inputdata['timeformat'] = timeformat;
    inputdata['setdate'] = setdate;
    inputdata['status'] = status;

    return inputdata;
  }
}
