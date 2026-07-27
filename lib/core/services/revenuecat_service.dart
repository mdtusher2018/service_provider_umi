import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// RevenueCat Service for IUMI Provider Subscriptions & 30-Day Trial
/// ─────────────────────────────────────────────────────────────────────────────
/// Handles:
/// 1. Apple App Store (iOS), Google Play Billing (Android), and Stripe (Web)
/// 2. Unique IUMI Provider ID cross-platform synchronization via Purchases.logIn()
/// 3. 30-Day Free Trial check & eligibility
/// 4. Restoration of purchases across re-installs and devices
/// ─────────────────────────────────────────────────────────────────────────────
class RevenueCatService {
  RevenueCatService._();
  static final RevenueCatService instance = RevenueCatService._();

  // TODO: Replace with actual RevenueCat API keys from RevenueCat Dashboard
  static const String _appleApiKey = 'appl_YOUR_REVENUECAT_APPLE_KEY';
  static const String _googleApiKey = 'goog_YOUR_REVENUECAT_GOOGLE_KEY';
  static const String _webApiKey = 'strip_YOUR_REVENUECAT_STRIPE_KEY';

  // Entitlement ID configured in RevenueCat dashboard
  static const String entitlementId = 'premium';
  static const String trialOfferingId = 'default';

  final _customerInfoController = StreamController<CustomerInfo>.broadcast();
  Stream<CustomerInfo> get customerInfoStream => _customerInfoController.stream;

  bool _isInitialized = false;

  /// 1. Initialize RevenueCat & Log In with unique IUMI Provider ID
  /// Must be called after provider successfully logs in or registers.
  Future<void> init(String providerId) async {
    if (_isInitialized) {
      // If already initialized, ensure logged in as current providerId
      await Purchases.logIn(providerId);
      return;
    }

    String apiKey = _googleApiKey;
    if (kIsWeb) {
      apiKey = _webApiKey;
    } else if (Platform.isIOS || Platform.isMacOS) {
      apiKey = _appleApiKey;
    } else if (Platform.isAndroid) {
      apiKey = _googleApiKey;
    }

    if (apiKey.contains('YOUR_REVENUECAT')) {
      debugPrint('⚠️ [RevenueCat] API Key not set up yet. Skipping live SDK init.');
      return;
    }

    final configuration = PurchasesConfiguration(apiKey)
      ..appUserID = providerId;

    await Purchases.configure(configuration);
    _isInitialized = true;

    // Cross-platform synchronization: bind subscription to unique IUMI provider ID
    await Purchases.logIn(providerId);

    // Listen for customer info updates (e.g. renewals, expirations, webhooks)
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      _customerInfoController.add(customerInfo);
    });
  }

  /// 2. Fetch Offerings (Monthly & Annual Plans)
  Future<Offerings?> getOfferings() async {
    try {
      if (!_isInitialized) return null;
      return await Purchases.getOfferings();
    } catch (e) {
      debugPrint('❌ [RevenueCat] Failed to fetch offerings: $e');
      return null;
    }
  }

  /// 3. Purchase a Subscription Package
  Future<CustomerInfo?> purchasePackage(Package package) async {
    try {
      final result = await Purchases.purchasePackage(package);
      return result.customerInfo;
    } catch (e) {
      debugPrint('❌ [RevenueCat] Purchase failed: $e');
      rethrow;
    }
  }

  /// 4. Restore Purchases (For reinstall or changing device)
  Future<CustomerInfo?> restorePurchases() async {
    try {
      return await Purchases.restorePurchases();
    } catch (e) {
      debugPrint('❌ [RevenueCat] Restore failed: $e');
      rethrow;
    }
  }

  /// 5. Get Current Customer Info
  Future<CustomerInfo?> getCustomerInfo() async {
    try {
      if (!_isInitialized) return null;
      return await Purchases.getCustomerInfo();
    } catch (e) {
      debugPrint('❌ [RevenueCat] Failed to get customer info: $e');
      return null;
    }
  }

  /// Check if provider has active access (Trial or Paid Subscription)
  bool hasActiveAccess(CustomerInfo? info) {
    if (info == null) return false;
    final entitlement = info.entitlements.all[entitlementId];
    return entitlement?.isActive ?? false;
  }

  /// Check if currently in 30-day Free Trial
  bool isInTrial(CustomerInfo? info) {
    if (info == null) return false;
    final entitlement = info.entitlements.all[entitlementId];
    if (entitlement == null || !entitlement.isActive) return false;
    return entitlement.periodType == PeriodType.trial;
  }

  /// Check if Trial is Eligible (has never used trial before on this ID)
  bool isEligibleForTrial(CustomerInfo? info) {
    if (info == null) return true; // Assume eligible if unknown
    // RevenueCat tracks intro/trial eligibility per appUserID
    final entitlement = info.entitlements.all[entitlementId];
    // If they already had an entitlement (expired or active), trial is exhausted
    return entitlement == null;
  }

  /// Calculate remaining trial days
  int getRemainingTrialDays(CustomerInfo? info) {
    if (!isInTrial(info)) return 0;
    final entitlement = info!.entitlements.all[entitlementId];
    final expirationDateString = entitlement?.expirationDate;
    if (expirationDateString == null) return 0;

    final expirationDate = DateTime.tryParse(expirationDateString);
    if (expirationDate == null) return 0;

    final diff = expirationDate.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  /// Log out from RevenueCat when user logs out of app
  Future<void> logout() async {
    if (!_isInitialized) return;
    try {
      await Purchases.logOut();
    } catch (e) {
      debugPrint('❌ [RevenueCat] Logout failed: $e');
    }
  }
}
