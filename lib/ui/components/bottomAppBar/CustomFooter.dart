import 'package:fe_capstone/ui/CustomerUI/home/HomeScreen1.dart';
import 'package:fe_capstone/ui/CustomerUI/contract/ContractScreen.dart';
import 'package:fe_capstone/ui/CustomerUI/feedback/FeedbackScreen.dart';
import 'package:fe_capstone/ui/CustomerUI/vehicle-management/VehicleManagementScreen.dart';
import 'package:fe_capstone/ui/screens/LoginScreen1.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomFooter extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomFooter({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> _handleProtectedNavigation(
      BuildContext context, Widget screen) async {
    final isLoggedIn = await _checkLoginStatus();

    if (!isLoggedIn) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Yêu cầu đăng nhập'),
          content: const Text('Vui lòng đăng nhập để sử dụng tính năng này'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen1()),
                );
              },
              child: const Text('Đăng nhập'),
            ),
          ],
        ),
      );
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
    }
  }

  Widget _buildNavItem(
      IconData icon, String title, int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen1()),
            (route) => false,
          );
        } else if (index == 1) {
          _handleProtectedNavigation(context, ContractScreen());
        } else if (index == 2) {
          _handleProtectedNavigation(context, VehicleListScreen());
        } else if (index == 3) {
          _handleProtectedNavigation(context, FeedbackScreen());
        } else {
          onItemTapped(index);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: selectedIndex == index ? Colors.green : Colors.grey),
          Text(
            title,
            style: TextStyle(
                color: selectedIndex == index ? Colors.green : Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.home, "Trang chủ", 0, context),
            _buildNavItem(Icons.layers, "Hợp đồng", 1, context),
            const SizedBox(width: 40),
            _buildNavItem(Icons.car_repair_sharp, "Quản lý xe", 2, context),
            _buildNavItem(Icons.feedback_sharp, "Phản hồi", 3, context),
          ],
        ),
      ),
    );
  }
}
