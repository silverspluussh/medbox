class RapidtestModel {
  final bool? testresults;
  final String? results;
  final String? testname;
  final String? testdate;

  RapidtestModel(
      {this.testresults, this.results, this.testname, this.testdate});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> inputdata = <String, dynamic>{};
    inputdata['id'] = testresults;
    inputdata['fname'] = results;
    inputdata['lname'] = testname;
    inputdata['dob'] = testdate;

    return inputdata;
  }
}
