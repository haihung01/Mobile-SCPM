import 'package:flutter/material.dart';
import 'package:fe_capstone/ui/CustomerUI/home/HomeScreen1.dart';

class QRScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  'Cổng thanh toán',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ),

          // Nội dung chính
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Thanh toán trực tuyến',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '100.000 VND',
                            style: TextStyle(
                              fontSize: 46,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 50),
                          Container(
                            width: 500,
                            height: 500,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Image.asset(
                              'assets/images/QR.jpg',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen1()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      'Đã thanh toán',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
