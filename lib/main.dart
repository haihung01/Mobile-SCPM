import 'package:fe_capstone/firebase_msg.dart';
import 'package:fe_capstone/firebase_options.dart';
import 'package:fe_capstone/ui/CustomerUI/home/HomeScreen1.dart';
import 'package:fe_capstone/ui/ChatScreen.dart'; // Import màn hình cần điều hướng
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

late Size mq;
late double fem;
late double ffem;

// Khởi tạo NavigatorKey để điều hướng
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  final firebaseMsg = FirebaseMsg();
  await firebaseMsg.initFCM();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    mq = MediaQuery.of(context).size;
    fem = mq.width / baseWidth;
    ffem = fem * 0.87;
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Capstone Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xFF6EC2F7)),
      home: HomeScreen1(),
      // home: ListParkingScreen(),
      // home: RegisterScreen1(),
      // home: ContractScreen(),
      // home: HomeScreen1(),
    );
  }
}
