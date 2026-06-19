# service_provider_umi

## users email:
```
user-       filoji3358@dardr.com
provider-   vosod13349@getasail.com
```

---

## API Contents

### Current Base URL

| Environment | Base URL                              | Socket URL                        |
|-------------|---------------------------------------|-----------------------------------|
| **Local**   | `http://103.186.20.117:1000/api/v1`   | `http://103.186.20.117:6005`      |
| Production  | `https://api.iumi.ro/api/v1`          | `https://socket.iumi.ro`          |

The active URLs are set in **`lib/main.dart`** inside `FlavorConfig.initialize()`.

### How to Change the Base URL

Open `lib/main.dart` and locate the `FlavorConfig.initialize(...)` call near the top of `main()`:

```dart
FlavorConfig.initialize(
  flavor: Flavor.dev,
  // baseUrl: 'https://api.iumi.ro/api/v1',   // ← Production
  // socketUrl: 'https://socket.iumi.ro',
  baseUrl: 'http://103.186.20.117:1000/api/v1', // ← Local server (currently active)
  socketUrl: 'http://103.186.20.117:6005',
  ...
);
```

**To switch to production:** comment out the local lines and uncomment the production lines:

```dart
FlavorConfig.initialize(
  flavor: Flavor.prod,
  baseUrl: 'https://api.iumi.ro/api/v1',   // ← uncomment
  socketUrl: 'https://socket.iumi.ro',      // ← uncomment
  // baseUrl: 'http://103.186.20.117:1000/api/v1',
  // socketUrl: 'http://103.186.20.117:6005',
  ...
);
```

### API Endpoints Overview

All endpoints are defined in `lib/core/services/network/api_endpoints.dart`.

| Group            | Endpoint                              |
|------------------|---------------------------------------|
| Auth             | `/auth/login`, `/auth/refresh-token`, `/auth/google-login`, `/auth/forgot-password`, `/auth/reset-password`, `/auth/change-password` |
| Register         | `/users`                              |
| OTP              | `/otp/verify-otp`, `/otp/resend-otp` |
| User / Profile   | `/users/my-profile`, `/users/update-my-profile`, `/verification-request` |
| Notifications    | `/notifications`, `/call-history`     |
| Categories       | `/categories`                         |
| Sub-categories   | `/sub-categories/{id}`                |
| Bookings         | `/bookings`, `/bookings/user-booking`, `/bookings/provider-booking` |
| Payments         | `/payments/payout`, `/stripe/connect`, `/stripe/payment-method` |
| Address          | `/address`                            |
| Chat             | `/chat/get-by-user-id/{receiverId}`   |
| FAQs / Reviews   | `/faq`, `/reviews`                    |
| Search           | `/homepage`                           |
| Static Content   | `/contents`, `/contents/web-about-us` |
| Availability     | `/homepage/availability`              |
| Work Schedule    | `/workSchedule`                       |