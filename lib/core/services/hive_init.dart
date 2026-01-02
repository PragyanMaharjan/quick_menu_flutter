import 'package:hive_flutter/hive_flutter.dart';
import '../constants/hive_table_constants.dart';
import '../../features/auth/data/models/auth_hive_model.dart';

class HiveInit {
  HiveInit._();

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters (add more adapters here in future)
    if (!Hive.isAdapterRegistered(HiveTableConstants.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }

    // Open boxes (add more boxes here in future)
    await Hive.openBox<AuthHiveModel>(HiveTableConstants.authBox);
  }
}
