import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:service_provider_umi/core/services/revenuecat_service.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// Subscription State Model
/// ─────────────────────────────────────────────────────────────────────────────
class SubscriptionState {
  final bool isLoading;
  final bool hasActiveAccess;
  final bool isInTrial;
  final bool isEligibleForTrial;
  final int remainingTrialDays;
  final CustomerInfo? customerInfo;
  final Offerings? offerings;
  final String? errorMessage;
  final bool isSuccess;

  const SubscriptionState({
    this.isLoading = false,
    this.hasActiveAccess = false,
    this.isInTrial = false,
    this.isEligibleForTrial = true,
    this.remainingTrialDays = 0,
    this.customerInfo,
    this.offerings,
    this.errorMessage,
    this.isSuccess = false,
  });

  SubscriptionState copyWith({
    bool? isLoading,
    bool? hasActiveAccess,
    bool? isInTrial,
    bool? isEligibleForTrial,
    int? remainingTrialDays,
    CustomerInfo? customerInfo,
    Offerings? offerings,
    String? errorMessage,
    bool? isSuccess,
    bool clearError = false,
  }) {
    return SubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      hasActiveAccess: hasActiveAccess ?? this.hasActiveAccess,
      isInTrial: isInTrial ?? this.isInTrial,
      isEligibleForTrial: isEligibleForTrial ?? this.isEligibleForTrial,
      remainingTrialDays: remainingTrialDays ?? this.remainingTrialDays,
      customerInfo: customerInfo ?? this.customerInfo,
      offerings: offerings ?? this.offerings,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// Subscription Notifier (Riverpod)
/// ─────────────────────────────────────────────────────────────────────────────
class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  StreamSubscription<CustomerInfo>? _infoSub;

  SubscriptionNotifier() : super(const SubscriptionState());

  /// 1. Initialize for current Provider ID
  Future<void> init(String providerId) async {
    debugPrint('🚀 [SubscriptionProvider] Initializing for providerId: $providerId');
    state = state.copyWith(isLoading: true, clearError: true);
    await RevenueCatService.instance.init(providerId);

    // Listen to real-time subscription status changes from RevenueCat SDK
    _infoSub?.cancel();
    _infoSub = RevenueCatService.instance.customerInfoStream.listen((info) {
      debugPrint('🔄 [SubscriptionProvider] Real-time CustomerInfo updated');
      _updateFromCustomerInfo(info);
    });

    final info = await RevenueCatService.instance.getCustomerInfo();
    debugPrint('📦 [SubscriptionProvider] Initial CustomerInfo fetched: ${info != null}');
    
    final offerings = await RevenueCatService.instance.getOfferings();
    debugPrint('🏷️ [SubscriptionProvider] Offerings fetched: ${offerings?.current != null}');
    if (offerings?.current != null) {
      debugPrint('   - Current Offering ID: ${offerings!.current!.identifier}');
      debugPrint('   - Available Packages: ${offerings.current!.availablePackages.length}');
    }

    _updateFromCustomerInfo(info, offerings: offerings);
  }

  void _updateFromCustomerInfo(CustomerInfo? info, {Offerings? offerings}) {
    final service = RevenueCatService.instance;
    final hasAccess = service.hasActiveAccess(info);
    final inTrial = service.isInTrial(info);
    final eligible = service.isEligibleForTrial(info);
    final daysLeft = service.getRemainingTrialDays(info);

    debugPrint('📊 [SubscriptionProvider] Status Updated:');
    debugPrint('   - Has Active Access: $hasAccess');
    debugPrint('   - In Trial: $inTrial');
    debugPrint('   - Eligible for Trial: $eligible');
    debugPrint('   - Days Left: $daysLeft');

    state = state.copyWith(
      isLoading: false,
      hasActiveAccess: hasAccess,
      isInTrial: inTrial,
      isEligibleForTrial: eligible,
      remainingTrialDays: daysLeft,
      customerInfo: info,
      offerings: offerings ?? state.offerings,
    );
  }

  /// 2. Activate 30-Day Free Trial
  /// As per requirements: "No payment should be required to activate the trial."
  Future<bool> activateFreeTrial() async {
    debugPrint('🚀 [SubscriptionProvider] activateFreeTrial() called!');
    
    if (!state.isEligibleForTrial) {
      debugPrint('❌ [SubscriptionProvider] User is NOT eligible for trial.');
      state = state.copyWith(errorMessage: 'You have already used your 30-day free trial on this account.');
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      if (state.offerings?.current == null || state.offerings!.current!.availablePackages.isEmpty) {
        debugPrint('❌ [SubscriptionProvider] Offerings or availablePackages is empty!');
        throw Exception('No packages available in RevenueCat Offerings. Please check RevenueCat Dashboard & App Store Connect.');
      }

      // Check if there is an introductory free trial package configured in RevenueCat
      final trialPackage = state.offerings!.current!.availablePackages.firstWhere(
        (p) => p.packageType == PackageType.custom || p.identifier == RevenueCatService.trialOfferingId,
        orElse: () => state.offerings!.current!.availablePackages.first,
      );

      debugPrint('📦 [SubscriptionProvider] Attempting to purchase package: ${trialPackage.identifier}');
      final info = await RevenueCatService.instance.purchasePackage(trialPackage);
      debugPrint('✅ [SubscriptionProvider] Purchase successful!');
      _updateFromCustomerInfo(info);
      return true;
    } catch (e, stacktrace) {
      debugPrint('❌ [SubscriptionProvider] Error in activateFreeTrial: $e');
      debugPrint('$stacktrace');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// 3. Purchase a Paid Subscription Package (Monthly or Annual)
  Future<bool> purchasePackage(Package package) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final info = await RevenueCatService.instance.purchasePackage(package);
      _updateFromCustomerInfo(info);
      state = state.copyWith(isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// 4. Restore Purchases (Reinstall or Device Change)
  Future<bool> restorePurchases() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final info = await RevenueCatService.instance.restorePurchases();
      _updateFromCustomerInfo(info);
      if (RevenueCatService.instance.hasActiveAccess(info)) {
        state = state.copyWith(isSuccess: true);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'No active subscription or free trial found to restore for this account.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  @override
  void dispose() {
    _infoSub?.cancel();
    super.dispose();
  }
}

/// Global Provider for Subscription State
final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
  return SubscriptionNotifier();
});
