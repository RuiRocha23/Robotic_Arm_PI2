import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

late final SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'NEEEICUM Admin',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          brightness: Brightness.light,
          backgroundColor: Colors.white),
      home: const HomePage(),
    );
  }
}
