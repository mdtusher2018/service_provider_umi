// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get home => 'الرئيسية';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get save => 'حفظ';

  @override
  String languageChangedTo(String language) {
    return 'تم تغيير اللغة إلى $language';
  }

  @override
  String get noBookings => 'لا توجد حجوزات';

  @override
  String get yourBookingsWillAppearHere => 'ستظهر حجوزاتك هنا';

  @override
  String get noProvidersFound => 'لم يتم العثور على مزودين';

  @override
  String get calendar => 'تقويم';

  @override
  String get service => 'خدمة';

  @override
  String get favourites => 'المفضلة';

  @override
  String get notification => 'إشعار';

  @override
  String get inbox => 'صندوق الوارد';

  @override
  String get minimumPriceSavedSuccessfully => 'تم حفظ السعر الأدنى بنجاح';

  @override
  String get minimumPriceTitle => 'السعر الأدنى';

  @override
  String get minimumPriceQuestion =>
      'ما هو السعر الأدنى الذي يجب أن يدفعه العميل لحجز خدمتك؟  +info';

  @override
  String get minimumPriceLabel => 'السعر الأدنى:';

  @override
  String get minimumPriceTip =>
      'سيؤدي هذا إلى تجنب الحجز بسعر منخفض جدًا لدرجة أنه لا يستحق وقتك في التنقل إلى الخدمة';

  @override
  String get upcomingBookings => 'الحجوزات القادمة';

  @override
  String get dateFilter => 'مرشح التاريخ';

  @override
  String get noBookingsFound => 'لم يتم العثور على أي حجوزات';

  @override
  String get request => 'طلب';

  @override
  String get completed => 'مكتمل';

  @override
  String get ongoing => 'مستمر';

  @override
  String get cancelled => 'تم الإلغاء';

  @override
  String get completedServices => 'الخدمات المكتملة';

  @override
  String get accountSettings => 'إعدادات الحساب';

  @override
  String get personalDetails => 'التفاصيل الشخصية';

  @override
  String get myAddresses => 'عناويني';

  @override
  String get paymentsAndRefunds => 'المدفوعات والمبالغ المستردة';

  @override
  String get mySubscription => 'اشتراكي';

  @override
  String get myListing => 'إعلاني';

  @override
  String get mySchedule => 'الجدول الزمني الخاص بي';

  @override
  String get minimumBookingAmount => 'الحد الأدنى لمبلغ الحجز';

  @override
  String get myReview => 'تقييمي';

  @override
  String get addFaq => 'إضافة سؤال شائع';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get language => 'لغة';

  @override
  String get aboutUs => 'معلومات عنا';

  @override
  String get termsAndConditions => 'الشروط والأحكام';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get logout => 'تسجيل خروج';

  @override
  String get failedToLoadProfile => 'فشل تحميل الملف الشخصي';

  @override
  String get pullToRefresh => 'اسحب للتحديث';

  @override
  String get areYouSureToLogout => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get notConnected => 'غير متصل';

  @override
  String get connected => 'متصل';

  @override
  String stripe(String status) {
    return 'Stripe : $status';
  }

  @override
  String get areYouSureToDeleteAccount => 'هل أنت متأكد أنك تريد الحذف؟';

  @override
  String get profileUpdatedSuccessfully => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String failedToUpdateProfile(String message) {
    return 'فشل تحديث الملف الشخصي: $message';
  }

  @override
  String failedToDeleteAccount(String message) {
    return 'فشل حذف الحساب: $message';
  }

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get aboutMe => 'ْعَنِّي';

  @override
  String get searchYourAddress => 'ابحث عن عنوانك...';

  @override
  String get phoneNumber => 'رقم التليفون';

  @override
  String get deleteAccountPermanently => 'حذف الحساب نهائيًا';

  @override
  String get yesDelete => 'نعم، احذف';

  @override
  String get noDontDelete => 'لا، لا تحذف';

  @override
  String get myAddress => 'عنواني';

  @override
  String get yourAddresses => 'عناوينك';

  @override
  String get retry => 'أعد المحاولة';

  @override
  String get noAddresses => 'لا عناوين';

  @override
  String get addYourFirstAddressBelow => 'أضف عنوانك الأول أدناه';

  @override
  String get addNewAddress => 'إضافة عنوان جديد';

  @override
  String get defaultAddressUpdated => 'تم تحديث العنوان الافتراضي';

  @override
  String get defaultString => 'تقصير';

  @override
  String addressLabel(String address) {
    return 'العنوان: $address';
  }

  @override
  String get setAsDefault => 'تعيين كافتراضي';

  @override
  String get edit => 'يحرر';

  @override
  String get delete => 'يمسح';

  @override
  String get areYouSureToDelete => 'هل أنت متأكد أنك تريد الحذف؟';

  @override
  String get thisAddressWillBeRemoved => 'ستتم إزالة هذا العنوان نهائيًا.';

  @override
  String get pleaseSearchAndSelectAddress => 'الرجاء البحث واختيار عنوان أولا.';

  @override
  String get editAddress => 'تحرير العنوان';

  @override
  String get addAddress => 'أضف عنوانًا';

  @override
  String get searchAddress => 'عنوان البحث';

  @override
  String latLng(String lat, String lng) {
    return 'خط العرض: $lat، خط الطول: $lng';
  }

  @override
  String get reviewAndAdjust => 'قم بالمراجعة والتعديل إذا لزم الأمر';

  @override
  String get addressLine1 => 'العنوان سطر 1 *';

  @override
  String get streetNumberAndName => 'رقم واسم الشارع';

  @override
  String get required => 'مطلوب';

  @override
  String get addressLine2 => 'سطر العنوان 2';

  @override
  String get areaNeighbourhood => 'المنطقة / الحي (اختياري)';

  @override
  String get city => 'مدينة';

  @override
  String get state => 'ولاية';

  @override
  String get postalCode => 'رمز بريدي';

  @override
  String get postal => 'بريدي';

  @override
  String get country => 'دولة';

  @override
  String get updateAddress => 'تحديث العنوان';

  @override
  String get saveAddress => 'حفظ العنوان';

  @override
  String get myCards => 'بطاقاتي';

  @override
  String get addNew => 'أضف جديد';

  @override
  String get failedToGetAddCardLink => 'فشل الحصول على رابط إضافة البطاقة';

  @override
  String get noCardsFound => 'لم يتم العثور على بطاقات';

  @override
  String get cardDeletedSuccessfully => 'تم حذف البطاقة بنجاح';

  @override
  String get setAsDefaultCardSuccessfully => 'تم تعيينها كبطاقة افتراضية بنجاح';

  @override
  String get failedToSetDefaultCard => 'فشل في تعيين البطاقة الافتراضية';

  @override
  String get setAsDefaultCard => 'تعيين كبطاقة افتراضية';

  @override
  String get myBalance => 'رصيدي';

  @override
  String get availableBalance => 'الرصيد المتاح';

  @override
  String get paymentAndRefunds => 'الدفع والمبالغ المستردة';

  @override
  String get paymentMethods => 'طرق الدفع';

  @override
  String get myBooking => 'حجزي';

  @override
  String paidOn(String date) {
    return 'تم الدفع في $date';
  }

  @override
  String serviceDate(String date) {
    return 'تاريخ الخدمة: $date';
  }

  @override
  String get passwordChangedSuccessfully => 'تم تغيير كلمة المرور بنجاح';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get oldPassword => 'كلمة المرور القديمة';

  @override
  String get enterOldPassword => 'أدخل كلمة المرور القديمة';

  @override
  String get newPassword => 'كلمة مرور جديدة';

  @override
  String get confirmNewPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get faqAddedSuccessfully => 'تم إضافة السؤال الشائع بنجاح';

  @override
  String get question => 'سؤال';

  @override
  String get enterYourQuestion => 'أدخل سؤالك';

  @override
  String get pleaseEnterQuestion => 'يرجى إدخال سؤال';

  @override
  String get answer => 'إجابة';

  @override
  String get enterYourAnswer => 'أدخل إجابتك';

  @override
  String get pleaseEnterAnswer => 'يرجى إدخال إجابة';

  @override
  String get submitFaq => 'إرسال السؤال الشائع';

  @override
  String get reviews => 'المراجعات';

  @override
  String get noReviewsFound => 'لم يتم العثور على تعليقات';

  @override
  String get noContentAvailable => 'لا يوجد محتوى متاح.';

  @override
  String get tryAgain => 'حاول ثانية';

  @override
  String get createAccountBtn => 'إنشاء حساب';

  @override
  String get logIn => 'تسجيل الدخول';

  @override
  String get continueAsGuest => 'استمر كضيف';

  @override
  String get whatWillYouDoOnIumi => 'ماذا ستفعل في إيومي؟';

  @override
  String get roleDecisionNotFinal =>
      'هذا القرار ليس نهائيا. يمكنك لاحقًا أن تصبح عميلاً\nومحترف من الحساب إذا كنت ترغب في ذلك.';

  @override
  String get bookAService => 'احجز خدمة';

  @override
  String get iAmAClient => 'أنا عميل';

  @override
  String get offerServices => 'تقديم الخدمات';

  @override
  String get iAmAProfessional => 'أنا محترف';

  @override
  String get createAccountTitle => 'إنشاء حساب';

  @override
  String get enterYourName => 'أدخل اسمك';

  @override
  String get enterEmail => 'أدخل البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get serviceLocation => 'موقع الخدمة';

  @override
  String get yourLocation => 'موقعك';

  @override
  String get searchAndSelectServiceArea =>
      'ابحث عن منطقة الخدمة الخاصة بك وحددها حتى يتمكن العملاء من العثور عليك.';

  @override
  String get weUseLocationForServices =>
      'نحن نستخدم موقعك لتظهر لك الخدمات ذات الصلة القريبة.';

  @override
  String get searchCitySuburbAddress =>
      'ابحث عن المدينة أو الضاحية أو العنوان...';

  @override
  String get acceptTermsPrivacy =>
      'من خلال إنشاء حساب، أوافق على الشروط والأحكام وأؤكد أنني قرأت سياسة الخصوصية';

  @override
  String get termsAndCondition => 'الشروط والأحكام';

  @override
  String get pleaseAcceptTerms => 'يرجى قبول الشروط والأحكام للمتابعة';

  @override
  String get haveAccountLogin => 'هل لديك حساب؟  تسجيل الدخول';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get forgotPassword => 'هل نسيت كلمة السر؟';

  @override
  String get enterEmailSendOtp =>
      'أدخل بريدك الإلكتروني وسنرسل لك كلمة مرور لمرة واحدة (OTP) لإعادة التعيين.';

  @override
  String get enterYourEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get sendOtp => 'أرسل كلمة مرور لمرة واحدة';

  @override
  String get otpVerifiedSuccessfully => 'تم التحقق من OTP بنجاح';

  @override
  String get otpResentSuccessfully => 'تمت إعادة إرسال OTP بنجاح';

  @override
  String get verifyOtp => 'التحقق من كلمة المرور لمرة واحدة (OTP).';

  @override
  String enterOtpSentTo(String email) {
    return 'أدخل كلمة المرور لمرة واحدة (OTP) المرسلة إلى $email';
  }

  @override
  String get enterTheOtp => 'أدخل كلمة المرور لمرة واحدة';

  @override
  String get verify => 'يؤكد';

  @override
  String get didNotReceiveOtpResend =>
      'لم تتلق كلمة المرور لمرة واحدة؟  إعادة الإرسال';

  @override
  String get resend => 'إعادة الإرسال';

  @override
  String resendOtpInSeconds(int seconds) {
    return 'أعد إرسال OTP خلال $seconds ثانية';
  }

  @override
  String get passwordResetSuccessfully =>
      'تم إعادة تعيين كلمة المرور بنجاح. الرجاء تسجيل الدخول.';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get continueWithGoogle => 'تواصل مع جوجل';

  @override
  String get or => 'أو';

  @override
  String get loginWithEmail => 'تسجيل الدخول مع البريد الإلكتروني';

  @override
  String get createWithEmail => 'إنشاء باستخدام البريد الإلكتروني';

  @override
  String get weValueYourPrivacy => 'نحن نقدر خصوصيتك';

  @override
  String get cookiePolicyMsg =>
      'تستخدم Webel ملفات تعريف الارتباط لتحليل أداء الحملات الإعلانية وتحسين إعلانات التطبيقات وتخصيص التجربة بناءً على تفضيلات المستخدم.';

  @override
  String get accept => 'يقبل';

  @override
  String get serviceAddress => 'عنوان الخدمة';

  @override
  String get selectWhereYouWantToReceiveService =>
      'اختر المكان الذي تريد تلقي الخدمة فيه';

  @override
  String get support => 'يدعم';

  @override
  String get call => 'يتصل';

  @override
  String get phoneNumberCopied => 'تم نسخ رقم الهاتف إلى الحافظة';

  @override
  String get message => 'رسالة';

  @override
  String get emailCopied => 'تم نسخ البريد الإلكتروني إلى الحافظة';

  @override
  String get verificationPending => 'التحقق معلق';

  @override
  String get verificationPendingDesc =>
      'حسابك في انتظار التحقق. قد تكون بعض الميزات محدودة حتى يتم التحقق من حسابك.';

  @override
  String get refresh => 'ينعش';

  @override
  String get whenDoYouNeedIt => 'متى تحتاج إليها؟';

  @override
  String get frequency => 'تكرار';

  @override
  String get justOnce => 'مرة واحدة فقط';

  @override
  String get oneTime => 'لمرة واحدة';

  @override
  String get weekly => 'أسبوعي';

  @override
  String get recurring => 'يتكرر';

  @override
  String get daysOfTheWeek => 'يوم (أيام) الأسبوع';

  @override
  String get startTime => 'وقت البدء';

  @override
  String get flexibleStart => 'بداية مرنة';

  @override
  String get exactStart => 'البداية الدقيقة';

  @override
  String get morning => 'صباح';

  @override
  String get evening => 'مساء';

  @override
  String get selectExactTime => 'حدد الوقت المحدد';

  @override
  String get skip => 'يتخطى';

  @override
  String get search => 'يبحث';

  @override
  String get back => 'خلف';

  @override
  String get clearFilters => 'مسح المرشحات';

  @override
  String get palliativeCare => 'الرعاية التلطيفية';

  @override
  String get palliativeCareDesc =>
      'اعرض فقط المتخصصين المتخصصين في الرعاية التلطيفية.';

  @override
  String get drivingLicence => 'رخصة القيادة';

  @override
  String get drivingLicenceDesc => 'أظهر فقط للمحترفين الذين لديهم رخصة قيادة';

  @override
  String get businessProfiles => 'الملفات الشخصية للأعمال';

  @override
  String get businessProfilesDesc =>
      'فقط الملفات الشخصية التي تتوافق مع شركة تم التحقق من صحتها أو محترف يعمل لحسابه الخاص.';

  @override
  String get qualifiedCarer => 'مقدم رعاية مؤهل';

  @override
  String get qualifiedCarerDesc =>
      'أظهر فقط مقدمي الرعاية الحاصلين على مؤهل أو دبلوم أو درجة علمية كشخصيين صحيين';

  @override
  String get priceRange => 'النطاق السعري';

  @override
  String get hourlyRate => 'سعر الساعة';

  @override
  String get maxPriceWillingToPay =>
      'الحد الأقصى للسعر الذي أنت على استعداد لدفعه.';

  @override
  String get experienceLevel => 'مستوى الخبرة';

  @override
  String get specificTasksRequirements => 'مهام / متطلبات محددة';

  @override
  String get updatedSuccessfully => 'تم التحديث بنجاح';

  @override
  String get images => 'الصور';

  @override
  String get coverImage => 'صورة الغلاف';

  @override
  String get galleryImages => 'صور المعرض';

  @override
  String get add => 'إضافة';

  @override
  String get palliativeCareImage => 'صورة الرعاية التلطيفية';

  @override
  String get drivingLicenceImage => 'صورة رخصة القيادة';

  @override
  String get businessProfileImage => 'صورة الملف الشخصي للنشاط التجاري';

  @override
  String get qualificationCertificate => 'شهادة التأهيل';

  @override
  String get submit => 'يُقدِّم';

  @override
  String get update => 'تحديث';

  @override
  String get applyFilters => 'تطبيق المرشحات';

  @override
  String get verificationSubmitted => 'تم إرسال التحقق';

  @override
  String get verificationSubmittedDesc =>
      'لقد تم تقديم طلبك بنجاح.\n\nالرجاء تسجيل الدخول مرة أخرى بحساب آخر.';

  @override
  String get findTheServiceYouNeed => 'ابحث عن الخدمة التي تحتاجها';

  @override
  String get mostPopularInYourArea => 'الأكثر شعبية في منطقتك';

  @override
  String get searchResults => 'نتائج البحث';

  @override
  String get noServicesFound => 'لم يتم العثور على الخدمات';

  @override
  String get tryADifferentSearchTerm => 'حاول استخدام مصطلح بحث مختلف';

  @override
  String get howDoesTheServiceWork => 'كيف تعمل الخدمة؟';

  @override
  String get finding => 'العثور على';

  @override
  String get professionals => 'المهنيين';

  @override
  String get whenQuestion => 'متى؟';

  @override
  String get filters => 'المرشحات';

  @override
  String get howDoesTheServiceWorkTitle => 'كيف يعتني بكبار السن\nعمل الخدمة؟';

  @override
  String get noFaqsAvailable => 'لا توجد أسئلة وأجوبة متاحة';

  @override
  String get bookingAccepted => 'تم قبول الحجز';

  @override
  String get comment => 'تعليق';

  @override
  String get serviceBookedSuccess =>
      'تم حجز الخدمة بنجاح لرعاية المسنين. يرجى التأكد من أن المساعدة تشمل تسجيلات الوصول اليومية والتذكير بالأدوية والمساعدة في التنقل كما تمت مناقشته.';

  @override
  String get dateAndTime => 'التاريخ والوقت';

  @override
  String get address => 'عنوان';

  @override
  String get servicePrice => 'سعر الخدمة';

  @override
  String get complete => 'مكتمل';

  @override
  String get bookingHasBeenCompleted => 'تم الانتهاء من هذا الحجز';

  @override
  String get customer => 'عميل:';

  @override
  String get provider => 'مزود:';

  @override
  String cantChatBeforeAction(String action) {
    return 'لا يمكنك الدردشة قبل $action الحجز';
  }

  @override
  String get accepting => 'قبول';

  @override
  String get creating => 'خلق';

  @override
  String failedToLoadChat(String message) {
    return 'فشل تحميل الدردشة: $message';
  }

  @override
  String get serviceText => 'خدمة';

  @override
  String get bookingHours => 'ساعات الحجز';

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String get clientProtection => 'حماية العميل';

  @override
  String get total => 'المجموع';

  @override
  String get free => 'حر';

  @override
  String get details => 'تفاصيل';

  @override
  String get noDataFound => 'لم يتم العثور على بيانات';

  @override
  String get addressNotAvailable => 'العنوان غير متوفر';

  @override
  String addressCoordsLabel(String lat, String lng) {
    return 'العنوان: خط العرض: $lat، خط الطول: $lng';
  }

  @override
  String get congratulations => 'تهانينا';

  @override
  String get congratulationsDesc =>
      'تهانينا على تحقيق هذا الإنجاز في رحلتك المهنية! إن تفانيك وخبرتك وعملك الجاد يستحق الثناء حقًا.';

  @override
  String get done => 'منتهي';

  @override
  String get setUpAtLeastOneDay => 'قم بإعداد يوم واحد على الأقل';

  @override
  String get selectATimeSlot => 'حدد فترة زمنية';

  @override
  String get bookingDotDot => 'الحجز…';

  @override
  String continueForAmountPerWeek(String price) {
    return 'استمر بسعر \$$price/أسبوع';
  }

  @override
  String bookForAmount(String price) {
    return 'احجز بسعر \$$price';
  }

  @override
  String get couldNotLoadAvailableSlots =>
      'تعذر تحميل الفتحات المتاحة. اضغط على \"إعادة المحاولة\" أعلاه.';

  @override
  String get noAvailableSlotsForDuration => 'لا توجد فتحات متاحة لهذه المدة.';

  @override
  String get selectATime => 'حدد الوقت';

  @override
  String saveTimeDuration(String start, String end, String duration) {
    return 'احفظ $start - $end · $duration ساعة';
  }

  @override
  String get chat => 'محادثة';

  @override
  String get history => 'تاريخ';

  @override
  String get alerts => 'التنبيهات';

  @override
  String get newAlerts => 'تنبيهات جديدة';

  @override
  String get searchFriends => 'البحث عن الأصدقاء';

  @override
  String get noUnreadAlerts => 'لا توجد تنبيهات غير مقروءة';

  @override
  String get paymentPending => 'الدفع معلق';

  @override
  String get pendingAcceptance => 'في انتظار القبول';

  @override
  String get payNow => 'ادفع الآن';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get serviceInProgress => 'الخدمة قيد التقدم';

  @override
  String get rating => 'تصنيف';

  @override
  String get needSupportImmediately => 'بحاجة إلى الدعم على الفور';

  @override
  String get manageSubscription => 'إدارة الاشتراك';

  @override
  String get subscriptionStatus => 'حالة الاشتراك';

  @override
  String freeTrialDaysLeft(String daysLeft) {
    return 'نسخة تجريبية مجانية مدتها 30 يومًا (متبقية $daysLeft من الأيام)';
  }

  @override
  String get cancelledActiveTillPeriodEnd => 'ملغى (نشط حتى نهاية الفترة)';

  @override
  String get activePremium => 'Premium نشط';

  @override
  String get expired => 'منتهي الصلاحية';

  @override
  String get currentPlan => 'الخطة الحالية';

  @override
  String get subscriptionPrice => 'سعر الاشتراك';

  @override
  String get activationDate => 'تاريخ التفعيل';

  @override
  String get nextBillingRenewal => 'الفوترة التالية / التجديد';

  @override
  String get purchasePlatform => 'منصة الشراء';

  @override
  String get annualPremium => 'القسط السنوي';

  @override
  String get monthlyPremium => 'القسط الشهري';

  @override
  String get noSubscriptionPurchased => 'لم يتم شراء أي اشتراك';

  @override
  String get yourValueThisMonth => 'قيمتك هذا الشهر';

  @override
  String thisMonthRequestsBookings(String requests, String bookings) {
    return 'في هذا الشهر، تلقيت $requests طلبًا وقبلت $bookings حجزًا.';
  }

  @override
  String get requestsReceived => 'الطلبات المستلمة';

  @override
  String get bookingsAccepted => 'الحجوزات المقبولة';

  @override
  String get acceptanceRate => 'معدل القبول';

  @override
  String get upgradeToPremiumNow => 'الترقية إلى Premium الآن';

  @override
  String get restorePurchase => 'استعادة المشتريات';

  @override
  String get subscriptionRestoredSuccessfully => 'تمت استعادة الاشتراك بنجاح!';

  @override
  String get noActiveSubscriptionFoundToRestore =>
      'لم يتم العثور على اشتراك نشط لاستعادته.';

  @override
  String get cancelSubscription => 'إلغاء الاشتراك';

  @override
  String get cancelSubscriptionQuestion => 'إلغاء الاشتراك؟';

  @override
  String ifYouCancelTodayPremiumAccess(String date) {
    return 'إذا قمت بالإلغاء اليوم، فسيظل وصولك المميز نشطًا حتى $date.\n\nيرجى إعلامنا بسبب مغادرتك:';
  }

  @override
  String get tooExpensive => 'مكلفة للغاية';

  @override
  String get notGettingEnoughClientRequests =>
      'عدم الحصول على ما يكفي من طلبات العملاء';

  @override
  String get usingADifferentPlatform => 'باستخدام منصة مختلفة';

  @override
  String get other => 'آخر';

  @override
  String get stayWithUsGet20Off =>
      'ابق معنا! احصل على خصم 20% على دورة الفاتورة التالية بدلاً من الإلغاء.';

  @override
  String get keepMySubscription => 'احتفظ باشتراكي';

  @override
  String get confirmCancellation => 'تأكيد الإلغاء';

  @override
  String get pleaseCancelViaStore =>
      'يرجى الإلغاء عبر صفحة اشتراكات Google Play أو App Store.';

  @override
  String get bio => 'السيرة الذاتية';

  @override
  String get writeSomethingAboutYourself => 'أكتب شيئا عن نفسك...';

  @override
  String get pricePerHour => 'السعر لكل ساعة';

  @override
  String get experience => 'الخبرة';

  @override
  String get selectExperience => 'اختر الخبرة';

  @override
  String get specialties => 'التخصصات';

  @override
  String get otherTasksOffered => 'المهام الأخرى المقدمة';

  @override
  String get workSchedule => 'جدول العمل';

  @override
  String get whenAreYouAvailable => 'متى تكون متاحًا لتقديم خدماتك؟';

  @override
  String get monday => 'الاثنين';

  @override
  String get tuesday => 'الثلاثاء';

  @override
  String get wednesday => 'الأربعاء';

  @override
  String get thursday => 'الخميس';

  @override
  String get friday => 'الجمعة';

  @override
  String get saturday => 'السبت';

  @override
  String get sunday => 'الأحد';

  @override
  String get available => 'متاح';

  @override
  String get notAvailable => 'غير متاح';

  @override
  String get confirm => 'تأكيد';

  @override
  String get pleaseUploadAnImage => 'يرجى تحميل صورة لكل خيار محدد.';

  @override
  String get ifYouAlreadySubmitARequest =>
      'إذا كنت قد قدمت طلبًا بالفعل، فيرجى تسجيل الدخول باستخدام حساب آخر';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get myWorkAreas => 'مجالات عملي';

  @override
  String get currentLocationMap => 'خريطة الموقع الحالي';

  @override
  String get next => 'التالي';

  @override
  String get pleaseSelectYourRole => 'الرجاء تحديد دورك';

  @override
  String get micAndCameraPermissionsRequired =>
      'مطلوب أذونات الميكروفون والكاميرا';

  @override
  String get userIsBusyOrUnavailable => 'المستخدم مشغول أو غير متاح';

  @override
  String get paymentSuccessful => 'تم الدفع بنجاح';

  @override
  String get accessLocked => 'الوصول مغلق';

  @override
  String get subscriptionRequired => 'الاشتراك مطلوب';

  @override
  String get startFreeTrialToReceiveRequests =>
      'ابدأ تجربتك المجانية لمدة 30 يومًا لتلقيها\nوإدارة طلبات العملاء.';

  @override
  String get startFreeTrial => 'ابدأ النسخة التجريبية المجانية';

  @override
  String get youCanStillManageProfile =>
      'لا يزال بإمكانك إدارة ملفك الشخصي،\nالخدمات والجدول الزمني.';

  @override
  String get tryIumiProviderFree => 'جرب موفر IUMI مجانًا';

  @override
  String get unlockEveryFeature => 'فتح كل ميزة موفر لمدة 30 يوما.';

  @override
  String get thirtyDaysFree => '30 يومًا مجانًا';

  @override
  String get receiveCustomerRequests => 'تلقي طلبات العملاء';

  @override
  String get acceptOrDeclineBookings => 'قبول أو رفض الحجوزات';

  @override
  String get contactCustomersAfterAcceptance => 'الاتصال بالعملاء بعد القبول';

  @override
  String get manageYourSchedule => 'إدارة الجدول الزمني الخاص بك';

  @override
  String get freeFor30Days => 'مجانًا لمدة 30 يومًا';

  @override
  String get then4999RonMonthCancelAnytime =>
      'ثم 49.99 رون/الشهر. إلغاء في أي وقت.';

  @override
  String get start30DayFreeTrial =>
      'ابدأ النسخة التجريبية المجانية لمدة 30 يومًا';

  @override
  String get upgradePremium => 'ترقية بريميوم';

  @override
  String get notNow => 'ليس الآن';

  @override
  String get noPaymentToday =>
      'لا يوجد دفع اليوم. يعمل عبر\niOS وأندرويد والويب.';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get seeMore => 'عرض المزيد';

  @override
  String get documents => 'مستندات';

  @override
  String get chooseYourPlan => 'اختر خطتك';

  @override
  String get noPlansAvailable => 'لا توجد خطط متاحة في الوقت الحالي.';

  @override
  String get checkBackLater => 'يرجى التحقق مرة أخرى لاحقًا أو الاتصال بالدعم.';

  @override
  String get upgradeToPremium => 'الترقية إلى Premium';

  @override
  String get unlockAllFeatures => 'افتح جميع الميزات ونمّي عملك.';

  @override
  String savePercent(String percent) {
    return 'وفر $percent%';
  }

  @override
  String get alreadySubscribed => 'أنت مشترك بالفعل في هذه الخطة.';

  @override
  String get planNotAvailable =>
      'هذه الخطة غير متاحة للشراء على هذه المنصة بعد. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String successfullySubscribed(String planName) {
    return 'تم الاشتراك بنجاح في $planName!';
  }

  @override
  String get subscribeNow => 'اشترك الآن';

  @override
  String get messageSentSuccessfully => 'تم إرسال رسالتك بنجاح.';

  @override
  String get failedToSendMessage =>
      'فشل إرسال الرسالة. يرجى المحاولة مرة أخرى.';

  @override
  String get pleaseSelectDocument =>
      'يرجى تحديد مستند واحد على الأقل للمتابعة.';

  @override
  String get documentsUpdatedSuccessfully => 'تم تحديث المستندات بنجاح';

  @override
  String get pleaseEnterValidPricePerHour => 'يرجى إدخال سعر صحيح لكل ساعة';

  @override
  String get listingUpdatedSuccessfully => 'تم تحديث القائمة بنجاح';

  @override
  String get failedToSubmitReview => 'فشل في تقديم المراجعة';

  @override
  String get reviewSubmittedSuccessfully => 'تم تقديم المراجعة بنجاح';

  @override
  String get failedToSaveSchedule => 'فشل حفظ الجدول الزمني. حاول مرة أخرى.';

  @override
  String get pleaseFillOutAllFields => 'يرجى ملء جميع الحقول.';

  @override
  String get pleaseSelectFlexibleStartTime =>
      'يرجى تحديد وقت بدء مرن أو استخدام \'تخطي\'.';

  @override
  String get outstanding => 'متميز';

  @override
  String get hello => 'مرحبًا';

  @override
  String get description => 'وصف';

  @override
  String get copyrightIBadi => 'حقوق الطبع والنشر عبادي';

  @override
  String get badi => 'بادي';

  @override
  String get download => 'تحميل';

  @override
  String get end => 'نهاية';

  @override
  String get markAllRead => 'وضع علامة على الكل مقروءة';

  @override
  String get goBack => 'عُد';

  @override
  String get iumiAdminSupport => 'دعم إدارة إيومي';

  @override
  String get emailAddress => 'عنوان البريد الإلكتروني';

  @override
  String get subject => 'موضوع';

  @override
  String get yourMessage => 'رسالتك';

  @override
  String get sayHello => 'قل مرحبا 👋';

  @override
  String get chooseOption => 'اختر الخيار';

  @override
  String get settings => 'إعدادات';

  @override
  String get completePayment => 'الدفع الكامل';

  @override
  String get noMessages => 'لا توجد رسائل';

  @override
  String get noNotification => 'لا يوجد إشعار';

  @override
  String get noScheduleAvailable => 'لا يوجد جدول زمني متاح.';

  @override
  String get additionalComments => 'تعليقات إضافية';

  @override
  String get gallery => 'معرض';

  @override
  String get failedToLoadGallery => 'فشل تحميل المعرض';

  @override
  String get noImagesAvailable => 'لا توجد صور متاحة';

  @override
  String get viewGallery => 'عرض المعرض';

  @override
  String get noGalleryImageFound => 'لم يتم العثور على صورة المعرض';

  @override
  String get comments => 'تعليقات';

  @override
  String get noCommentsFound => 'لم يتم العثور على تعليقات';

  @override
  String get serviceFrequency => 'تردد الخدمة';

  @override
  String get howManyTimesDoYouWantTheService => 'كم مرة تريد الخدمة؟';

  @override
  String get rateYourExperience => 'قيم تجربتك';

  @override
  String get deleteThisAddress => 'هل تريد حذف هذا العنوان؟';

  @override
  String get showSpecialistsIn => 'عرض المتخصصين في:';

  @override
  String get ok => 'نعم';

  @override
  String get chooseFromGallery => 'اختر من المعرض';

  @override
  String get takeAPhoto => 'التقط صورة';

  @override
  String get profilePicture => 'صورة الملف الشخصي';

  @override
  String get doYouWantToGoBack => 'هل تريد العودة؟';

  @override
  String get startYour30DayFreeTrialToReceiveAndManageCustomerRequests =>
      'ابدأ تجربتك المجانية لمدة 30 يومًا لتلقيها\n.وإدارة طلبات العملاء';

  @override
  String get youCanStillManageYourProfileServicesAndSchedule =>
      ',لا يزال بإمكانك إدارة ملفك الشخصي\n.الخدمات والجدول الزمني';
}
