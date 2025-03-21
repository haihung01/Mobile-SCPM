import 'package:flutter/material.dart';

class VehicleDetailsScreen extends StatelessWidget {
  final String vehicleName;
  final String vehiclePlate;
  final String vehicleImage;
  final String vehicleColor;
  final String vehicleYear;

  const VehicleDetailsScreen({
    Key? key,
    required this.vehicleName,
    required this.vehiclePlate,
    required this.vehicleImage,
    required this.vehicleColor,
    required this.vehicleYear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Chi tiết hồ sơ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Chức năng sửa thông tin
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.black26),
                  ),
                ),
                child: const Text("Thông tin"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text("Sửa thông tin"),
              ),
            ],
          ),
          const SizedBox(height: 30),
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(vehicleImage),
          ),
          const SizedBox(height: 20),
          Text(
            vehicleName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            vehiclePlate,
            style: const TextStyle(fontSize: 16, color: Colors.green),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoCard("Màu", vehicleColor),
              const SizedBox(width: 16),
              _buildInfoCard("Năm Sản Xuất", vehicleYear),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
