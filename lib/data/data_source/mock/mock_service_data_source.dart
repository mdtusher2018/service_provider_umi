import 'package:service_provider_umi/data/data_source/remote/service_remote_data_source.dart';
import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/misc_models.dart';
import 'package:service_provider_umi/data/models/mock_service_provider_models.dart';
import 'package:service_provider_umi/data/models/provider_models.dart';
import 'package:service_provider_umi/data/models/search_models.dart';
import 'package:service_provider_umi/data/models/service_models.dart';
import 'package:service_provider_umi/data/models/booking_models.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';

class MockServiceDataSource implements ServiceRemoteDataSource {
  // ─── Mock Services ────────────────────────────────────────────────────────

  static final List<ServiceModel> _allServices = [
    ServiceModel(
      id: '1',
      name: 'Home',
      image:
          'https://static.vecteezy.com/system/resources/previews/010/151/123/original/house-symbol-and-home-icon-sign-design-free-png.png',
      haveSubcategory: false,
    ),
    ServiceModel(
      id: '2',
      name: 'Cleaning',
      image: 'https://cdn-icons-png.flaticon.com/256/12211/12211111.png',
      haveSubcategory: true,
    ),
    ServiceModel(
      id: '3',
      name: 'Care',
      image: 'https://cdn-icons-png.flaticon.com/512/6205/6205324.png',
      haveSubcategory: true,
    ),
    ServiceModel(
      id: '4',
      name: 'Pet Care',
      image: 'https://cdn-icons-png.flaticon.com/512/2138/2138410.png',
      haveSubcategory: false,
    ),
    ServiceModel(
      id: '5',
      name: 'Electrical',
      image:
          'https://tse3.mm.bing.net/th/id/OIP.yj0qQw6b2ZeMsAK1tL9TJAHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
      haveSubcategory: false,
    ),
    ServiceModel(
      id: '6',
      name: 'Others',
      image:
          'https://static.vecteezy.com/system/resources/previews/016/327/497/original/gift-box-3d-icon-render-illustration-png.png',
      haveSubcategory: false,
    ),
    ServiceModel(
      id: '7',
      name: 'Plumbing',
      image: 'https://picsum.photos/seed/plumbing/200',
      haveSubcategory: false,
    ),
    ServiceModel(
      id: '8',
      name: 'Electrical',
      image: 'https://picsum.photos/seed/electrical/200',
      haveSubcategory: false,
    ),
  ];

  static final Map<String, List<ServiceModel>> _subCategories = {
    'elderly_care': [
      ServiceModel(
        id: '21',
        name: 'Dementia Care',
        image: 'https://picsum.photos/seed/dementia/200',
        haveSubcategory: false,
      ),
      ServiceModel(
        id: '22',
        name: 'Palliative Care',
        image: 'https://picsum.photos/seed/palliative/200',
        haveSubcategory: false,
      ),
      ServiceModel(
        id: '23',
        name: 'Live-in Care',
        image: 'https://picsum.photos/seed/livein/200',
        haveSubcategory: false,
      ),
    ],
    'child_care': [
      ServiceModel(
        id: '31',
        name: 'Babysitting',
        image: 'https://cdn-icons-png.flaticon.com/512/6205/6205324.png',
        haveSubcategory: false,
      ),
      ServiceModel(
        id: '32',
        name: 'After School Care',
        image: 'https://cdn-icons-png.flaticon.com/512/2138/2138410.png',
        haveSubcategory: false,
      ),
    ],
    '2': [
      ServiceModel(
        id: '21',
        name: 'Dementia Care',
        image: 'https://picsum.photos/seed/dementia/200',
        haveSubcategory: false,
      ),
      ServiceModel(
        id: '22',
        name: 'Palliative Care',
        image: 'https://picsum.photos/seed/palliative/200',
        haveSubcategory: false,
      ),
      ServiceModel(
        id: '23',
        name: 'Live-in Care',
        image: 'https://picsum.photos/seed/livein/200',
        haveSubcategory: false,
      ),
    ],
    '3': [
      ServiceModel(
        id: '31',
        name: 'Babysitting',
        image: 'https://cdn-icons-png.flaticon.com/512/6205/6205324.png',
        haveSubcategory: false,
      ),
      ServiceModel(
        id: '32',
        name: 'After School Care',
        image: 'https://cdn-icons-png.flaticon.com/512/2138/2138410.png',
        haveSubcategory: false,
      ),
    ],
  };

  // ─── Mock Providers ───────────────────────────────────────────────────────

  static final List<ProviderSearchResult> _mockProviders = [
    ProviderSearchResult(
      id: 'provider_001',
      name: 'NB Sujon',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      verified: true,
      isLiked: false,
      rating: 5.0,
      reviewsCount: 12,
      servicesCount: 3,
      pricePerHour: 15.0,
      repeatedCount: 4,
    ),
    ProviderSearchResult(
      id: 'provider_002',
      name: 'Sarah Ahmed',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      verified: true,
      isLiked: true,
      rating: 4.8,
      reviewsCount: 27,
      servicesCount: 2,
      pricePerHour: 18.0,
      repeatedCount: 9,
    ),
    ProviderSearchResult(
      id: 'provider_003',
      name: 'Mr. Raju',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
      verified: false,
      isLiked: false,
      rating: 4.5,
      reviewsCount: 8,
      servicesCount: 1,
      pricePerHour: 12.0,
      repeatedCount: 2,
    ),
    ProviderSearchResult(
      id: 'provider_004',
      name: 'Fatima Begum',
      avatarUrl: 'https://i.pravatar.cc/150?img=9',
      verified: true,
      isLiked: true,
      rating: 4.9,
      reviewsCount: 41,
      servicesCount: 4,
      pricePerHour: 20.0,
      repeatedCount: 15,
    ),
    ProviderSearchResult(
      id: 'provider_005',
      name: 'Karim Uddin',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      verified: false,
      isLiked: false,
      rating: 4.2,
      reviewsCount: 5,
      servicesCount: 2,
      pricePerHour: 10.0,
      repeatedCount: 1,
    ),
    ProviderSearchResult(
      id: 'provider_006',
      name: 'Nasrin Islam',
      avatarUrl: 'https://i.pravatar.cc/150?img=16',
      verified: true,
      isLiked: false,
      rating: 4.7,
      reviewsCount: 19,
      servicesCount: 3,
      pricePerHour: 16.0,
      repeatedCount: 7,
    ),
  ];

  // ─── Mock Bookings ────────────────────────────────────────────────────────

  static final List<BookingItem> _mockBookings = [
    BookingItem(
      bookingId: 'b_101',
      bookingStatus: BookingStatus.accepted,
      serviceName: 'Elderly Care',
      serviceImageUrl: 'https://picsum.photos/seed/elderlycare/200',
      bookingDate: DateTime.now().add(const Duration(days: 2)).toString(),
      startTime: '10:00',
      endTime: '12:00',
      price: 30.0,
      paidOnDate: DateTime.now().subtract(const Duration(days: 1)).toString(),
    ),
    BookingItem(
      bookingId: 'b_102',
      bookingStatus: BookingStatus.pending,
      serviceName: 'Home Care',
      serviceImageUrl: 'https://picsum.photos/seed/homecare/200',
      bookingDate: DateTime.now().add(const Duration(days: 5)).toString(),
      startTime: '14:00',
      endTime: '16:00',
      price: 24.0,
      paidOnDate: DateTime.now().toString(),
    ),
    BookingItem(
      bookingId: 'b_103',
      bookingStatus: BookingStatus.completed,
      serviceName: 'Cleaning',
      serviceImageUrl: 'https://picsum.photos/seed/cleaning/200',
      bookingDate: DateTime.now().subtract(const Duration(days: 3)).toString(),
      startTime: '09:00',
      endTime: '11:00',
      price: 20.0,
      paidOnDate: DateTime.now().subtract(const Duration(days: 5)).toString(),
    ),
    BookingItem(
      bookingId: 'b_104',
      bookingStatus: BookingStatus.cancelled,
      serviceName: 'Child Care',
      serviceImageUrl: 'https://picsum.photos/seed/childcare/200',
      bookingDate: DateTime.now().subtract(const Duration(days: 7)).toString(),
      startTime: '13:00',
      endTime: '15:00',
      price: 28.0,
      paidOnDate: DateTime.now().subtract(const Duration(days: 8)).toString(),
      cancelledBy: 'Sarah Ahmed',
    ),
    BookingItem(
      bookingId: 'b_105',
      bookingStatus: BookingStatus.ongoing,
      serviceName: 'Elderly Care',
      serviceImageUrl: 'https://picsum.photos/seed/elderlycare/200',
      bookingDate: DateTime.now().toString(),
      startTime: '08:00',
      endTime: '10:00',
      price: 30.0,
      paidOnDate: DateTime.now().subtract(const Duration(days: 2)).toString(),
    ),
    BookingItem(
      bookingId: 'b_106',
      bookingStatus: BookingStatus.rejected,
      serviceName: 'Pet Care',
      serviceImageUrl: 'https://picsum.photos/seed/petcare/200',
      bookingDate: DateTime.now().subtract(const Duration(days: 10)).toString(),
      startTime: '11:00',
      endTime: '12:00',
      price: 15.0,
      paidOnDate: DateTime.now().subtract(const Duration(days: 11)).toString(),
    ),
  ];

  // ─── Mock FAQs ────────────────────────────────────────────────────────────

  static const Map<String, List<FaqItem>> _faqs = {
    'elderly_care': [
      FaqItem(
        id: 1,
        question: 'How does this service work?',
        answer:
            'Select a service, choose your schedule, and book a provider. '
            'The provider will confirm and arrive at your location.',
      ),
      FaqItem(
        id: 2,
        question: 'Can I cancel a booking?',
        answer:
            'Yes, you can cancel a booking up to 24 hours before the start '
            'time without any charge.',
      ),
      FaqItem(
        id: 3,
        question: 'Are providers background-checked?',
        answer:
            'All verified providers have undergone thorough background checks '
            'and identity verification.',
      ),
      FaqItem(
        id: 4,
        question: 'What payment methods are accepted?',
        answer:
            'We accept all major credit/debit cards and mobile banking payments.',
      ),
      FaqItem(
        id: 5,
        question: 'How do I contact support?',
        answer:
            'You can reach our support team via the in-app support section '
            'or call our helpline at any time.',
      ),
    ],
  };

  // ─── Implementations ──────────────────────────────────────────────────────

  @override
  Future<List<ServiceModel>> getAllCategories() async {
    await _delay();
    return _allServices;
  }

  @override
  Future<ServiceModel> getServiceById(String id) async {
    await _delay();
    return _allServices.firstWhere(
      (s) => s.id == id,
      orElse: () => throw Exception('Service not found: $id'),
    );
  }

  @override
  Future<List<ServiceModel>> getSubCategories(String serviceId) async {
    await _delay();
    final key = serviceId.toLowerCase().replaceAll(' ', '_');
    return _subCategories[key] ?? _subCategories[serviceId] ?? [];
  }

  @override
  Future<SearchProvidersResponse> searchProviders(
    SearchProvidersRequest request,
  ) async {
    await _delay(ms: 800);
    final page = request.page;
    final limit = request.limit;
    final total = _mockProviders.length;
    final start = ((page - 1) * limit).clamp(0, total);
    final end = (start + limit).clamp(0, total);
    return SearchProvidersResponse(
      results: _mockProviders.sublist(start, end),
      pagination: PaginationMeta(page: page, limit: limit, totalPage: total),
    );
  }

  @override
  Future<ServiceFiltersModel> getFilters(String serviceType) async {
    await _delay();
    return const ServiceFiltersModel(
      maxPrice: 50.0,
      tasks: [
        'Cleaning',
        'Cooking',
        'Medication reminder',
        'Personal hygiene',
        'Companionship',
        'Transportation',
      ],
      specializations: [
        'Senile dementia',
        'Parkinsons',
        'Stroke',
        'Multiple sclerosis',
        "Alzheimer's",
      ],
    );
  }

  @override
  Future<ProviderProfile> getProviderProfile(String providerId) async {
    await _delay(ms: 700);
    return ProviderProfile(
      id: providerId,
      name: _nameForProvider(providerId),
      serviceTitle: 'Elderly Care Specialist',
      profileImage:
          'https://i.pravatar.cc/300?img=${_imgForProvider(providerId)}',
      verified: true,
      hourlyRate: 15.0,
      about:
          'I am a dedicated and compassionate care professional with over 6 years of experience '
          'working with elderly clients. I specialize in dementia and palliative care, '
          'and I always strive to provide the highest quality of service.',
      rating: const ProviderRating(
        average: 4.9,
        totalReviews: 23,
        breakdown: RatingBreakdown(
          service: 5.0,
          punctuality: 4.8,
          kindness: 5.0,
          valueForMoney: 4.9,
          professionalism: 4.9,
        ),
      ),
      gallery: [
        'https://picsum.photos/seed/gallery1/400/300',
        'https://picsum.photos/seed/gallery2/400/300',
        'https://picsum.photos/seed/gallery3/400/300',
        'https://picsum.photos/seed/gallery4/400/300',
      ],
      questions: const [
        ProviderQuestion(
          question: 'How much experience do you have as a carer?',
          answer: '6–10 years of experience',
        ),
        ProviderQuestion(
          question: 'Do you have a driving license?',
          answer: 'Yes, I have a valid driving license.',
        ),
        ProviderQuestion(
          question: 'Are you qualified in palliative care?',
          answer: 'Yes, I hold a Level 3 certificate in palliative care.',
        ),
      ],
      comments: [
        ProviderComment(
          id: 'r_1',
          userName: 'Ana Silva',
          userImage: 'https://i.pravatar.cc/100?img=20',
          userVerified: true,
          rating: 5.0,
          comment:
              'The service was outstanding. Very punctual and professional.',
          createdAt: DateTime.now()
              .subtract(const Duration(days: 5))
              .toString(),
        ),
        ProviderComment(
          id: 'r_2',
          userName: 'Mark Johnson',
          userImage: 'https://i.pravatar.cc/100?img=33',
          userVerified: true,
          rating: 4.8,
          comment: 'Great with my mother. Would definitely book again.',
          createdAt: DateTime.now()
              .subtract(const Duration(days: 12))
              .toString(),
        ),
        ProviderComment(
          id: 'r_3',
          userName: 'Layla Hassan',
          userImage: 'https://i.pravatar.cc/100?img=47',
          userVerified: true,
          rating: 5.0,
          comment: 'Very kind and attentive. Highly recommended!',
          createdAt: DateTime.now()
              .subtract(const Duration(days: 20))
              .toString(),
        ),
      ],
      availability: ProviderAvailability(
        days: {
          'monday': [
            const AvailabilitySlot(start: '09:00', maxDurationMinutes: 480),
          ],
          'tuesday': [
            const AvailabilitySlot(start: '09:00', maxDurationMinutes: 480),
          ],
          'wednesday': [
            const AvailabilitySlot(start: '09:00', maxDurationMinutes: 240),
            const AvailabilitySlot(start: '14:00', maxDurationMinutes: 240),
          ],
          'thursday': [
            const AvailabilitySlot(start: '09:00', maxDurationMinutes: 480),
          ],
          'friday': [
            const AvailabilitySlot(start: '09:00', maxDurationMinutes: 360),
          ],
          'saturday': [
            const AvailabilitySlot(start: '10:00', maxDurationMinutes: 240),
          ],
          'sunday': [],
        },
        slotIntervalMinutes: 60,
      ),
    );
  }

  @override
  Future<void> createBooking(CreateBookingRequest request) async {
    await _delay(ms: 800);
  }

  @override
  Future<BookingsListResponse> getMyBookings({
    BookingStatus? status,
    int page = 1,
    int limit = 10,
  }) async {
    await _delay();
    var filtered = _mockBookings;
    if (status != null) {
      filtered = filtered.where((b) => b.bookingStatus == status).toList();
    }
    final total = filtered.length;
    final start = ((page - 1) * limit).clamp(0, total);
    final end = (start + limit).clamp(0, total);
    return BookingsListResponse(
      bookings: filtered.sublist(start, end),
      pagination: PaginationMeta(page: page, limit: limit, totalPage: total),
    );
  }

  @override
  Future<BookingDetails> getBookingDetail(String bookingId) async {
    await _delay();
    return BookingDetails(
      bookingId: bookingId,
      status: BookingStatus.accepted,
      provider: const BookingProvider(
        id: 'provider_003',
        name: 'Mr. Raju',
        phone: '+880 1840-560614',
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
        chatEnabled: true,
      ),
      comments: 'Please bring your own gloves.',
      date: '2026-04-10',
      startTime: '10:00',
      endTime: '12:00',
      durationMinutes: 120,
      location: const BookingLocation(
        address: 'Dhaka, Bangladesh',
        coordinates: [23.8103, 90.4125],
      ),
      service: const BookingService(name: 'Elderly Care', pricePerHour: 15.0),
      pricing: const BookingPricing(
        bookingHours: 2,
        subtotal: 30.0,
        clientProtection: 0.0,
        totalPrice: 30.0,
      ),
    );
  }

  @override
  Future<List<FaqItem>> getFaqs(String serviceType) async {
    await _delay(ms: 400);
    final key = serviceType.toLowerCase().replaceAll('-', '_');
    return _faqs[key] ?? _faqs['elderly_care'] ?? [];
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  String _nameForProvider(String id) {
    const names = {
      'provider_001': 'NB Sujon',
      'provider_002': 'Sarah Ahmed',
      'provider_003': 'Mr. Raju',
      'provider_004': 'Fatima Begum',
      'provider_005': 'Karim Uddin',
    };
    return names[id] ?? 'Provider $id';
  }

  int _imgForProvider(String id) {
    const imgs = {
      'provider_001': 1,
      'provider_002': 5,
      'provider_003': 3,
      'provider_004': 9,
      'provider_005': 12,
    };
    return imgs[id] ?? 7;
  }

  Future<void> _delay({int ms = 500}) =>
      Future.delayed(Duration(milliseconds: ms));
}
