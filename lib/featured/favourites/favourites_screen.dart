import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_card.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';

// ─── Model ────────────────────────────────────────────────────
class FavouriteProvider {
  final String id;
  final String name;
  final String? imageUrl;
  final String specialty;
  final double rating;
  final int reviewCount;
  final int serviceCount;
  final double pricePerHour;
  final bool isVerified;
  final bool hasRepeated;
  final bool hasUpdatedSchedule;

  const FavouriteProvider({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.serviceCount,
    required this.pricePerHour,
    this.isVerified = false,
    this.hasRepeated = false,
    this.hasUpdatedSchedule = false,
  });
}

// ─── Screen ───────────────────────────────────────────────────
class FavouritesScreen extends ConsumerStatefulWidget {
  const FavouritesScreen({super.key});

  @override
  ConsumerState<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  // Mock data - matches the design
  final List<FavouriteProvider> _favourites = const [
    FavouriteProvider(
      id: '1',
      name: 'NB Sujon',
      specialty: 'Elderly care',
      rating: 5.0,
      reviewCount: 1,
      serviceCount: 2,
      pricePerHour: 10,
      isVerified: true,
      hasRepeated: true,
      hasUpdatedSchedule: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: "Favourites",
        centerTitle: false,
        showBackButton: false,
        backgroundColor: AppColors.background,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: _favourites.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final p = _favourites[i];
          return ProviderCard(
            name: p.name,
            serviceType: "widget.category",
            rating: p.rating,
            reviewCount: p.reviewCount,
            serviceCount: p.serviceCount,
            pricePerHour: p.pricePerHour,
            isVerified: p.isVerified,
            hasRepeated: p.hasRepeated,
            hasUpdatedSchedule: p.hasUpdatedSchedule,
            onTap: () {
              // context.go('/user/services/provider/${p.id}');
            },
            onFavorite: () {},
          );
        },
      ),
    );
  }
}
