class User {
  final String id;
  final String email;
  final String fullName;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'role': role,
    };
  }
}

class AuthResponse {
  final bool success;
  final AuthData? data;

  AuthResponse({
    required this.success,
    this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? AuthData.fromJson(json['data']) : null,
    );
  }
}

class AuthData {
  final String accessToken;
  final User user;

  AuthData({
    required this.accessToken,
    required this.user,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      accessToken: json['access_token'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }
}
