import 'package:fe_capstone/models/Contract.dart';
import 'package:fe_capstone/ui/CustomerUI/contract/ContractScreen.dart';
import 'package:fe_capstone/ui/CustomerUI/contract/RenewContractDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlConstant {
  static const GOOGLE_MAPS_GEO = 'geo:';
  static const GOOGLE_MAPS_APP = 'google.navigation:q=';
  static const GOOGLE_MAPS_WEB =
      'https://www.google.com/maps/search/?api=1&query=';
}

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

  String formatCurrency(double amount) {
    final format = NumberFormat("#,##0", "vi_VN");
    return format.format(amount);
  }


  Future<void> _openMap(double lat, double long) async {
    final String geoUrl = '${UrlConstant.GOOGLE_MAPS_GEO}$lat,$long';
    final String googleMapsAppUrl = '${UrlConstant.GOOGLE_MAPS_APP}$lat,$long';
    final String googleMapsWebUrl = '${UrlConstant.GOOGLE_MAPS_WEB}$lat,$long';

    final Uri geoUri = Uri.parse(geoUrl);
    final Uri googleMapsAppUri = Uri.parse(googleMapsAppUrl);
    final Uri googleMapsWebUri = Uri.parse(googleMapsWebUrl);

    try {
      print('Trying geo URL: $geoUrl');
      if (await canLaunchUrl(geoUri)) {
        print('Launching geo URL...');
        await launchUrl(
          geoUri,
          mode: LaunchMode.externalApplication,
        );
        print('Geo URL launched successfully');
        return;
      }

      print(
          'Geo URL not available, trying Google Maps app URL: $googleMapsAppUrl');
      if (await canLaunchUrl(googleMapsAppUri)) {
        print('Launching Google Maps app...');
        await launchUrl(
          googleMapsAppUri,
          mode: LaunchMode.externalApplication,
        );
        print('Google Maps app launched successfully');
        return;
      }

      print(
          'Google Maps app not available, falling back to web URL: $googleMapsWebUrl');
      if (await canLaunchUrl(googleMapsWebUri)) {
        print('Launching web URL...');
        await launchUrl(
          googleMapsWebUri,
          mode: LaunchMode.externalApplication,
        );
        print('Web URL launched successfully');
      } else {
        throw 'Không tìm thấy ứng dụng để mở bản đồ';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    }
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
            Container(
              padding: EdgeInsets.all(16),
              decoration: _boxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.description,
                          color: Colors.grey[700], size: 20),
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
                  _buildInfoRow(
                      "Mã hợp đồng:", widget.contract.contractId.toString()),
                  _buildInfoRow(
                      "Trạng thái:", _getStatusText(widget.contract.status)),
                  _buildInfoRow("Lý do:", _getStatusText(widget.contract.note)),
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
                      Icon(Icons.access_time,
                          color: Colors.grey[700], size: 20),
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
                  _buildInfoRow(
                      "Từ ngày:", _formatDate(widget.contract.startDate)),
                  _buildInfoRow(
                      "Đến ngày:", _formatDate(widget.contract.endDate)),
                  SizedBox(height: 8),
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
                  _buildInfoRow("Màu sắc:",
                      widget.contract.car.color ?? 'Không có thông tin'),
                  _buildInfoRow("Model:", widget.contract.car.model),
                  Divider(height: 24, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tổng chi phí",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        widget.contract.status == "Active"
                            ? (widget.contract.totalAllPayments != null
                            ? '${formatCurrency(widget.contract.totalAllPayments)} VND'
                            : 'Chưa có thông tin thanh toán')
                            : (widget.contract.totalAmount != null
                            ? '${formatCurrency(widget.contract.totalAmount)} VND'
                            : 'Chưa có thông tin thanh toán'),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black),
                      ),
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
              widget.contract.lat,
              widget.contract.long,
            ),

            // Nút Gia hạn
            if (widget.contract.status == 'Active') ...[
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RenewScreen(contract: widget.contract),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Gia hạn',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
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

  Widget _buildParkingCard(
      String title, String address, String space, double lat, double long) {
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
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
          IconButton(
            icon: Icon(Icons.directions, color: Colors.blue, size: 30),
            onPressed: () async {
              try {
                await _openMap(lat, long);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
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
      case 'Pending':
        return 'Chờ duyệt';
      case 'Approved':
        return 'Đã duyệt';
      case 'Rejected':
        return 'Từ chối';
      case 'Paid':
        return 'Đã thanh toán';
      case 'Activated':
        return 'Đang hoạt động';

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
