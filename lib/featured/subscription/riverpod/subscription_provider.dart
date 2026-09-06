import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:service_provider_umi/core/services/network/dio_client.dart';
import 'package:service_provider_umi/core/services/revenuecat_service.dart';
import 'package:service_provider_umi/core/services/storage/local_storage_service.dart';
import 'package:service_provider_umi/core/services/storage/storage_key.dart';
import 'package:service_provider_umi/core/di/core_providers.dart';

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
  final bool isInitialized;
  
  // Backend parsed data
  final Map<String, dynamic>? backendSubscription;

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
    this.isInitialized = false,
    this.backendSubscription,
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
    bool? isInitialized,
    bool clearError = false,
    Map<String, dynamic>? backendSubscription,
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
      isInitialized: isInitialized ?? this.isInitialized,
      backendSubscription: backendSubscription ?? this.backendSubscription,
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// Subscription Notifier (Riverpod)
/// ─────────────────────────────────────────────────────────────────────────────
class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  StreamSubscription<CustomerInfo>? _infoSub;

  SubscriptionNotifier(this._dio, this._storage) : super(SubscriptionState(
    hasActiveAccess: _storage.readSync(StorageKey.hasActiveSubscription) ?? false,
  ));
  
  final Dio _dio;
  final LocalStorageService _storage;

  /// 1. Initialize for current Provider ID
  Future<void> init(String providerId) async {
    if (state.isInitialized) return; // Prevent multiple calls
    debugPrint('🚀 [SubscriptionProvider] Initializing for providerId: $providerId');
    state = state.copyWith(isLoading: true, clearError: true, isInitialized: true);
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
    await fetchBackendSubscription();
    _backendCheckCompleted = true;
    _evaluateOverallAccess();
  }

  bool _backendCheckCompleted = false;

  /// Fetch current subscription from backend and update state accordingly
  Future<void> fetchBackendSubscription() async {
    try {
      debugPrint('📡 [SubscriptionProvider] GET /subscriptions/current...');
      final response = await _dio.get('/subscriptions/current');
      
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];
        if (data != null) {
          final bool hasActiveSubscription = data['hasActiveSubscription'] ?? false;
          final subscription = data['subscription'];
          
          bool isTrial = false;
          int daysLeft = 0;
          
          if (subscription != null) {
            isTrial = subscription['productId'] == 'free_trial';
            daysLeft = subscription['daysRemaining'] ?? 0;
            
            // Determine eligibility based on if they ever had a free trial (or active sub)
            // If they have any subscription record, they likely aren't eligible for a new trial.
          }
          
          state = state.copyWith(
            isInTrial: state.isInTrial || isTrial,
            remainingTrialDays: state.remainingTrialDays > 0 ? state.remainingTrialDays : daysLeft,
            isEligibleForTrial: subscription == null && !hasActiveSubscription,
            backendSubscription: subscription,
          );
          
          _evaluateOverallAccess();
          
          debugPrint('✅ [SubscriptionProvider] Merged backend status. Active: \${state.hasActiveAccess}, Trial: \${state.isInTrial}, Days: \${state.remainingTrialDays}');
        }
      }
    } catch (e) {
      debugPrint('❌ [SubscriptionProvider] Error fetching backend subscription: $e');
    }
  }

  void _updateFromCustomerInfo(CustomerInfo? info, {Offerings? offerings}) {
    final service = RevenueCatService.instance;
    final rcHasAccess = service.hasActiveAccess(info);
    final inTrial = service.isInTrial(info);
    final eligible = service.isEligibleForTrial(info);
    final daysLeft = service.getRemainingTrialDays(info);
    
    // Check if backend previously confirmed we have access
    final backendHasAccess = state.backendSubscription != null && 
        (state.backendSubscription!['isActive'] == true || state.backendSubscription!['isPaid'] == true);

    debugPrint('📊 [SubscriptionProvider] Status Updated:');
    debugPrint('   - Has Active Access (RC): $rcHasAccess');
    debugPrint('   - Has Active Access (Backend): $backendHasAccess');
    debugPrint('   - In Trial: $inTrial');
    debugPrint('   - Eligible for Trial: $eligible');
    debugPrint('   - Days Left: $daysLeft');
    state = state.copyWith(
      isLoading: false,
      isInTrial: inTrial || state.isInTrial,
      isEligibleForTrial: eligible,
      remainingTrialDays: daysLeft > 0 ? daysLeft : state.remainingTrialDays,
      customerInfo: info,
      offerings: offerings ?? state.offerings,
    );
    
    _evaluateOverallAccess();
  }

  void _evaluateOverallAccess() {
    final rcHasAccess = RevenueCatService.instance.hasActiveAccess(state.customerInfo);
    final backendHasAccess = state.backendSubscription != null && 
        (state.backendSubscription!['isActive'] == true || state.backendSubscription!['isPaid'] == true);

    // If the backend check hasn't completed yet, trust the optimistic cache or RC
    if (!_backendCheckCompleted) {
      state = state.copyWith(
        hasActiveAccess: rcHasAccess || state.hasActiveAccess,
      );
    } else {
      // Once both RC and backend are fully loaded, strictly evaluate the true access
      final hasTrueAccess = rcHasAccess || backendHasAccess;
      if (state.hasActiveAccess != hasTrueAccess) {
        state = state.copyWith(hasActiveAccess: hasTrueAccess);
      }
    }
    
    // Always keep cache in sync with state
    _storage.write(StorageKey.hasActiveSubscription, state.hasActiveAccess);
  }

  /// 2. Activate 30-Day Free Trial
  Future<bool> activateFreeTrial() async {
    debugPrint('🚀 [SubscriptionProvider] activateFreeTrial() via Backend API called!');
    
    if (!state.isEligibleForTrial) {
      debugPrint('❌ [SubscriptionProvider] User is NOT eligible for trial.');
      state = state.copyWith(errorMessage: 'You have already used your 30-day free trial on this account.');
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      debugPrint('📡 [SubscriptionProvider] POST /subscriptions/free-trial...');
      final response = await _dio.post('/subscriptions/free-trial');
      debugPrint('📡 [SubscriptionProvider] Status: ${response.statusCode}');
      debugPrint('📡 [SubscriptionProvider] Response: ${response.data}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ [SubscriptionProvider] Backend free trial activated successfully!');
        
        // Optimistically update UI so it unlocks immediately
        state = state.copyWith(
          isLoading: false,
          hasActiveAccess: true,
          isInTrial: true,
          remainingTrialDays: 30,
          isEligibleForTrial: false,
        );
        
        // Fetch updated backend subscription to reflect changes immediately
        await fetchBackendSubscription();
        
        return true;
      } else {
        throw Exception('Failed to activate trial. Status: ${response.statusCode}');
      }
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
      
      debugPrint('==================================================');
      debugPrint('💰 [Subscription] CustomerInfo: $info');
      debugPrint('🎟️ [Subscription] Entitlements: ${info?.entitlements.all}');
      debugPrint('==================================================');

      final entitlement = info?.entitlements.all[RevenueCatService.entitlementId] ?? info?.entitlements.active.values.firstOrNull; 
      if (entitlement != null) {
        final subscriptionInfo = info?.subscriptionsByProductIdentifier[entitlement.productIdentifier];
        
        String? gracePeriod = subscriptionInfo?.gracePeriodExpiresDate;
        if (gracePeriod == null && entitlement.expirationDate != null) {
          final expDate = DateTime.tryParse(entitlement.expirationDate!);
          if (expDate != null) {
            gracePeriod = expDate.add(const Duration(days: 3)).toUtc().toIso8601String();
          }
        }

        final rawTransactionId = subscriptionInfo?.storeTransactionId ?? "unknown";
        final randomString = (Random().nextInt(90000) + 10000).toString();
        final uniqueTransactionId = "${rawTransactionId}_$randomString";

        final payload = {
          "productId": entitlement.productIdentifier,
          "store_transaction_id": uniqueTransactionId,
          "purchase_date": entitlement.latestPurchaseDate,
          "expires_date": entitlement.expirationDate,
          "grace_period_expires_date": gracePeriod ?? entitlement.expirationDate,
        };

        debugPrint('🚀 Sending manual subscription payload to backend: $payload');
        try {
          await _dio.post('/subscriptions/manual-update', data: payload);
          debugPrint('✅ Backend manual subscription updated successfully.');
        } catch (apiError) {
          debugPrint('❌ Failed to update backend manual subscription: $apiError');
        }
      }

      _updateFromCustomerInfo(info);
      await fetchBackendSubscription(); // Sync backend immediately
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
      await fetchBackendSubscription(); // Sync backend immediately
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
  final dio = ref.watch(dioClientProvider);
  final storage = ref.watch(localStorageProvider);
  return SubscriptionNotifier(dio, storage);
});
