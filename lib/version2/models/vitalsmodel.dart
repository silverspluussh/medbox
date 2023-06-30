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
    br = json['breathRate'] ?? '0';
    bp = json['bloodPressure'] ?? '0';
    hr = json['heartRate'] ?? '0';
    temp = json['temp'] ?? '0';
    bmi = json['bmi'] ?? '0';
    weight = json['weight'] ?? '0';
    date = json['date'];
    vid = tid;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date ?? '0';
    data['bloodPressure'] = bp ?? '0';
    data['breathRate'] = br ?? '0';
    data['heartRate'] = hr ?? '0';
    data['bmi'] = bmi ?? '0';
    data['weight'] = weight ?? '0';
    data['temp'] = temp ?? '0';

    return data;
  }
}
