import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:service_provider_umi/core/services/network/dio_client.dart';
import 'package:service_provider_umi/core/services/revenuecat_service.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/featured/subscription/riverpod/subscription_provider.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// Backend Package Model
/// ─────────────────────────────────────────────────────────────────────────────
class SubscriptionPackage {
  final String id;
  final String name;
  final String type; // 'monthly' or 'annual'
  final double price;
  final String currency;
  final String? description;
  final int? savingsPercent;
  final String? productId; // RevenueCat/App Store product identifier
  final int? duration; // days

  const SubscriptionPackage({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.currency,
    this.description,
    this.savingsPercent,
    this.productId,
    this.duration,
  });

  factory SubscriptionPackage.fromJson(Map<String, dynamic> json) {
    // Determine type from duration if 'type' field is missing
    final duration = json['duration'] as int? ?? 0;
    String type = json['type'] ?? json['interval'] ?? '';
    if (type.isEmpty) {
      if (duration <= 31) {
        type = 'monthly';
      } else {
        type = 'annual';
      }
    }

    return SubscriptionPackage(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      type: type,
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      currency: json['currency'] ?? 'USD',
      description: json['description'],
      savingsPercent: json['savingsPercent'] ?? json['savings_percent'],
      productId: json['productId'] ?? json['product_id'],
      duration: duration,
    );
  }

  bool get isMonthly => type.toLowerCase().contains('month') || duration == 30;
  bool get isAnnual => type.toLowerCase().contains('annual') || type.toLowerCase().contains('year') || duration == 365;

  String get priceString {
    final symbol = currency == 'USD' ? '\$' : currency == 'EUR' ? '€' : currency == 'RON' ? 'RON ' : '$currency ';
    return '$symbol${price.toStringAsFixed(2)}';
  }

  String get periodSuffix => isMonthly ? '/month' : isAnnual ? '/year' : '';
}

/// ─────────────────────────────────────────────────────────────────────────────
/// FutureProvider to fetch packages from backend
/// ─────────────────────────────────────────────────────────────────────────────
final backendPackagesProvider = FutureProvider<List<SubscriptionPackage>>((ref) async {
  final dio = ref.watch(dioClientProvider);
  try {
    debugPrint('📡 [Packages] Fetching /packages...');
    final response = await dio.get('/packages');
    debugPrint('📡 [Packages] Status Code: ${response.statusCode}');
    debugPrint('📡 [Packages] Response Data: ${response.data}');

    if (response.statusCode == 200) {
      final data = response.data;
      List<dynamic> list;

      if (data is List) {
        list = data;
      } else if (data is Map<String, dynamic>) {
        // Handle: { data: { data: [...] } } or { data: [...] } or { packages: [...] }
        final innerData = data['data'];
        if (innerData is List) {
          list = innerData;
        } else if (innerData is Map<String, dynamic>) {
          list = innerData['data'] ?? innerData['packages'] ?? [];
        } else {
          list = data['packages'] ?? [];
        }
      } else {
        list = [];
      }

      debugPrint('📡 [Packages] Extracted list length: ${list.length}');
      final packages = list.map((e) => SubscriptionPackage.fromJson(e as Map<String, dynamic>)).toList();
      debugPrint('✅ [Packages] Fetched ${packages.length} packages');
      return packages;
    }
    throw Exception('Failed to fetch packages. Status: ${response.statusCode}');
  } catch (e) {
    debugPrint('❌ [Packages] Error: $e');
    rethrow;
  }
});

/// ─────────────────────────────────────────────────────────────────────────────
/// Premium Packages Screen
/// Shows Monthly & Annual subscription plans from Backend API
/// ─────────────────────────────────────────────────────────────────────────────
class PremiumPackagesScreen extends ConsumerStatefulWidget {
  const PremiumPackagesScreen({super.key});

  @override
  ConsumerState<PremiumPackagesScreen> createState() => _PremiumPackagesScreenState();
}

class _PremiumPackagesScreenState extends ConsumerState<PremiumPackagesScreen> {
  static const Color _cyanColor = Color(0xFF00B4D8);
  int _selectedIndex = -1;
  bool _isPurchasing = false;

  @override
  Widget build(BuildContext context) {
    final packagesAsync = ref.watch(backendPackagesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF334155)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const AppText.h3(
          'Choose Your Plan',
          color: Color(0xFF1E293B),
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: packagesAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: _cyanColor),
          ),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                  16.verticalSpace,
                  const AppText.bodyLg(
                    'Failed to load plans.',
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                  8.verticalSpace,
                  AppText.bodySm(
                    error.toString(),
                    color: const Color(0xFF94A3B8),
                  ),
                  16.verticalSpace,
                  TextButton(
                    onPressed: () => ref.invalidate(backendPackagesProvider),
                    child: const Text('Tap to retry', style: TextStyle(color: _cyanColor)),
                  ),
                ],
              ),
            ),
          ),
          data: (allPackages) {
            final packages = allPackages.where((p) => p.price > 0 && p.productId != 'free_trial').toList();
            if (packages.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey.shade400),
                      16.verticalSpace,
                      const AppText.bodyLg(
                        'No plans available right now.',
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                      8.verticalSpace,
                      const AppText.bodySm(
                        'Please check back later or contact support.',
                        color: Color(0xFF94A3B8),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  /// Header
                  const Icon(Icons.workspace_premium, size: 56, color: _cyanColor),
                  12.verticalSpace,
                  const AppText.h2(
                    'Upgrade to Premium',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                  8.verticalSpace,
                  const AppText.bodySm(
                    'Unlock all features and grow your business.',
                    color: Color(0xFF94A3B8),
                  ),
                  32.verticalSpace,

                  /// Package Cards
                  Expanded(
                    child: ListView.separated(
                      itemCount: packages.length,
                      separatorBuilder: (_, __) => 16.verticalSpace,
                      itemBuilder: (context, index) {
                        final package = packages[index];
                        final isSelected = _selectedIndex == index;

                        // Calculate savings for annual
                        String? savingsBadge;
                        if (package.isAnnual && packages.any((p) => p.isMonthly)) {
                          final monthlyPkg = packages.firstWhere((p) => p.isMonthly);
                          final monthlyAnnualCost = monthlyPkg.price * 12;
                          if (monthlyAnnualCost > package.price) {
                            final savings = ((monthlyAnnualCost - package.price) / monthlyAnnualCost * 100).round();
                            savingsBadge = 'Save $savings%';
                          }
                        }
                        if (package.savingsPercent != null && package.savingsPercent! > 0) {
                          savingsBadge = 'Save ${package.savingsPercent}%';
                        }

                        return GestureDetector(
                          onTap: () => setState(() => _selectedIndex = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? _cyanColor : const Color(0xFFE2E8F0),
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [BoxShadow(color: _cyanColor.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 4))]
                                  : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                            ),
                            child: Row(
                              children: [
                                /// Radio indicator
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? _cyanColor : const Color(0xFFCBD5E1),
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? Center(
                                          child: Container(
                                            width: 12,
                                            height: 12,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _cyanColor,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                16.horizontalSpace,

                                /// Plan details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: AppText.bodyLg(
                                              package.name,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF1E293B),
                                            ),
                                          ),
                                          if (savingsBadge != null) ...[
                                            8.horizontalSpace,
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF059669),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: AppText.bodySm(
                                                savingsBadge,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      4.verticalSpace,
                                      AppText.bodySm(
                                        '${package.priceString}${package.periodSuffix}',
                                        color: const Color(0xFF64748B),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      if (package.isAnnual) ...[
                                        2.verticalSpace,
                                        AppText.bodySm(
                                          '${(package.price / 12).toStringAsFixed(2)} ${package.currency}/month',
                                          color: const Color(0xFF94A3B8),
                                          fontSize: 12,
                                        ),
                                      ],
                                      if (package.description != null && package.description!.isNotEmpty) ...[
                                        4.verticalSpace,
                                        AppText.bodySm(
                                          package.description!,
                                          color: const Color(0xFF94A3B8),
                                          fontSize: 12,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  24.verticalSpace,

                  /// Subscribe Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedIndex >= 0 ? _cyanColor : const Color(0xFFCBD5E1),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: (_selectedIndex < 0 || _isPurchasing)
                          ? null
                          : () async {
                              setState(() => _isPurchasing = true);
                              try {
                                final selectedPackage = packages[_selectedIndex];
                                debugPrint('🛒 [Packages] Selected: ${selectedPackage.name} (productId: ${selectedPackage.productId})');

                                // Check if user already has this same product
                                final subState = ref.read(subscriptionProvider);
                                final currentProductId = subState.customerInfo
                                    ?.entitlements.all[RevenueCatService.entitlementId]
                                    ?.productIdentifier;

                                if (currentProductId == selectedPackage.productId) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('You are already subscribed to this plan.'),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                  }
                                  return;
                                }

                                // Find matching RevenueCat package by productId
                                final offerings = await RevenueCatService.instance.getOfferings();
                                Package? rcPackage;

                                if (offerings?.current != null) {
                                  for (final pkg in offerings!.current!.availablePackages) {
                                    if (pkg.storeProduct.identifier == selectedPackage.productId) {
                                      rcPackage = pkg;
                                      break;
                                    }
                                  }
                                }

                                // Also search all offerings if not found in current
                                if (rcPackage == null && offerings != null) {
                                  for (final offering in offerings.all.values) {
                                    for (final pkg in offering.availablePackages) {
                                      if (pkg.storeProduct.identifier == selectedPackage.productId) {
                                        rcPackage = pkg;
                                        break;
                                      }
                                    }
                                    if (rcPackage != null) break;
                                  }
                                }

                                if (rcPackage == null) {
                                  debugPrint('❌ [Packages] No matching RevenueCat package found for productId: ${selectedPackage.productId}');
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('This plan is not available for purchase on this platform yet. Please try again later.'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                  return;
                                }

                                debugPrint('✅ [Packages] Found RevenueCat package: ${rcPackage.identifier} -> ${rcPackage.storeProduct.identifier}');

                                // Purchase via RevenueCat (handles both new purchase & upgrade)
                                final success = await ref.read(subscriptionProvider.notifier).purchasePackage(rcPackage);

                                if (mounted && success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Successfully subscribed to ${selectedPackage.name}!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.of(context).pop();
                                } else if (mounted) {
                                  final errorMsg = ref.read(subscriptionProvider).errorMessage;
                                  if (errorMsg != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
                                    );
                                  }
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                                  );
                                }
                              } finally {
                                if (mounted) setState(() => _isPurchasing = false);
                              }
                            },
                      child: _isPurchasing
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const AppText.bodyLg(
                              'Subscribe Now',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                    ),
                  ),
                  16.verticalSpace,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
