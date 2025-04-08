// customer_model.dart
class Customer {
  final int ownerId;
  final String username;

  Customer({
    required this.ownerId,
    required this.username,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      ownerId: json['customerId'] as int,
      username: json['username'] as String,
    );
  }
}