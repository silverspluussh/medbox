typedef APID = String;

class ApModel {
  APID? aid;
  String? testtype;
  String? pharmacy;
  String? date;
  String? note;
  String? number;
  String? time;
  bool? status;

  ApModel(
      {this.aid,
      this.testtype,
      this.pharmacy,
      this.date,
      this.note,
      this.time,
      this.status,
      this.number});

  factory ApModel.fromJson(Map<String, dynamic> json, {required APID aid}) {
    final testtype = json['testtype'] ?? 'none';
    final p = json['pharmacy'] ?? 'none';
    final d = json['date'] ?? 'none';
    final n = json['note'] ?? 'none';
    final num = json['number'] ?? 'none';
    final t = json['time'] ?? 'none';
    final s = json['status'] ?? 'none';

    return ApModel(
        aid: aid,
        testtype: testtype,
        pharmacy: p,
        date: d,
        note: n,
        number: num,
        time: t,
        status: s);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> inputdata = <String, dynamic>{};
    inputdata['testtype'] = testtype;
    inputdata['pharmacy'] = pharmacy;
    inputdata['date'] = date;
    inputdata['note'] = note;
    inputdata['number'] = number;
    inputdata['time'] = time;
    inputdata['status'] = status;

    return inputdata;
  }
}
