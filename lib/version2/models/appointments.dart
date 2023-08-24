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
  String createdAt;

  ApModel(
      {this.aid,
      this.testtype,
      this.pharmacy,
      this.date,
      this.note,
      this.time,
      required this.createdAt,
      this.status,
      this.number});

  factory ApModel.fromJson(Map<String, dynamic> json, {required APID aid}) {
    final testtype = json['testtype'];
    final p = json['pharmacy'];
    final d = json['date'];
    final n = json['note'];
    final num = json['number'];
    final t = json['time'];
    final s = json['status'];
    final ca = json['createdAt'];

    return ApModel(
        aid: aid,
        createdAt: ca,
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
