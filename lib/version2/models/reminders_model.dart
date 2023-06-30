class RModel {
  int? id;
  String? medicinename;
  String? time;
  String? date;
  String? body;

  RModel({this.id, this.time, this.medicinename, this.date, this.body});

  RModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    body = json['body'];
    medicinename = json['medicinename'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> inputdata = <String, dynamic>{};
    inputdata['id'] = id;
    inputdata['body'] = body;
    inputdata['medicinename'] = medicinename;
    inputdata['time'] = time;
    inputdata['date'] = date;

    return inputdata;
  }
}
