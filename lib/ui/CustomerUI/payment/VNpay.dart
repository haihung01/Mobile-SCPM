import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

class VNPayService {
  static const String vnp_TmnCode = '8JZGUOCX';
  static const String vnp_HashSecret = 'YS9FBBIBCCDU5HJPGHVXGGQ2JV08SZ0XH';
  static const String vnp_Url =
      'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html';
  static const String vnp_ReturnUrl =
      'https://sandbox.vnpayment.vn/return_order.html';

  static Future<void> pay(int amount) async {
    final DateTime now = DateTime.now();
    final String vnp_TxnRef = Random().nextInt(1000000).toString();
    final String vnp_OrderInfo = 'Thanh toan test Flutter';
    final String vnp_CreateDate = DateFormat('yyyyMMddHHmmss').format(now);

    Map<String, String> params = {
      'vnp_Version': '2.1.0',
      'vnp_Command': 'pay',
      'vnp_TmnCode': vnp_TmnCode,
      'vnp_Amount': '${amount * 100}',
      'vnp_CurrCode': 'VND',
      'vnp_TxnRef': vnp_TxnRef,
      'vnp_OrderInfo': vnp_OrderInfo,
      'vnp_Locale': 'vn',
      'vnp_ReturnUrl': vnp_ReturnUrl,
      'vnp_CreateDate': vnp_CreateDate,
    };

    // Sắp xếp key theo thứ tự từ điển
    final sortedKeys = params.keys.toList()..sort();
    // final query = sortedKeys.map((k) => '$k=${params[k]}').join('&');
    final query = sortedKeys
        .map((k) => '$k=${Uri.encodeComponent(params[k]!)}')
        .join('&');

    final rawData = sortedKeys.map((k) => '$k=${params[k]}').join('&');
    final secureHash = Hmac(sha512, utf8.encode(vnp_HashSecret))
        .convert(utf8.encode(rawData))
        .toString();

    final paymentUrl = '$vnp_Url?$query&vnp_SecureHash=$secureHash';

    if (await launchUrl(Uri.parse(paymentUrl))) {
      print('🔗 VNPay URL: $paymentUrl');

      await launchUrl(Uri.parse(paymentUrl),
          mode: LaunchMode.externalApplication);
    } else {
      print('⚠️ Không mở được URL: $paymentUrl');
      throw 'Không thể mở VNPay URL';
    }
  }
}
