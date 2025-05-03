import 'package:fe_capstone/models/Contract.dart';
import 'package:fe_capstone/models/car_model.dart';
import 'package:fe_capstone/service/data_service.dart';
import 'package:fe_capstone/ui/CustomerUI/contract/ContractDetailScreen.dart';
import 'package:fe_capstone/ui/CustomerUI/home/HomeScreen1.dart';
import 'package:fe_capstone/ui/CustomerUI/parking-management/ListParkingScreen.dart';
import 'package:fe_capstone/ui/CustomerUI/payment/PaymentScreen.dart';
import 'package:fe_capstone/ui/components/bottomAppBar/CustomFooter.dart';
import 'package:flutter/material.dart';

class ContractScreen extends StatefulWidget {
  @override
  _ContractScreenState createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  int selectedTabIndex = 0;
  late Future<List<Contract>> futureContracts;
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _loadContracts();
  }

  void _loadContracts() {
    setState(() {
      futureContracts = _fetchContractsForTab(selectedTabIndex);
    });
  }

  Future<List<Contract>> _fetchContractsForTab(int tabIndex) async {
    try {
      if (tabIndex == 0) {
        final pendingContracts = await _dataService.getPendingContracts();
        final approvedContracts = await _dataService.getApprovedContracts();
        final rejectedContracts = await _dataService.getRejectedContracts();
        return [
          ...pendingContracts,
          ...approvedContracts,
          ...rejectedContracts
        ];
      } else if (tabIndex == 1) {
        // "Đã Thanh Toán" tab
        return await _dataService.getPaidContracts();
      } else {
        // "Đang Hoạt Động" tab
        return await _dataService.getActivatedContracts();
      }
    } catch (e) {
      throw Exception('Failed to load contracts: ${e.toString()}');
    }
  }

  String getSafeThumbnail(Car car) {
    if (car.thumbnail == null || car.thumbnail!.isEmpty) {
      return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQraYGSzS_s1fqgQG7xYf1DfmTWfEzHMB44aw&s';
    }
    return car.thumbnail!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Hợp đồng",
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTabButton("Chưa thanh toán", 0),
                // _buildTabButton("Đã thanh toán", 1),
                _buildTabButton("Đang hoạt động", 2),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Contract>>(
                future: futureContracts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Không có hợp đồng nào'));
                  } else {
                    final contracts = snapshot.data!;
                    return ListView.builder(
                      itemCount: contracts.length,
                      itemBuilder: (context, index) {
                        final contract = contracts[index];
                        return _buildContractCard(contract);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => ListParkingScreen(),
          );
        },
        backgroundColor: Colors.green,
        shape: const CircleBorder(),
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          child: const Text(
            "Soạn",
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomFooter(
        selectedIndex: 1,
        onItemTapped: (index) {},
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTabIndex = index;
            _loadContracts();
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selectedTabIndex == index ? Colors.green : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: selectedTabIndex == index ? Colors.white : Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContractCard(Contract contract) {
    final statusText = _getStatusText(contract.status);
    final statusColor = _getStatusColor(contract.status);
    final buttonLabel = _getButtonLabel(contract);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                // Thêm SizedBox để cố định kích thước
                width: 50,
                height: 50,
                child: Image.network(
                  getSafeThumbnail(contract.car),
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.car_repair, size: 24),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hợp Đồng Xe ${contract.car.model}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.place, size: 14, color: Colors.green),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "Bãi ${contract.parkingSpaceName}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          border: Border.all(color: statusColor),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print("Data contract: ${contract.toJson()}");
                if (buttonLabel.toLowerCase() == "thanh toán") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(contract: contract),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ContractDetailScreen(contract: contract),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                buttonLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'Pending':
        return 'Chờ duyệt';
      case 'Approved':
        return 'Đã duyệt';
      case 'Rejected':
        return 'Từ chối';
      case 'Paid':
        return 'Đã thanh toán';
      case 'PendingActivation':
        return 'Chờ hiệu lực';
      case 'Active':
        return 'Đang hoạt động';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Paid':
        return Colors.purple;
      case 'PendingActivation':
        return Colors.blue;
      case 'Active':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getButtonLabel(Contract contract) {
    if (contract.status == 'Approved') {
      return 'Thanh toán';
    }
    return 'Chi tiết';
  }
}
