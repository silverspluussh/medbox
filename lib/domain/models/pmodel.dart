import 'dart:math';

class PModel {
  int? id;
  String? fname;
  String? lname;
  String? dob;
  String? email;
  String? username;

  PModel({
    this.id,
    this.dob,
    this.email,
    this.fname,
    this.lname,
    this.username,
  });

  PModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? Random().nextInt(200);
    fname = json['fname'];
    lname = json['lname'];
    dob = json['dob'];
    email = json['email'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> inputdata = <String, dynamic>{};
    inputdata['id'] = id;
    inputdata['fname'] = fname;
    inputdata['lname'] = lname;
    inputdata['dob'] = dob;
    inputdata['email'] = email;
    inputdata['username'] = username;

    return inputdata;
  }
}
