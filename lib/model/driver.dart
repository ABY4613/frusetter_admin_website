class Driver {
  final String id;
  final String email;
  final String phone;
  final String fullName;
  final String role;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Driver({
    required this.id,
    required this.email,
    required this.phone,
    required this.fullName,
    required this.role,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['ID'] ?? '',
      email: json['Email'] ?? '',
      phone: json['Phone'] ?? '',
      fullName: json['FullName'] ?? '',
      role: json['Role'] ?? '',
      isActive: json['IsActive'] ?? false,
      createdAt: json['CreatedAt'] != null
          ? DateTime.tryParse(json['CreatedAt'])
          : null,
      updatedAt: json['UpdatedAt'] != null
          ? DateTime.tryParse(json['UpdatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Email': email,
      'Phone': phone,
      'FullName': fullName,
      'Role': role,
      'IsActive': isActive,
      'CreatedAt': createdAt?.toIso8601String(),
      'UpdatedAt': updatedAt?.toIso8601String(),
    };
  }
}
