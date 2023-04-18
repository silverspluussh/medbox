class VModel {
  int? id;
  String? bloodpressure;
  String? oxygenlevel;
  String? heartrate;
  String? temperature;
  String? bmi;
  String? weight;
  String? respiration;
  String? height;
  String? datetime;

  VModel(
      {this.id,
      this.bloodpressure,
      this.oxygenlevel,
      this.temperature,
      this.heartrate,
      this.bmi,
      this.weight,
      this.respiration,
      this.datetime,
      this.height});

  VModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    temperature = json['temperature'];
    bloodpressure = json['bloodpressure'];
    heartrate = json['heartrate'];
    oxygenlevel = json['oxygenlevel'];
    weight = json['weight'];
    bmi = json['bmi'];
    datetime = json['day'];
    respiration = json['respiration'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> inputdata = <String, dynamic>{};
    inputdata['id'] = id;
    inputdata['oxygenlevel'] = oxygenlevel;
    inputdata['bloodpressure'] = bloodpressure;
    inputdata['heartrate'] = heartrate;
    inputdata['temperature'] = temperature;
    inputdata['weight'] = weight;
    inputdata['bmi'] = bmi;
    inputdata['respiration'] = respiration;
    inputdata['height'] = height;
    inputdata['day'] = datetime;

    return inputdata;
  }
}
