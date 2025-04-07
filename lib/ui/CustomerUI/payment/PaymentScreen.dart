import 'package:fe_capstone/models/Contract.dart';
import 'package:fe_capstone/ui/CustomerUI/payment/QRScreen.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final Contract contract;
  const PaymentScreen({super.key, required this.contract});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
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
          "Thanh toán",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Thời gian để xe
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

            // Xe đăng ký
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
                      const Text("Tổng cộng",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        totalCost,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Phương thức thanh toán
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
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
            const Spacer(),

            // Nút Thanh Toán
            SizedBox(
              width: 250,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QRScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text("Thanh Toán",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  String get totalCost {
    // if (widget.contract.paymentContract != null) {
    //   return '${widget.contract.paymentContract!.paymentAmount.toStringAsFixed(0)}đ';
    // }
    return 'Chưa có thông tin thanh toán';
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
}
