import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: FirebaseOptions(
     

#firebase options
#firebase options
#firebase options
#firebase options
#firebase options
#firebase options




    ),
  );
  print("Firebase initialized successfully");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}
