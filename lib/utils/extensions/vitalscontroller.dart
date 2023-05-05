import '../../data/repos/Dbhelpers/vitalsdb.dart';
import '../../domain/models/vitalsmodel.dart';

class VController {
  Future<int> addvital({VModel vModel}) async {
    return await VitalsDB().insertvitals(vModel);
  }
}
