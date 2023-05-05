import 'package:MedBox/main.dart';

class SharedCli {
  Future<bool> username({value}) => prefs.setString('username', value);
  Future<bool> email({value}) => prefs.setString('email', value);
  Future<bool> contact({value}) => prefs.setString('contact', value);
  Future<bool> age({value}) => prefs.setString('age', value);
  Future<bool> address({value}) => prefs.setString('address', value);

  //
  //

  String getusername() => prefs.getString('username');
  String getemail() => prefs.getString('email');
  String getcontact() => prefs.getString('contact');
  String getage() => prefs.getString('age');
  String getaddress() => prefs.getString('address');

  //
  Future<bool> setgpfp({value}) => prefs.setString('gpfp', value);
  String getgpfp() => prefs.getString('gpfp');
  //

  Future<bool> setgmailstatus({value}) =>
      prefs.setBool('googleloggedin', value);
  bool getgmailstatus() => prefs.getBool('googleloggedin');

  //

  String getemoji() => prefs.getString('emotion');
  Future<bool> setemo({value}) => prefs.setString('emotion', value);

  //

  Future<bool> setuserID({value}) => prefs.setString('userID', value);
  String getuserID() => prefs.getString('userID');
  Future<bool> setheights({value}) => prefs.setString('height', value);
  Future<bool> setweight({value}) => prefs.setString('weight', value);
  Future<bool> setbmi({value}) => prefs.setString('bmi', value);

  String getheight() => prefs.getString('height');
  String getweight() => prefs.getString('weight');
  String getbmi() => prefs.getString('bmi');
}
