// import 'package:service_provider_umi/data/data_source/remote/service_remote_data_source.dart';
// import 'package:service_provider_umi/data/models/api_response.dart';
// import 'package:service_provider_umi/data/models/faq_model.dart';
// import 'package:service_provider_umi/data/models/mock_service_provider_models.dart';
// import 'package:service_provider_umi/data/models/provider_models.dart';
// import 'package:service_provider_umi/data/models/search_models.dart';
// import 'package:service_provider_umi/data/models/service_models.dart';
// import 'package:service_provider_umi/data/models/booking_models.dart';
// import 'package:service_provider_umi/data/models/user_models.dart';
// import 'package:service_provider_umi/data/models/work_schedule_model.dart';
// import 'package:service_provider_umi/shared/enums/app_enums.dart';
// import 'package:service_provider_umi/shared/enums/booking_status.dart';

// class MockServiceDataSource implements ServiceRemoteDataSource {
//   // ─── Mock Services ────────────────────────────────────────────────────────

//   static final List<ServiceModel> _allServices = [
//     ServiceModel(
//       id: '6a02ca9deb8a6e52452763a4',
//       name: 'Home',
//       image:
//           'https://static.vecteezy.com/system/resources/previews/010/151/123/original/house-symbol-and-home-icon-sign-design-free-png.png',
//       haveSubcategory: false,
//     ),
//     ServiceModel(
//       id: '69c4fa8a6db7d36f60fec4ad',
//       name: 'Cleaning',
//       image: 'https://cdn-icons-png.flaticon.com/256/12211/12211111.png',
//       haveSubcategory: true,
//     ),
//     ServiceModel(
//       id: '6a02caceeb8a6e52452763a5',
//       name: 'Care',
//       image: 'https://cdn-icons-png.flaticon.com/512/6205/6205324.png',
//       haveSubcategory: true,
//     ),
//     ServiceModel(
//       id: '69c4fa8a6db7d36f60fec4ad',
//       name: 'Pet Care',
//       image: 'https://cdn-icons-png.flaticon.com/512/2138/2138410.png',
//       haveSubcategory: false,
//     ),
//     ServiceModel(
//       id: '69c4fa8a6db7d36f60fec4ad',
//       name: 'Electrical',
//       image:
//           'https://tse3.mm.bing.net/th/id/OIP.yj0qQw6b2ZeMsAK1tL9TJAHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
//       haveSubcategory: false,
//     ),
//     ServiceModel(
//       id: '69c4fa8a6db7d36f60fec4ad',
//       name: 'Others',
//       image:
//           'https://static.vecteezy.com/system/resources/previews/016/327/497/original/gift-box-3d-icon-render-illustration-png.png',
//       haveSubcategory: false,
//     ),
//     ServiceModel(
//       id: '69c4fa8a6db7d36f60fec4ad',
//       name: 'Plumbing',
//       image: 'https://picsum.photos/seed/plumbing/200',
//       haveSubcategory: false,
//     ),
//     ServiceModel(
//       id: '69c4fa8a6db7d36f60fec4ad',
//       name: 'Electrical',
//       image: 'https://picsum.photos/seed/electrical/200',
//       haveSubcategory: false,
//     ),
//   ];

//   static final Map<String, List<ServiceModel>> _subCategories = {
//     'elderly_care': [
//       ServiceModel(
//         id: '21',
//         name: 'Dementia Care',
//         image: 'https://picsum.photos/seed/dementia/200',
//         haveSubcategory: false,
//       ),
//       ServiceModel(
//         id: '22',
//         name: 'Palliative Care',
//         image: 'https://picsum.photos/seed/palliative/200',
//         haveSubcategory: false,
//       ),
//       ServiceModel(
//         id: '23',
//         name: 'Live-in Care',
//         image: 'https://picsum.photos/seed/livein/200',
//         haveSubcategory: false,
//       ),
//     ],
//     'child_care': [
//       ServiceModel(
//         id: '31',
//         name: 'Babysitting',
//         image: 'https://cdn-icons-png.flaticon.com/512/6205/6205324.png',
//         haveSubcategory: false,
//       ),
//       ServiceModel(
//         id: '32',
//         name: 'After School Care',
//         image: 'https://cdn-icons-png.flaticon.com/512/2138/2138410.png',
//         haveSubcategory: false,
//       ),
//     ],
//     '2': [
//       ServiceModel(
//         id: '21',
//         name: 'Dementia Care',
//         image: 'https://picsum.photos/seed/dementia/200',
//         haveSubcategory: false,
//       ),
//       ServiceModel(
//         id: '22',
//         name: 'Palliative Care',
//         image: 'https://picsum.photos/seed/palliative/200',
//         haveSubcategory: false,
//       ),
//       ServiceModel(
//         id: '23',
//         name: 'Live-in Care',
//         image: 'https://picsum.photos/seed/livein/200',
//         haveSubcategory: false,
//       ),
//     ],
//     '3': [
//       ServiceModel(
//         id: '31',
//         name: 'Babysitting',
//         image: 'https://cdn-icons-png.flaticon.com/512/6205/6205324.png',
//         haveSubcategory: false,
//       ),
//       ServiceModel(
//         id: '32',
//         name: 'After School Care',
//         image: 'https://cdn-icons-png.flaticon.com/512/2138/2138410.png',
//         haveSubcategory: false,
//       ),
//     ],
//   };

//   // ─── Mock Providers ───────────────────────────────────────────────────────

//   static final List<ProviderSearchResult> _mockProviders = [
//     ProviderSearchResult(
//       id: '69ca1d079d5373b1fc1189d3',
//       name: 'NB Sujon',
//       avatarUrl: 'https://i.pravatar.cc/150?img=1',
//       verified: true,
//       isLiked: false,
//       rating: 5.0,
//       reviewsCount: 12,
//       servicesCount: 3,
//       pricePerHour: 15.0,
//       repeatedCount: 4,
//     ),
//     ProviderSearchResult(
//       id: '69ca1d079d5373b1fc1189d3',
//       name: 'Sarah Ahmed',
//       avatarUrl: 'https://i.pravatar.cc/150?img=5',
//       verified: true,
//       isLiked: true,
//       rating: 4.8,
//       reviewsCount: 27,
//       servicesCount: 2,
//       pricePerHour: 18.0,
//       repeatedCount: 9,
//     ),
//     ProviderSearchResult(
//       id: '69ca1d079d5373b1fc1189d3',
//       name: 'Mr. Raju',
//       avatarUrl: 'https://i.pravatar.cc/150?img=3',
//       verified: false,
//       isLiked: false,
//       rating: 4.5,
//       reviewsCount: 8,
//       servicesCount: 1,
//       pricePerHour: 12.0,
//       repeatedCount: 2,
//     ),
//     ProviderSearchResult(
//       id: '69ca1d079d5373b1fc1189d3',
//       name: 'Fatima Begum',
//       avatarUrl: 'https://i.pravatar.cc/150?img=9',
//       verified: true,
//       isLiked: true,
//       rating: 4.9,
//       reviewsCount: 41,
//       servicesCount: 4,
//       pricePerHour: 20.0,
//       repeatedCount: 15,
//     ),
//     ProviderSearchResult(
//       id: '69ca1d079d5373b1fc1189d3',
//       name: 'Karim Uddin',
//       avatarUrl: 'https://i.pravatar.cc/150?img=12',
//       verified: false,
//       isLiked: false,
//       rating: 4.2,
//       reviewsCount: 5,
//       servicesCount: 2,
//       pricePerHour: 10.0,
//       repeatedCount: 1,
//     ),
//     ProviderSearchResult(
//       id: '69ca1d079d5373b1fc1189d3',
//       name: 'Nasrin Islam',
//       avatarUrl: 'https://i.pravatar.cc/150?img=16',
//       verified: true,
//       isLiked: false,
//       rating: 4.7,
//       reviewsCount: 19,
//       servicesCount: 3,
//       pricePerHour: 16.0,
//       repeatedCount: 7,
//     ),
//   ];

//   // ─── Mock Bookings ────────────────────────────────────────────────────────

//   static final List<BookingModel> _mockBookings = [];

//   // ─── Mock FAQs ────────────────────────────────────────────────────────────

//   static const Map<String, List<FaqItem>> _faqs = {
//     'elderly_care': [
//       FaqItem(
//         id: "1",
//         question: 'How does this service work?',
//         answer:
//             'Select a service, choose your schedule, and book a provider. '
//             'The provider will confirm and arrive at your location.',
//       ),
//     ],
//   };

//   // ─── Implementations ──────────────────────────────────────────────────────

//   @override
//   Future<List<ServiceModel>> getAllCategories() async {
//     await _delay();
//     return _allServices;
//   }

//   @override
//   Future<ServiceModel> getServiceById(String id) async {
//     await _delay();
//     return _allServices.firstWhere(
//       (s) => s.id == id,
//       orElse: () => throw Exception('Service not found: $id'),
//     );
//   }

//   @override
//   Future<List<ServiceModel>> getSubCategories(String serviceId) async {
//     await _delay();
//     final key = serviceId.toLowerCase().replaceAll(' ', '_');
//     return _subCategories[key] ?? _subCategories[serviceId] ?? [];
//   }

//   @override
//   Future<SearchProvidersResponse> searchProviders(
//     SearchProvidersRequest request,
//   ) async {
//     await _delay(ms: 800);
//     final page = request.page;
//     final limit = request.limit;
//     final total = _mockProviders.length;
//     final start = ((page - 1) * limit).clamp(0, total);
//     final end = (start + limit).clamp(0, total);
//     return SearchProvidersResponse(
//       results: _mockProviders.sublist(start, end),
//       pagination: PaginationMeta(page: page, limit: limit, totalPage: total),
//     );
//   }

//   @override
//   Future<ServiceFiltersModel> getFilters() async {
//     await _delay();
//     return const ServiceFiltersModel(
//       experienceOptions: [],
//       othersTaskOptions: [],
//       category: [],
//     );
//   }

//   @override
//   Future<UserProfile> getProviderProfile(String providerId) async {
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> createBooking(CreateBookingRequest request) async {
//     await _delay(ms: 800);
//   }

//   @override
//   Future<BookingsListResponse> getMyBookings({
//     required int page,
//     required BookingStatus status,
//     required AppRole appRole,
//   }) async {
//     await _delay();
//     var filtered = _mockBookings;
//     int limit = 10;
//     final total = filtered.length;
//     final start = ((page - 1) * limit).clamp(0, total);
//     final end = (start + limit).clamp(0, total);
//     return BookingsListResponse(bookings: filtered.sublist(start, end));
//   }

//   @override
//   Future<BookingDetailModel> getBookingDetail(String bookingId) async {
//     throw UnimplementedError();
//   }

//   @override
//   Future<List<FaqItem>> getFaqs(String serviceType) async {
//     await _delay(ms: 400);
//     final key = serviceType.toLowerCase().replaceAll('-', '_');
//     return _faqs[key] ?? _faqs['elderly_care'] ?? [];
//   }

//   // ─── Helpers ──────────────────────────────────────────────────────────────

//   Future<void> _delay({int ms = 500}) =>
//       Future.delayed(Duration(milliseconds: ms));

//   // ── POST /workSchedule ───────────────────────────────────────────────────────
//   @override
//   Future<void> createWorkSchedule(List<WorkScheduleRequest> schedules) async {}

//   // ── PATCH /workSchedule ──────────────────────────────────────────────────────
//   @override
//   Future<void> updateWorkSchedule(List<WorkScheduleRequest> schedules) async {}

//   @override
//   Future<WorkScheduleListResponse> getWorkSchedule({
//     int? page,
//     int? limit,
//   }) async {
//     await _delay();
//     final total = 20;
//     final data = List.generate(
//       total,
//       (index) => WorkScheduleModel(
//         id: 'ws_${index + 1}',
//         userId: 'provider_001',
//         day: [
//           'Monday',
//           'Tuesday',
//           'Wednesday',
//           'Thursday',
//           'Friday',
//         ][index % 5],
//         startTime: DateTime.now().add(Duration(days: index, hours: 9)),
//         endTime: DateTime.now().add(Duration(days: index, hours: 17)),
//         status: index % 2 == 0,
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//       ),
//     );
//     return WorkScheduleListResponse(
//       data: data
//           .skip(((page ?? 1) - 1) * (limit ?? 10))
//           .take((limit ?? 10))
//           .toList(),
//       meta: PaginationMeta(
//         page: (page ?? 1),
//         limit: (limit ?? 10),
//         totalPage: total,
//       ),
//     );
//   }

//   @override
//   Future<UserProfile> updateServiceProviderProfile(
//     UpdateProviderRequest schedules,
//   ) {
//     // TODO: implement updateServiceProviderProfile
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> acceptBooking(String bookingId) {
//     // TODO: implement acceptBooking
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> rejectBooking(String bookingId) {
//     // TODO: implement rejectBooking
//     throw UnimplementedError();
//   }

//   @override
//   Future<List<ProviderComment>> getProviderReviews(String providerId) {
//     // TODO: implement getProviderReviews
//     throw UnimplementedError();
//   }
// }
