import 'package:fe_capstone/models/Contract.dart';
import 'package:fe_capstone/service/data_service.dart';
import 'package:fe_capstone/ui/CustomerUI/contract/ContractDetailScreen.dart';
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
      switch (tabIndex) {
        case 0: // Pending
          return await _dataService.getPendingContracts();
        case 1: // Approved
          return await _dataService.getApprovedContracts();
        case 2: // Paid
          return await _dataService.getPaidContracts();
        case 3: // Activated
          return await _dataService.getActivatedContracts();
        default:
          return [];
      }
    } catch (e) {
      throw Exception('Failed to load contracts: ${e.toString()}');
    }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTabButton("Chờ duyệt", 0),
                _buildTabButton("Đã duyệt", 1),
                _buildTabButton("Đang hoạt động", 3),
                _buildTabButton("Đã thanh toán", 2),
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
        onPressed: () {},
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
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
          margin: const EdgeInsets.symmetric(horizontal: 2),
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
              fontSize: 12,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.directions_car, size: 40, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contract.car.model,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contract.parkingSpaceName,
                        style: const TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.place, size: 14, color: Colors.green),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              contract.parkingLotAddress,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
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
                                horizontal: 8, vertical: 4),
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
                                  color: statusColor),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${contract.startDate.day}/${contract.startDate.month}/${contract.startDate.year} - ${contract.endDate.day}/${contract.endDate.month}/${contract.endDate.year}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (buttonLabel.toLowerCase() == "thanh toán") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentScreen(contract: contract)),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContractDetailScreen(contract: contract)),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  buttonLabel,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
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
      case 'Paid':
        return 'Đã thanh toán';
      case 'Activated':
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
        return Colors.blue;
      case 'Paid':
        return Colors.purple;
      case 'Activated':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getButtonLabel(Contract contract) {
    if (contract.status == 'Pending') {
      return 'Thanh toán';
    }
    return 'Chi tiết';
  }
}