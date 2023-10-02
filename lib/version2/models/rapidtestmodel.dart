class RapidtestModel {
  String? tid;
  String? testkitname;
  String? testtime;
  String? testBill;
  String? testoutcome;
  String? testtype;
  String? testdate;
  String? pharmacyName;
  String? patientID;

  RapidtestModel(
      {this.testkitname,
      this.tid,
      this.testoutcome,
      this.testtype,
      this.testdate,
      this.testtime,
      this.patientID,
      this.pharmacyName,
      this.testBill});

  RapidtestModel.fromJson(Map<String, dynamic> json, {required String tid}) {
    tid = tid;
    testtype = json['testtype'];
    testdate = json['testdate'];
    testBill = json['testbill'];
    testtime = json['testtime'];
    testoutcome = json['testoutcome'];
    testtype = json['testtype'];
    patientID = json['patientID'];
    pharmacyName = json['pharmacyName'];
  }
}
