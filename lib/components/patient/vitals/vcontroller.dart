import '../../../artifacts/Dbhelpers/vitalsdb.dart';
import 'vitalsmodel.dart';

class VController {
  Future<int> addvital({VModel? vModel}) async {
    return await VitalsDB.insertvitals(vModel);
  }
}
