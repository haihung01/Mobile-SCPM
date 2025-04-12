class Entrance {
  final int entranceId;
  final String entranceDate;
  final String entranceTime;
  final String licensePlate;
  final String floorName;
  final String areaName;
  final String parkingLotName;
  final String parkingSpaceName;
  final String status;

  Entrance({
    required this.entranceId,
    required this.entranceDate,
    required this.entranceTime,
    required this.licensePlate,
    required this.floorName,
    required this.areaName,
    required this.parkingLotName,
    required this.parkingSpaceName,
    required this.status,
  });

  factory Entrance.fromJson(Map<String, dynamic> json) {
    return Entrance(
      entranceId: json['entranceId'] as int? ?? 0,
      entranceDate: json['entranceDate'] as String? ?? '',
      entranceTime: json['entranceTime'] as String? ?? '',
      licensePlate: json['licensePlate'] as String? ?? '',
      floorName: json['floorName'] as String? ?? '',
      areaName: json['areaName'] as String? ?? '',
      parkingLotName: json['parkingLotName'] as String? ?? '',
      parkingSpaceName: json['parkingSpaceName'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entranceId': entranceId,
      'entranceDate': entranceDate,
      'entranceTime': entranceTime,
      'licensePlate': licensePlate,
      'floorName': floorName,
      'areaName': areaName,
      'parkingLotName': parkingLotName,
      'parkingSpaceName': parkingSpaceName,
      'status': status,
    };
  }
}