import 'package:flutter/material.dart';
import 'LoginScreen1.dart'; // Import màn hình đăng nhập

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "SCPM",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const Text(
            "Smart-Parking",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(height: 20),
          Image.network(
            'https://images.template.net/85586/free-car-parking-illustration-ql7jz.jpg',
            width: 500,
            height: 400,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20),
          const Text("Bãi đỗ xe",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          const Text("thông minh",
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          SizedBox(height: 20),

          // Indicator Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              indicatorDot(false),
              indicatorDot(false),
              indicatorDot(true),
              indicatorDot(false),
            ],
          ),
          SizedBox(height: 20),

          // Start Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00A86B),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen1()),
              );
            },
            child: const Text("Bắt đầu",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),

          // Register Text
          SizedBox(height: 15),
          RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 14),
              children: [
                TextSpan(text: "Chưa có tài khoản? "),
                TextSpan(
                  text: "Đăng ký",
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget indicatorDot(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF5A4FCF) : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
