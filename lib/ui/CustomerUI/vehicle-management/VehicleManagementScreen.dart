import 'package:fe_capstone/models/car_model.dart';
import 'package:fe_capstone/ui/CustomerUI/home/HomeScreen1.dart';
import 'package:flutter/material.dart';
import 'package:fe_capstone/service/data_service.dart';
import 'package:fe_capstone/ui/CustomerUI/vehicle-management/NewVehicle.dart';
import 'package:fe_capstone/ui/CustomerUI/vehicle-management/VehicleDetailScreen.dart';
import 'package:fe_capstone/ui/components/bottomAppBar/CustomFooter.dart';

class VehicleListScreen extends StatefulWidget {
  @override
  _VehicleListScreenState createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final DataService _dataService = DataService();
  late Future<List<Car>> _futureVehicles;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  void _loadVehicles() {
    setState(() {
      _futureVehicles = _dataService.getCarsOfCustomer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: FutureBuilder<List<Car>>(
        future: _futureVehicles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi tải danh sách xe'));
          }
          // Luôn gọi _buildVehicleGrid, ngay cả khi snapshot.data rỗng
          return _buildVehicleGrid(snapshot.data ?? []);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddVehicle(context),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:
          CustomFooter(selectedIndex: 2, onItemTapped: (index) {}),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen1()),
          );
        },
      ),
      // actions: const [
      //   Padding(
      //     padding: EdgeInsets.only(right: 16),
      //     child: CircleAvatar(
      //       backgroundImage: AssetImage("assets/images/profile1.webp"),
      //     ),
      //   ),
      // ],
    );
  }

  Widget _buildVehicleGrid(List<Car> vehicles) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (vehicles.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Không có xe nào. Nhấn "Thêm xe" để thêm!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
          Expanded(
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
                  return _buildVehicleCard(context, vehicles[index]);
                }
                return _buildAddCard(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(BuildContext context, Car vehicle) {
    const String defaultImageUrl =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQraYGSzS_s1fqgQG7xYf1DfmTWfEzHMB44aw&s';

    return GestureDetector(
      onTap: () => _navigateToDetail(context, vehicle.carId),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  vehicle.thumbnail?.isNotEmpty == true
                      ? vehicle.thumbnail!
                      : defaultImageUrl,
                  height: 115,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 128,
                    color: Colors.grey[200],
                    child: Icon(Icons.car_repair, size: 50),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${vehicle.brand}${vehicle.model}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Màu xe: ${vehicle.color}",
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Biển Số: ${vehicle.licensePlate}",
                style: const TextStyle(color: Colors.black54),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // if (vehicle.entrance != null) ...[
              //   Text(
              //     'Vị trí đỗ xe',
              //     style: TextStyle(fontWeight: FontWeight.bold),
              //   ),
              //   Text('Tầng: ${vehicle.entrance!.floorName}'),
              //   Text(
              //     'Khu vực: ${vehicle.entrance!.areaName}',
              //   ),
              //   Text(
              //     'Bãi đỗ: ${vehicle.entrance!.parkingLotName}',
              //   ),
              //   Text(
              //     'Vị trí đỗ: ${vehicle.entrance!.parkingSpaceName}',
              //   ),
              // ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        onTap: () => _navigateToAddVehicle(context),
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

  void _navigateToDetail(BuildContext context, int carId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleDetailsScreen(carId: carId),
      ),
    ).then((_) => _loadVehicles()); // Refresh list after returning
  }

  void _navigateToAddVehicle(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewVehicleScreen()),
    ).then((_) => _loadVehicles()); // Refresh list after adding
  }
}
