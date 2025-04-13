import 'dart:async';

import 'package:fe_capstone/ui/CustomerUI/vehicle-management/VehicleManagementScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fe_capstone/ui/screens/LoginScreen1.dart';
import 'package:fe_capstone/ui/CustomerUI/LocationScreen.dart';
import 'package:fe_capstone/ui/CustomerUI/contract/ContractScreen.dart';
import 'package:fe_capstone/ui/CustomerUI/profile/ProfileScreen1.dart';
import 'package:fe_capstone/ui/components/bottomAppBar/CustomFooter.dart';

class HomeScreen1 extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen1> {
  int _selectedIndex = 0;
  int _currentBannerIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Auto scroll
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentBannerIndex + 1) % 3;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> _handleProtectedNavigation(
      BuildContext context, Widget screen) async {
    final isLoggedIn = await _checkLoginStatus();

    if (!isLoggedIn) {
      await _showLoginRequiredDialog(context);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
    }
  }

  Future<void> _showLoginRequiredDialog(BuildContext context) async {
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
  }

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
            onTap: () async {
              await _handleProtectedNavigation(context, ProfileScreen());
            },
            child: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/profile1.webp"),
            ),
          ),
        ),
        title: const Text(
          "SCPM",
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
            child: Icon(Icons.notifications_none,
                color: Color.fromARGB(255, 235, 110, 101)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔝 GridView ở trên
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildCard(
                    Icons.location_on_outlined,
                    "Tìm bãi đỗ",
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LocationScreen()),
                    ),
                    iconColor: Colors.green,
                  ),
                  _buildCard(
                    Icons.layers_outlined,
                    "Hợp đồng",
                    () => _handleProtectedNavigation(context, ContractScreen()),
                    iconColor: Color.fromARGB(255, 235, 217, 59),
                  ),
                  _buildCard(
                    Icons.directions_car_outlined,
                    "Danh sách xe",
                    () => _handleProtectedNavigation(
                        context, VehicleListScreen()),
                    iconColor: Color.fromARGB(255, 130, 187, 233),
                  ),
                  _buildCard(
                    Icons.notifications_active_outlined,
                    "Thông báo",
                    () {},
                    iconColor: const Color.fromARGB(255, 235, 110, 101),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Transform.translate(
                    offset: Offset(0, -55),
                    child: Text(
                      'Xem chi tiết',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 58, 58, 58),
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -50),
                  child: SizedBox(
                    height: 185,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentBannerIndex = index;
                            });
                          },
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            final images = [
                              'https://hungvuongphat.com/wp-content/uploads/2021/07/mo-hinh-bai-giu-xe-thong-minh.jpg',
                              'https://vending-cdn.kootoro.com/torov-cms/upload/image/1672300550330-d%C3%A1n%20decal%20qu%E1%BA%A3ng%20c%C3%A1o%20%C3%B4%20t%C3%B4.jpg',
                              'https://bcp.cdnchinhphu.vn/334894974524682240/2022/4/1/b60a911bf638239b911a077c0744ec96-16488114501631594628377.jpg',
                            ];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromARGB(255, 197, 197, 197),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    images[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                width: _currentBannerIndex == index ? 12 : 8,
                                height: _currentBannerIndex == index ? 12 : 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentBannerIndex == index
                                      ? Colors.white
                                      : Colors.white54,
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.network(
            'https://static.vecteezy.com/system/resources/previews/005/064/963/non_2x/letter-p-alphabet-natural-green-icons-leaf-logo-free-vector.jpg',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomFooter(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, VoidCallback onTap,
      {Color iconColor = Colors.black54}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: iconColor),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
