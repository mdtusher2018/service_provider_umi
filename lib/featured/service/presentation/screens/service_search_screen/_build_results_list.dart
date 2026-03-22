part of 'service_search_results_screen.dart';

// Mocked provider results
final List<_ProviderResult> _providers = [
  _ProviderResult(
    id: '1',
    name: 'NB Sujon',
    rating: 5.0,
    reviews: 1,
    serviceCount: 2,
    pricePerHour: 10,
    isVerified: true,
    hasRepeated: true,
    hasUpdatedSchedule: true,
  ),
  _ProviderResult(
    id: '2',
    name: 'NB Sujon',
    rating: 5.0,
    reviews: 1,
    serviceCount: 2,
    pricePerHour: 15,
    isVerified: true,
    hasRepeated: false,
    hasUpdatedSchedule: true,
  ),
  _ProviderResult(
    id: '3',
    name: 'NB Sujon',
    rating: 5.0,
    reviews: 1,
    serviceCount: 2,
    pricePerHour: 20,
    isVerified: true,
    hasRepeated: true,
    hasUpdatedSchedule: false,
  ),
];

Widget _buildResultsList({required WidgetRef ref, required String category}) {
  return ListView.separated(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
    itemCount: _providers.length,
    separatorBuilder: (_, __) => 12.verticalSpace,
    itemBuilder: (_, i) {
      final p = _providers[i];
      return ProviderCard(
        name: p.name,
        serviceType: category,
        rating: p.rating,
        reviewCount: p.reviews,
        serviceCount: p.serviceCount,
        pricePerHour: p.pricePerHour,
        isVerified: p.isVerified,
        hasRepeated: p.hasRepeated,
        hasUpdatedSchedule: p.hasUpdatedSchedule,
        onTap: () {
          Navigator.push(
            ref.context,
            MaterialPageRoute(
              builder: (context) {
                return ProviderProfileScreen(providerId: "");
              },
            ),
          );
        },
        onFavorite: () {},
      );
    },
  );
}
