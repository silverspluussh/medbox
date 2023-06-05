class VModel {
  int? id;
  String? bloodpressure;
  String? oxygenlevel;
  String? heartrate;
  String? temperature;
  String? respiration;
  String? datetime;

  VModel({
    this.id,
    this.bloodpressure,
    this.oxygenlevel,
    this.temperature,
    this.heartrate,
    this.respiration,
    this.datetime,
  });

  VModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    temperature = json['temperature'];
    bloodpressure = json['bloodpressure'];
    heartrate = json['heartrate'];
    oxygenlevel = json['oxygenlevel'];
    datetime = json['day'];
    respiration = json['respiration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> inputdata = <String, dynamic>{};
    inputdata['id'] = id;
    inputdata['oxygenlevel'] = oxygenlevel;
    inputdata['bloodpressure'] = bloodpressure;
    inputdata['heartrate'] = heartrate;
    inputdata['temperature'] = temperature;
    inputdata['respiration'] = respiration;
    inputdata['day'] = datetime;

    return inputdata;
  }
}
