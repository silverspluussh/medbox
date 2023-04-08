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

  VModel(
      {this.id,
      this.bloodpressure,
      this.oxygenlevel,
      this.temperature,
      this.heartrate,
      this.bmi,
      this.weight,
      this.respiration,
      this.height});

  VModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '0';
    temperature = json['temperature'] ?? '0';
    bloodpressure = json['bloodpressure'] ?? '0';
    heartrate = json['heartrate'] ?? '0';
    oxygenlevel = json['oxygenlevel'] ?? '0';
    weight = json['weight'] ?? '0';
    bmi = json['bmi'] ?? '0';
    respiration = json['respiration'] ?? '0';
    height = json['height'] ?? '0';
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

    return inputdata;
  }
}
