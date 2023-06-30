import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class Shareservice {
  Future<void> shareplus({paths, title, text}) async {
    var status = await Permission.storage.status;
    XFile filepath = XFile(paths);
    if (status.isDenied) {
      await Permission.storage.request();
    }

    await Share.shareXFiles(
      [filepath],
      text: text,
      subject: title,
    );
  }
}
