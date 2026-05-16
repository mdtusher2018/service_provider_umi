// models/booking/booking_models.dart
import 'package:service_provider_umi/shared/enums/booking_status.dart';

// ── Request ───────────────────────────────────────────────────────────────────

class BookingDayRequest {
  final String day;
  final DateTime startTime;
  final DateTime endTime;
  final double durationHours;

  const BookingDayRequest({
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.durationHours,
  });

  Map<String, dynamic> toJson() => {
    'day': day,
    'startTime': startTime.toUtc().toIso8601String(),
    'endTime': endTime.toUtc().toIso8601String(),
    'durationHours': durationHours,
  };
}

class CreateBookingRequest {
  final String providerId;
  final double price;
  final DateTime startDate;
  final double totalHours;
  final String bookingType; // 'weekly' | 'once'
  final List<BookingDayRequest> bookingDays;

  const CreateBookingRequest({
    required this.providerId,
    required this.price,
    required this.startDate,
    required this.totalHours,
    required this.bookingType,
    required this.bookingDays,
  });

  Map<String, dynamic> toJson() => {
    'providerId': providerId,
    'price': price,
    'startDate': startDate.toUtc().toIso8601String(),
    'totalHours': totalHours,
    'bookingType': bookingType,
    'bookingDays': bookingDays.map((d) => d.toJson()).toList(),
  };
}

// ── Booking Details ───────────────────────────────────────────────────────────

class BookingDetailModel {
  final String id;
  final String userId;
  final String providerId;
  final bool isPaid;
  final String bookingType;
  final String status;
  final int price;
  final DateTime? startDate;
  final DateTime? endDate;
  final int totalHours;
  final bool isActive;
  final String? nextBooking;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final List<BookingTimeScheduleModel> bookingDays;
  final BookedUserDetailModel? user;
  final BookedProviderDetailModel? provider;
  final List<dynamic> payments;

  const BookingDetailModel({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.isPaid,
    required this.bookingType,
    required this.status,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.totalHours,
    required this.isActive,
    required this.nextBooking,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.provider,
    required this.payments,
    required this.bookingDays,
  });

  factory BookingDetailModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      providerId: json['providerId'] ?? '',
      isPaid: json['isPaid'] ?? false,
      bookingType: json['bookingType'] ?? '',
      status: json['status'] ?? '',
      price: json['price'] ?? 0,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'])
          : null,
      totalHours: json['totalHours'] ?? 0,
      isActive: json['isActive'] ?? false,
      nextBooking: json['nextBooking'],
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      user: json['user'] != null
          ? BookedUserDetailModel.fromJson(json['user'])
          : null,
      provider: json['provider'] != null
          ? BookedProviderDetailModel.fromJson(json['provider'])
          : null,
      payments: json['payments'] ?? [],
      bookingDays:
          (json['bookingDays'] as List<dynamic>?)
              ?.map((e) => BookingTimeScheduleModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class BookedUserDetailModel {
  final String id;
  final String name;
  final String email;
  final String? profile;
  final String? phoneNumber;

  const BookedUserDetailModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profile,
    required this.phoneNumber,
  });

  factory BookedUserDetailModel.fromJson(Map<String, dynamic> json) {
    return BookedUserDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profile: json['profile'],
      phoneNumber: json['phoneNumber'],
    );
  }
}

class BookedProviderDetailModel {
  final String id;
  final String name;
  final String email;
  final String? profile;
  final String? phoneNumber;
  final LocationModel? location;

  const BookedProviderDetailModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profile,
    required this.phoneNumber,
    required this.location,
  });

  factory BookedProviderDetailModel.fromJson(Map<String, dynamic> json) {
    return BookedProviderDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profile: json['profile'],
      phoneNumber: json['phoneNumber'],
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
    );
  }
}

class LocationModel {
  final String type;
  final List<double> coordinates;

  const LocationModel({required this.type, required this.coordinates});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      type: json['type'] ?? '',
      coordinates: (json['coordinates'] as List<dynamic>? ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}

// ── Booking List Item ─────────────────────────────────────────────────────────

class BookingsListResponse {
  final List<BookingModel> bookings;

  const BookingsListResponse({required this.bookings});

  factory BookingsListResponse.fromJson(Map<String, dynamic> json) =>
      BookingsListResponse(
        bookings: (json['data'] as List)
            .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class BookingModel {
  final String id;
  final String userId;
  final String providerId;
  final bool isPaid;
  final String bookingType;
  final int price;
  final DateTime? startDate;
  final DateTime? endDate;
  final int totalHours;
  final bool isActive;
  final String? nextBooking;
  final BookingStatus status;
  final bool isDeleted;

  final _BookedUserModel? user;
  final _BookedProviderModel? provider;
  final List<BookingTimeScheduleModel> bookingDays;

  BookingModel({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.isPaid,
    required this.bookingType,
    required this.price,
    this.startDate,
    this.endDate,
    required this.totalHours,
    required this.isActive,
    this.nextBooking,
    required this.status,
    required this.isDeleted,
    this.user,
    this.provider,
    required this.bookingDays,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
    id: json['id'] ?? '',
    userId: json['userId'] ?? '',
    providerId: json['providerId'] ?? '',
    isPaid: json['isPaid'] ?? false,
    bookingType: json['bookingType'] ?? '',
    price: json['price'] ?? 0,
    startDate: json['startDate'] != null
        ? DateTime.tryParse(json['startDate'])
        : null,
    endDate: json['endDate'] != null
        ? DateTime.tryParse(json['endDate'])
        : null,
    totalHours: json['totalHours'] ?? 0,
    isActive: json['isActive'] ?? false,
    nextBooking: json['nextBooking'],
    isDeleted: json['isDeleted'] ?? false,
    user: json['user'] != null ? _BookedUserModel.fromJson(json['user']) : null,
    provider: json['provider'] != null
        ? _BookedProviderModel.fromJson(json['provider'])
        : null,
    bookingDays:
        (json['bookingDays'] as List<dynamic>?)
            ?.map((e) => BookingTimeScheduleModel.fromJson(e))
            .toList() ??
        [],
    status: BookingStatus.fromString(json['status'] as String),
  );
}

class _BookedUserModel {
  final String id;
  final String name;
  final String email;
  final String profile;
  final String phoneNumber;

  _BookedUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profile,
    required this.phoneNumber,
  });

  factory _BookedUserModel.fromJson(Map<String, dynamic> json) =>
      _BookedUserModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        profile: json['profile'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
      );
}

class _BookedProviderModel {
  final String id;
  final String name;
  final String email;
  final String profile;
  final String phoneNumber;
  final String serviceName;

  _BookedProviderModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profile,
    required this.phoneNumber,
    required this.serviceName,
  });

  factory _BookedProviderModel.fromJson(
    Map<String, dynamic> json,
  ) => _BookedProviderModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    profile: json['profile'] ?? '',
    phoneNumber: json['phoneNumber'] ?? '',
    serviceName:
        json['serviceProviderInfo']?['specialistsIn']?[0]?['category']?['name'] ??
        '',
  );
}

class BookingTimeScheduleModel {
  final String id;
  final String day;
  final DateTime? startTime;
  final DateTime? endTime;
  final int durationHours;
  final BookingStatus status;

  BookingTimeScheduleModel({
    required this.id,
    required this.day,
    this.startTime,
    this.endTime,
    required this.durationHours,
    required this.status,
  });

  factory BookingTimeScheduleModel.fromJson(Map<String, dynamic> json) =>
      BookingTimeScheduleModel(
        id: json['id'] ?? '',
        day: json['day'] ?? '',
        startTime: json['startTime'] != null
            ? DateTime.tryParse(json['startTime'])
            : null,
        endTime: json['endTime'] != null
            ? DateTime.tryParse(json['endTime'])
            : null,
        durationHours: json['durationHours'] ?? 0,
        status: BookingStatus.fromString(json['status'] as String),
      );
}

