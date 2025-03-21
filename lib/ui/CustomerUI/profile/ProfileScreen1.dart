import 'package:fe_capstone/ui/screens/LoginScreen1.dart';
import 'package:flutter/material.dart';
import 'package:fe_capstone/ui/components/bottomAppBar/CustomFooter.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "SPCM",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/images/profile1.webp"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "letiendat",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "mail1234@gmail.com",
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.notifications_none, color: Colors.black),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Menu List
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildMenuItem(Icons.lock_outline, "Mật Khẩu"),
                  _buildMenuItem(Icons.phone_outlined, "Phone"),
                  _buildMenuItem(Icons.location_on_outlined, "Địa chỉ"),
                ],
              ),
            ),

            const SizedBox(height: 100),
            SizedBox(
              width: 140,
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen1()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(66, 19),
                ),
                child: const Text(
                  "Đăng xuất",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Floating Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: CustomFooter(
        selectedIndex: 0,
        onItemTapped: (index) {},
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
      onTap: () {},
    );
  }
}
