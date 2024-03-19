import 'package:cheyyan/auth/auth_gate.dart';
import 'package:cheyyan/db/db_helper%20copy.dart';
import 'package:cheyyan/db/db_helper.dart';
import 'package:cheyyan/firebase_options.dart';
import 'package:cheyyan/services/theme_services.dart';
import 'package:cheyyan/ui/calander.dart';
import 'package:cheyyan/ui/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
  await DBHelper.initDB();
  await DBHelper2.initDB();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cheyyan',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeService().theme,
      theme: Themes.light,
      darkTheme: Themes.dark,
      home: const AuthGate(),
    );
  }
}
