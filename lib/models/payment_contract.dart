class PaymentContract {
  final int? paymentContractId;
  final String? startDate;
  final String? endDate;
  final double? pricePerMonth;
  final double? paymentAmount;
  final String? paymentMethod;
  final String? paymentDate;
  final String? status;
  final String? note;
  final String? createdDate;
  final String? startDateString;
  final String? endDateString;

  PaymentContract({
    this.paymentContractId,
    this.startDate,
    this.endDate,
    this.pricePerMonth,
    this.paymentAmount,
    this.paymentMethod,
    this.paymentDate,
    this.status,
    this.note,
    this.createdDate,
    this.startDateString,
    this.endDateString,
  });

  factory PaymentContract.fromJson(Map<String, dynamic> json) {
    return PaymentContract(
      paymentContractId: json['paymentContractId'] is int
          ? json['paymentContractId'] as int?
          : null, // Handle non-int values
      startDate: json['startDate'] is String ? json['startDate'] as String? : null,
      endDate: json['endDate'] is String ? json['endDate'] as String? : null,
      pricePerMonth: json['pricePerMonth'] is num
          ? (json['pricePerMonth'] as num?)?.toDouble()
          : null,
      paymentAmount: json['paymentAmount'] is num
          ? (json['paymentAmount'] as num?)?.toDouble()
          : null,
      paymentMethod: json['paymentMethod'] is String
          ? json['paymentMethod'] as String?
          : null,
      paymentDate: json['paymentDate'] is String
          ? json['paymentDate'] as String?
          : null,
      status: json['status'] is String ? json['status'] as String? : null,
      note: json['note'] is String ? json['note'] as String? : null,
      createdDate: json['createdDate'] is String
          ? json['createdDate'] as String?
          : null,
      startDateString: json['startDateString'] is String
          ? json['startDateString'] as String?
          : null,
      endDateString: json['endDateString'] is String
          ? json['endDateString'] as String?
          : null,
    );
  }

}