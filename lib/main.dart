import 'package:fe_capstone/ui/ChatScreen.dart';
import 'package:fe_capstone/ui/CustomerUI/BottomTabNavCustomer.dart';
import 'package:fe_capstone/ui/CustomerUI/LocationScreen.dart';
import 'package:fe_capstone/ui/CustomerUI/HomeScreen.dart';
import 'package:fe_capstone/ui/CustomerUI/contract/ContractScreen.dart';
import 'package:fe_capstone/ui/CustomerUI/home/HomeScreen1.dart';
import 'package:fe_capstone/ui/CustomerUI/VechicleScreen.dart';
import 'package:fe_capstone/ui/CustomerUI/WalletScreen.dart';
import 'package:fe_capstone/ui/CustomerUI/parking-management/ListParkingScreen.dart';
import 'package:fe_capstone/ui/PLOwnerUI/BottomTabNavPlo.dart';
import 'package:fe_capstone/ui/PLOwnerUI/ContractExpiredScreen.dart';
import 'package:fe_capstone/ui/PLOwnerUI/PloChatScreen.dart';
import 'package:fe_capstone/ui/PLOwnerUI/PloHomeScreen.dart';
import 'package:fe_capstone/ui/screens/LoginScreen.dart';
import 'package:fe_capstone/ui/screens/LoginScreen1.dart';
import 'package:fe_capstone/ui/screens/RegisterScreen.dart';
import 'package:fe_capstone/ui/screens/RegisterScreen1.dart';
import 'package:fe_capstone/ui/screens/WelcomeScreen.dart';
import 'package:flutter/material.dart';

late Size mq;
late double fem;
late double ffem;

void main() {
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
      title: 'Capstone Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xFF6EC2F7)),
      // home: WelcomeScreen(),
      home: ListParkingScreen(),
      // home: RegisterScreen1(),
      // home: ContractScreen(),
      // home: HomeScreen1(),
    );
  }
}
