class RapidtestModel {
  final bool? testresults;
  final String? results;
  final String? testname;
  final String? testdate;
  final String? patientcontact;

  RapidtestModel(
      {this.testresults,
      this.results,
      this.testname,
      this.testdate,
      this.patientcontact});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> inputdata = <String, dynamic>{};
    inputdata['id'] = testresults;
    inputdata['fname'] = results;
    inputdata['lname'] = testname;
    inputdata['dob'] = testdate;
    inputdata['patientcontact'] = patientcontact;

    return inputdata;
  }
}
