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
    };
  }

  // Thêm vào Car model
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
    );
  }
}

