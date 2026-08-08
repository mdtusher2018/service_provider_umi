import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
    Locale('ro'),
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @languageChangedTo.
  ///
  /// In en, this message translates to:
  /// **'Language changed to {language}'**
  String languageChangedTo(String language);

  /// No description provided for @noBookings.
  ///
  /// In en, this message translates to:
  /// **'No bookings'**
  String get noBookings;

  /// No description provided for @yourBookingsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Your bookings will appear here'**
  String get yourBookingsWillAppearHere;

  /// No description provided for @noProvidersFound.
  ///
  /// In en, this message translates to:
  /// **'No providers found'**
  String get noProvidersFound;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @favourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get favourites;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @inbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get inbox;

  /// No description provided for @minimumPriceSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Minimum price saved successfully'**
  String get minimumPriceSavedSuccessfully;

  /// No description provided for @minimumPriceTitle.
  ///
  /// In en, this message translates to:
  /// **'Minimum price'**
  String get minimumPriceTitle;

  /// No description provided for @minimumPriceQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is the minimum price a client must pay to book your service?  +info'**
  String get minimumPriceQuestion;

  /// No description provided for @minimumPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Minimum price:'**
  String get minimumPriceLabel;

  /// No description provided for @minimumPriceTip.
  ///
  /// In en, this message translates to:
  /// **'This will avoid being booked for a price so low that it\'s not worth your time to commute to the service'**
  String get minimumPriceTip;

  /// No description provided for @upcomingBookings.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Bookings'**
  String get upcomingBookings;

  /// No description provided for @dateFilter.
  ///
  /// In en, this message translates to:
  /// **'Date Filter'**
  String get dateFilter;

  /// No description provided for @noBookingsFound.
  ///
  /// In en, this message translates to:
  /// **'No bookings found'**
  String get noBookingsFound;

  /// No description provided for @request.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get request;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @completedServices.
  ///
  /// In en, this message translates to:
  /// **'Completed Services'**
  String get completedServices;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal details'**
  String get personalDetails;

  /// No description provided for @myAddresses.
  ///
  /// In en, this message translates to:
  /// **'My addresses'**
  String get myAddresses;

  /// No description provided for @paymentsAndRefunds.
  ///
  /// In en, this message translates to:
  /// **'Payments and refunds'**
  String get paymentsAndRefunds;

  /// No description provided for @mySubscription.
  ///
  /// In en, this message translates to:
  /// **'My Subscription'**
  String get mySubscription;

  /// No description provided for @myListing.
  ///
  /// In en, this message translates to:
  /// **'My Listing'**
  String get myListing;

  /// No description provided for @mySchedule.
  ///
  /// In en, this message translates to:
  /// **'My schedule'**
  String get mySchedule;

  /// No description provided for @minimumBookingAmount.
  ///
  /// In en, this message translates to:
  /// **'Minimum booking amount'**
  String get minimumBookingAmount;

  /// No description provided for @myReview.
  ///
  /// In en, this message translates to:
  /// **'My Review'**
  String get myReview;

  /// No description provided for @addFaq.
  ///
  /// In en, this message translates to:
  /// **'Add FAQ'**
  String get addFaq;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get termsAndConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @failedToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get failedToLoadProfile;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get pullToRefresh;

  /// No description provided for @areYouSureToLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get areYouSureToLogout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @notConnected.
  ///
  /// In en, this message translates to:
  /// **'Not Connected'**
  String get notConnected;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @stripe.
  ///
  /// In en, this message translates to:
  /// **'Stripe : {status}'**
  String stripe(String status);

  /// No description provided for @areYouSureToDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete ?'**
  String get areYouSureToDeleteAccount;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @failedToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile: {message}'**
  String failedToUpdateProfile(String message);

  /// No description provided for @failedToDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account: {message}'**
  String failedToDeleteAccount(String message);

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @aboutMe.
  ///
  /// In en, this message translates to:
  /// **'About me'**
  String get aboutMe;

  /// No description provided for @searchYourAddress.
  ///
  /// In en, this message translates to:
  /// **'Search your address…'**
  String get searchYourAddress;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @deleteAccountPermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete account permanently'**
  String get deleteAccountPermanently;

  /// No description provided for @yesDelete.
  ///
  /// In en, this message translates to:
  /// **'YES, DELETE'**
  String get yesDelete;

  /// No description provided for @noDontDelete.
  ///
  /// In en, this message translates to:
  /// **'NO, DON\'T DELETE'**
  String get noDontDelete;

  /// No description provided for @myAddress.
  ///
  /// In en, this message translates to:
  /// **'My Address'**
  String get myAddress;

  /// No description provided for @yourAddresses.
  ///
  /// In en, this message translates to:
  /// **'Your Addresses'**
  String get yourAddresses;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noAddresses.
  ///
  /// In en, this message translates to:
  /// **'No addresses'**
  String get noAddresses;

  /// No description provided for @addYourFirstAddressBelow.
  ///
  /// In en, this message translates to:
  /// **'Add your first address below'**
  String get addYourFirstAddressBelow;

  /// No description provided for @addNewAddress.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addNewAddress;

  /// No description provided for @defaultAddressUpdated.
  ///
  /// In en, this message translates to:
  /// **'Default address updated'**
  String get defaultAddressUpdated;

  /// No description provided for @defaultString.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultString;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address: {address}'**
  String addressLabel(String address);

  /// No description provided for @setAsDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as Default'**
  String get setAsDefault;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @areYouSureToDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete?'**
  String get areYouSureToDelete;

  /// No description provided for @thisAddressWillBeRemoved.
  ///
  /// In en, this message translates to:
  /// **'This address will be permanently removed.'**
  String get thisAddressWillBeRemoved;

  /// No description provided for @pleaseSearchAndSelectAddress.
  ///
  /// In en, this message translates to:
  /// **'Please search and select an address first.'**
  String get pleaseSearchAndSelectAddress;

  /// No description provided for @editAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddress;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'Add address'**
  String get addAddress;

  /// No description provided for @searchAddress.
  ///
  /// In en, this message translates to:
  /// **'Search Address'**
  String get searchAddress;

  /// No description provided for @latLng.
  ///
  /// In en, this message translates to:
  /// **'Lat: {lat},  Lng: {lng}'**
  String latLng(String lat, String lng);

  /// No description provided for @reviewAndAdjust.
  ///
  /// In en, this message translates to:
  /// **'Review & adjust if needed'**
  String get reviewAndAdjust;

  /// No description provided for @addressLine1.
  ///
  /// In en, this message translates to:
  /// **'Address Line 1 *'**
  String get addressLine1;

  /// No description provided for @streetNumberAndName.
  ///
  /// In en, this message translates to:
  /// **'Street number & name'**
  String get streetNumberAndName;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @addressLine2.
  ///
  /// In en, this message translates to:
  /// **'Address Line 2'**
  String get addressLine2;

  /// No description provided for @areaNeighbourhood.
  ///
  /// In en, this message translates to:
  /// **'Area / neighbourhood (optional)'**
  String get areaNeighbourhood;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @postalCode.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get postalCode;

  /// No description provided for @postal.
  ///
  /// In en, this message translates to:
  /// **'Postal'**
  String get postal;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @updateAddress.
  ///
  /// In en, this message translates to:
  /// **'Update Address'**
  String get updateAddress;

  /// No description provided for @saveAddress.
  ///
  /// In en, this message translates to:
  /// **'Save Address'**
  String get saveAddress;

  /// No description provided for @myCards.
  ///
  /// In en, this message translates to:
  /// **'My Cards'**
  String get myCards;

  /// No description provided for @addNew.
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get addNew;

  /// No description provided for @failedToGetAddCardLink.
  ///
  /// In en, this message translates to:
  /// **'Failed to get add card link'**
  String get failedToGetAddCardLink;

  /// No description provided for @noCardsFound.
  ///
  /// In en, this message translates to:
  /// **'No cards found'**
  String get noCardsFound;

  /// No description provided for @cardDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Card deleted successfully'**
  String get cardDeletedSuccessfully;

  /// No description provided for @setAsDefaultCardSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Set as default card successfully'**
  String get setAsDefaultCardSuccessfully;

  /// No description provided for @failedToSetDefaultCard.
  ///
  /// In en, this message translates to:
  /// **'Failed to set default card'**
  String get failedToSetDefaultCard;

  /// No description provided for @setAsDefaultCard.
  ///
  /// In en, this message translates to:
  /// **'Set as Default Card'**
  String get setAsDefaultCard;

  /// No description provided for @myBalance.
  ///
  /// In en, this message translates to:
  /// **'My Balance'**
  String get myBalance;

  /// No description provided for @availableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available balance'**
  String get availableBalance;

  /// No description provided for @paymentAndRefunds.
  ///
  /// In en, this message translates to:
  /// **'Payment and refunds'**
  String get paymentAndRefunds;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payments methods'**
  String get paymentMethods;

  /// No description provided for @myBooking.
  ///
  /// In en, this message translates to:
  /// **'My booking'**
  String get myBooking;

  /// No description provided for @paidOn.
  ///
  /// In en, this message translates to:
  /// **'Paid on {date}'**
  String paidOn(String date);

  /// No description provided for @serviceDate.
  ///
  /// In en, this message translates to:
  /// **'Service date: {date}'**
  String serviceDate(String date);

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccessfully;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old password'**
  String get oldPassword;

  /// No description provided for @enterOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter old password'**
  String get enterOldPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @faqAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'FAQ added successfully'**
  String get faqAddedSuccessfully;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @enterYourQuestion.
  ///
  /// In en, this message translates to:
  /// **'Enter your question'**
  String get enterYourQuestion;

  /// No description provided for @pleaseEnterQuestion.
  ///
  /// In en, this message translates to:
  /// **'Please enter a question'**
  String get pleaseEnterQuestion;

  /// No description provided for @answer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get answer;

  /// No description provided for @enterYourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Enter your answer'**
  String get enterYourAnswer;

  /// No description provided for @pleaseEnterAnswer.
  ///
  /// In en, this message translates to:
  /// **'Please enter an answer'**
  String get pleaseEnterAnswer;

  /// No description provided for @submitFaq.
  ///
  /// In en, this message translates to:
  /// **'Submit FAQ'**
  String get submitFaq;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @noReviewsFound.
  ///
  /// In en, this message translates to:
  /// **'No reviews found'**
  String get noReviewsFound;

  /// No description provided for @noContentAvailable.
  ///
  /// In en, this message translates to:
  /// **'No content available.'**
  String get noContentAvailable;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @createAccountBtn.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountBtn;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as a guest'**
  String get continueAsGuest;

  /// No description provided for @whatWillYouDoOnIumi.
  ///
  /// In en, this message translates to:
  /// **'What will you do on iumi?'**
  String get whatWillYouDoOnIumi;

  /// No description provided for @roleDecisionNotFinal.
  ///
  /// In en, this message translates to:
  /// **'This decision is not final. You can later be both a client\nand a professional from the account if you wish.'**
  String get roleDecisionNotFinal;

  /// No description provided for @bookAService.
  ///
  /// In en, this message translates to:
  /// **'Book a service'**
  String get bookAService;

  /// No description provided for @iAmAClient.
  ///
  /// In en, this message translates to:
  /// **'I am a Client'**
  String get iAmAClient;

  /// No description provided for @offerServices.
  ///
  /// In en, this message translates to:
  /// **'Offer services'**
  String get offerServices;

  /// No description provided for @iAmAProfessional.
  ///
  /// In en, this message translates to:
  /// **'I am a Professional'**
  String get iAmAProfessional;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountTitle;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @serviceLocation.
  ///
  /// In en, this message translates to:
  /// **'Service location'**
  String get serviceLocation;

  /// No description provided for @yourLocation.
  ///
  /// In en, this message translates to:
  /// **'Your Location'**
  String get yourLocation;

  /// No description provided for @searchAndSelectServiceArea.
  ///
  /// In en, this message translates to:
  /// **'Search and select your service area so clients can find you.'**
  String get searchAndSelectServiceArea;

  /// No description provided for @weUseLocationForServices.
  ///
  /// In en, this message translates to:
  /// **'We use your location to show you relevant services nearby.'**
  String get weUseLocationForServices;

  /// No description provided for @searchCitySuburbAddress.
  ///
  /// In en, this message translates to:
  /// **'Search city, suburb or address...'**
  String get searchCitySuburbAddress;

  /// No description provided for @acceptTermsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'By creating an account, I accept the Terms and Condition and confirm that I have read the Privacy Policy'**
  String get acceptTermsPrivacy;

  /// No description provided for @termsAndCondition.
  ///
  /// In en, this message translates to:
  /// **'Terms and Condition'**
  String get termsAndCondition;

  /// No description provided for @pleaseAcceptTerms.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms and Conditions to proceed'**
  String get pleaseAcceptTerms;

  /// No description provided for @haveAccountLogin.
  ///
  /// In en, this message translates to:
  /// **'Do you have an account?  Log in'**
  String get haveAccountLogin;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @enterEmailSendOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a reset OTP.'**
  String get enterEmailSendOtp;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @otpVerifiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'OTP Verified Successfully'**
  String get otpVerifiedSuccessfully;

  /// No description provided for @otpResentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'OTP resent successfully'**
  String get otpResentSuccessfully;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @enterOtpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Enter the OTP sent to {email}'**
  String enterOtpSentTo(String email);

  /// No description provided for @enterTheOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter the OTP'**
  String get enterTheOtp;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @didNotReceiveOtpResend.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive OTP?  Resend'**
  String get didNotReceiveOtpResend;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @resendOtpInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP in {seconds}s'**
  String resendOtpInSeconds(int seconds);

  /// No description provided for @passwordResetSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully. Please log in.'**
  String get passwordResetSuccessfully;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @loginWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Login with email'**
  String get loginWithEmail;

  /// No description provided for @createWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Create with email'**
  String get createWithEmail;

  /// No description provided for @weValueYourPrivacy.
  ///
  /// In en, this message translates to:
  /// **'We value your privacy'**
  String get weValueYourPrivacy;

  /// No description provided for @cookiePolicyMsg.
  ///
  /// In en, this message translates to:
  /// **'Webel uses cookies to analyse advertising campaign performance, improve app ads, and personalize the experience based on user preference.'**
  String get cookiePolicyMsg;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @serviceAddress.
  ///
  /// In en, this message translates to:
  /// **'Service address'**
  String get serviceAddress;

  /// No description provided for @selectWhereYouWantToReceiveService.
  ///
  /// In en, this message translates to:
  /// **'Select where you want to receive the service'**
  String get selectWhereYouWantToReceiveService;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @phoneNumberCopied.
  ///
  /// In en, this message translates to:
  /// **'Phone number copied to clipboard'**
  String get phoneNumberCopied;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @emailCopied.
  ///
  /// In en, this message translates to:
  /// **'Email copied to clipboard'**
  String get emailCopied;

  /// No description provided for @verificationPending.
  ///
  /// In en, this message translates to:
  /// **'Verification Pending'**
  String get verificationPending;

  /// No description provided for @verificationPendingDesc.
  ///
  /// In en, this message translates to:
  /// **'Your account is pending verification. Some features may be limited until your account is verified.'**
  String get verificationPendingDesc;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @whenDoYouNeedIt.
  ///
  /// In en, this message translates to:
  /// **'When do you need it?'**
  String get whenDoYouNeedIt;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @justOnce.
  ///
  /// In en, this message translates to:
  /// **'Just once'**
  String get justOnce;

  /// No description provided for @oneTime.
  ///
  /// In en, this message translates to:
  /// **'One-Time'**
  String get oneTime;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @recurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get recurring;

  /// No description provided for @daysOfTheWeek.
  ///
  /// In en, this message translates to:
  /// **'Day(s) of the week'**
  String get daysOfTheWeek;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get startTime;

  /// No description provided for @flexibleStart.
  ///
  /// In en, this message translates to:
  /// **'Flexible start'**
  String get flexibleStart;

  /// No description provided for @exactStart.
  ///
  /// In en, this message translates to:
  /// **'Exact start'**
  String get exactStart;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @selectExactTime.
  ///
  /// In en, this message translates to:
  /// **'Select exact time'**
  String get selectExactTime;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @palliativeCare.
  ///
  /// In en, this message translates to:
  /// **'Palliative care'**
  String get palliativeCare;

  /// No description provided for @palliativeCareDesc.
  ///
  /// In en, this message translates to:
  /// **'Only show professionals specialising in palliative care.'**
  String get palliativeCareDesc;

  /// No description provided for @drivingLicence.
  ///
  /// In en, this message translates to:
  /// **'Driving licence'**
  String get drivingLicence;

  /// No description provided for @drivingLicenceDesc.
  ///
  /// In en, this message translates to:
  /// **'Only show professionals with a driving licence'**
  String get drivingLicenceDesc;

  /// No description provided for @businessProfiles.
  ///
  /// In en, this message translates to:
  /// **'Business profiles'**
  String get businessProfiles;

  /// No description provided for @businessProfilesDesc.
  ///
  /// In en, this message translates to:
  /// **'Only profiles that correspond to a validated business or self employed professional.'**
  String get businessProfilesDesc;

  /// No description provided for @qualifiedCarer.
  ///
  /// In en, this message translates to:
  /// **'Qualified carer'**
  String get qualifiedCarer;

  /// No description provided for @qualifiedCarerDesc.
  ///
  /// In en, this message translates to:
  /// **'Only show caregivers with a qualification, diploma or degree as health personal'**
  String get qualifiedCarerDesc;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price range'**
  String get priceRange;

  /// No description provided for @hourlyRate.
  ///
  /// In en, this message translates to:
  /// **'Hourly rate'**
  String get hourlyRate;

  /// No description provided for @maxPriceWillingToPay.
  ///
  /// In en, this message translates to:
  /// **'Maximum price you are willing to pay.'**
  String get maxPriceWillingToPay;

  /// No description provided for @experienceLevel.
  ///
  /// In en, this message translates to:
  /// **'Experience level'**
  String get experienceLevel;

  /// No description provided for @specificTasksRequirements.
  ///
  /// In en, this message translates to:
  /// **'Specific tasks / Requirements'**
  String get specificTasksRequirements;

  /// No description provided for @updatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully'**
  String get updatedSuccessfully;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @coverImage.
  ///
  /// In en, this message translates to:
  /// **'Cover Image'**
  String get coverImage;

  /// No description provided for @galleryImages.
  ///
  /// In en, this message translates to:
  /// **'Gallery Images'**
  String get galleryImages;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @palliativeCareImage.
  ///
  /// In en, this message translates to:
  /// **'Palliative Care Image'**
  String get palliativeCareImage;

  /// No description provided for @drivingLicenceImage.
  ///
  /// In en, this message translates to:
  /// **'Driving Licence Image'**
  String get drivingLicenceImage;

  /// No description provided for @businessProfileImage.
  ///
  /// In en, this message translates to:
  /// **'Business Profile Image'**
  String get businessProfileImage;

  /// No description provided for @qualificationCertificate.
  ///
  /// In en, this message translates to:
  /// **'Qualification Certificate'**
  String get qualificationCertificate;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get applyFilters;

  /// No description provided for @verificationSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Verification Submitted'**
  String get verificationSubmitted;

  /// No description provided for @verificationSubmittedDesc.
  ///
  /// In en, this message translates to:
  /// **'Your request has been submitted successfully.\n\nPlease login again with another account.'**
  String get verificationSubmittedDesc;

  /// No description provided for @findTheServiceYouNeed.
  ///
  /// In en, this message translates to:
  /// **'Find the service you need'**
  String get findTheServiceYouNeed;

  /// No description provided for @mostPopularInYourArea.
  ///
  /// In en, this message translates to:
  /// **'Most popular in your area'**
  String get mostPopularInYourArea;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search results'**
  String get searchResults;

  /// No description provided for @noServicesFound.
  ///
  /// In en, this message translates to:
  /// **'No services found'**
  String get noServicesFound;

  /// No description provided for @tryADifferentSearchTerm.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryADifferentSearchTerm;

  /// No description provided for @howDoesTheServiceWork.
  ///
  /// In en, this message translates to:
  /// **'How does the service work?'**
  String get howDoesTheServiceWork;

  /// No description provided for @finding.
  ///
  /// In en, this message translates to:
  /// **'Finding '**
  String get finding;

  /// No description provided for @professionals.
  ///
  /// In en, this message translates to:
  /// **'professionals'**
  String get professionals;

  /// No description provided for @whenQuestion.
  ///
  /// In en, this message translates to:
  /// **'When?'**
  String get whenQuestion;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @howDoesTheServiceWorkTitle.
  ///
  /// In en, this message translates to:
  /// **'How does the Elderly care\nservice work?'**
  String get howDoesTheServiceWorkTitle;

  /// No description provided for @noFaqsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No FAQs available'**
  String get noFaqsAvailable;

  /// No description provided for @bookingAccepted.
  ///
  /// In en, this message translates to:
  /// **'Booking accepted'**
  String get bookingAccepted;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @serviceBookedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Service booked successfully for elder care. Please ensure assistance includes daily check-ins, medication reminders, and help with mobility as discussed.'**
  String get serviceBookedSuccess;

  /// No description provided for @dateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Date and time'**
  String get dateAndTime;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @servicePrice.
  ///
  /// In en, this message translates to:
  /// **'Service price'**
  String get servicePrice;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @bookingHasBeenCompleted.
  ///
  /// In en, this message translates to:
  /// **'This Booking has been Completed'**
  String get bookingHasBeenCompleted;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer:'**
  String get customer;

  /// No description provided for @provider.
  ///
  /// In en, this message translates to:
  /// **'Provider:'**
  String get provider;

  /// No description provided for @cantChatBeforeAction.
  ///
  /// In en, this message translates to:
  /// **'You can\'t chat before {action} the booking'**
  String cantChatBeforeAction(String action);

  /// No description provided for @accepting.
  ///
  /// In en, this message translates to:
  /// **'accepting'**
  String get accepting;

  /// No description provided for @creating.
  ///
  /// In en, this message translates to:
  /// **'creating'**
  String get creating;

  /// No description provided for @failedToLoadChat.
  ///
  /// In en, this message translates to:
  /// **'Failed to load chat: {message}'**
  String failedToLoadChat(String message);

  /// No description provided for @serviceText.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get serviceText;

  /// No description provided for @bookingHours.
  ///
  /// In en, this message translates to:
  /// **'Booking hours'**
  String get bookingHours;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @clientProtection.
  ///
  /// In en, this message translates to:
  /// **'Client protection'**
  String get clientProtection;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get noDataFound;

  /// No description provided for @addressNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Address not available'**
  String get addressNotAvailable;

  /// No description provided for @addressCoordsLabel.
  ///
  /// In en, this message translates to:
  /// **'Address: Lat: {lat}, Lng: {lng}'**
  String addressCoordsLabel(String lat, String lng);

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations'**
  String get congratulations;

  /// No description provided for @congratulationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Congratulations on achieving this milestone in your professional journey! Your dedication, expertise, and hard work are truly commendable.'**
  String get congratulationsDesc;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @setUpAtLeastOneDay.
  ///
  /// In en, this message translates to:
  /// **'Set up at least one day'**
  String get setUpAtLeastOneDay;

  /// No description provided for @selectATimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Select a time slot'**
  String get selectATimeSlot;

  /// No description provided for @bookingDotDot.
  ///
  /// In en, this message translates to:
  /// **'Booking…'**
  String get bookingDotDot;

  /// No description provided for @continueForAmountPerWeek.
  ///
  /// In en, this message translates to:
  /// **'Continue for \${price}/week'**
  String continueForAmountPerWeek(String price);

  /// No description provided for @bookForAmount.
  ///
  /// In en, this message translates to:
  /// **'Book for \${price}'**
  String bookForAmount(String price);

  /// No description provided for @couldNotLoadAvailableSlots.
  ///
  /// In en, this message translates to:
  /// **'Could not load available slots. Tap retry above.'**
  String get couldNotLoadAvailableSlots;

  /// No description provided for @noAvailableSlotsForDuration.
  ///
  /// In en, this message translates to:
  /// **'No available slots for this duration.'**
  String get noAvailableSlotsForDuration;

  /// No description provided for @selectATime.
  ///
  /// In en, this message translates to:
  /// **'Select a time'**
  String get selectATime;

  /// No description provided for @saveTimeDuration.
  ///
  /// In en, this message translates to:
  /// **'Save {start} - {end} · {duration}h'**
  String saveTimeDuration(String start, String end, String duration);

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @newAlerts.
  ///
  /// In en, this message translates to:
  /// **'New Alerts'**
  String get newAlerts;

  /// No description provided for @searchFriends.
  ///
  /// In en, this message translates to:
  /// **'Search friends'**
  String get searchFriends;

  /// No description provided for @noUnreadAlerts.
  ///
  /// In en, this message translates to:
  /// **'No Unread Alerts'**
  String get noUnreadAlerts;

  /// No description provided for @paymentPending.
  ///
  /// In en, this message translates to:
  /// **'Payment Pending'**
  String get paymentPending;

  /// No description provided for @pendingAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Pending acceptance'**
  String get pendingAcceptance;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay now'**
  String get payNow;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @serviceInProgress.
  ///
  /// In en, this message translates to:
  /// **'Service in progress'**
  String get serviceInProgress;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @needSupportImmediately.
  ///
  /// In en, this message translates to:
  /// **'Need Support Immediately'**
  String get needSupportImmediately;

  /// No description provided for @manageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage Subscription'**
  String get manageSubscription;

  /// No description provided for @subscriptionStatus.
  ///
  /// In en, this message translates to:
  /// **'Subscription Status'**
  String get subscriptionStatus;

  /// No description provided for @freeTrialDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'30-Day Free Trial ({daysLeft} days left)'**
  String freeTrialDaysLeft(String daysLeft);

  /// No description provided for @cancelledActiveTillPeriodEnd.
  ///
  /// In en, this message translates to:
  /// **'Cancelled (Active till period end)'**
  String get cancelledActiveTillPeriodEnd;

  /// No description provided for @activePremium.
  ///
  /// In en, this message translates to:
  /// **'Active Premium'**
  String get activePremium;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlan;

  /// No description provided for @subscriptionPrice.
  ///
  /// In en, this message translates to:
  /// **'Subscription Price'**
  String get subscriptionPrice;

  /// No description provided for @activationDate.
  ///
  /// In en, this message translates to:
  /// **'Activation Date'**
  String get activationDate;

  /// No description provided for @nextBillingRenewal.
  ///
  /// In en, this message translates to:
  /// **'Next Billing / Renewal'**
  String get nextBillingRenewal;

  /// No description provided for @purchasePlatform.
  ///
  /// In en, this message translates to:
  /// **'Purchase Platform'**
  String get purchasePlatform;

  /// No description provided for @annualPremium.
  ///
  /// In en, this message translates to:
  /// **'Annual Premium'**
  String get annualPremium;

  /// No description provided for @monthlyPremium.
  ///
  /// In en, this message translates to:
  /// **'Monthly Premium'**
  String get monthlyPremium;

  /// No description provided for @noSubscriptionPurchased.
  ///
  /// In en, this message translates to:
  /// **'No Subscription Purchased'**
  String get noSubscriptionPurchased;

  /// No description provided for @yourValueThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Your Value This Month'**
  String get yourValueThisMonth;

  /// No description provided for @thisMonthRequestsBookings.
  ///
  /// In en, this message translates to:
  /// **'This month you received {requests} requests and accepted {bookings} bookings.'**
  String thisMonthRequestsBookings(String requests, String bookings);

  /// No description provided for @requestsReceived.
  ///
  /// In en, this message translates to:
  /// **'Requests Received'**
  String get requestsReceived;

  /// No description provided for @bookingsAccepted.
  ///
  /// In en, this message translates to:
  /// **'Bookings Accepted'**
  String get bookingsAccepted;

  /// No description provided for @acceptanceRate.
  ///
  /// In en, this message translates to:
  /// **'Acceptance Rate'**
  String get acceptanceRate;

  /// No description provided for @upgradeToPremiumNow.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium Now'**
  String get upgradeToPremiumNow;

  /// No description provided for @restorePurchase.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchase'**
  String get restorePurchase;

  /// No description provided for @subscriptionRestoredSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Subscription restored successfully!'**
  String get subscriptionRestoredSuccessfully;

  /// No description provided for @noActiveSubscriptionFoundToRestore.
  ///
  /// In en, this message translates to:
  /// **'No active subscription found to restore.'**
  String get noActiveSubscriptionFoundToRestore;

  /// No description provided for @cancelSubscription.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription'**
  String get cancelSubscription;

  /// No description provided for @cancelSubscriptionQuestion.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription?'**
  String get cancelSubscriptionQuestion;

  /// No description provided for @ifYouCancelTodayPremiumAccess.
  ///
  /// In en, this message translates to:
  /// **'If you cancel today, your premium access will remain active until {date}.\n\nPlease let us know why you are leaving:'**
  String ifYouCancelTodayPremiumAccess(String date);

  /// No description provided for @tooExpensive.
  ///
  /// In en, this message translates to:
  /// **'Too expensive'**
  String get tooExpensive;

  /// No description provided for @notGettingEnoughClientRequests.
  ///
  /// In en, this message translates to:
  /// **'Not getting enough client requests'**
  String get notGettingEnoughClientRequests;

  /// No description provided for @usingADifferentPlatform.
  ///
  /// In en, this message translates to:
  /// **'Using a different platform'**
  String get usingADifferentPlatform;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @stayWithUsGet20Off.
  ///
  /// In en, this message translates to:
  /// **'Stay with us! Get 20% OFF your next billing cycle instead of cancelling.'**
  String get stayWithUsGet20Off;

  /// No description provided for @keepMySubscription.
  ///
  /// In en, this message translates to:
  /// **'Keep My Subscription'**
  String get keepMySubscription;

  /// No description provided for @confirmCancellation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Cancellation'**
  String get confirmCancellation;

  /// No description provided for @pleaseCancelViaStore.
  ///
  /// In en, this message translates to:
  /// **'Please cancel via your Google Play or App Store subscriptions page.'**
  String get pleaseCancelViaStore;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @writeSomethingAboutYourself.
  ///
  /// In en, this message translates to:
  /// **'Write something about yourself...'**
  String get writeSomethingAboutYourself;

  /// No description provided for @pricePerHour.
  ///
  /// In en, this message translates to:
  /// **'Price per hour'**
  String get pricePerHour;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No description provided for @selectExperience.
  ///
  /// In en, this message translates to:
  /// **'Select experience'**
  String get selectExperience;

  /// No description provided for @specialties.
  ///
  /// In en, this message translates to:
  /// **'Specialties'**
  String get specialties;

  /// No description provided for @otherTasksOffered.
  ///
  /// In en, this message translates to:
  /// **'Other tasks offered'**
  String get otherTasksOffered;

  /// No description provided for @workSchedule.
  ///
  /// In en, this message translates to:
  /// **'Work schedule'**
  String get workSchedule;

  /// No description provided for @whenAreYouAvailable.
  ///
  /// In en, this message translates to:
  /// **'When are you available to offer your services?'**
  String get whenAreYouAvailable;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @pleaseUploadAnImage.
  ///
  /// In en, this message translates to:
  /// **'Please upload an image for each selected option.'**
  String get pleaseUploadAnImage;

  /// No description provided for @ifYouAlreadySubmitARequest.
  ///
  /// In en, this message translates to:
  /// **'If you already submit a request please login with another account'**
  String get ifYouAlreadySubmitARequest;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @myWorkAreas.
  ///
  /// In en, this message translates to:
  /// **'My work areas'**
  String get myWorkAreas;

  /// No description provided for @currentLocationMap.
  ///
  /// In en, this message translates to:
  /// **'Current Location Map'**
  String get currentLocationMap;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @pleaseSelectYourRole.
  ///
  /// In en, this message translates to:
  /// **'Please select your role'**
  String get pleaseSelectYourRole;

  /// No description provided for @micAndCameraPermissionsRequired.
  ///
  /// In en, this message translates to:
  /// **'Microphone and Camera permissions are required'**
  String get micAndCameraPermissionsRequired;

  /// No description provided for @userIsBusyOrUnavailable.
  ///
  /// In en, this message translates to:
  /// **'User is busy or unavailable'**
  String get userIsBusyOrUnavailable;

  /// No description provided for @paymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment successful'**
  String get paymentSuccessful;

  /// No description provided for @accessLocked.
  ///
  /// In en, this message translates to:
  /// **'ACCESS LOCKED'**
  String get accessLocked;

  /// No description provided for @subscriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Subscription required'**
  String get subscriptionRequired;

  /// No description provided for @startFreeTrialToReceiveRequests.
  ///
  /// In en, this message translates to:
  /// **'Start your 30-day free trial to receive\nand manage customer requests.'**
  String get startFreeTrialToReceiveRequests;

  /// No description provided for @startFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'Start Free Trial'**
  String get startFreeTrial;

  /// No description provided for @youCanStillManageProfile.
  ///
  /// In en, this message translates to:
  /// **'You can still manage your profile,\nservices and schedule.'**
  String get youCanStillManageProfile;

  /// No description provided for @tryIumiProviderFree.
  ///
  /// In en, this message translates to:
  /// **'Try IUMI Provider free'**
  String get tryIumiProviderFree;

  /// No description provided for @unlockEveryFeature.
  ///
  /// In en, this message translates to:
  /// **'Unlock every provider feature for 30 days.'**
  String get unlockEveryFeature;

  /// No description provided for @thirtyDaysFree.
  ///
  /// In en, this message translates to:
  /// **'30 DAYS FREE'**
  String get thirtyDaysFree;

  /// No description provided for @receiveCustomerRequests.
  ///
  /// In en, this message translates to:
  /// **'Receive customer requests'**
  String get receiveCustomerRequests;

  /// No description provided for @acceptOrDeclineBookings.
  ///
  /// In en, this message translates to:
  /// **'Accept or decline bookings'**
  String get acceptOrDeclineBookings;

  /// No description provided for @contactCustomersAfterAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Contact customers after acceptance'**
  String get contactCustomersAfterAcceptance;

  /// No description provided for @manageYourSchedule.
  ///
  /// In en, this message translates to:
  /// **'Manage your schedule'**
  String get manageYourSchedule;

  /// No description provided for @freeFor30Days.
  ///
  /// In en, this message translates to:
  /// **'Free for 30 days'**
  String get freeFor30Days;

  /// No description provided for @then4999RonMonthCancelAnytime.
  ///
  /// In en, this message translates to:
  /// **'Then 49.99 RON/month. Cancel anytime.'**
  String get then4999RonMonthCancelAnytime;

  /// No description provided for @start30DayFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'Start 30-Day Free Trial'**
  String get start30DayFreeTrial;

  /// No description provided for @upgradePremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Premium'**
  String get upgradePremium;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @noPaymentToday.
  ///
  /// In en, this message translates to:
  /// **'No payment today. Works across\niOS, Android and web.'**
  String get noPaymentToday;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pt',
    'ro',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
