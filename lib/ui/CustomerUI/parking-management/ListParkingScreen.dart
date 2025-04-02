import 'package:fe_capstone/ui/CustomerUI/contract/ContractScreen.dart';
import 'package:flutter/material.dart';

class ListParkingScreen extends StatefulWidget {
  @override
  _ListParkingScreenState createState() => _ListParkingScreenState();
}

class _ListParkingScreenState extends State<ListParkingScreen> {
  String? selectedCar = 'oto 1';

  String? selectedParking;
  DateTime selectedDate = DateTime(2023, 9, 15);
  final String totalCost = '100,000đ';

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
          'Soạn hợp đồng',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Thời gian để xe
            Container(
              padding: EdgeInsets.all(16),
              decoration: _boxDecoration(),
              child: Row(
                children: [
                  Icon(Icons.access_time, color: Colors.grey[700]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Thời gian Để xe",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800])),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDate(selectedDate),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700)),
                            Text(_formatDate(selectedDate),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Chọn xe
            Container(
              padding: EdgeInsets.all(16),
              decoration: _boxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey[700]),
                      SizedBox(width: 8),
                      Text("Chọn Xe",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800])),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text("oto 1", style: TextStyle(fontSize: 16)),
                  Divider(height: 24, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tổng cộng",
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

            // Danh sách bãi xe
            _buildParkingCard("Bãi Xe A", "status: trống 10 chỗ"),
            _buildParkingCard("Bãi Xe B", "Mô tả"),
            _buildParkingCard("Bãi Xe C", "Mô tả"),

            SizedBox(height: 24),

            // Gửi button
            SizedBox(
              width: 190,
              height: 40,
              child: ElevatedButton(
                onPressed: _onSubmit,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18))),
                child: Text("Gửi", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParkingCard(String title, String subtitle) {
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
                    Icon(Icons.location_on, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text(subtitle, style: TextStyle(fontSize: 14)),
                  ],
                )
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                selectedParking = title;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: Size(60, 36),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text("chọn"),
          )
        ],
      ),
    );
  }

  void _onSubmit() {
    if (selectedCar != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hợp đồng đã được gửi!")),
      );

      // Điều hướng sang trang ContractScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContractScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng chọn xe và bãi xe")),
      );
    }
  }

  String _formatDate(DateTime date) {
    return "${_padZero(date.day)}/${_padZero(date.month)}/${date.year}";
  }

  String _padZero(int number) => number.toString().padLeft(2, '0');

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
