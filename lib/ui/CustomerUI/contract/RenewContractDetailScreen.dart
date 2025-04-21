import 'package:fe_capstone/models/Contract.dart';
import 'package:fe_capstone/service/data_service.dart';
import 'package:flutter/material.dart';

class RenewScreen extends StatefulWidget {
  final Contract contract;

  const RenewScreen({super.key, required this.contract});

  @override
  State<RenewScreen> createState() => _RenewScreenState();
}

class _RenewScreenState extends State<RenewScreen> {
  final DataService _dataService = DataService();
  int selectedMonthDuration = 1;
  String totalCost = '';
  DateTime selectedStartDate = DateTime.now();
  DateTime endDate = DateTime.now();
  double _parkingLotPrice = 3000000;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedStartDate = widget.contract.endDate;
    _fetchParkingLotPrice();
  }

  Future<void> _fetchParkingLotPrice() async {
    try {
      final response =
          await _dataService.getParkingLotPrice(widget.contract.parkingLotId);
      setState(() {
        _parkingLotPrice = response;
        _calculateTotalCost();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _parkingLotPrice = 0;
        _calculateTotalCost();
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Không thể lấy giá bãi xe, sử dụng giá mặc định")),
      );
    }
  }

  void _calculateTotalCost() {
    final cost = _parkingLotPrice * selectedMonthDuration;
    setState(() {
      totalCost = _formatPrice(cost) + 'VNĐ';
    });
    _updateEndDate();
  }

  void _updateEndDate() {
    setState(() {
      endDate = DateTime(
        selectedStartDate.year,
        selectedStartDate.month + selectedMonthDuration,
        selectedStartDate.day,
      );
    });
  }

  Future<void> _onSubmit() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận gia hạn'),
        content: Text(
            'Bạn có muốn gia hạn thêm $selectedMonthDuration tháng nữa không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Không', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Có', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _dataService.renewContract(
        contractId: widget.contract.contractId,
        numberMonth: selectedMonthDuration,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gia hạn hợp đồng thành công!")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gia hạn thất bại: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatPrice(double price) {
    String priceStr = price.toStringAsFixed(0);
    String result = '';
    int count = 0;

    for (int i = priceStr.length - 1; i >= 0; i--) {
      count++;
      result = priceStr[i] + result;
      if (count % 3 == 0 && i > 0) {
        result = '.' + result;
      }
    }
    return result;
  }

  String _formatDate(DateTime date) {
    return "${_padZero(date.day)}/${_padZero(date.month)}/${date.year}";
  }

  String _padZero(int number) => number.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          title:
              Text("Gia hạn hợp đồng", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text("Gia hạn hợp đồng", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildBox(
              title: "Thời gian để xe",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bắt đầu: ${_formatDate(selectedStartDate)}",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Kết thúc: ${_formatDate(endDate)}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButton<int>(
                        value: selectedMonthDuration,
                        items: List.generate(12, (index) {
                          int months = index + 1;
                          return DropdownMenuItem(
                            value: months,
                            child: Text("$months tháng"),
                          );
                        }),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedMonthDuration = value;
                            });
                            _calculateTotalCost();
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildBox(
              title: "Thông tin xe",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow("Biển số:", widget.contract.car.licensePlate),
                  _buildInfoRow("Model:", widget.contract.car.model),
                  _buildInfoRow(
                      "Màu sắc:", widget.contract.car.color ?? 'Không có'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildBox(
              title: "Chi phí",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tổng cộng",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(totalCost,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
            ),
            SizedBox(height: 80),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Xác nhận gia hạn",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBox({required String title, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800])),
          const SizedBox(height: 12),
          child,
        ],
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
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
