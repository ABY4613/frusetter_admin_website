import 'dart:convert';

class AdminLogResponse {
  final bool success;
  final AdminLogData data;

  AdminLogResponse({
    required this.success,
    required this.data,
  });

  factory AdminLogResponse.fromJson(Map<String, dynamic> json) => AdminLogResponse(
        success: json["success"],
        data: AdminLogData.fromJson(json["data"]),
      );
}

class AdminLogData {
  final List<AdminLog> logs;
  final Pagination pagination;

  AdminLogData({
    required this.logs,
    required this.pagination,
  });

  factory AdminLogData.fromJson(Map<String, dynamic> json) => AdminLogData(
        logs: List<AdminLog>.from(json["logs"].map((x) => AdminLog.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
      );
}

class AdminLog {
  final String id;
  final String userId;
  final String userRole;
  final String action;
  final String entityType;
  final String entityId;
  final String details;
  final DateTime createdAt;

  AdminLog({
    required this.id,
    required this.userId,
    required this.userRole,
    required this.action,
    required this.entityType,
    required this.entityId,
    required this.details,
    required this.createdAt,
  });

  factory AdminLog.fromJson(Map<String, dynamic> json) => AdminLog(
        id: json["id"],
        userId: json["user_id"],
        userRole: json["user_role"],
        action: json["action"],
        entityType: json["entity_type"],
        entityId: json["entity_id"],
        details: json["details"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> get parsedDetails {
    try {
      return json.decode(details);
    } catch (e) {
      return {"raw": details};
    }
  }
}

class Pagination {
  final int limit;
  final int page;
  final int total;
  final int totalPages;

  Pagination({
    required this.limit,
    required this.page,
    required this.total,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        limit: json["limit"],
        page: json["page"],
        total: json["total"],
        totalPages: json["total_pages"],
      );
}
