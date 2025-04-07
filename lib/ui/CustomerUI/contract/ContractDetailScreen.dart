import 'package:fe_capstone/models/Contract.dart';
import 'package:fe_capstone/ui/CustomerUI/contract/ContractScreen.dart';
import 'package:flutter/material.dart';

class ContractDetailScreen extends StatefulWidget {
  final Contract contract;

  const ContractDetailScreen({super.key, required this.contract});
  @override
  _ListContractDetailScreenState createState() =>
      _ListContractDetailScreenState();
}

class _ListContractDetailScreenState extends State<ContractDetailScreen> {
  String? selectedCar;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectedCar = widget.contract.car.model;
    selectedDate = widget.contract.startDate;
  }

  String get totalCost {
    if (widget.contract.paymentContract != null) {
      return '${widget.contract.paymentContract!.paymentAmount.toStringAsFixed(0)}đ';
    }
    return 'Chưa có thông tin thanh toán';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Hợp đồng ${widget.contract.car.model}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Thông tin hợp đồng
            Container(
              padding: EdgeInsets.all(16),
              decoration: _boxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.description, color: Colors.grey[700], size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Thông tin hợp đồng",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _buildInfoRow("Mã hợp đồng:", widget.contract.contractId.toString()),
                  _buildInfoRow("Trạng thái:", _getStatusText(widget.contract.currentStatus)),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Thời gian để xe
            Container(
              padding: EdgeInsets.all(16),
              decoration: _boxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey[700], size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Thời gian để xe",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _buildInfoRow("Từ ngày:", _formatDate(widget.contract.startDate)),
                  _buildInfoRow("Đến ngày:", _formatDate(widget.contract.endDate)),
                  SizedBox(height: 8),
                  if (widget.contract.paymentContract != null) ...[
                    Divider(height: 24, thickness: 1),
                    _buildInfoRow("Trạng thái thanh toán:",
                        _getPaymentStatusText(widget.contract.paymentContract!.status)),
                  ],
                ],
              ),
            ),
            SizedBox(height: 16),

            // Thông tin xe
            Container(
              padding: EdgeInsets.all(16),
              decoration: _boxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.directions_car, color: Colors.grey[700]),
                      SizedBox(width: 8),
                      Text("Thông tin xe",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800])),
                    ],
                  ),
                  SizedBox(height: 12),
                  _buildInfoRow("Biển số:", widget.contract.car.licensePlate),
                  _buildInfoRow("Màu sắc:", widget.contract.car.color),
                  _buildInfoRow("Model:", widget.contract.car.model),
                  Divider(height: 24, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tổng chi phí",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(totalCost,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black)),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 16),

            // Thông tin bãi đỗ
            _buildParkingCard(
              widget.contract.parkingLotName,
              widget.contract.parkingLotAddress,
              widget.contract.parkingSpaceName,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildParkingCard(String title, String address, String space) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              "assets/images/parking.jpg",
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.space_bar, color: Colors.blue, size: 16),
                    SizedBox(width: 4),
                    Text("Vị trí: $space", style: TextStyle(fontSize: 14)),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(address,
                          style: TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${_padZero(date.day)}/${_padZero(date.month)}/${date.year}";
  }

  String _padZero(int number) => number.toString().padLeft(2, '0');

  String _getStatusText(String status) {
    switch (status) {
      case 'Waiting':
        return 'Chờ duyệt';
      case 'Active':
        return 'Đang hoạt động';
      case 'Expired':
        return 'Đã kết thúc';
      default:
        return status;
    }
  }

  String _getPaymentStatusText(String status) {
    switch (status) {
      case 'Completed':
        return 'Đã thanh toán';
      case 'Paid':
        return 'Đã thanh toán';
      case 'Pending':
        return 'Chờ thanh toán';
      default:
        return status;
    }
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
      ],
    );
  }
}