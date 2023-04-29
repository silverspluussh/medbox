class PModel {
  String? fname;
  String? lname;
  String? dob;
  String? email;
  String? username;

  PModel({
    this.dob,
    this.email,
    this.fname,
    this.lname,
    this.username,
  });

  PModel.fromJson(Map<String, dynamic> json) {
    fname = json['fname'];
    lname = json['lname'];
    dob = json['dob'];
    email = json['email'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> inputdata = <String, dynamic>{};
    inputdata['fname'] = fname;
    inputdata['lname'] = lname;
    inputdata['dob'] = dob;
    inputdata['email'] = email;
    inputdata['username'] = username;

    return inputdata;
  }
}
