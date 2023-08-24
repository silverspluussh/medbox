import 'package:MedBox/main.dart';

class SharedCli {
  Future<bool> setuserID({value}) => prefs.setString('userID', value);
  String? getuserID() => prefs.getString('userID');

  //
  Future<bool> tourstatus({bool? value}) => prefs.setBool('tour', value!);
  bool tourbool() => prefs.getBool('tour') ?? false;
}
