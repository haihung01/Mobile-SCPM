import 'package:fe_capstone/firebase_msg.dart';
import 'package:fe_capstone/ui/screens/ForgotPasswordScreen.dart';
import 'package:fe_capstone/ui/screens/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:fe_capstone/service/data_service.dart';
import 'package:fe_capstone/ui/CustomerUI/home/HomeScreen1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen1 extends StatefulWidget {
  @override
  _LoginScreen1State createState() => _LoginScreen1State();
}

class _LoginScreen1State extends State<LoginScreen1> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final DataService _dataService = DataService();
  bool _obscurePassword = true;

  Future<void> _login() async {
    try {
      final customer = await _dataService.login(
        _usernameController.text,
        _passwordController.text,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // Lấy FCM token và đăng ký thiết bị
      final firebaseMsg = FirebaseMsg();
      String? token = await firebaseMsg.getDeviceToken();
      if (token != null) {
        await _dataService.registerDevice(token);
      } else {
        print('Không lấy được FCM token');
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen1()),
      );
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Lỗi"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Thử lại"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _showForgotPasswordDialog() async {
    _emailController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Quên mật khẩu"),
          content: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "Nhập email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                final email = _emailController.text.trim();
                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Vui lòng nhập email")),
                  );
                  return;
                }
                try {
                  await _dataService.forgotPassword(email);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Vui lòng kiểm tra lại email của bạn"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  final errorMessage = e.toString().replaceFirst('Exception: ', '');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text("Gửi"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "SCPM",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const Text(
                "Smart-Parking",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              SizedBox(height: 20),
              Image.network(
                'https://images.template.net/85586/free-car-parking-illustration-ql7jz.jpg',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Tên đăng nhập",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _showForgotPasswordDialog,
                    child: const Text(
                      "Quên mật khẩu ?",
                      style: TextStyle(color: Colors.green, fontSize: 14),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()),
                      );
                    },
                    child: const Text(
                      "Đăng ký",
                      style: TextStyle(color: Colors.green, fontSize: 14),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00A86B),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: _login,
                child: const Text(
                  "Đăng nhập",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}