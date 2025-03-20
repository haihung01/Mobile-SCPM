import 'package:fe_capstone/ui/CustomerUI/ContractScreen.dart';
import 'package:flutter/material.dart';

class HomeScreen1 extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen1> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(
              "https://images.template.net/85586/free-car-parking-illustration-ql7jz.jpg",
              height: 40,
            ),
            Text(
              "SPCM",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            CircleAvatar(
              backgroundImage: AssetImage("assets/profile.jpg"),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildCard(Icons.location_on_outlined, "Tìm Bãi Đỗ", context),
                  _buildCard(Icons.layers_outlined, "Hợp Đồng", context),
                  _buildCard(
                      Icons.directions_car_outlined, "Thông Tin Xe", context),
                  _buildCard(Icons.notifications_active_outlined, "Thông Báo",
                      context),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(Icons.home, "Trang chủ", 0),
              _buildNavItem(Icons.layers, "Hợp đồng", 1),
              SizedBox(width: 40), // khoảng trống cho FAB
              _buildNavItem(Icons.car_crash, "Quản lý xe", 3),
              _buildNavItem(Icons.feedback_sharp, "Feedback", 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          if (title == "Tìm Bãi Đỗ") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContractScreen()),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.black54),
            SizedBox(height: 10),
            Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: _selectedIndex == index ? Colors.green : Colors.grey),
        Text(
          title,
          style: TextStyle(
              color: _selectedIndex == index ? Colors.green : Colors.grey),
        ),
      ],
    );
  }
}
