import 'package:fe_capstone/models/entrance_model.dart';

class Car {
  final int carId;
  final int customerId;
  final String model;
  final String color;
  final String licensePlate;
  final String registedDate;
  final bool status;
  final List<dynamic> contracts;
  final dynamic customer;
  final Entrance? entrance;
  final String? thumbnail;
  final String brand;

  Car({
    required this.carId,
    required this.customerId,
    required this.model,
    required this.color,
    required this.licensePlate,
    required this.registedDate,
    required this.status,
    required this.contracts,
    required this.customer,
    this.entrance,
    this.thumbnail,
    required this.brand,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      carId: json['carId'] as int? ?? 0,
      customerId: json['customerId'] as int? ?? 0,
      model: json['model'] as String? ?? '',
      color: json['color'] as String? ?? '',
      licensePlate: json['licensePlate'] as String? ?? '',
      registedDate: json['registedDate'] as String? ?? '',
      status: json['status'] as bool? ?? false,
      contracts: json['contracts'] as List<dynamic>? ?? [],
      customer: json['customer'],
      entrance: json['entrance'] != null
          ? Entrance.fromJson(json['entrance'] as Map<String, dynamic>)
          : null,
      thumbnail: json['thumbnail'] as String?,
      brand: json['brand'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'carId': carId,
      'customerId': customerId,
      'model': model,
      'color': color,
      'licensePlate': licensePlate,
      'registedDate': registedDate,
      'status': status,
      'contracts': contracts,
      'customer': customer,
      'entrance': entrance?.toJson(),
      'thumbnail': thumbnail,
      "brand": brand,
    };
  }

  Car copyWith({
    int? carId,
    int? customerId,
    String? model,
    String? color,
    String? licensePlate,
    String? registedDate,
    bool? status,
    List<dynamic>? contracts,
    dynamic customer,
    Entrance? entrance,
    String? thumbnail,
    String? brand,
  }) {
    return Car(
      carId: carId ?? this.carId,
      customerId: customerId ?? this.customerId,
      model: model ?? this.model,
      color: color ?? this.color,
      licensePlate: licensePlate ?? this.licensePlate,
      registedDate: registedDate ?? this.registedDate,
      status: status ?? this.status,
      contracts: contracts ?? this.contracts,
      customer: customer ?? this.customer,
      entrance: entrance ?? this.entrance,
      thumbnail: thumbnail ?? this.thumbnail,
      brand: brand ?? this.brand,
    );
  }
}
