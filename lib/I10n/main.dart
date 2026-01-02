import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../app/app.dart';
import '../core/constants/hive_table_constants.dart';
import '../features/auth/domain/data/models/auth_hive_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Init Hive
  await Hive.initFlutter();

  // ✅ Register adapter (typeId must match)
  if (!Hive.isAdapterRegistered(HiveTableConstants.authTypeId)) {
    Hive.registerAdapter(AuthHiveModelAdapter());
  }

  // ✅ Open box (THIS FIXES "Box not found")
  await Hive.openBox<AuthHiveModel>(HiveTableConstants.authBox);

  runApp(const App());
}
