// ─── work_schedule_models.dart ────────────────────────────────────────────────

import 'package:service_provider_umi/data/models/api_response.dart';

class WorkScheduleModel {
  final String id;
  final String userId;
  final String day; // Mon, Tue, Wed, Thu, Fri, Sat, Sun
  final DateTime startTime;
  final DateTime endTime;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WorkScheduleModel({
    required this.id,
    required this.userId,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkScheduleModel.fromJson(Map<String, dynamic> json) =>
      WorkScheduleModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        day: json['day'] as String,
        startTime: DateTime.parse(json['startTime'] as String),
        endTime: DateTime.parse(json['endTime'] as String),
        status: json['status'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'day': day,
    'startTime': startTime.toUtc().toIso8601String(),
    'endTime': endTime.toUtc().toIso8601String(),
    'status': status,
  };
}

// ─── List response wrapper ────────────────────────────────────────────────────

class WorkScheduleListResponse {
  final List<WorkScheduleModel> data;
  final PaginationMeta meta;

  const WorkScheduleListResponse({required this.data, required this.meta});

  factory WorkScheduleListResponse.fromJson(Map<String, dynamic> json) {
    final inner = json['data'] as Map<String, dynamic>;
    return WorkScheduleListResponse(
      data: (inner['data'] as List)
          .map((e) => WorkScheduleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PaginationMeta.fromJson(inner['meta'] as Map<String, dynamic>),
    );
  }
}

// ─── Request body item ────────────────────────────────────────────────────────

class WorkScheduleRequest {
  final String day;
  final String userId;
  final DateTime startTime;
  final DateTime endTime;
  final bool status;

  const WorkScheduleRequest({
    required this.day,
    required this.userId,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'day': day,
    'userId': userId,
    'startTime': startTime.toUtc().toIso8601String(),
    'endTime': endTime.toUtc().toIso8601String(),
    'status': status,
  };
}
