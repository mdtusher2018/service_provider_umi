// models/booking/booking_models.dart



import 'package:service_provider_umi/data/models/api_response.dart';

enum BookingStatus {
  pending,
  accepted,
  ongoing,
  completed,
  cancelled,
  rejected;

  static BookingStatus fromString(String value) =>
      BookingStatus.values.firstWhere(
        (e) => e.name == value,
        orElse: () => BookingStatus.pending,
      );
}

// ── Request ───────────────────────────────────────────────────────────────────

class BookingLocation {
  final String address;
  final List<double> coordinates;

  const BookingLocation({required this.address, required this.coordinates});

  Map<String, dynamic> toJson() => {
        'address': address,
        'coordinates': coordinates,
      };

  factory BookingLocation.fromJson(Map<String, dynamic> json) =>
      BookingLocation(
        address: json['address'] as String,
        coordinates: List<double>.from(
            (json['coordinates'] as List).map((e) => (e as num).toDouble())),
      );
}

class CreateBookingRequest {
  final String serviceProvider;
  final String date;
  final String startTime;
  final int duration;
  final BookingLocation location;
  final String? additionalInstruction;

  const CreateBookingRequest({
    required this.serviceProvider,
    required this.date,
    required this.startTime,
    required this.duration,
    required this.location,
    this.additionalInstruction,
  });

  Map<String, dynamic> toJson() => {
        'service_provider': serviceProvider,
        'date': date,
        'start_time': startTime,
        'duration': duration,
        'location': location.toJson(),
        if (additionalInstruction != null)
          'additional_instruction': additionalInstruction,
      };
}

// ── Booking List Item ─────────────────────────────────────────────────────────

class BookingItem {
  final String bookingId;
  final String bookingStatus;
  final String serviceName;
  final String serviceImageUrl;
  final String bookingDate;
  final String startTime;
  final String endTime;
  final double price;
  final String paidOnDate;
  final String? cancelledBy;

  const BookingItem({
    required this.bookingId,
    required this.bookingStatus,
    required this.serviceName,
    required this.serviceImageUrl,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.paidOnDate,
    this.cancelledBy,
  });

  factory BookingItem.fromJson(Map<String, dynamic> json) => BookingItem(
        bookingId: json['booking_id'] as String,
        bookingStatus: json['booking_status'] as String,
        serviceName: json['service_name'] as String,
        serviceImageUrl: json['service_image_url'] as String,
        bookingDate: json['booking_date'] as String,
        startTime: json['start_time'] as String,
        endTime: json['end_time'] as String,
        price: (json['price'] as num).toDouble(),
        paidOnDate: json['paid_on_date'] as String,
        cancelledBy: json['cancled_by'] as String?,
      );
}

class BookingsListResponse {
  final List<BookingItem> bookings;
  final PaginationMeta pagination;

  const BookingsListResponse({
    required this.bookings,
    required this.pagination,
  });

  factory BookingsListResponse.fromJson(Map<String, dynamic> json) =>
      BookingsListResponse(
        bookings: (json['data'] as List)
            .map((e) => BookingItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        pagination: PaginationMeta.fromJson(
            json['pagination'] as Map<String, dynamic>),
      );
}

// ── Booking Details ───────────────────────────────────────────────────────────

class BookingDetails {
  final String bookingId;
  final String status;
  final BookingProvider provider;
  final String? comments;
  final String date;
  final String startTime;
  final String endTime;
  final int durationMinutes;
  final BookingLocation location;
  final BookingService service;
  final BookingPricing pricing;

  const BookingDetails({
    required this.bookingId,
    required this.status,
    required this.provider,
    this.comments,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.location,
    required this.service,
    required this.pricing,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) => BookingDetails(
        bookingId: json['booking_id'] as String,
        status: json['status'] as String,
        provider: BookingProvider.fromJson(
            json['provider'] as Map<String, dynamic>),
        comments: json['comments'] as String?,
        date: json['date'] as String,
        startTime: json['start_time'] as String,
        endTime: json['end_time'] as String,
        durationMinutes: json['duration_minutes'] as int,
        location:
            BookingLocation.fromJson(json['location'] as Map<String, dynamic>),
        service:
            BookingService.fromJson(json['service'] as Map<String, dynamic>),
        pricing:
            BookingPricing.fromJson(json['pricing'] as Map<String, dynamic>),
      );
}

class BookingProvider {
  final String id;
  final String name;
  final String phone;
  final String avatarUrl;
  final bool chatEnabled;

  const BookingProvider({
    required this.id,
    required this.name,
    required this.phone,
    required this.avatarUrl,
    required this.chatEnabled,
  });

  factory BookingProvider.fromJson(Map<String, dynamic> json) =>
      BookingProvider(
        id: json['id'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        avatarUrl: json['avatar_url'] as String,
        chatEnabled: json['chat_enabled'] as bool,
      );
}

class BookingService {
  final String name;
  final double pricePerHour;

  const BookingService({required this.name, required this.pricePerHour});

  factory BookingService.fromJson(Map<String, dynamic> json) => BookingService(
        name: json['name'] as String,
        pricePerHour: (json['price_per_hour'] as num).toDouble(),
      );
}

class BookingPricing {
  final int bookingHours;
  final double subtotal;
  final double clientProtection;
  final double totalPrice;

  const BookingPricing({
    required this.bookingHours,
    required this.subtotal,
    required this.clientProtection,
    required this.totalPrice,
  });

  factory BookingPricing.fromJson(Map<String, dynamic> json) => BookingPricing(
        bookingHours: json['booking_hours'] as int,
        subtotal: (json['subtotal'] as num).toDouble(),
        clientProtection: (json['client_protection'] as num).toDouble(),
        totalPrice: (json['total_price'] as num).toDouble(),
      );
}
