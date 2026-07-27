# 🚀 IUMI Provider Subscription & RevenueCat Integration Guide

This document outlines the complete technical implementation, architectural mapping, and step-by-step setup guide for the **IUMI Provider Premium Subscription & 30-Day Free Trial** feature using **RevenueCat** across iOS, Android, and Web (Stripe).

---

## 📊 1. Requirements Implementation Matrix

Based on the 12 client specifications, here is how each requirement maps across **RevenueCat**, **Flutter Application**, **IUMI Backend**, and the **App Stores**:

| # | Requirement | RevenueCat | Flutter Application | IUMI Backend | Store (Apple / Google / Stripe) |
|---|---|---|---|---|---|
| **1** | **30-Day Free Trial** | Configured as `default` introductory trial offering or promo | **`SubscriptionScreen`**: Displays "Start 30-Day Free Trial" button & trial banner | **Full Logic**: Validates 1-time eligibility per unique IUMI `providerId` | Store intro eligibility / zero-cost initial transaction |
| **2** | **"Not Now" & Restricted Mode** | — | **`SubscriptionRequiredCard`**: Compact card + blurred request preview when unsigned | **Permission API**: Restricts full request payload, contact info, chat, & calls | — |
| **3** | **Cross-Platform Sync** | **`Purchases.logIn(providerId)`**: Links Apple/Google/Stripe to 1 user ID | Calls `init(providerId)` immediately after login/signup | Stores RevenueCat App User ID & syncs subscription state | — |
| **4** | **Trial Countdown & Alerts** | Provides `expirationDate` via `CustomerInfo` | UI displays *"23 days left in your free trial"* | **Cron + FCM**: Triggers push notifications at 7d, 3d, 24h, & expiry | — |
| **5** | **Subscription Plans** | `monthly` and `annual` packages under Offerings | Selectable UI cards with **"SAVE 20%"** discount badge on Annual | Receives package ID via webhook | Configure pricing tiers in App Store Connect / Play Console |
| **6** | **Manage Subscription** | Provides status, renewal, and platform via SDK | **`ManageSubscriptionScreen`**: Shows plan, dates, price, and actions | Stores billing period end date | Hosts native subscription management page |
| **7** | **Restore Purchases** | **`Purchases.restorePurchases()`**: Re-binds store receipt to current ID | **"Restore Purchase"** button in screens & settings | Webhook updates database on receipt restore | Validates native Apple/Google store receipt |
| **8** | **Failed Payment Grace Period**| Detects `BILLING_ISSUE` event | Displays payment warning banner during grace period | Allows 3-day grace period before revoking restricted API access | Handles retry billing logic (Apple Billing Grace Period) |
| **9** | **Provider Value Summary** | — | Embeds Value Summary Card (*"Received 12 requests, accepted 5 bookings"*) | **Calculate**: Aggregates monthly provider stats | — |
| **10**| **Cancellation & Retention** | — | Interactive Cancellation Reason Dialog + **20% OFF Retention Offer** | Logs cancellation reason for admin analytics | — |
| **11**| **Admin Dashboard** | Webhook events feed subscription status | — | **Admin Module**: Report conversion rates, manual grants/revokes, promotional subs | — |
| **12**| **Additional Capabilities** | — | Displays **`PremiumProviderBadge`** ("PRO" / Crown icon) on profile | Priority search sorting (active subscribers ordered first) | — |

---

## 🛠️ 2. Flutter Codebase Architecture & Files Created

All required Flutter UI components, Riverpod state controllers, and RevenueCat SDK services have been built and added to the codebase:

```text
lib/
├── core/
│   └── services/
│       └── revenuecat_service.dart          # Core RevenueCat singleton (Apple, Google Play, Stripe Web)
└── featured/
    └── subscription/
        ├── riverpod/
        │   └── subscription_provider.dart   # Riverpod Notifier managing trial state & store purchases
        ├── screens/
        │   ├── subscription_screen.dart     # Premium onboarding screen (Trial & Plan selection)
        │   └── manage_subscription_screen.dart # Settings screen (Status, dates, stats, cancel dialog)
        └── widgets/
            ├── subscription_required_card.dart # Compact restricted card with blurred request items
            └── premium_provider_badge.dart  # Golden crown PRO badge for subscribers
```

---

## 📋 3. Step-by-Step Integration & Setup Guide

### Step 1: Add Dependencies (Completed)
In `pubspec.yaml`, the RevenueCat SDK has been added under payments:
```yaml
dependencies:
  purchases_flutter: ^10.0.0
```

### Step 2: Configure RevenueCat API Keys
Open `lib/core/services/revenuecat_service.dart` and replace the placeholder keys with your live keys from the [RevenueCat Dashboard](https://app.revenuecat.com/):
```dart
static const String _appleApiKey = 'appl_xxxxxxxxx'; // iOS App Store
static const String _googleApiKey = 'goog_xxxxxxxxx'; // Google Play Billing
static const String _webApiKey = 'strip_xxxxxxxxx';  // Stripe Web
```

### Step 3: Initialize on Provider Login
Whenever a service provider successfully logs in or signs up, initialize RevenueCat with their unique IUMI `providerId`:
```dart
import 'package:service_provider_umi/featured/subscription/riverpod/subscription_provider.dart';

// Call after login/signup:
await ref.read(subscriptionProvider.notifier).init(currentUser.id);
```
> *Why? Calling `Purchases.logIn(providerId)` guarantees requirement #1 & #3: eligibility and subscription status are bound to the IUMI ID across iOS, Android, Web, devices, and reinstalls!*

### Step 4: Show the Premium Onboarding Screen
After admin approval or when a user clicks "Upgrade":
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => SubscriptionScreen(
      onNotNowTapped: () {
        Navigator.of(context).pop();
        // User enters restricted mode
      },
    ),
  ),
);
```

### Step 5: Implement Restricted Mode in Service / Requests Screen
In `ServiceProviderHomeScreen` or your requests listing widget, check subscription status:
```dart
final subState = ref.watch(subscriptionProvider);

if (!subState.hasActiveAccess) {
  // Show Restricted Mode UI with blurred preview instead of live requests!
  return SubscriptionRequiredCard(
    availableRequestsCount: 5, // Get from backend summary
    isEligibleForTrial: subState.isEligibleForTrial,
    onStartTrialTapped: () => _openSubscriptionScreen(context),
    onUpgradeTapped: () => _openSubscriptionScreen(context),
  );
}

// Otherwise, render full interactive customer request list
```

### Step 6: Add "Manage Subscription" in Profile / Settings
In your profile menu or account settings screen, add a menu item:
```dart
ListTile(
  leading: const Icon(Icons.workspace_premium, color: AppColors.primary),
  title: const Text('Manage Subscription'),
  onTap: () => Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const ManageSubscriptionScreen()),
  ),
);
```

---

## 🌐 4. RevenueCat Dashboard Setup Guide

1. **Create a RevenueCat Project**: Go to RevenueCat and create a project named `IUMI Provider`.
2. **Add Apps**:
   - Add iOS app (connect Apple App Store Shared Secret).
   - Add Android app (upload Google Play Service Account JSON).
   - Add Stripe Web app (connect Stripe API Key).
3. **Create Entitlement**: Create an entitlement with ID exactly matching: `premium`.
4. **Create Offerings**: Create a default Offering (`default`) and attach two packages:
   - Identifier: `$rc_monthly` (Type: Monthly)
   - Identifier: `$rc_annual` (Type: Annual)
5. **Configure Webhook**: Point the RevenueCat webhook to your IUMI backend: `https://api.iumi.ro/api/v1/webhooks/revenuecat`.

---

## 🖥️ 5. Backend (Node.js/Prisma) Webhook Requirements

To fulfill Requirement #8 (Grace Period), #11 (Admin Dashboard), and #12 (Priority Search), the backend team should handle these RevenueCat webhook events:

* `INITIAL_PURCHASE` / `RENEWAL`: Set user database status `isPremium = true`, `subscriptionExpiry = event.expiration_at_ms`.
* `CANCELLATION`: Keep `isPremium = true` until `expiration_at_ms`. Log cancellation reason from client.
* `BILLING_ISSUE`: Set `paymentFailed = true`. Start a 3-day timer (Grace period). If not resolved within 3 days, set `isPremium = false`.
* `EXPIRATION`: Set `isPremium = false`.
