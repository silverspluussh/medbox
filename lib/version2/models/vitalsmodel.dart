class VModel {
  String? vid;
  String? bp;
  String? hr;
  String? temp;
  String? br;
  String? bmi;
  String? weight;
  String? date;

  VModel(
      {this.bmi,
      this.bp,
      this.hr,
      this.temp,
      this.br,
      this.date,
      this.vid,
      this.weight});

  VModel.fromJson(Map<String, dynamic> json, {required String tid}) {
    br = json['breathRate'];
    bp = json['bloodPressure'];
    hr = json['heartRate'];
    temp = json['temp'];
    bmi = json['bmi'];
    weight = json['weight'];
    date = json['createdAt'];
    vid = tid;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = date;
    data['bloodPressure'] = bp;
    data['breathRate'] = br;
    data['heartRate'] = hr;
    data['bmi'] = bmi;
    data['weight'] = weight;
    data['temp'] = temp;
    data["vid"] = vid;

    return data;
  }
}
