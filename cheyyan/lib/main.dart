import 'package:cheyyan/db/db_helper.dart';
import 'package:cheyyan/services/theme_services.dart';
import 'package:cheyyan/ui/calander.dart';
import 'package:cheyyan/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDB();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeService().theme,
      theme: Themes.light,
      darkTheme: Themes.dark,
      home: const HomePage(),
    );
  }
}
