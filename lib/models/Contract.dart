import 'package:fe_capstone/models/car_model.dart';

class Contract {
  final int contractId;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final int parkingSpaceId;
  final String parkingSpaceName;
  final String parkingLotName;
  final String parkingLotAddress;
  final double totalAmount;
  final double totalAllPayments;
  final double lat;
  final double long;
  final String note;
  final Car car;
  final int paymentContractId;
  final int parkingLotId;
  final double parkingLotPrice;

  Contract({
    required this.contractId,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.parkingSpaceId,
    required this.parkingSpaceName,
    required this.totalAmount,
    required this.totalAllPayments,
    required this.parkingLotName,
    required this.parkingLotAddress,
    required this.lat,
    required this.long,
    required this.note,
    required this.car,
    required this.paymentContractId,
    required this.parkingLotId,
    required this.parkingLotPrice,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      contractId: json['contractId'] ?? 0,
      startDate: _parseContractDate(json['startDate']),
      endDate: _parseContractDate(json['endDate']),
      status: json['status'] ?? '',
      parkingSpaceId: json['parkingSpaceId'] ?? 0,
      parkingSpaceName: json['parkingSpaceName'] ?? '',
      parkingLotName: json['parkingLotName'] ?? '',
      parkingLotAddress: json['parkingLotAddress'] ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      totalAllPayments: (json['totalAllPayments'] as num?)?.toDouble() ?? 0.0,
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      long: (json['long'] as num?)?.toDouble() ?? 0.0,
      note: json['note'] ?? '',
      car: Car.fromJson(json['car'] ?? {}),
      paymentContractId: json['paymentContractId'] ?? 0,
      parkingLotId: json['parkingLotId'] ?? 0,
      parkingLotPrice: (json['parkingLotPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  static DateTime _parseContractDate(dynamic dateValue) {
    try {
      if (dateValue == null) return DateTime.now();

      final dateString = dateValue.toString();
      if (dateString.isEmpty) return DateTime.now();

      // Handle format: "2025/04/05 00:00"
      if (dateString.contains('/')) {
        final datePart = dateString.split(' ')[0];
        final parts = datePart.split('/');
        if (parts.length != 3) return DateTime.now();

        final year = int.tryParse(parts[0]) ?? DateTime.now().year;
        final month = int.tryParse(parts[1]) ?? 1;
        final day = int.tryParse(parts[2]) ?? 1;

        return DateTime(year, month, day);
      }

      // Handle ISO format
      return DateTime.parse(dateString);
    } catch (e) {
      print('Error parsing date $dateValue: $e');
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'contractId': contractId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'parkingSpaceId': parkingSpaceId,
      'parkingSpaceName': parkingSpaceName,
      'parkingLotName': parkingLotName,
      'parkingLotAddress': parkingLotAddress,
      'totalAmount': totalAmount,
      'totalAllPayments': totalAllPayments,
      'lat': lat,
      'long': long,
      'note': note,
      'car': car.toJson(),
      'paymentContractId': paymentContractId,
      'parkingLotId': parkingLotId,
      'parkingLotPrice': parkingLotPrice,
    };
  }
}
