import 'package:fe_capstone/models/Contract.dart';
import 'package:fe_capstone/models/payment_contract.dart';
import 'package:fe_capstone/service/data_service.dart';
import 'package:fe_capstone/ui/CustomerUI/contract/ContractDetailScreen.dart';
import 'package:fe_capstone/ui/screens/PaymentWebViewScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatefulWidget {
  final Contract contract;
  const PaymentScreen({super.key, required this.contract});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final DataService _dataService = DataService();
  List<PaymentContract> _paymentContracts = [];
  bool _isLoadingPayments = true;
  String? _paymentError;

  @override
  void initState() {
    super.initState();
    _fetchPaymentContracts();
  }

  Future<void> _fetchPaymentContracts() async {
    try {
      final paymentContracts =
          await _dataService.getPaymentContracts(widget.contract.contractId);
      setState(() {
        _paymentContracts = paymentContracts;
        _isLoadingPayments = false;
      });
    } catch (e) {
      setState(() {
        _paymentError = e.toString().replaceFirst('Exception: ', '');
        _isLoadingPayments = false;
      });
    }
  }

  String formatCurrency(double amount) {
    final format = NumberFormat("#,##0", "vi_VN");
    return format.format(amount);
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  String _getPaymentStatusText(String status) {
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
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Trang thanh toán",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoCard(
              icon: Icons.access_time,
              title: "Thời gian Để xe",
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDate(widget.contract.startDate),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(_formatDate(widget.contract.endDate),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              icon: Icons.directions_car,
              title: "Xe đăng ký",
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.contract.car.model,
                          style: const TextStyle(fontSize: 16)),
                      Text(widget.contract.parkingSpaceName,
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const Divider(height: 20),
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
            const SizedBox(height: 16),
            _buildInfoCard(
              icon: Icons.payment,
              title: "Phương thức thanh toán",
              content: Row(
                children: [
                  Image.asset("assets/images/vnpay.webp", height: 24),
                  const SizedBox(width: 10),
                  const Text("Thanh toán qua VNPAY",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 16),

// Thông tin bãi đỗ (build y chang ở ContractDetailScreen)
            _buildParkingCard(
              widget.contract.parkingLotName,
              widget.contract.parkingLotAddress,
              widget.contract.parkingSpaceName,
              widget.contract.lat,
              widget.contract.long,
            ),

            const Spacer(),
            SizedBox(
              width: 250,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  final int contractId = widget.contract.paymentContractId;
                  final dataService = DataService();
                  final url = await dataService.redirectToVNPay(contractId);

                  if (url != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RechargeWebViewScreen(url, contractId),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Không thể tạo URL thanh toán'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  "Thanh toán",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey[700]),
              const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.grey[800])),
            ],
          ),
          const SizedBox(height: 12),
          content,
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
}
