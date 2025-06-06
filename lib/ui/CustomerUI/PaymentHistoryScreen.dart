import 'package:fe_capstone/service/data_service.dart';
import 'package:fe_capstone/ui/CustomerUI/chat/WebView.dart';
import 'package:fe_capstone/ui/PaymentHistoryDetail.dart';
import 'package:flutter/material.dart';
import 'package:fe_capstone/models/payment_contract.dart';
import 'package:fe_capstone/ui/components/bottomAppBar/CustomFooter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentHistoryScreen extends StatefulWidget {
  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  late Future<List<PaymentContract>> _paymentHistoriesFuture;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _paymentHistoriesFuture = DataService().getPaymentHistories();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add navigation logic for other tabs if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Text(
              'Lịch sử giao dịch',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<PaymentContract>>(
        future: _paymentHistoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No payment history found.'));
          }

          final paymentHistories = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: paymentHistories.length,
            itemBuilder: (context, index) {
              final payment = paymentHistories[index];
              return _buildPaymentCard(payment);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
          final customerId = isLoggedIn ? (prefs.getInt('ownerId') ?? 0) : 0;

          final url =
              'https://scpmbe-hrhheedhh7gmatev.southeastasia-01.azurewebsites.net/api/Customer/$customerId/chat';

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatWebViewScreen(url),
            ),
          );
        },
        backgroundColor: Colors.white,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.network(
            'https://cdn-icons-png.flaticon.com/512/6066/6066674.png',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomFooter(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildPaymentCard(PaymentContract payment) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentHistoryDetail(
              paymentContract: payment,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://static.vecteezy.com/system/resources/previews/005/064/963/non_2x/letter-p-alphabet-natural-green-icons-leaf-logo-free-vector.jpg',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.description,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mã thanh toán #${payment.paymentContractId}: ${payment.note}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${payment.paymentDate}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  formatter.format(payment.paymentAmount ?? 0),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
