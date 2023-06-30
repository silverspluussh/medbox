import 'package:MedBox/main.dart';

class SharedCli {
  Future<bool> setgpfp({value}) => prefs.setString('gpfp', value);
  String? getgpfp() => prefs.getString('gpfp')!;
  //

  Future<bool> setgmailstatus({value}) =>
      prefs.setBool('googleloggedin', value);
  bool? getgmailstatus() => prefs.getBool('googleloggedin');

  //

  String? getemoji() => prefs.getString('emotion');
  Future<bool> setemo({value}) => prefs.setString('emotion', value);

  //

  Future<bool> setuserID({value}) => prefs.setString('userID', value);
  String? getuserID() => prefs.getString('userID');

  //
  Future<bool> tourstatus({bool? value}) => prefs.setBool('tour', value!);
  bool tourbool() => prefs.getBool('tour') ?? false;
}
