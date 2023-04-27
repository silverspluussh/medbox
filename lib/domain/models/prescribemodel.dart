class PrescModel {
  int? id;
  String? title;
  String? fileimagepath;
  String? datetime;

  PrescModel({this.title, this.fileimagepath, this.datetime, this.id});

  PrescModel.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    fileimagepath = json["fileimagepath"];
    datetime = json["datetime"];
    id = json["id"];
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> tojson = <String, dynamic>{};
    tojson['title'] = title;
    tojson['id'] = id;
    tojson['datetime'] = datetime;
    tojson['fileimagepath'] = fileimagepath;
    return tojson;
  }
}
