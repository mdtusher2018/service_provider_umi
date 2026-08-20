// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get save => 'Save';

  @override
  String languageChangedTo(String language) {
    return 'Language changed to $language';
  }

  @override
  String get noBookings => 'No bookings';

  @override
  String get yourBookingsWillAppearHere => 'Your bookings will appear here';

  @override
  String get noProvidersFound => 'No providers found';

  @override
  String get calendar => 'Calendar';

  @override
  String get service => 'Service';

  @override
  String get favourites => 'Favourites';

  @override
  String get notification => 'Notification';

  @override
  String get inbox => 'Inbox';

  @override
  String get minimumPriceSavedSuccessfully =>
      'Minimum price saved successfully';

  @override
  String get minimumPriceTitle => 'Minimum price';

  @override
  String get minimumPriceQuestion =>
      'What is the minimum price a client must pay to book your service?  +info';

  @override
  String get minimumPriceLabel => 'Minimum price:';

  @override
  String get minimumPriceTip =>
      'This will avoid being booked for a price so low that it\'s not worth your time to commute to the service';

  @override
  String get upcomingBookings => 'Upcoming Bookings';

  @override
  String get dateFilter => 'Date Filter';

  @override
  String get noBookingsFound => 'No bookings found';

  @override
  String get request => 'Request';

  @override
  String get completed => 'Completed';

  @override
  String get ongoing => 'Ongoing';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get completedServices => 'Completed Services';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get personalDetails => 'Personal details';

  @override
  String get myAddresses => 'My addresses';

  @override
  String get paymentsAndRefunds => 'Payments and refunds';

  @override
  String get mySubscription => 'My Subscription';

  @override
  String get myListing => 'My Listing';

  @override
  String get mySchedule => 'My schedule';

  @override
  String get minimumBookingAmount => 'Minimum booking amount';

  @override
  String get myReview => 'My Review';

  @override
  String get addFaq => 'Add FAQ';

  @override
  String get changePassword => 'Change Password';

  @override
  String get language => 'Language';

  @override
  String get aboutUs => 'About Us';

  @override
  String get termsAndConditions => 'Terms and conditions';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get logout => 'Logout';

  @override
  String get failedToLoadProfile => 'Failed to load profile';

  @override
  String get pullToRefresh => 'Pull to refresh';

  @override
  String get areYouSureToLogout => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get notConnected => 'Not Connected';

  @override
  String get connected => 'Connected';

  @override
  String stripe(String status) {
    return 'Stripe : $status';
  }

  @override
  String get areYouSureToDeleteAccount => 'Are you sure you want to delete ?';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String failedToUpdateProfile(String message) {
    return 'Failed to update profile: $message';
  }

  @override
  String failedToDeleteAccount(String message) {
    return 'Failed to delete account: $message';
  }

  @override
  String get fullName => 'Full name';

  @override
  String get aboutMe => 'About me';

  @override
  String get searchYourAddress => 'Search your address…';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get deleteAccountPermanently => 'Delete account permanently';

  @override
  String get yesDelete => 'YES, DELETE';

  @override
  String get noDontDelete => 'NO, DON\'T DELETE';

  @override
  String get myAddress => 'My Address';

  @override
  String get yourAddresses => 'Your Addresses';

  @override
  String get retry => 'Retry';

  @override
  String get noAddresses => 'No addresses';

  @override
  String get addYourFirstAddressBelow => 'Add your first address below';

  @override
  String get addNewAddress => 'Add New Address';

  @override
  String get defaultAddressUpdated => 'Default address updated';

  @override
  String get defaultString => 'Default';

  @override
  String addressLabel(String address) {
    return 'Address: $address';
  }

  @override
  String get setAsDefault => 'Set as Default';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get areYouSureToDelete => 'Are you sure you want to delete?';

  @override
  String get thisAddressWillBeRemoved =>
      'This address will be permanently removed.';

  @override
  String get pleaseSearchAndSelectAddress =>
      'Please search and select an address first.';

  @override
  String get editAddress => 'Edit Address';

  @override
  String get addAddress => 'Add address';

  @override
  String get searchAddress => 'Search Address';

  @override
  String latLng(String lat, String lng) {
    return 'Lat: $lat,  Lng: $lng';
  }

  @override
  String get reviewAndAdjust => 'Review & adjust if needed';

  @override
  String get addressLine1 => 'Address Line 1 *';

  @override
  String get streetNumberAndName => 'Street number & name';

  @override
  String get required => 'Required';

  @override
  String get addressLine2 => 'Address Line 2';

  @override
  String get areaNeighbourhood => 'Area / neighbourhood (optional)';

  @override
  String get city => 'City';

  @override
  String get state => 'State';

  @override
  String get postalCode => 'Postal Code';

  @override
  String get postal => 'Postal';

  @override
  String get country => 'Country';

  @override
  String get updateAddress => 'Update Address';

  @override
  String get saveAddress => 'Save Address';

  @override
  String get myCards => 'My Cards';

  @override
  String get addNew => 'Add New';

  @override
  String get failedToGetAddCardLink => 'Failed to get add card link';

  @override
  String get noCardsFound => 'No cards found';

  @override
  String get cardDeletedSuccessfully => 'Card deleted successfully';

  @override
  String get setAsDefaultCardSuccessfully => 'Set as default card successfully';

  @override
  String get failedToSetDefaultCard => 'Failed to set default card';

  @override
  String get setAsDefaultCard => 'Set as Default Card';

  @override
  String get myBalance => 'My Balance';

  @override
  String get availableBalance => 'Available balance';

  @override
  String get paymentAndRefunds => 'Payment and refunds';

  @override
  String get paymentMethods => 'Payments methods';

  @override
  String get myBooking => 'My booking';

  @override
  String paidOn(String date) {
    return 'Paid on $date';
  }

  @override
  String serviceDate(String date) {
    return 'Service date: $date';
  }

  @override
  String get passwordChangedSuccessfully => 'Password changed successfully';

  @override
  String get currentPassword => 'Current password';

  @override
  String get oldPassword => 'Old password';

  @override
  String get enterOldPassword => 'Enter old password';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get faqAddedSuccessfully => 'FAQ added successfully';

  @override
  String get question => 'Question';

  @override
  String get enterYourQuestion => 'Enter your question';

  @override
  String get pleaseEnterQuestion => 'Please enter a question';

  @override
  String get answer => 'Answer';

  @override
  String get enterYourAnswer => 'Enter your answer';

  @override
  String get pleaseEnterAnswer => 'Please enter an answer';

  @override
  String get submitFaq => 'Submit FAQ';

  @override
  String get reviews => 'Reviews';

  @override
  String get noReviewsFound => 'No reviews found';

  @override
  String get noContentAvailable => 'No content available.';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get createAccountBtn => 'Create Account';

  @override
  String get logIn => 'Log in';

  @override
  String get continueAsGuest => 'Continue as a guest';

  @override
  String get whatWillYouDoOnIumi => 'What will you do on iumi?';

  @override
  String get roleDecisionNotFinal =>
      'This decision is not final. You can later be both a client\nand a professional from the account if you wish.';

  @override
  String get bookAService => 'Book a service';

  @override
  String get iAmAClient => 'I am a Client';

  @override
  String get offerServices => 'Offer services';

  @override
  String get iAmAProfessional => 'I am a Professional';

  @override
  String get createAccountTitle => 'Create account';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get enterEmail => 'Enter email';

  @override
  String get password => 'Password';

  @override
  String get serviceLocation => 'Service location';

  @override
  String get yourLocation => 'Your Location';

  @override
  String get searchAndSelectServiceArea =>
      'Search and select your service area so clients can find you.';

  @override
  String get weUseLocationForServices =>
      'We use your location to show you relevant services nearby.';

  @override
  String get searchCitySuburbAddress => 'Search city, suburb or address...';

  @override
  String get acceptTermsPrivacy =>
      'By creating an account, I accept the Terms and Condition and confirm that I have read the Privacy Policy';

  @override
  String get termsAndCondition => 'Terms and Condition';

  @override
  String get pleaseAcceptTerms =>
      'Please accept the Terms and Conditions to proceed';

  @override
  String get haveAccountLogin => 'Do you have an account?  Log in';

  @override
  String get login => 'Login';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get enterEmailSendOtp =>
      'Enter your email and we\'ll send you a reset OTP.';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get otpVerifiedSuccessfully => 'OTP Verified Successfully';

  @override
  String get otpResentSuccessfully => 'OTP resent successfully';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String enterOtpSentTo(String email) {
    return 'Enter the OTP sent to $email';
  }

  @override
  String get enterTheOtp => 'Enter the OTP';

  @override
  String get verify => 'Verify';

  @override
  String get didNotReceiveOtpResend => 'Didn\'t receive OTP?  Resend';

  @override
  String get resend => 'Resend';

  @override
  String resendOtpInSeconds(int seconds) {
    return 'Resend OTP in ${seconds}s';
  }

  @override
  String get passwordResetSuccessfully =>
      'Password reset successfully. Please log in.';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get or => 'or';

  @override
  String get loginWithEmail => 'Login with email';

  @override
  String get createWithEmail => 'Create with email';

  @override
  String get weValueYourPrivacy => 'We value your privacy';

  @override
  String get cookiePolicyMsg =>
      'Webel uses cookies to analyse advertising campaign performance, improve app ads, and personalize the experience based on user preference.';

  @override
  String get accept => 'Accept';

  @override
  String get serviceAddress => 'Service address';

  @override
  String get selectWhereYouWantToReceiveService =>
      'Select where you want to receive the service';

  @override
  String get support => 'Support';

  @override
  String get call => 'Call';

  @override
  String get phoneNumberCopied => 'Phone number copied to clipboard';

  @override
  String get message => 'Message';

  @override
  String get emailCopied => 'Email copied to clipboard';

  @override
  String get verificationPending => 'Verification Pending';

  @override
  String get verificationPendingDesc =>
      'Your account is pending verification. Some features may be limited until your account is verified.';

  @override
  String get refresh => 'Refresh';

  @override
  String get whenDoYouNeedIt => 'When do you need it?';

  @override
  String get frequency => 'Frequency';

  @override
  String get justOnce => 'Just once';

  @override
  String get oneTime => 'One-Time';

  @override
  String get weekly => 'Weekly';

  @override
  String get recurring => 'Recurring';

  @override
  String get daysOfTheWeek => 'Day(s) of the week';

  @override
  String get startTime => 'Start time';

  @override
  String get flexibleStart => 'Flexible start';

  @override
  String get exactStart => 'Exact start';

  @override
  String get morning => 'Morning';

  @override
  String get evening => 'Evening';

  @override
  String get selectExactTime => 'Select exact time';

  @override
  String get skip => 'Skip';

  @override
  String get search => 'Search';

  @override
  String get back => 'Back';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get palliativeCare => 'Palliative care';

  @override
  String get palliativeCareDesc =>
      'Only show professionals specialising in palliative care.';

  @override
  String get drivingLicence => 'Driving licence';

  @override
  String get drivingLicenceDesc =>
      'Only show professionals with a driving licence';

  @override
  String get businessProfiles => 'Business profiles';

  @override
  String get businessProfilesDesc =>
      'Only profiles that correspond to a validated business or self employed professional.';

  @override
  String get qualifiedCarer => 'Qualified carer';

  @override
  String get qualifiedCarerDesc =>
      'Only show caregivers with a qualification, diploma or degree as health personal';

  @override
  String get priceRange => 'Price range';

  @override
  String get hourlyRate => 'Hourly rate';

  @override
  String get maxPriceWillingToPay => 'Maximum price you are willing to pay.';

  @override
  String get experienceLevel => 'Experience level';

  @override
  String get specificTasksRequirements => 'Specific tasks / Requirements';

  @override
  String get updatedSuccessfully => 'Updated successfully';

  @override
  String get images => 'Images';

  @override
  String get coverImage => 'Cover Image';

  @override
  String get galleryImages => 'Gallery Images';

  @override
  String get add => 'Add';

  @override
  String get palliativeCareImage => 'Palliative Care Image';

  @override
  String get drivingLicenceImage => 'Driving Licence Image';

  @override
  String get businessProfileImage => 'Business Profile Image';

  @override
  String get qualificationCertificate => 'Qualification Certificate';

  @override
  String get submit => 'Submit';

  @override
  String get update => 'Update';

  @override
  String get applyFilters => 'Apply filters';

  @override
  String get verificationSubmitted => 'Verification Submitted';

  @override
  String get verificationSubmittedDesc =>
      'Your request has been submitted successfully.\n\nPlease login again with another account.';

  @override
  String get findTheServiceYouNeed => 'Find the service you need';

  @override
  String get mostPopularInYourArea => 'Most popular in your area';

  @override
  String get searchResults => 'Search results';

  @override
  String get noServicesFound => 'No services found';

  @override
  String get tryADifferentSearchTerm => 'Try a different search term';

  @override
  String get howDoesTheServiceWork => 'How does the service work?';

  @override
  String get finding => 'Finding ';

  @override
  String get professionals => 'professionals';

  @override
  String get whenQuestion => 'When?';

  @override
  String get filters => 'Filters';

  @override
  String get howDoesTheServiceWorkTitle =>
      'How does the Elderly care\nservice work?';

  @override
  String get noFaqsAvailable => 'No FAQs available';

  @override
  String get bookingAccepted => 'Booking accepted';

  @override
  String get comment => 'Comment';

  @override
  String get serviceBookedSuccess =>
      'Service booked successfully for elder care. Please ensure assistance includes daily check-ins, medication reminders, and help with mobility as discussed.';

  @override
  String get dateAndTime => 'Date and time';

  @override
  String get address => 'Address';

  @override
  String get servicePrice => 'Service price';

  @override
  String get complete => 'Complete';

  @override
  String get bookingHasBeenCompleted => 'This Booking has been Completed';

  @override
  String get customer => 'Customer:';

  @override
  String get provider => 'Provider:';

  @override
  String cantChatBeforeAction(String action) {
    return 'You can\'t chat before $action the booking';
  }

  @override
  String get accepting => 'accepting';

  @override
  String get creating => 'creating';

  @override
  String failedToLoadChat(String message) {
    return 'Failed to load chat: $message';
  }

  @override
  String get serviceText => 'Service';

  @override
  String get bookingHours => 'Booking hours';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get clientProtection => 'Client protection';

  @override
  String get total => 'Total';

  @override
  String get free => 'Free';

  @override
  String get details => 'Details';

  @override
  String get noDataFound => 'No data found';

  @override
  String get addressNotAvailable => 'Address not available';

  @override
  String addressCoordsLabel(String lat, String lng) {
    return 'Address: Lat: $lat, Lng: $lng';
  }

  @override
  String get congratulations => 'Congratulations';

  @override
  String get congratulationsDesc =>
      'Congratulations on achieving this milestone in your professional journey! Your dedication, expertise, and hard work are truly commendable.';

  @override
  String get done => 'Done';

  @override
  String get setUpAtLeastOneDay => 'Set up at least one day';

  @override
  String get selectATimeSlot => 'Select a time slot';

  @override
  String get bookingDotDot => 'Booking…';

  @override
  String continueForAmountPerWeek(String price) {
    return 'Continue for \$$price/week';
  }

  @override
  String bookForAmount(String price) {
    return 'Book for \$$price';
  }

  @override
  String get couldNotLoadAvailableSlots =>
      'Could not load available slots. Tap retry above.';

  @override
  String get noAvailableSlotsForDuration =>
      'No available slots for this duration.';

  @override
  String get selectATime => 'Select a time';

  @override
  String saveTimeDuration(String start, String end, String duration) {
    return 'Save $start - $end · ${duration}h';
  }

  @override
  String get chat => 'Chat';

  @override
  String get history => 'History';

  @override
  String get alerts => 'Alerts';

  @override
  String get newAlerts => 'New Alerts';

  @override
  String get searchFriends => 'Search friends';

  @override
  String get noUnreadAlerts => 'No Unread Alerts';

  @override
  String get paymentPending => 'Payment Pending';

  @override
  String get pendingAcceptance => 'Pending acceptance';

  @override
  String get payNow => 'Pay now';

  @override
  String get pending => 'Pending';

  @override
  String get serviceInProgress => 'Service in progress';

  @override
  String get rating => 'Rating';

  @override
  String get needSupportImmediately => 'Need Support Immediately';

  @override
  String get manageSubscription => 'Manage Subscription';

  @override
  String get subscriptionStatus => 'Subscription Status';

  @override
  String freeTrialDaysLeft(String daysLeft) {
    return '30-Day Free Trial ($daysLeft days left)';
  }

  @override
  String get cancelledActiveTillPeriodEnd =>
      'Cancelled (Active till period end)';

  @override
  String get activePremium => 'Active Premium';

  @override
  String get expired => 'Expired';

  @override
  String get currentPlan => 'Current Plan';

  @override
  String get subscriptionPrice => 'Subscription Price';

  @override
  String get activationDate => 'Activation Date';

  @override
  String get nextBillingRenewal => 'Next Billing / Renewal';

  @override
  String get purchasePlatform => 'Purchase Platform';

  @override
  String get annualPremium => 'Annual Premium';

  @override
  String get monthlyPremium => 'Monthly Premium';

  @override
  String get noSubscriptionPurchased => 'No Subscription Purchased';

  @override
  String get yourValueThisMonth => 'Your Value This Month';

  @override
  String thisMonthRequestsBookings(String requests, String bookings) {
    return 'This month you received $requests requests and accepted $bookings bookings.';
  }

  @override
  String get requestsReceived => 'Requests Received';

  @override
  String get bookingsAccepted => 'Bookings Accepted';

  @override
  String get acceptanceRate => 'Acceptance Rate';

  @override
  String get upgradeToPremiumNow => 'Upgrade to Premium Now';

  @override
  String get restorePurchase => 'Restore Purchase';

  @override
  String get subscriptionRestoredSuccessfully =>
      'Subscription restored successfully!';

  @override
  String get noActiveSubscriptionFoundToRestore =>
      'No active subscription found to restore.';

  @override
  String get cancelSubscription => 'Cancel Subscription';

  @override
  String get cancelSubscriptionQuestion => 'Cancel Subscription?';

  @override
  String ifYouCancelTodayPremiumAccess(String date) {
    return 'If you cancel today, your premium access will remain active until $date.\n\nPlease let us know why you are leaving:';
  }

  @override
  String get tooExpensive => 'Too expensive';

  @override
  String get notGettingEnoughClientRequests =>
      'Not getting enough client requests';

  @override
  String get usingADifferentPlatform => 'Using a different platform';

  @override
  String get other => 'Other';

  @override
  String get stayWithUsGet20Off =>
      'Stay with us! Get 20% OFF your next billing cycle instead of cancelling.';

  @override
  String get keepMySubscription => 'Keep My Subscription';

  @override
  String get confirmCancellation => 'Confirm Cancellation';

  @override
  String get pleaseCancelViaStore =>
      'Please cancel via your Google Play or App Store subscriptions page.';

  @override
  String get bio => 'Bio';

  @override
  String get writeSomethingAboutYourself => 'Write something about yourself...';

  @override
  String get pricePerHour => 'Price per hour';

  @override
  String get experience => 'Experience';

  @override
  String get selectExperience => 'Select experience';

  @override
  String get specialties => 'Specialties';

  @override
  String get otherTasksOffered => 'Other tasks offered';

  @override
  String get workSchedule => 'Work schedule';

  @override
  String get whenAreYouAvailable =>
      'When are you available to offer your services?';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get available => 'Available';

  @override
  String get notAvailable => 'Not available';

  @override
  String get confirm => 'Confirm';

  @override
  String get pleaseUploadAnImage =>
      'Please upload an image for each selected option.';

  @override
  String get ifYouAlreadySubmitARequest =>
      'If you already submit a request please login with another account';

  @override
  String get preferences => 'Preferences';

  @override
  String get myWorkAreas => 'My work areas';

  @override
  String get currentLocationMap => 'Current Location Map';

  @override
  String get next => 'Next';

  @override
  String get pleaseSelectYourRole => 'Please select your role';

  @override
  String get micAndCameraPermissionsRequired =>
      'Microphone and Camera permissions are required';

  @override
  String get userIsBusyOrUnavailable => 'User is busy or unavailable';

  @override
  String get paymentSuccessful => 'Payment successful';

  @override
  String get accessLocked => 'ACCESS LOCKED';

  @override
  String get subscriptionRequired => 'Subscription required';

  @override
  String get startFreeTrialToReceiveRequests =>
      'Start your 30-day free trial to receive\nand manage customer requests.';

  @override
  String get startFreeTrial => 'Start Free Trial';

  @override
  String get youCanStillManageProfile =>
      'You can still manage your profile,\nservices and schedule.';

  @override
  String get tryIumiProviderFree => 'Try IUMI Provider free';

  @override
  String get unlockEveryFeature => 'Unlock every provider feature for 30 days.';

  @override
  String get thirtyDaysFree => '30 DAYS FREE';

  @override
  String get receiveCustomerRequests => 'Receive customer requests';

  @override
  String get acceptOrDeclineBookings => 'Accept or decline bookings';

  @override
  String get contactCustomersAfterAcceptance =>
      'Contact customers after acceptance';

  @override
  String get manageYourSchedule => 'Manage your schedule';

  @override
  String get freeFor30Days => 'Free for 30 days';

  @override
  String get then4999RonMonthCancelAnytime =>
      'Then 49.99 RON/month. Cancel anytime.';

  @override
  String get start30DayFreeTrial => 'Start 30-Day Free Trial';

  @override
  String get upgradePremium => 'Upgrade Premium';

  @override
  String get notNow => 'Not now';

  @override
  String get noPaymentToday =>
      'No payment today. Works across\niOS, Android and web.';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get seeMore => 'See more';

  @override
  String get documents => 'Documents';

  @override
  String get chooseYourPlan => 'Choose Your Plan';

  @override
  String get noPlansAvailable => 'No plans available right now.';

  @override
  String get checkBackLater => 'Please check back later or contact support.';

  @override
  String get upgradeToPremium => 'Upgrade to Premium';

  @override
  String get unlockAllFeatures => 'Unlock all features and grow your business.';

  @override
  String savePercent(String percent) {
    return 'Save $percent%';
  }

  @override
  String get alreadySubscribed => 'You are already subscribed to this plan.';

  @override
  String get planNotAvailable =>
      'This plan is not available for purchase on this platform yet. Please try again later.';

  @override
  String successfullySubscribed(String planName) {
    return 'Successfully subscribed to $planName!';
  }

  @override
  String get subscribeNow => 'Subscribe Now';

  @override
  String get messageSentSuccessfully =>
      'Your message has been sent successfully.';

  @override
  String get failedToSendMessage => 'Failed to send message. Please try again.';

  @override
  String get pleaseSelectDocument =>
      'Please select at least one document to proceed.';

  @override
  String get documentsUpdatedSuccessfully => 'Documents updated successfully';

  @override
  String get pleaseEnterValidPricePerHour =>
      'Please enter a valid price per hour';

  @override
  String get listingUpdatedSuccessfully => 'Listing updated successfully';

  @override
  String get failedToSubmitReview => 'Failed to submit review';

  @override
  String get reviewSubmittedSuccessfully => 'Review submitted successfully';

  @override
  String get failedToSaveSchedule => 'Failed to save schedule. Try again.';

  @override
  String get pleaseFillOutAllFields => 'Please fill out all fields.';

  @override
  String get pleaseSelectFlexibleStartTime =>
      'Please select a flexible start time slot or use \'Skip\'.';

  @override
  String get outstanding => 'Outstanding';

  @override
  String get hello => 'Hello';

  @override
  String get description => 'Description';

  @override
  String get copyrightIBadi => 'Copyright iBadi';

  @override
  String get badi => 'Badi';

  @override
  String get download => 'Download';

  @override
  String get end => 'End';

  @override
  String get markAllRead => 'Mark All Read';

  @override
  String get goBack => 'Go back';

  @override
  String get iumiAdminSupport => 'Iumi Admin Support';

  @override
  String get emailAddress => 'Email address';

  @override
  String get subject => 'Subject';

  @override
  String get yourMessage => 'Your message';

  @override
  String get sayHello => 'Say hello 👋';

  @override
  String get chooseOption => 'Choose option';

  @override
  String get settings => 'Settings';

  @override
  String get completePayment => 'Complete Payment';

  @override
  String get noMessages => 'No messages';

  @override
  String get noNotification => 'No Notification';

  @override
  String get noScheduleAvailable => 'No schedule available.';

  @override
  String get additionalComments => 'Additional comments';

  @override
  String get gallery => 'Gallery';

  @override
  String get failedToLoadGallery => 'Failed to load gallery';

  @override
  String get noImagesAvailable => 'No images available';

  @override
  String get viewGallery => 'View gallery';

  @override
  String get noGalleryImageFound => 'No gallery image found';

  @override
  String get comments => 'Comments';

  @override
  String get noCommentsFound => 'No comments found';

  @override
  String get serviceFrequency => 'Service frequency';

  @override
  String get howManyTimesDoYouWantTheService =>
      'How many times do you want the service?';

  @override
  String get rateYourExperience => 'Rate Your Experience';

  @override
  String get deleteThisAddress => 'Delete this address?';

  @override
  String get showSpecialistsIn => 'Show specialists in:';

  @override
  String get ok => 'OK';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get takeAPhoto => 'Take a photo';

  @override
  String get profilePicture => 'Profile picture';

  @override
  String get doYouWantToGoBack => 'Do you want to go back?';

  @override
  String get startYour30DayFreeTrialToReceiveAndManageCustomerRequests =>
      'Start your 30-day free trial to receive\n.and manage customer requests';

  @override
  String get youCanStillManageYourProfileServicesAndSchedule =>
      ',You can still manage your profile\n.services and schedule';
}
