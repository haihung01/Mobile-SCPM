// contract_model.dart
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
  final double lat;
  final double long;
  final String note;
  final Car car;
  final PaymentContract? paymentContract;
  final String currentStatus;

  Contract({
    required this.contractId,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.parkingSpaceId,
    required this.parkingSpaceName,
    required this.parkingLotName,
    required this.parkingLotAddress,
    required this.lat,
    required this.long,
    required this.note,
    required this.car,
    this.paymentContract,
    required this.currentStatus,
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
      lat: json['lat']?.toDouble() ?? 0.0,
      long: json['long']?.toDouble() ?? 0.0,
      note: json['note'] ?? '',
      car: Car.fromJson(json['car'] ?? {}),
      paymentContract: json['paymentContract'] != null
          ? PaymentContract.fromJson(json['paymentContract'])
          : null,
      currentStatus: json['currentStatus'] ?? '',
    );
  }

  static DateTime _parseContractDate(dynamic dateValue) {
    try {
      if (dateValue == null) return DateTime.now();

      final dateString = dateValue.toString();

      if (dateString.isEmpty) return DateTime.now();

      // Handle format: "2025/02/01 00:00"
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
      'lat': lat,
      'long': long,
      'note': note,
      'car': car.toJson(),
      'paymentContract': paymentContract?.toJson(),
      'currentStatus': currentStatus,
    };
  }
}

class PaymentContract {
  final int paymentContractId;
  final DateTime startDate;
  final DateTime endDate;
  final double paymentAmount;
  final String? paymentMethod;
  final String status;
  final String note;

  PaymentContract({
    required this.paymentContractId,
    required this.startDate,
    required this.endDate,
    required this.paymentAmount,
    this.paymentMethod,
    required this.status,
    required this.note,
  });

  factory PaymentContract.fromJson(Map<String, dynamic> json) {
    return PaymentContract(
      paymentContractId: json['paymentContractId'] ?? 0,
      startDate: Contract._parseContractDate(json['startDate']),
      endDate: Contract._parseContractDate(json['endDate']),
      paymentAmount: json['paymentAmount']?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'],
      status: json['status'] ?? '',
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentContractId': paymentContractId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'paymentAmount': paymentAmount,
      'paymentMethod': paymentMethod,
      'status': status,
      'note': note,
    };
  }
}

