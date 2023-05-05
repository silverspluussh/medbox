class RapidtestModel {
  List<bool> testresults;
  List<String> results;
  List<String> testname;
  List<String> testdate;
  List<String> patientcontact;

  RapidtestModel(
      {this.testresults,
      this.results,
      this.testname,
      this.testdate,
      this.patientcontact});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> inputdata = <String, dynamic>{};
    inputdata['testresults'] = testresults;
    inputdata['fname'] = results;
    inputdata['lname'] = testname;
    inputdata['dob'] = testdate;
    inputdata['patientcontact'] = patientcontact;

    return inputdata;
  }

  RapidtestModel.fromJson(Map<String, dynamic> json) {
    testresults = json['testresults'] ?? 'none';
    patientcontact = json['patientcontact'] ?? 'none';
    results = json['results'] ?? 'none';
    testname = json['testdate'] ?? 'none';
    testdate = json['testdate'] ?? true;
  }
}
