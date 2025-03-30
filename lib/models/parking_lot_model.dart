class ParkingLot {
  final int parkingLotId;
  final int ownerId;
  final double pricePerHour;
  final double pricePerDay;
  final double pricePerMonth;
  final String address;
  final double long;
  final double lat;
  final String createdDate;
  final String updatedDate;
  final List<dynamic> areas;
  final dynamic owner;
  final List<dynamic> parkingLotPriceHistories;

  ParkingLot({
    required this.parkingLotId,
    required this.ownerId,
    required this.pricePerHour,
    required this.pricePerDay,
    required this.pricePerMonth,
    required this.address,
    required this.long,
    required this.lat,
    required this.createdDate,
    required this.updatedDate,
    required this.areas,
    required this.owner,
    required this.parkingLotPriceHistories,
  });

  factory ParkingLot.fromJson(Map<String, dynamic> json) {
    return ParkingLot(
      parkingLotId: json['parkingLotId'] as int? ?? 0,
      ownerId: json['ownerId'] as int? ?? 0,
      pricePerHour: (json['pricePerHour'] as num?)?.toDouble() ?? 0.0,
      pricePerDay: (json['pricePerDay'] as num?)?.toDouble() ?? 0.0,
      pricePerMonth: (json['pricePerMonth'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] as String? ?? '',
      long: (json['long'] as num?)?.toDouble() ?? 0.0,
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      createdDate: json['createdDate'] as String? ?? '',
      updatedDate: json['updatedDate'] as String? ?? '',
      areas: json['areas'] as List<dynamic>? ?? [],
      owner: json['owner'],
      parkingLotPriceHistories: json['parkingLotPriceHistories'] as List<dynamic>? ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parkingLotId': parkingLotId,
      'ownerId': ownerId,
      'pricePerHour': pricePerHour,
      'pricePerDay': pricePerDay,
      'pricePerMonth': pricePerMonth,
      'address': address,
      'long': long,
      'lat': lat,
      'createdDate': createdDate,
      'updatedDate': updatedDate,
      'areas': areas,
      'owner': owner,
      'parkingLotPriceHistories': parkingLotPriceHistories,
    };
  }
}