import 'driver.dart';

class DriverAssignment {
  final String id;
  final String driverId;
  final String customerId;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Driver? driver;
  final AssignmentCustomer? customer;

  DriverAssignment({
    required this.id,
    required this.driverId,
    required this.customerId,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.driver,
    this.customer,
  });

  factory DriverAssignment.fromJson(Map<String, dynamic> json) {
    return DriverAssignment(
      id: json['id'] ?? '',
      driverId: json['driver_id'] ?? '',
      customerId: json['customer_id'] ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      driver: json['driver'] != null ? Driver.fromJson(json['driver']) : null,
      customer: json['customer'] != null
          ? AssignmentCustomer.fromJson(json['customer'])
          : null,
    );
  }
}

class AssignmentCustomer {
  final String id;
  final String email;
  final String phone;
  final String fullName;
  final String role;
  final bool isActive;

  AssignmentCustomer({
    required this.id,
    required this.email,
    required this.phone,
    required this.fullName,
    required this.role,
    required this.isActive,
  });

  factory AssignmentCustomer.fromJson(Map<String, dynamic> json) {
    return AssignmentCustomer(
      id: json['ID'] ?? '',
      email: json['Email'] ?? '',
      phone: json['Phone'] ?? '',
      fullName: json['FullName'] ?? '',
      role: json['Role'] ?? '',
      isActive: json['IsActive'] ?? false,
    );
  }
}
