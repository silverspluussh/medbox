class RapidtestModel {
  String? tid;
  bool? testresult;
  String? results;
  String? testtype;
  String? testdate;
  String? pharmacy;

  RapidtestModel({
    this.testresult,
    this.tid,
    this.results,
    this.testtype,
    this.testdate,
    this.pharmacy,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> inputdata = <String, dynamic>{};
    inputdata['testresults'] = testresult;
    inputdata['results'] = results;
    inputdata['testtype'] = testtype;
    inputdata['testdate'] = testdate;
    inputdata['pharmacy'] = pharmacy;

    return inputdata;
  }

  RapidtestModel.fromJson(Map<String, dynamic> json, {required String tid}) {
    testresult = json['testresults'];
    tid = tid;
    results = json['results'];
    testtype = json['testtype'];
    testdate = json['testdate'];
    pharmacy = json['pharmacy'];
  }
}
