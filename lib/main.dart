import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_to_text_project_fyp/Screens/home_screen.dart';
import 'package:image_to_text_project_fyp/Screens/splash_screen.dart';
import 'package:image_to_text_project_fyp/firebase_options.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
