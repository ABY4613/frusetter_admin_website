enum DeliveryStatus { pending, inProgress, delivered, cancelled }

class Delivery {
  final String id;
  final String customerName;
  final String address;
  final DateTime scheduledTime;
  final String driverName;
  final DeliveryStatus status;
  final List<String> items;

  Delivery({
    required this.id,
    required this.customerName,
    required this.address,
    required this.scheduledTime,
    required this.driverName,
    required this.status,
    required this.items,
  });
}
