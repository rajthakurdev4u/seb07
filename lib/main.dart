import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ATESTS/authentication/ALogin.dart';
import 'ATESTS/other/AGlobalVariables.dart';
import 'ATESTS/screens/ACountries.dart';
import 'ATESTS/provider/AUserProvider.dart';
import 'ATESTS/responsive/AMobileScreenLayout.dart';
import 'ATESTS/authentication/ALogin.dart';
import 'ATESTS/responsive/AMobileScreenLayout.dart';
import 'ATESTS/responsive/AResponsiveLayout.dart';
import 'ATESTS/responsive/AWebScreenLayout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.black),
            hintStyle: TextStyle(color: Colors.grey),
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 236, 234, 234),
        ),
        home: const ResponsiveLayout(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        ),
      ),
    );
  }
}
