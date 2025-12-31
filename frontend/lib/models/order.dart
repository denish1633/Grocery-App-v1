class Order {
  final int id;
  final String status;
  final String? trackingNumber;
  final String totalAmount;
  final DateTime createdAt;
  

  Order({
    required this.id,
    required this.status,
    this.trackingNumber,
    required this.totalAmount,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      status: json['status'],
      trackingNumber: json['tracking_number'],
      totalAmount: json['total_amount'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
