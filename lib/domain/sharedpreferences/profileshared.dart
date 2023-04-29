import 'package:MedBox/main.dart';

class SharedCli {
  Future<bool> username({required value}) => prefs.setString('username', value);
  Future<bool> lastname({required value}) => prefs.setString('lastname', value);
  Future<bool> firstname({required value}) =>
      prefs.setString('firstname', value);
  Future<bool> email({required value}) => prefs.setString('email', value);
  Future<bool> contact({required value}) => prefs.setString('contact', value);
  Future<bool> dob({required value}) => prefs.setString('dob', value);

  //
  //

  String? getusername() => prefs.getString('username');
  String? getlname() => prefs.getString('lastname');
  String? getfname() => prefs.getString('firstname');
  String? getemail() => prefs.getString('email');
  String? getcontact() => prefs.getString('contact');
  String? getdob() => prefs.getString('dob');

  //
  Future<bool> setgpfp({required value}) => prefs.setString('gpfp', value);
  String? getgpfp() => prefs.getString('gpfp');
  //
  Future<bool> setpfp({required value}) => prefs.setString('pfp', value);
  String? getpfp() => prefs.getString('pfp');
  //
  //
  Future<bool> setgmailstatus({required value}) =>
      prefs.setBool('googleloggedin', value);
  bool? getgmailstatus() => prefs.getBool('googleloggedin');

  //

  String? getemoji() => prefs.getString('emotion');
  Future<bool> setemo({required value}) => prefs.setString('emotion', value);
}
