import 'package:flutter/material.dart';
import 'package:quick_menu/app/app.dart';
import 'package:quick_menu/core/services/hive_init.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveInit.init();

  runApp(const App());
}
