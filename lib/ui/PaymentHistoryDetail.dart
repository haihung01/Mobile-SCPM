import 'package:fe_capstone/models/Contract.dart';
import 'package:fe_capstone/models/payment_contract.dart';
import 'package:fe_capstone/service/data_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlConstant {
  static const GOOGLE_MAPS_GEO = 'geo:';
  static const GOOGLE_MAPS_APP = 'google.navigation:q=';
  static const GOOGLE_MAPS_WEB =
      'https://www.google.com/maps/search/?api=1&query=';
}

class PaymentHistoryDetail extends StatefulWidget {
  final PaymentContract paymentContract;

  const PaymentHistoryDetail({super.key, required this.paymentContract});

  @override
  _ListPaymentHistoryDetailState createState() =>
      _ListPaymentHistoryDetailState();
}

class _ListPaymentHistoryDetailState extends State<PaymentHistoryDetail> {
  final DataService _dataService = DataService();
  Contract? contract;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchContractDetails();
  }

  Future<void> _fetchContractDetails() async {
    try {
      final contractId = widget.paymentContract.contractId;
      if (contractId == null) {
        throw Exception('Contract ID is null');
      }
      final fetchedContract = await _dataService.getContractById(contractId);
      setState(() {
        contract = fetchedContract;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
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
    if (_isLoading) {
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
            'Chi tiết giao dịch',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null || contract == null) {
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
            'Chi tiết giao dịch',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(child: Text(_errorMessage ?? 'Không tìm thấy hợp đồng')),
      );
    }

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
          'Hợp đồng ${contract!.car.brand}${contract!.car.model}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 16),
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
                      "Mã hợp đồng:", contract!.contractId.toString()),
                  _buildInfoRow(
                      "Ngày thanh toán:", widget.paymentContract.paymentDate.toString()),
                  _buildInfoRow("Lý do:", contract!.note ?? 'Không có'),
                ],
              ),
            ),
            SizedBox(height: 16),
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
                  _buildInfoRow("Từ ngày:", _formatDate(contract!.startDate)),
                  _buildInfoRow("Đến ngày:", _formatDate(contract!.endDate)),
                  SizedBox(height: 8),
                ],
              ),
            ),
            SizedBox(height: 16),
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
                  _buildInfoRow("Biển số:", contract!.car.licensePlate),
                  _buildInfoRow(
                      "Tên xe:", contract!.car.brand + contract!.car.model),
                  _buildInfoRow(
                      "Màu sắc:", contract!.car.color ?? 'Không có thông tin'),
                  Divider(height: 24, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tổng chi phí",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('${formatCurrency(widget.paymentContract.paymentAmount!)} VND', style: TextStyle(
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
            _buildParkingCard(
              contract!.parkingLotName,
              contract!.parkingLotAddress,
              contract!.parkingSpaceName,
              contract!.lat,
              contract!.long,
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
      case 'PendingActivation':
        return 'Chờ hiệu lực';
      case 'Completed':
        return 'Đã hoạt động';
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
