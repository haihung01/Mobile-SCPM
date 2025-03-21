import 'package:fe_capstone/ui/CustomerUI/LocationScreen.dart';
import 'package:fe_capstone/ui/CustomerUI/profile/ProfileScreen1.dart';
import 'package:fe_capstone/ui/CustomerUI/contract/ContractScreen.dart';
import 'package:fe_capstone/ui/components/bottomAppBar/CustomFooter.dart';
import 'package:flutter/material.dart';
// import 'package:fe_capstone/widgets/custom_footer.dart';

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
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            child: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/profile1.webp"),
            ),
          ),
        ),
        title: const Text(
          "SPCM",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.notifications_none, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomFooter(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
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
              MaterialPageRoute(
                  builder: (context) => LocationScreen()), // Giữ nguyên
            );
          } else if (title == "Hợp Đồng") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ContractScreen()), // Thêm chức năng hợp đồng
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.black54),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
