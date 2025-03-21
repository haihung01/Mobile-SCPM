import 'package:fe_capstone/ui/CustomerUI/home/HomeScreen1.dart';
import 'package:fe_capstone/ui/CustomerUI/contract/ContractScreen.dart';
import 'package:fe_capstone/ui/CustomerUI/feedback/FeedbackScreen.dart';
import 'package:fe_capstone/ui/CustomerUI/vehicle-management/VehicleManagementScreen.dart';
import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomFooter({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

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
            _buildNavItem(Icons.car_crash, "Quản lý xe", 2, context),
            _buildNavItem(Icons.feedback_sharp, "Feedback", 3, context),
          ],
        ),
      ),
    );
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContractScreen()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VehicleListScreen()),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FeedbackScreen()),
          );
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
}
