import 'package:fe_capstone/ui/CustomerUI/vehicle-management/NewVehicle.dart';
import 'package:fe_capstone/ui/CustomerUI/vehicle-management/VehicleDetailScreen.dart';
import 'package:fe_capstone/ui/components/bottomAppBar/CustomFooter.dart';
import 'package:flutter/material.dart';

class VehicleListScreen extends StatelessWidget {
  final List<Map<String, String>> vehicles = [
    {
      "name": "BMW 320i",
      "plate": "59A-123.45",
      "image": "assets/images/car1.jpg",
      "color": "xanh nhạt",
      "year": "2025"
    },
    {
      "name": "Mercedes C200",
      "plate": "59A-567.89",
      "image": "assets/images/car2.webp",
      "color": "trắng",
      "year": "2023"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Danh Sách Xe",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/profile1.webp"),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.82,
          ),
          itemCount: vehicles.length + 1,
          itemBuilder: (context, index) {
            if (index < vehicles.length) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VehicleDetailsScreen(
                        vehicleName: vehicles[index]["name"]!,
                        vehiclePlate: vehicles[index]["plate"]!,
                        vehicleImage: vehicles[index]["image"]!,
                        vehicleColor: vehicles[index]["color"]!,
                        vehicleYear: vehicles[index]["year"]!,
                      ),
                    ),
                  );
                },
                child: _buildVehicleCard(
                  vehicles[index]["image"]!,
                  vehicles[index]["name"]!,
                  vehicles[index]["plate"]!,
                ),
              );
            } else {
              return _buildAddCarCard(context);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomFooter(
        selectedIndex: 2,
        onItemTapped: (index) {},
      ),
    );
  }

  Widget _buildVehicleCard(String image, String name, String plate) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(image,
                  height: 138, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "🚗 Biển Số: $plate",
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCarCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewVehicleScreen()),
          );
        },
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 30, color: Colors.black54),
              SizedBox(height: 8),
              Text("Thêm Xe",
                  style: TextStyle(fontSize: 16, color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}
