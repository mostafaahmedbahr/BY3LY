# بيعلي (BY3LY) — التوثيق الشامل للتطبيق

> **APP_DOCUMENTATION.md** — وثيقة تقنية كاملة للتطبيق، مُعدّة وفق تحليل الكود الفعلي فقط.
> كل ما لا يمكن التحقق منه من الكود مُعلّم صراحةً بـ **"Not Found"** أو **"Needs Verification"**.
> المصطلحات التقنية وأسماء الفئات والملفات وواجهات API بقيت بالإنجليزية كما هي في الكود.
>
> تاريخ الإعداد: 2026-11-09 — إصدار التطبيق الموثّق: `1.0.0+1` (انظر `pubspec.yaml`).
> عدد ملفات Dart في `lib/`: **445** ملفًا.

---

## جدول المحتويات

1. [نظرة عامة على التطبيق](#1-نظرة-عامة-على-التطبيق)
2. [الـ Technology Stack](#2-الـ-technology-stack)
3. [معمارية المشروع (Project Architecture)](#3-معمارية-المشروع-project-architecture)
4. [المميزات والوظائف (Features)](#4-المميزات-والوظائف-features)
5. [أدوار المستخدمين والصلاحيات](#5-أدوار-المستخدمين-والصلاحيات)
6. [رحلات وعمليات التطبيق (Workflows)](#6-رحلات-وعمليات-التطبيق-workflows)
7. [توثيق قاعدة البيانات](#7-توثيق-قاعدة-البيانات)
8. [توثيق الـ API](#8-توثيق-الـ-api)
9. [المصادقة والأمان](#9-المصادقة-والأمان)
10. [التثبيت والإعداد](#10-التثبيت-والإعداد)
11. [القيود المعروفة والديون التقنية](#11-القيود-المعروفة-والديون-التقنية)
12. [Glossary (قاموس المصطلحات)](#12-glossary-قاموس-المصطلحات)

---

# 1. نظرة عامة على التطبيق

| البند | القيمة |
|---|---|
| **اسم التطبيق** | BY3LY (بيعلي) — في `my_app.dart`: `title: "BY3LY"`، وعلى Android يظهر باسم `by3ly` (`android/app/src/main/AndroidManifest.xml`) وعلى iOS باسم **By3ly** (`ios/Runner/Info.plist` → `CFBundleDisplayName`) |
| **النوع** | تطبيق Flutter متقاطع (Android / iOS فقط — منصات web/macOS/windows/linux موجودة في الشجرة لكن `firebase_options.dart` يرمي `UnsupportedError` عليها؛ أي أن الدعم الفعلي للـ Firebase هو Android و iOS فقط) |
| **الفئة** | سوق إلكتروني / إعلانات مبوبة (Online Marketplace / Classifieds) خاص بالسوق المصري |
| **اللغة الافتراضية** | العربية (`startLocale: Locale('ar')` في `main.dart`)، مع دعم كامل للإنجليزية (350 مفتاح في `lib/lang/locale_keys.dart`) |
| **الغرض** | منصة وصل بين البائع والمشتري: نشر إعلانات المنتجات، تصفح الفئات، البحث والفلترة، التفاوض/الشراء، التواصل عبر شات داخلي، وإدارة الإعلانات والباقات والشحن عبر محفظة داخلية |
| **الـ Backend** | API بعيد عبر Dio — Base URL الحالي: `https://by3li.axeviadigital.com/api/` (مُعرّف في `lib/core/app_services/remote_services/end_points.dart`) |

## 1.1 المشاكل التي يحلها التطبيق

1. تمكين أي فرد/متجر من **عرض منتجاته للبيع** في السوق المصري مع صور وفيديو (صور فعليًا).
2. تمكين المشتري من **البحث والمقارنة** بين منتجين جنبًا إلى جنب قبل الشراء.
3. توفير **قناة تواصل آمنة** بين المشتري والبائع داخل التطبيق (Chat) بدلًا من مشاركة الأرقام.
4. إدارة **باقات النشر المدفوعة** (Subscription Packages) وربطها بمحفظة داخلية وطرق دفع تحويل (Vodafone Cash / Orange Cash / Etisalat Cash / InstaPay / Bank / Fawry).
5. مكافحة إساءة الاستخدام عبر **التبليغ** (report ad / complaint) وحظر الشراء بدون تسجيل.

## 1.2 الفئة المستهدفة

- **المشترون**: تصفح مجاني عبر وضع الزائر (Guest Mode) أو بحساب.
- **البائعون الأفراد والمتاجر (مصريون)**: يحتاجون حسابًا + اشتراك/دفع رسوم النشر.
- **تطبيقات المصري**: صيغة الرقم المصري `^01[0-9]{9}$` إجبارية في التحقق (`MyValidators.phoneValidator`).

## 1.3 أبرز المميزات المنفذة فعليًا في الكود

| المجال | المميزات |
|---|---|
| التصفح | Home (بانرات + فئات + أفضل المنتجات)، جميع الفئات والفئات الفرعية، منتجات حسب الفئة الفرعية، بحث مع فلترة سيرفرية + Pagination |
| المنتجات | تفاصيل المنتج (جاليري + تقييم + منتجات مشابهة + التواصل مع البائع + porównanie)، مقارنة منتجين (حد أقصى 2)، صفحة البائع |
| النشر | إضافة إعلان (حتى 5 صور)، تعديل إعلان، إيقاف/تفعيل الإعلان، حذف إعلان، "إعلاناتي" مع فلاتر (الكل/النشط/غير النشط) |
| الاشتراكات والمحفظة | باقات اشتراك شهرية/3/6 شهور/سنوية، الدفع عبر المحفظة أو تحويل مع رفع إيصال، شحن المحفظة (`wallet/top-up`)، سجل الحركات (`wallet/history`) مع تحميل/مشاركة الإيصال |
| الحساب | تسجيل/دخول بالهاتف + تفعيل عبر OTP (بريد إلكتروني)، نسيان كلمة المرور عبر resetPassword (وضع برمجي فقط بدون واجهة)، حذف الحساب |
| الاجتماعي | شات مشتري↔بائع (Polling: كل دقيقة داخل المحادثة، كل دقيقتين في القائمة)، إشعارات FCM + عداد غير مقروء |
| الدعم | صفحة مساعدة (FAQ محلية)، شات دعم محلي (بدون API)، تبليغ عن منتج/إعلان، محتوى قانوني (About / Terms / Privacy) من الـ API |
| إضافي | وضع الزائر (Guest)، دعم الثيم الفاتح/الداكن، تغيير اللغة بدون إعادة تشغيل، إحصائيات البائع (مبيعات الشهر)، تعليمات الشراء (HTML من السيرفر)، إعدادات الخصوصية (وسيلة التواصل المفضلة) |

---

# 2. الـ Technology Stack

## 2.1 لغات وأطر العمل

| الطبقة | التقنية |
|---|---|
| اللغة | Dart (SDK `^3.12.1` في `pubspec.yaml`) |
| الإطار | Flutter (Material 3، منصات Android / iOS) |
| نمط المعمارية | Feature-first + طبقات `data` / `presentation` (مشابه لـ Clean Architecture) مع Cubits من `flutter_bloc` — **لاحظ**: لا توجد طبقة Domain كاملة؛ ملفات `lib/core/use_cases/` موجودة (`UseCaseWithParam` / `UseCaseWithNoParam` / `NoParam`) لكن **لا تُستخدم** في أي feature؛ كل Cubit يستدعي الـ Repository مباشرة ويعتمد على `dartz Either<Failure, T>` أحيانًا (الـ repos تُرجع `right/left` يدويًا) |
| إدارة الحالة | `flutter_bloc 8.1.6` + `bloc 8.1.x` + `Cubit` |
| حقن الاعتمادية | `get_it 9.3.0` (`lib/core/app_services/remote_services/service_locator.dart` — `setup()` يسجّل 30+ Singleton) |
| الشبكة | `dio 5.11.1` + `pretty_dio_logger` (debug فقط) |
| التخزين المحلي | `shared_preferences 2.5.5` (غير حساس) + `flutter_secure_storage 11.2.0` (التوكن) |
| الترجمة | `easy_localization 3.0.8` + `CodegenLoader` (الخرائط في `lib/lang/ar_lang.dart` و `en_lang.dart`؛ **المسار `assets/lang` غير موجود** — انظر قسم 11) |
| Firebase | `firebase_core 4.15.0` + `firebase_messaging 16.7.0` + `flutter_local_notifications 20.x` (Android-only display للـ data messages) |
| UI | `flutter_screenutil`, `responsive_framework`, `carousel_slider`, `smooth_page_indicator`, `shimmer`, `flutter_svg`, `cached_network_image 3.4.1`, `flutter_animate`, `flashy_tab_bar2`, `pin_code_fields`, `introduction_screen`, `custom_rating_bar`, `card_swiper`, `cherry_toast`, `quickalert`, `flutter_html` (الصفحات القانونية), `animated_theme_switcher`, `expansion_tile_card`, `flutter_staggered_animations`, `flutter_staggered_grid_view`, `easy_date_timeline`, `readmore`, `auto_size_text`, `gap`, `page_transition`, `conditional_builder_null_safety`, `loading_animation_widget`, `flutter_spinkit`, `flutter_image_stack` |
| أدوات أخرى | `url_launcher`, `image_picker`, `file_picker`, `share_plus`, `gal`, `path_provider`, `cupertino_icons`, `dartz`, `custom_rating_bar`, `connectivity` غير موجودة |

## 2.2 قواعد البيانات المحلية

**لا توجد قاعدة بيانات محلية.** لا يوجد `sqflite` / `hive` / `drift` / `floor` / `isar` في الاعتمادات. كل البيانات تأتي من الـ API؛ التخزين الوحيد هو:
- توكن المصادقة في `FlutterSecureStorage` (مفتاح `userToken`) عبر `SecureStorageService` / `CacheTokenManger`.
- بيانات صغيرة في `SharedPreferences` عبر `CacheHelper` (اللغة، `isGuest`، `fcmToken`، `firstRun`، `email`، `isDarkMode`، `userToken` نسخة نصية عادية!).

## 2.3 الخدمات الخارجية والتكاملات

| الخدمة | الاستخدام | مصدر في الكود |
|---|---|---|
| REST API خاص بـ BY3LY | كل البيانات | `EndPoints.baseUrl = https://by3li.axeviadigital.com/api/` (نسختان قديمتان معلّقتان: `by3li.leaderfortrans.com` و `http://tzhab.cloudy-digital.com`) |
| Firebase Cloud Messaging | إشعارات Push | `lib/core/notifications/`، `firebase_options.dart` (Android + iOS، مشروع `by3ly-ed414`) |
| Google Services | إعداد FCM لـ Android | `android/app/google-services.json` + نسخة مكررة في جذر المشروع (**مُتتبعة في Git**) |
| GoogleService-Info.plist | إعداد FCM لـ iOS | `ios/Runner/GoogleService-Info.plist` (**مُتتبعة في Git**) |
| url_launcher | فتح روابط البانرات، `mailto:`, `tel:` | `home_banner_slider.dart`، `help_support_cubit.dart` |
| الحافظة / المشاركة | نسخ أرقام التحويل، تحميل/مشاركة الإيصالات | `transfer_method_card.dart`، `wallet` history (`gal` + `share_plus`) |

## 2.4 أدوات التطوير والبناء

| الأداة | ملاحظة |
|---|---|
| `flutter_lints 6.0.0` | `analysis_options.yaml` يتضمن `package:flutter_lints/flutter.yaml` فقط؛ قواعد مخصصة معطلة (معلقة) |
| Android Gradle (Kotlin DSL) | `namespace/applicationId = com.example.by3ly`، `minSdk 24`، `targetSdk 36`، `compileSdk 36`، Java 17، `isCoreLibraryDesugaringEnabled = true` (desugar `2.1.4`) |
| iOS | `CFBundleDisplayName = By3ly`، permission usage وحيد: `NSPhotoLibraryAddUsageDescription` |
| الخطوط | Cairo (`assets/fonts/cairo/Cairo-VariableFont_slnt,wght.ttf`) — معرّف كـ `fontFamily` في الثيم |
| CI/CD | **غير موجود** (لا `.github/` ولا أي workflow) |
| الاختبارات | **غير موجودة** (لا مجلد `test/`) |

---

# 3. معمارية المشروع (Project Architecture)

## 3.1 الصورة العامة

```
┌─────────────────────────────────────────────────────────────┐
│                        UI (Views)                           │
│        lib/features/<feature>/presentation/views/           │
└───────────────┬─────────────────────────────┬───────────────┘
                │ context.read<Cubit>()        │ .tr() LocaleKeys
┌───────────────▼──────────────┐  ┌────────────▼─────────────┐
│   Cubit (Business Logic)     │  │  Shared Widgets / Core   │
│  view_model/*.dart + states  │  │  lib/core/shared_widgets │
└───────────────┬──────────────┘  └──────────────────────────┘
                │ calls
┌───────────────▼──────────────┐
│   Repository (Abstract/      │
│   Impl) — data/repos/        │
└───────────────┬──────────────┘
                │ Either<Failure, Model> (right/left)
┌───────────────▼──────────────┐
│   ApiService (Dio wrapper)   │  + CacheTokenManger (secure)
│   Interceptors: headers,     │  + CacheHelper (prefs)
│   Bearer, lang, 401→logout   │
└───────────────┬──────────────┘
                ▼
   https://by3li.axeviadigital.com/api/   (Laravel-style backend)
```

## 3.2 دورة حياة الطلب (مثال: تسجيل الدخول)

1. `LoginView` → `LoginButtonsWidget` يتحقق من الـ Form ثم يستدعي `LoginCubit.login(phone, password, deviceToken)`.
2. `LoginCubit` يستدعي `LoginRepoImpl.login(...)` → `ApiService.postData(endPoint: EndPoints.login, data: json.encode({...}))`.
3. `ApiService` يُرفق `Authorization: Bearer <token>`، `Accept-Language`، `lang`، ويطبع لوج في debug.
4. الرد يُحوَّل إلى `LoginModel` عبر `LoginModel.fromJson`، ويُعاد كـ `right(...)` / `left(handleError(e))`.
5. عند أي **401** في أي طلب، `ApiService` ينفّذ `_performLogout()`: يمسح التوكن + الكاش ويوجّه إلى `LoginView`.

## 3.3 أقسام المشروع ودور كل مجلد

```
lib/
├── main.dart                 # نقطة الدخول: AppInitializer + FCM + EasyLocalization + MyApp
├── main_importants.dart      # Barrel file واحد يستورد كل التصدير الشائع (>30 export)
├── my_app.dart               # MyApp: MultiBlocProvider لكل الـ Cubits العامة + MaterialApp
├── firebase_options.dart     # إعداد Firebase (Android/iOS فقط)
├── core/
│   ├── app_services/
│   │   ├── remote_services/  # api_service.dart, end_points.dart, service_locator.dart (DI)
│   │   └── local_services/   # cache_helper.dart (prefs), cache_token.dart, secure_storage_service.dart
│   ├── errors/               # failure.dart (ServerFailure + fromDioError), error_handler.dart, error_ui.dart
│   ├── extensions/           # lang.dart (isArabic), log.dart (ملون)، navigate.dart (push helpers)
│   ├── general_models/       # general_model.dart ({status, number, message})
│   ├── notifications/        # app_notifications.dart (FCM wiring), notification_service.dart (local notif),
│   │                         # device_token_sync.dart (معطّل — updateDeviceToken == null)
│   ├── routing/              # routes.dart (أسماء) + app_router.dart (توليد الـ Pages + DI للـ Cubits)
│   ├── shared_cubits/        # auth_cubit/ (AuthCubit: isGuest/login/logout) + lang_cubit/
│   ├── shared_widgets/       # مكونات UI عامة: الأزرار، البطاقات، Shimmer، الصور، المعالجات...
│   ├── use_cases/            # (غير مستخدمة) عقود Clean Architecture
│   └── utils/                # الثيم/الألوان/الستايل/المدقق/الصلاحيات/الثيم الداكن/التخزين/الثيم...
├── features/                 # 40+ feature، كل واحدة بثلاث طبقات:
│   └── <feature>/
│       ├── data/models/      # نماذج JSON
│       ├── data/repos/       # abstract + impl (impl يستخدم getIt<ApiService>)
│       └── presentation/
│           ├── view_model/   # Cubit + states
│           └── views/        # الشاشات والـ widgets
└── lang/                     # ar_lang.dart, en_lang.dart, locale_keys.dart, codegen_loader.g.dart
```

### المجلدات ودورها باختصار

| المجلد | الدور |
|---|---|
| `core/app_services/remote_services/api_service.dart` | غلاف Dio موحّد: baseUrl، 30 ثانية timeout، ترويسات افتراضية، اعتراض 401 → خروج إجباري، تسجيل debug |
| `core/app_services/remote_services/end_points.dart` | **كل** المسارات والـ Base URL — لا توجد URLs مكتوبة يدويًا في الـ repos |
| `core/app_services/remote_services/service_locator.dart` | تسجيل Singleton لكل repo + `ApiService` + `ChatUnreadCubit` عبر GetIt |
| `core/routing/app_router.dart` | تعريف `Routes.*` وربطها بالـ Views + حقن الـ Cubits عبر DI |
| `core/shared_widgets/*` | `CustomButton`, `CustomTextFormField`, `CustomNetWorkImage`, `ProductGridCard`, `ProductRowCard`, `FavHeartButton`, `ProductBadges`, `FullScreenGallery`, `Shimmer`... إلخ |
| `core/utils/app_validator` | `MyValidators` — كل قواعد التحقق برسائل مترجمة |
| `core/utils/app_theme` | `AppThemes` (Light/Dark، Material 3، Cairo) + `ThemeModeSwitch` |
| `features/layout` | `LayoutView` — الـ Scaffold الرئيسي بعد الدخول: `FlashyTabBar` بـ 5 تبويبات + `LayoutCubit.pageIndex` (static) |
| `features/*` | الـ feature modules (انظر القسم 4) |

## 3.4 التواصل بين الوحدات

- **الواجهات تتواصل عبر الـ Cubits فقط** (لا تُنشئ Models بنفسها).
- **مشاركة الحالة العامة** عبر GetIt (مثل `ChatUnreadCubit` singleton) أو عبر `MultiBlocProvider` في `my_app.dart` (`ProfileCubit`, `HomeCubit`, `NotificationsCubit`, `FavCubit`, `SearchCubit`, `ChooseLocationCubit`, `CompareCubit`, `SellAllBestViewCubit`, `PrivacyCubit`, `DeleteAccountCubit`, `UpdateProfileDataCubit`, `AuthCubit`, `LayoutCubit`, `LanguageCubit`, `ReportProductCubit`, `AddBalanceCubit`, `HelpSupportCubit`, `HelpSupportChatCubit`, `ConfirmPaymentCubit`).
- **الأحداث بين الوحدات**: FCM → `AppNotifications._handleForegroundMessage` → `NotificationsCubit.activeInstance.onNewNotificationArrived()` لتحديث العداد وعمل silent refresh.
- **التنقل**: أسماء عبر `Routes` + `AppRouter.generateRoute`، وأحيانًا `context.pushAndRemoveAll` أو `NewAppNav.customNavigator`.

## 3.5 الثيم والألوان

| العنصر | القيمة |
|---|---|
| `AppColors.mainColor` | `0xff0E8565` (أخضر داكن) |
| `AppColors.secondColor` | `0xff279275` |
| `AppColors.buttonColor` | `0xff0D4B74` (أزرق داكن) |
| `AppColors.yellowColor` | `0xffFAB043` |
| `AppColors.redColor` | `0xffC21919` |
| الأسطح الداكنة | `0xff0F172A` (خلفية) / `0xff1E293B` (سطح) |
| خط العرض | Cairo، ومقاسات `.sp` عبر `flutter_screenutil` بحجم تصميم `390×844` |

---

# 4. المميزات والوظائف (Features)

> لكل feature مذكور: الغرض، طريقة العمل، المدخلات، المخرجات، الملفات، الاعتماد على features أخرى.
> جميع المسارات داخل `lib/features/`.

## 4.1 المصادقة وإدارة الحساب

### 4.1.1 Splash (`splash/`)
- **الغرض**: شاشة افتتاحية 4 ثوانٍ (`Curves.bounceOut`) ثم التوجيه.
- **كيف تعمل**: تقرأ `CacheTokenManger.userToken` (static يُملأ في `AppInitializer`) و`GuestGuard.isGuest`؛ وجود أيٍّ منهما → `LayoutView`، وإلا → `OnBoardingView` (الوكيل وايدجت مباشرة وليس route مسجل).
- **ملفات**: `presentation/views/splash_view.dart` فقط. **لا يوجد Cubit ولا شبكة.**
- **ملاحظة**: `Routes.splashView` هو `initialRoute`.

### 4.1.2 OnBoarding (`onBoarding/`)
- **الغرض**: 3 شرائح تعريفية (`introduction_screen`) للمستخدم غير المسجل.
- **التقدم**: `OnBoardingView` → زر Done/Skip → `pushNamedAndRemoveAll(Routes.loginView)`.
- **ملفات**: `presentation/view_model/on_boarding_cubit.dart` + `views/on_boarding_view.dart`.
- **لا توجد شبكة** ولا استقبال لبيانات خارجية. `Routes.onBoardingView` معرّف لكن غير مسجّل في router.

### 4.1.3 تسجيل الدخول (`login/`)
- **الغرض**: دخول بالهاتف + كلمة المرور، مع زر "المتابعة كزائر" ورابط التسجيل.
- **المدخلات**: `phone` (11 رقمًا مصريًا)، `password`، `device_token` (من كاش `fcmToken`).
- **الـ API**: `POST /login` بـ JSON `{phone, password, device_token}`.
- **المخرجات عند النجاح**: `LoginModel{data.user, data.isActive, data.requires_otp}`؛ عند `isActive == true` يُحفظ التوكن (secure + كاش) ويُستدعى `AuthCubit.loginWithToken` ثم الانتقال لـ `LayoutView`.
- **ملفات**: `data/models/login_model.dart`، `data/repos/login_repos_imple.dart`، `presentation/view_model/login_cubit.dart`، `presentation/views/login_view.dart` + `login_widgets/*`.
- **الاعتمادات**: `AuthCubit`, `ProfileCubit`, `GuestGuard`, `Toast`.
- **مشكلة معروفة**: عند `isActive == false` لا يُصدر أي state (الشاشة تتجمد على loading) — انظر القسم 11.

### 4.1.4 إنشاء حساب (`register/`)
- **الغرض**: تسجيل حساب جديد بصورة شخصية اختيارية ثم الانتقال إلى OTP.
- **المدخلات**: `name`, `email`, `phone`, `password`, `age`, `image?`.
- **الـ API**: `POST /register` — **multipart** (`FormData`)، الحقول: `image?`, `phone`, `name`, `email`, `password`, `age`, + `center_id: 1` و `city_id: 1` **مهاردكود**.
- **التحقق**: `phoneValidator` (`^01[0-9]{9}$`)، `displayNameValidator` (2–50 بدون أرقام/رموز)، `emailValidator`، `ageValidator` (18–100)، `passwordValidator` (8–30 + أحرف كبيرة/صغيرة + رقم + رمز `!@#$%^&*(),.?":{}|<>`)، `repeatPasswordValidator`.
- **المخرجات**: `RegisterModel` — عند النجاح: كاش `email` → `pushNamed(Routes.otpView, arguments: resolvedEmail)`.
- **ملفات**: `data/models/register_model.dart`، `data/repos/register_repo_imple.dart`، `presentation/view_model/register_cubit.dart`، `views/register_*`.

### 4.1.5 تفعيل OTP (`otp/`)
- **الغرض**: كود تفعيل من 6 خانات يُرسل على البريد الإلكتروني (وليس SMS).
- **المدخلات**: `email` (من الوسيط route arguments)، الكود من `pin_code_fields`.
- **الـ API**:
  - `POST /verifyCode` — JSON `{email, otp, device_token}`.
  - `POST /resendCode` — body `{email}` (Map خام).
- **التدفق**: نجاح التحقق → حفظ التوكن (`CacheTokenManger` + `CacheHelper[userToken]` + `isGuest=false`) → `AuthCubit.loginWithToken` → `ProfileCubit.getProfile()` → `pushNamedAndRemoveAll(Routes.chooseLocationView)`.
- **مؤقت 60 ثانية** لإعادة الإرسال؛ **الـ API يعيد الكود ويُعرض للمستخدم** (`ResendOtpButton` يعرض `data.code`) — انظر قسم الأمان 11.
- **ملفات**: `data/models/otp_model.dart` + `resend_otp_model.dart`، `repos/*_imple.dart`، `view_model/*`، `views/otp_*`.

### 4.1.6 اختيار الموقع (`chooseLocation/`)
- **الغرض**: بعد التفعيل — اختيار المحافظة ثم المركز/الحي وحفظه في الحساب.
- **الـ API**: `GET /getCities` → `{cities:[{id,name,centers:[...]}]}`؛ `POST /addLocation` — body `{city_id, center_id}` (strings).
- **المخرجات**: حفظ الموقع ثم `NewAppNav.customNavigator(screen: LayoutView(), finish: true)` + `ProfileCubit.getProfile()`.
- **ملفات**: `data/models/choose_location_model.dart` + `cities_centers_model.dart`، `repos_imple`، `view_model/*`، `views/choose_location_widgets/`.

### 4.1.7 تغيير كلمة المرور (`changePassword/`)
- **الغرض**: تغيير كلمة المرور للحساب النشط، مع وضع برمجي ثانٍ لـ reset عبر OTP (`screenName == "ForgetPasswordView"` — **لا توجد واجهة له**).
- **الـ API**: `POST /changePassword` — **multipart FormData** `{email, reset_token: <userToken>, new_password, confirm_new_password}` (لاحظ: `oldPassword` **يُجمع ولا يُرسل**)؛ الوضع البديل: `POST /resetPassword` بـ `{email, otp, password, password_confirmation}`.
- **النجاح** → مسح التوكن + الكاش + `pushNamedAndRemoveAll(Routes.loginView)` + `LayoutCubit.pageIndex = 0`.
- **المسار**: `Routes.changePasswordView` (من إعدادات البروفايل).

### 4.1.8 تسجيل الخروج
- **أين**: إعدادات البروفايل → زر Sign Out → `logout_dialog` → `ProfileCubit.logout()` → `POST /logout` (بدون body) + مسح التوكن/الكاش/`isGuest` → `pushNamedAndRemoveAll(Routes.loginView)` + `LayoutCubit.pageIndex = 0`.
- **بديل**: عند 401 في أي طلب، `ApiService._performLogout()` ينفذ نفس المسح + Toast "youLoggedOutPleaseLoginAgain" + توجيه login.

### 4.1.9 حذف الحساب (`deleteAccount/`)
- **الغرض**: حذف نهائي مع تحذير (شاشة الإعدادات → Delete Account → نوافذ تحذير → زر أحمر "Delete now").
- **الـ API**: `POST /deleteAccount` — **بدون body**.
- **ملاحظة حرجة**: هذه الشاشة **لا تمسح** التوكن/الكاش (على عكس `ProfileCubit.deleteAccount()` الموجود لكنه غير مستخدم هنا) — انظر القسم 11.

### 4.1.10 الوضع كود/زائر (`GuestGuard` في `core/utils/guest_guard.dart`)
- **الغرض**: تصفح السوق بدون حساب.
- **السلوك**: `isGuest` من كاش `isGuest == true`؛ الدخول `GuestGuard.enterAsGuest()` → `AuthCubit.loginAsGuest()` + توجيه `LayoutView`؛ التبويبات المقيدة (Chat / Ads / Account) تطلب تسجيل الدخول عبر `requireLogin()` → حوار تأكيد؛ `GuestPlaceholder` شاشة بديل؛ الـ fetches الخاصة بالحساب (profile/fav/notifications/chat badge) **تُتخطى** في الزائر.

### 4.1.11 تغيير اللغة (`changeLang/`)
- **الغرض**: ورقة سفلية (Bottom Sheet) للتبديل بين العربية والإنجليزية + إعادة تحميل كل البيانات.
- **كيف**: `showChangeLangSheet(context)`؛ `LanguageCubit.changeLanguage()` يحفظ الكود أولًا (ليصل الـ interceptor) ثم `EasyLocalization.setLocale`؛ ثم `refreshAllData()` يعيد جلب: Home data/banners، Search، Cities، Complaints، BestView — وإن لم يكن زائرًا: Profile، Privacy، Fav، Notifications، ChatUnread.
- **ملاحظة**: `LanguageCubit` مكررة في مكانين (`core/shared_cubits/lang_cubit/lang_cubit.dart` و `features/changeLang/.../change_lang_cubit.dart`).

---

## 4.2 الرئيسية والتصفح (Home & Catalog)

### 4.2.1 Home (`home/`)
- **الغرض**: الشاشة الرئيسية — بانرات إعلانية، بحث، الفئات (أول 5)، بانر "انضم الآن" للنشر، شبكة "أفضل المشاهدات" (Best View).
- **الـ API**: `GET /home` (categories + bestView + ads)، `GET /getBanners` (تسامحية parsing لحقول مختلفة: `banners|data|slides|items`، وصورة قد تُقرأ من `image|image_url|banner|photo|url`).
- **مكونات UI**: `HomeBannerSlider` (carousel + `url_launcher` للروابط)، `CategoriesList`، `BestViewProductsList` (GridView عمودان)، `BannerToLogin`، موجّه البحث `ContainerSearchWidget`.
- **ملفات**: `data/models/home_model.dart` (BestView/Categories/Ads — نفس حقول المنتج تقريبًا)، `data/models/banners_model.dart`، `repos/home_repo_imple.dart`، `view_model/home_cubit.dart`، `views/home_view.dart` + `home_widgets/*`.
- **حالة خاصة**: `HomeAdsStrip` و`BestViewStrip` **موجودتان لكنهما غير مستخدمتين**؛ `AllAdsView` لا تُستدعى من أي شاشة.
- **السحب للتحديث**: يعيد `getHome()` + `getBanners()` معًا.

### 4.2.2 جميع الفئات (`allCategories/`)
- **الغرض**: قائمة بكل الفئات الرئيسية مع عدد الفئات الفرعية، والانتقال إلى شاشات الفئات الفرعية.
- **الـ API**: `GET /viewAllCategories` (بدون params؛ يحتوي `categories[].subCategories[]`).
- **كاش جلسة**: `AllCategoriesCubit.cachedModel` + Future مشترك (`_inFlight`) — كل الشاشات تستهلك نفس الكاش.
- **ملفات**: `data/models/all_categoies_model.dart`، `data/repositories/*_imple.dart` (لاحظ اسم المجلد `repositories` وليس `repos`)، `presentation/view_model/cubit.dart`، `views/all_categories_view.dart`.
- **ملاحظة**: عنوان الشاشة مهاردكود بالعربية "جميع الفئات".

### 4.2.3 الفئات الفرعية (`allSubCategories/`)
- **الغرض**: عرض الأقسام الفرعية للفئة الرئيسية مع `products_count`.
- **الـ API**: `GET /getSubCategories?category_id=<int>` (بدون page).
- **كاش لكل فئة**: `AllSubCategoriesCubit._cache` (Map<int, model>) — يُستهلك عبر `cachedFor(int)` في ورقة الفلتر.
- **صفر منتجات** → Snackbar "لا يوجد منتجات في هذا القسم" بدل الانتقال.

### 4.2.4 منتجات الفئة الفرعية (`allSubCategoriesProducts/`)
- **الغرض**: شبكة منتجات القسم الفرعي مع بحث محلي + ورقة فلتر **محلية** (client-side filtering).
- **الـ API**: `GET /productBySubCategory?sub_category_id=<int>`.
- **الفلتر**: ورقة `ProductsFilterSheet` (Category/SubCategory/Type/Price range/City+Center/Shipping/Condition) — لكن هنا **كل الفلترة محلية** على القائمة المحمّلة؛ انتقال الـ params للسيرفر يتم فقط عبر `ProductsFilter.toQueryParams()` في Search.
- **الصفحات**: لا يوجد pagination.
- **التراكم**: `AllSubCategoriesProductsCubit` **يُلحق** المنتجات الجديدة للقائمة (بدون قص).

### 4.2.5 البحث (`search/`)
- **الغرض**: بحث نصي + فلترة سيرفرية + **Pagination حقيقي** (infinite scroll).
- **الـ API**: `GET /products?page=N&<filter params>`.
- **الفلتر**: نفس `ProductsFilter` (`showProductsFilterSheet`): `category_id, sub_category_id, min_price, max_price, city_id, center_id, shipping_type (free|paid|both), condition (new|used|both)`.
- **الرد**: `data{products[], pagination{current_page, last_page, per_page, total}}` — `hasMore => currentPage < lastPage`، وتحميل المزيد عند الوصول لـ 300px من النهاية، مع زر Retry عند فشل الصفحات التالية.
- **ملاحظة**: الفلترة النصية (البحث الحر) محلية على الصفحات المحمّلة؛ `searchProducts` معرّف لكن غير مستخدم.
- **كود ميت**: `search_filter_view.dart` (قوائم عربي مهاردكود + زر بلا onPressed).

### 4.2.6 رؤية الكل — Best View (`seeAllBestView/`)
- **الغرض**: صفحة "عرض الكل" لمنتجات أفضل مشاهدة (نفس بيانات Home).
- **الـ API**: `GET /bestAllView` (بنية `products[]` **مختلفة**: seller مفرود على المنتج — `seller_name` إلخ — بدل كائن متداخل).
- **بحث محلي** بالاسم/الوصف/السعر فقط؛ لا فلتر ولا pagination.

### 4.2.7 المقارنة (`compare/`)
- **الغرض**: مقارنة منتجين جنبًا إلى جنب (حد أقصى **2** — `CompareCubit.maxItems`).
- **الاختيار**: من زر "مقارنة" في شاشة تفاصيل المنتج؛ عند إضافة الثاني ينتقل تلقائيًا إلى `CompareView`. عند الوصول للحد الأقصى يُزال الأقدم (`removeAt(0)`) ويُضاف الجديد.
- **المقارنة**: `POST /compareProducts` بـ `{product_ids: [id1, id2]}`؛ وعند فشل الشبكة أو استجابة ناقصة (< 2 منتجات) **يرجع إلى جلبَي `productDetails`** (`type: "home"`) ويدمجهما.
- **العرض**: بطاقتان + دائرة "VS" + جدول صفوف (السعر مع تظليل، السعر القديم مشطوب، النوع، الموديل، الماركة، المكان، التقييم، تاريخ الإضافة) + بطاقة وصف.
- **ملفات**: `data/models/compare_model.dart` (يتسامح مع `data` كـ List)، `repos/compare_repos_imple.dart`، `view_model/compare_cubit.dart` + `compare_view.dart` + `compare_view_body.dart`.
- **كود ميت**: `addCompare` (`GET addCompare?product_ids[]=`) و`ProductDetailsCubit.addProductToCompare` و`AddProductToCompareModel` — كلها **لا يستدعيها أي view**.

### 4.2.8 تفاصيل المنتج (`productDetails/`)
- **الغرض**: شاشة إعلان كاملة: جاليري صور + ملء الشاشة، بطاقة البائع، زر دردشة/اتصال، تقييم، زر مقارنة، إيقاف/تفعيل الإعلان (للمالك فقط)، منتجات مرتبطة، نصائح أمان، روابط التبليغ وتعليمات الشراء.
- **الـ API**:
  - `GET /productDetials?product_id=<int>&type=home` (**`type` دائمًا `"home"`** — دلالاته غير موثقة، انظر القسم 7).
  - `POST /rateProduct` — `{product_id, rate, commenet}`.
  - `POST /pauseAd` / `POST /resumeAd` — `{ad_id: <productId>}` (لاحظ: يُستخدم productId كـ ad_id).
- **النموذج**: `ProductDetailsModel{data:{product, relatedProducts[], similarProducts[], sponsoredProducts[], banners[]}}` — **الـ similar/sponsored/banners و`specifications` و`map` و`safety_tips` تُقرأ ولا تُعرض**.
- **التفاصيل**:
  - **المالك**: يُكتشف عبر مقارنة `ProfileCubit` user id مع `seller.id` — يُخفي زر الشات ويُظهر قائمة إيقاف/تفعيل.
  - **التقييم**: نجوم + تعليق؛ نجاحه يعيد جلب التفاصيل (فتظهر المراجعة).
  - **آخر المنتجات المشابهة**: تُعرض `relatedProducts` فقط.
- **ملفات**: `data/models/product_details_model.dart` + `pause_resume_ad_model.dart` + `add_product_to_compare_model.dart` (غير مستخدم)، `repos/product_details_repo_imple.dart`، `view_model/product_details_cubit.dart`، `views/product_details_view.dart` + widgets (image, seller, rating, related, tips...).

### 4.2.9 صفحة البائع (`productSeller/`)
- **الغرض**: الملف العام للبائع: صورة + اسم + "تواصل الآن" + 3 تبويبات (بيانات البائع / المعروض الآن / المبيعات السابقة).
- **الـ API**: `GET /sellerDetails?seller_id=<int>` — الرد يحتوي `seller{contact_method, can_chat, can_call, store_name, rating, ...}` + `products[]` + `pagination` (موجودة في النموذج لكن **لا تُستخدم** — لا يوجد طلب page).
- **ملاحظة**: التبويبان 2 و3 يعرضان **نفس القائمة**.
- **تعليقات**: التعليقات/المراجعات تُقرأ لكن مكوناتها **معلقة في الكود** (commented out).

### 4.2.10 المفضلة (`fav/`)
- **الغرض**: قائمة الإعلانات المفضلة + المصدر الوحيد لحالة القلب في كل البطاقات.
- **الـ API** (كلها `EndPoints.favourites = "favourites"`):
  - `GET /favourites` — القائمة.
  - `POST /favourites` — body `{product_id}` — إضافة.
  - `DELETE /favourites` — query `product_id` — إزالة.
- **نمط التفاؤل (optimistic)**: `FavCubit.toggleFavourite()` يقلّب `favouriteIds: Set<int>` فورًا ويصدر `FavToggleOptimistic`، ثم يعكس عند الفشل + Snackbar، ويعيد المزامنة عبر `getFavData()` في الحالتين. الزائر يرى قلبًا عاديًا بدون فعل (`GuestGuard`).
- **الرد**: `GeneralModel{status, number, message}` للإضافة/الحذف، و`FavDataModel{data.favourites[]}` للقائمة.

---

## 4.3 إدارة الإعلانات والنشر والباقات والدفع

### 4.3.1 إضافة إعلان — التدفق الموحّد (`addAdvertisements` — `add_new_ad_view`)
- **الغرض**: نشر إعلان بيع بخطوات: صور → بيانات → فئة → شحن/حالة → موقع → معاينة الدفع.
- **الحقول**: صور (1–5، كاميرا/معرض، multipart باسم `images[]`)، `name`, `description`, `price`, `discount?` (نسبة تُحسب حيًا)، `is_negotiable` (0/1), `is_urgent` (0/1), `category_id` + `sub_category_id` (قائمة منسدلة معتمدة)، `shipping_type` (`free|paid`)، `condition` (`new|used`)، `city_id` + `center_id` (افتراضيات من بروفايل المستخدم عبر `initLocation`), `listing_type` مهاردكود `'sale'`.
- **بوابة النشر**:
  1. يحاول `isPublishingCovered()` → `GET /subscriptions/current`: إذا `active && !is_expired && (ads_limit == 0 || remaining_ads > 0)` → نشر مباشر بدون حقول دفع.
  2. إن فشل الفحص أو غير مغطى → `showAdPaymentSheet` (انظر 4.3.2).
  3. السيرفر قد يفرض الدفع: إذا `fieldErrors` يحتوي `payment_method | receipt | transfer_reference` → يعيد فتح الورقة (`AddNewAdPaymentRequired`).
- **الـ API**: `POST /addNewAds` — **multipart** بالحقول: `name, description, price, discount?, is_negotiable, is_urgent, listing_type, category_id, sub_category_id, shipping_type, condition, city_id, center_id` + `payment_method?` + `transfer_reference?` + `images[]` + `receipt?` (فقط عند الدفع بتحويل).
- **النجاح** → `AddNewAdSuccess` → Pop مع `true` → قائمة إعلاناتي تعيد الجلب.
- **ملفات**: `data/repos/add_advertisements_repos_imple.dart` (و`AddNewAdCubit` في `view_model/add_new_ad_cubit.dart`)، `presentation/views/add_new_ad_view.dart` + `add_new_ad_widgets/add_new_ad_view_body.dart` + `ad_payment_sheet.dart`.

### 4.3.2 إضافة إعلان — التدفق القديم (Legacy)
- نفس الـ feature لكن بحالة مستقلة: `AddAdvertisementsView` → `AddAdvertisementsCubit` → `POST /addProduct` بـ `FormData`: `name_ar, desc_ar, price, category_id, sub_category_id, marka_id, model_id, type_id, lat: 22.2222222222 (مهاردكود), long: 33.33333333` + `images[]` (حد أقصى **2 صور**).
- الحقول **`communication` و`negotiable` و`phone` تُجمع ولا تُرسل**. القوائم الثلاث (الماركة/الموديل/النوع) عبر `GET /marka`, `GET /models`, `GET /typies`.
- **أي شاشة تستدعي هذا التدفق؟ غير موثقة في الكود** — التدفق الموحّد هو الظاهر في الواجهات (زر `+` في "إعلاناتي" يفتح `AddNewAdView`).

### 4.3.3 تعديل إعلان (`EditAdView`)
- يعيد استخدام `AddNewAdCubit` + `AddNewAdViewBody(adToEdit: ad)` مع `fillForEdit()`؛ **لا توجد حقول دفع في التعديل**.
- **الـ API**: `POST /editAds` — multipart: `ad_id` + نفس حقول النشر + `images[]` (الملفات الجديدة فقط؛ الصور القديمة تُرسل **حاليًا لا تُرسل** — فقط الجديدة).

### 4.3.4 إعلاناتي (`advertisements/`)
- **الغرض**: قائمة كل إعلانات المستخدم مع بحث + تبويبات الحالة + إيقاف/تفعيل/حذف + زر الباقات وزر الإضافة.
- **الـ API**:
  - `GET /getAllAds` (بدون params؛ الفلترة بالتبويب/البحث تتم محليًا).
  - `POST /deleteAds` — body `{ad_id}` (بعد حوار تأكيد).
  - `POST /pauseAd` / `POST /resumeAd` — body `{ad_id}` → تحديث `is_paused` محليًا (الحماية من double-tap عبر `_pauseResumeInFlight`).
- **التبويبات**: `["الكل", "النشط الان", "الغير نشط"]` مع عدادات لكل تبويب.
- **شارة مميزة**: `status == 3` → شارة "مميز" (`isFeatured`)؛ `is_urgent == true` → شارة "عاجل".

### 4.3.5 الباقات والاشتراك (`packages/`)
- **الغرض**: شراء باقة نشر/عرض (قرار تجربة: باقات بمدة شهري/3/6/سنوي).
- **الـ API**:
  - `GET /subscriptionPackages` — القائمة (فلترة محلية بالتبويب الزمني).
  - `GET /payment-methods` — طرق التحويل المتاحة (`data.methods: [{code, name, account}]`) مع **كاش جلسة static** (`PackagesCubit.cachedMethods`).
  - `GET /subscriptions/current` — باقة المستخدم الحالية (نفس ما تستهلكه بوابة النشر).
  - `POST /subscriptions/checkout` — **JSON** `{package_id, payment_method: 'wallet'}` للمحفظة، أو **multipart** `{package_id, payment_method: <code>, receipt: file}` للتحويل.
- **طرق التحويل المبنية** (في `transfer_method_card.dart`): Vodafone Cash، Orange Cash، Etisalat Cash، InstaPay، Fawry، Bank transfer، Wallet، Cash — تُطابق بالكود: `vodafone|orange|etisalat|instapay|fawry|bank|wallet|cash`.
- **بعد الشراء**: صفحة المحفظة تعرض بطاقة "الباقة الحالية" (حيث `is_subscribed == true`).
- **ملفات**: `data/models/packages_model.dart`, `payment_methods_model.dart`, `subscribe_package_model.dart`، `repos/packages_repos_imple.dart`، `view_model/packages_cubit.dart`، `views/packages_view.dart` + `transfer_view.dart` + `payment_method_sheet.dart`.

### 4.3.6 المحفظة والدفع والرصيد (`PaymentBalance/` + `addBalance/` + `confirmPayment/`)
- **`PaymentBalance/` (الحالي)**:
  - **الشحن**: زر "أضف رصيد" → `TransferView(topUpMode: true)` → `POST /wallet/top-up` — multipart `{amount, payment_method, transfer_reference?, receipt}` — بعد النجاح يعيد جلب البروفايل والحركات.
  - **سجل الحركات**: `GET /wallet/history` — يتسامح مع شكل `data` كـ List أو Map (`history|transactions|data|items`)؛ كل عملية تُعرض بنوع (إيداع/خصم)، التاريخ، المبلغ، حالة (approved/rejected/pending عبر كلمات مفتاحية عربية/إنجليزية)، طريقة الدفع مترجمة، مع زر "عرض الإيصال" → bottom sheet مع **تحميل** (`gal`) و**مشاركة** (`share_plus`).
  - **ملفات**: `PaymentBalance/data/models/wallet_history_model.dart` + `repos/wallet_repos_imple.dart` + `view_model/wallet_cubit.dart` + `views/payment_and_balance_view.dart`.
- **`addBalance/` (قديم — فعليًا معطّل)**: قائمتان بأرقام هاتفية **مهاردكود** (`+1234567890, +0987654321, +1122334455`) وحساب إنستا بي **مهاردكود** `"123456789023"` — بدون أي اتصال API؛ ملف `payment_with_insta_pay_widget.dart` **فارغ (0 بايت)**.
- **`confirmPayment/` (قديم — غير وظيفي)**: منتقي صور فقط؛ زر الإرسال `onPressed: () {}` بدون أي استدعاء شبكي.
- **`makePurchase` / `purchaseInstructions`**: `purchaseInstructions` تُستهلك في صفحة تعليمات الشراء (4.4.7)؛ `makePurchase` معرّف ولم يُرسَل إليه أي طلب من التطبيق (**Not Found أي استدعاء**).

### 4.3.7 إحصائيات البائع (`statistics/`)
- **الغرض**: لوحة إحصائيات شهرية: إجمالي المبيعات، المبلغ، المنتجات المعروضة، المهتمون، المفضلة، الشكاوى + تايم لاين بالأيام.
- **الـ API**: `GET /statistics?page=1&month=YYYY-MM` (و`?date=YYYY-MM-DD` ليوم واحد).
- **UI**: قرص شهر مع prev/next + `EasyDateTimeLine` + 6 بطاقات `StatisticsItem` ملونة + بطاقة `period`.
- **ملاحظة**: الـ pagination في النموذج **لا تُستخدم**؛ `sales` تُقرأ كـ `List<dynamic>` ولا تُعرض.

---

## 4.4 الحساب والإعدادات والمساعدة

### 4.4.1 البروفايل (`profile/`)
- **الغرض**: تبويب "الحساب" — بطاقة المستخدم (صورة، الاسم، الهاتف، "Member From") + 4 اختصارات (الدفع والرصيد / المفضلة / الإحصائيات / المقارنة) + قائمة إعدادات.
- **الإعدادات الفعلية (بالترتيب)**: Reporting & Support، Privacy، Change Password، Change Language، Theme (فاتح/داكن)، Notify (مفتاح محلي غير متصل بالـ API — **لا يحفظ أي شيء**)، legal (قابل للطي: About / Terms / Privacy)، Delete Account، ثم زر Sign Out الأحمر.
- **الـ API**: `GET /getProfileData` (النموذج `ProfileModel` — يتضمن `wallet_balance`, `wallet_currency`, `subscription_package`, `cityName`... الإلخ)، و`POST /logout`.
- **ملفات**: `data/models/profile_data_model.dart`، `repos/profile_repos_imple.dart`، `view_model/profile_cubit.dart`، `views/profile_view.dart` + `profile_widgets/*` (الفعلية: `profile_view_body_2.dart`, `settings_list_widget.dart`, ...).
- **ملفات ميتة**: `profile_view_body.dart` (قديم بعناصر Item N)، `profile_view_body_list_item_widget.dart`، `settings_item_widget.dart`.

### 4.4.2 تعديل البروفايل (`updateProfile/`)
- الاسم/الإيميل/الهاتف + الصورة (غاليري، 800px، جودة 85) → `POST /updateProfile` **multipart** بالحقول `image?, name?, email?, phone?` (فقط غير الفارغة).
- على النجاح: انتقال إلى `LayoutView` + Toast + `ProfileCubit.getProfile()`.

### 4.4.3 الإشعارات (`notifications/`)
- **الغرض**: قائمة الإشعارات + عدّاد "غير مقروء" على جرس Home وتبويب الشات.
- **الأنواع المعرفة في الكود**: `general` (الكل)، `unread`، `purchaseRequests`، `regularMessages` — لكن **الواجهة تعرض فقط رقائق All / Read / Unread**؛ مكون `notifications_buttons_types.dart` موجود وغير مستخدم.
- **الـ API**:
  - `GET /notifications?type=&page=&per_page=15`
  - `PATCH /notifications/:id/read`
  - `PATCH /notifications/read-all`
  - `DELETE /notifications/:id` و `DELETE /notifications` (الكل)
- **السلوك**: تفاؤلي (optimistic) مع تراجع عند الفشل؛ `unread_count` من السيرفر هو المرجعي؛ FCM يزيد العداد فورًا ويعمل silent refresh؛ القائمة infinite scroll + swipe-to-delete + RefreshIndicator.
- **ملفات**: `data/models/notifications_model.dart` (يتسامح مع `0/1` في bool)، `repos/notifications_repos_imple.dart`، `view_model/notifications_cubit.dart`، `views/notifications_*`.

### 4.4.4 المحادثات — المشتري ↔ البائع (`chat/`)
- **الغرض**: سوق داخلي: قائمة المحادثات + شاشة محادثة (نص + صور) + عدّاد عالمي للرسائل غير المقروءة.
- **التقنية**: **Polling فقط — لا يوجد WebSocket / Firebase Realtime**. داخل المحادثة: كل **دقيقة** بـ `after_id`؛ القائمة: كل **دقيقتين** (paused عند توقف التطبيق، تُستأنف مع resume).
- **الـ API**:
  - `GET /conversations?page=&per_page=`
  - `GET /conversations/unread-count`
  - `GET /conversations/:id/messages?page=&per_page=&before_id=&after_id=`
  - `POST /conversations` — بدء محادثة: body `{product_id?, user_id?, body?}` (create-or-reopen).
  - `POST /conversations/:id/messages` — body `body` أو **multipart `image`** (صور jpg/jpeg/png/webp ≤ 5MB).
  - `PATCH /conversations/:id/read`
  - `DELETE /conversations/:cid/messages/:mid`
  - `DELETE /conversations/:id` — **إخفاء من طرف المستخدم الحالي فقط**.
- **الميزات**: رسائل optimistic-prepend، ticks قراءة (أزرق عند القراءة)، حذف رسالة (تظهر stub "رسالة محذوفة")، فتح صورة ملء الشاشة، long-press للنسخ/الحذف، منع الدردشة مع النفس، حماية الزائر (login required).
- **العداد العالمي**: `ChatUnreadCubit` singleton (GetIt + `BlocProvider.value` في الجذر) يغذي شارة تبويب الشات وشريط المحادثات.
- **ملفات**: `chat/data/repos/chat_repository_impl.dart`، `presentation/view_model/{chat,conversations,chat_unread,start_chat}_cubit.dart`، `views/{conversations_view,chat_view}.dart` + `chat_widgets/*` + `conversations_widgets/*`.
- **ملفات ميتة/معطلة**: `chat_product_header.dart` غير مستخدم في layout (معلّق).

### 4.4.5 الإبلاغ والشكاوى (`reportProduct/`)
- **تدفقان**:
  1. **شكوى عامة** (من صفحة المساعدة): أنواع من `GET /complaintsTypes` + رسالة → `POST /addComplaint` بـ `{complaint_id, seller_id?, product_id?, message}`.
  2. **تبليغ عن إعلان** (من شاشة تفاصيل المنتج): أسباب من `GET /reportReasons` → `POST /reportAd` بـ `{seller_id, product_id, reason, description}`.
- **ملاحظة**: `ReportTheProductView(sellerId, productId)` تقرر التدفق حسب توفر المعرّفات. أنواع الشكاوى **ديناميكية من السيرفر** (نصوص عربية) — وأنواع الشكاوى تُجلب مرة واحدة عند إقلاع التطبيق (`my_app.dart`).
- **ملاحظة**: شاشة الشكوى العامة تقارن loading state بـ `GetAllCategoriesLoading` (من feature أخرى) — خطأ نسخ محتمل، انظر القسم 11.

### 4.4.6 المساعدة والدعم (`helpSupport/` + `helpSupportChat/`)
- **محلي 100% — بدون API**:
  - **Chat** → `HelpSupportChatView` (شات تجريبي محلي في الذاكرة؛ يُمحى عند الخروج؛ بدون avatars ولا حفظ).
  - **Email** → يعرض `bi3lyapp@example.com` لكن يفتح `mailto:mustafa.bahr12323@gmail.com` (**غير متطابقين**).
  - **Call us** → يعرض `01110690299` لكن يفتح `tel:+1234567890` (**مهاردكود بديل**).
  - **Report Product** → `ReportTheProductView()` (الشكوى العامة).
  - **Report Seller** → **مهلة معلقة (dead)** — الكود معلّق.
  - **FAQ** — نص عربي مهاردكود بالكامل (إجابتهما متطابقتان).

### 4.4.7 المحتوى القانوني والإرشادي (`legalContent/` + `howToMakePurchase/`)
- **الغرض**: عرض About / Terms / Privacy بتنسيق HTML من السيرفر (نفس `flutter_html`).
- **الـ API**: `GET /about`, `GET /terms`, `GET /privacy` — رد HTML مع `title`, `content` (يتسامح مع `html`), `language`, `direction` (افتراضي RTL).
- **تعليمات الشراء**: `GET /purchaseInstructions` (نفس النمط).

### 4.4.8 إعدادات الخصوصية (`privacy/`)
- **الغرض**: وسيلة التواصل المفضلة للبائع: (شات بيعلي / هاتف / كلاهما) + رقم الهاتف + استقبال إشعارات المنتجات الجديدة + بطاقة اسم/عنوان المتجر.
- **الـ API**: `GET /settings` و `PATCH /settings` بـ `{contact_method, contact_phone, notify_new_products, store_name?, store_address?}`. **لا توجد أكثر من مفتاح إشعار واحد** (`notify_new_products`).
- يُقرأ عند فتح الشاشة فقط؛ الـ Save يطبق استجابة السيرفر على الحالة مباشرة.

### 4.4.9 الحذف النهائي للحساب
- راجع القسم 4.1.9.

---

## 4.5 الخلاصة: مصفوفة الميزات ↔ Endpoints

| Feature | Endpoints | الثيم |
|---|---|---|
| Home | `GET home`, `GET getBanners` | تصفح |
| الفئات | `GET viewAllCategories`, `GET getSubCategories`, `GET productBySubCategory` | تصفح |
| البحث | `GET products` | تصفح |
| Best View | `GET bestAllView` | تصفح |
| المقارنة | `POST compareProducts` | أداة |
| التفاصيل | `GET productDetials`, `POST rateProduct`, `POST pauseAd/resumeAd` | منتج |
| المفضلة | `GET/POST/DELETE favourites` | تفاعل |
| النشر | `POST addNewAds`, `POST editAds`, `POST addProduct (legacy)` | بائع |
| إعلاناتي | `GET getAllAds`, `POST deleteAds` | بائع |
| الباقات | `GET subscriptionPackages`, `GET payment-methods`, `GET subscriptions/current`, `POST subscriptions/checkout` | دفع |
| المحفظة | `POST wallet/top-up`, `GET wallet/history`, `GET ad-publishing-settings` | دفع |
| الإحصائيات | `GET statistics` | بائع |
| الإشعارات | `GET/PATCH/DELETE notifications`, `PATCH notifications/read-all` | نظام |
| الشات | `GET/POST conversations`, `GET unread-count`, `GET/POST/DELETE messages`, `PATCH read` | نظام |
| التقييم/التبليغ | `POST rateProduct`, `GET complaintsTypes`, `POST addComplaint`, `GET reportReasons`, `POST reportAd` | تفاعل |
| القانوني/الشراء | `GET about/terms/privacy`, `GET purchaseInstructions` | ثابت |
| الحساب | `POST register`, `POST login`, `POST verifyCode`, `POST resendCode`, `GET getCities`, `POST addLocation`, `POST changePassword`, `POST resetPassword`, `POST logout`, `POST deleteAccount`, `GET getProfileData`, `POST updateProfile` | حساب |

---

# 5. أدوار المستخدمين والصلاحيات

**لا يوجد نظام Admin Panel داخل التطبيق** — كل الصلاحيات تسقط من "هل التوكن موجود؟ هل `isGuest`؟"

| الدور | التعريف في الكود | الوصول |
|---|---|---|
| **زائر (Guest)** | `isGuest == true` في `CacheHelper` (لا توكن) | تصفح Home، الفئات، البحث، Best View، تفاصيل المنتج، الشراء/النشر/التفضلة/الشات **كلها ممنوعة** — تُطلب عبر `GuestGuard.requireLogin()` أو تُظهر `GuestPlaceholder` |
| **مستخدم مسجل غير مفعل** | `isActive == false` في رد login (يتطلب OTP) | عمليًا **لا توجد شاشة تغطي هذه الحالة** — انظر القسم 11 |
| **مستخدم مفعل (Buyer/Seller)** | `isActive == true` + توكن في secure storage | كل ما يلي + النشر (بشرط الدفع/الاشتراك) + إعلاناتي + الإحصائيات + الإعدادات كاملة |
| **مالك الإعلان (Seller)** | `ProfileCubit` user id == `product.seller.id` | إيقاف/تفعيل إعلانه، منع زر الشات مع نفسه، إحصائياته، إعلاناته |
| **مشترك بباقة (Subscriber)** | `subscription_package != null` أو `subscriptions/current.isCovered` | نشر إعلانات مجانية ضمن الحد؛ غير ذلك تُدفع "رسوم النشر" لكل إعلان |
| **Admin / مشرف** | **Not Found** — لا توجد أدوار إدارية في الكود | غير موجود |

قيود إضافية مفروضة في الكود:
- الزائر: تخطي كل الـ fetches الخاصة بالحساب (انظر `my_app.dart` و `GuestGuard`).
- المشتري لا يرى "إيقاف/تفعيل" إلا على إعلاناته.
- الخادم هو من يقرر أهلية النشر (`subscriptions/current`)؛ الواجهة تفحصه ثم تفحص `subscriptionPackage` محليًا كـ fallback.

---

# 6. رحلات وعمليات التطبيق (Workflows)

## 6.1 رحلة الإقلاع والتنقل

```
main()
 ├─ AppInitializer.init():
 │    WidgetsFlutterBinding.ensureInitialized → Firebase.initializeApp (firebase_options)
 │    → CacheHelper.init() → فحص "firstRun" (يمسح كل secure storage + كاش المستخدم أول مرة)
 │    → CacheTokenManger.getUserToken() → يحمّل التوكن إلى static userToken
 │    → EasyLocalization.ensureInitialized → setup() (DI) → getDeviceToken() (FCM)
 │    → Bloc.observer = SimpleBlocObserver()
 ├─ FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler)
 ├─ AppNotifications.initialize()  (قناة by3ly_notifications + مستمعي FCM)
 └─ runApp(EasyLocalization(ar, [ar, en], CodegenLoader)(MyApp))
      └─ MyApp: MultiBlocProvider (كل الكيوبتات العامة) → ThemeProvider → ScreenUtilInit
           → MaterialApp(initialRoute: Routes.splashView)

SplashView (4 ث)
 └─ userToken != null أو Guest → LayoutView   وإلا → OnBoardingView → LoginView

LayoutView (FlashyTabBar): [Home | Chat(عداد) | Search | Ads | Account]
   Guests: Chat/Ads/Account مقيدة → حوار "loginRequired"
```

## 6.2 رحلة التسجيل الكاملة

```
RegisterView (اسم/إيميل/هاتف/عمر/باسورد/صورة)
 └─ POST /register (multipart) → RegisterModel
      └─ حفظ email → pushNamed(otpView, email)
           └─ OtpView (٦ خانات، مؤقت 60 ث)
                └─ POST /verifyCode {email, otp, device_token}
                     └─ حفظ التوكن + isGuest=false + loginWithToken
                          └─ ProfileCubit.getProfile() → pushNamedAndRemoveAll(chooseLocationView)
                               └─ اختيار المحافظة ثم المركز → POST /addLocation
                                    └─ تنقل إنهاء (finish) إلى LayoutView + getProfile()
```

## 6.3 رحلة تسجيل الدخول

```
LoginView → POST /login {phone, password, device_token}
 ├─ status==true && isActive==true → حفظ التوكن + loginWithToken + getProfile + LayoutView
 ├─ status==true && isActive==false → (لا يصدر state — الشاشة معلقة)   [BUG]
 └─ status==false → Toast بالرسالة
```

## 6.4 رحلة نشر إعلان (التدفق الموحّد)

```
AdvertisementsView (زر +) → AddNewAdView
 ├─ جمع الصور (≤5) والبيانات بالترتيب (صور → بيانات → فئة → شحن → موقع)
 └─ زر "نشر الإعلان":
      └─ isPublishingCovered()?  (GET /subscriptions/current)
           ├─ نعم → submit() → POST /addNewAds (بدون حقول دفع) → نجاح → Pop(true)
           └─ لا → showAdPaymentSheet()
                    ├─ إن كان ad-publishing-settings.price <= 0 → submit() تلقائي (مجاني)
                    ├─ "محفظة بيعلي" (إن كان الرصيد ≥ الرسوم) → submit(paymentMethod: 'wallet')
                    └─ "تحويل" (اختيار طريقة + رفع إيصال) → submit(paymentMethod: method.code,
                        receiptPath: <file>, transferReference: <اختياري>)
                         └─ عند رفض السيرفر بسبب حقول الدفع → AddNewAdPaymentRequired → إعادة فتح الورقة
```

## 6.5 رحلة شراء باقة اشتراك

```
Ads tab → AddBundleButton → PackagesView (تبويبات: شهري/3/6/سنوي؛ GET /subscriptionPackages)
 └─ بطاقة باقة → "اشترك الآن" → showPaymentMethodSheet()
      ├─ "محفظة" → POST /subscriptions/checkout (JSON, payment_method: 'wallet')
      └─ "تحويل" → TransferView → GET /payment-methods → اختيار طريقة + رفع إيصال
           → POST /subscriptions/checkout (multipart, payment_method: <code>, receipt)
                → نهائية: الباقة تُعرض في شاشة المحفظة (is_subscribed) وفي البروفايل
```

## 6.6 رحلة شحن المحفظة

```
PaymentAndBalanceView → "أضف رصيد" → TransferView(topUpMode: true)
 ├─ حقل المبلغ + قائمة طرق التحويل (GET /payment-methods) + إيصال (+ رقم مرجع اختياري)
 └─ "تأكيد الشحن" → POST /wallet/top-up (multipart: amount, payment_method,
      transfer_reference?, receipt) → Toast + pop(true) + تحديث الرصيد والسجل
```

## 6.7 رحلة محادثة المشتري ↔ البائع

```
ProductDetailsView → "contactSeller" (أو StartChatButton في صفحة البائع)
 └─ POST /conversations {product_id, user_id}  (create-or-reopen)
      └─ ChatView(conversation):
           ├─ تحميل آخر 30  message (after_id polling كل دقيقة + lifecycle resume polling)
           ├─ إرسال نص → POST messages (optimistic)  |  إرسال صورة → multipart (≤5MB)
           ├─ فتح المحادثة → PATCH read (+ تصفير عدّاد المحادثة والعداد العالمي)
           ├─ long-press → نسخ / حذف رسالتك (DELETE message)  |  القائمة → حذف/إخفاء المحادثة (DELETE /conversations/:id)
           └─ الخروج → stopPolling + startPolling في القائمة + refresh
```

## 6.8 رحلة دورة حياة إشعار FCM

```
FCM (data-only) → onBackgroundMessage → NotificationService.showRemoteMessage()  [Android فقط]
                 أو على iOS تفويض للنظام
App مفتوح: onMessage → NotificationsCubit.onNewNotificationArrived()
           → unreadCount++ + emit NewNotificationArrived + silentRefresh() (PATCH local أولاً ثم تزامن)
ضغط المستخدم إشعارًا → onMessageOpenedApp / handleInitialMessage()
           → (إن لم يكن زائرًا) pushNamed(notificationsView)
```

## 6.9 رحلة 401 (أي طلب)

```
أي request يُرجع 401
 └─ ApiService.onError → _performLogout():
      مسح CacheTokenManger + FlutterSecureStorage.deleteAll + CacheHelper.clearUserData
      + LayoutCubit.pageIndex = 0
      + Toast "youYouLoggedOutPleaseLoginAgain"
      + pushNamedAndRemoveUntil(loginView, (route) => false)
```

## 6.10 رحلة الفشل في الشبكة

```
DioException
 └─ ServerFailure.fromDioError → (timeout/cancel/badResponse/ SocketException → "noInternet"...)
      422 → أول رسالة حقلية تظهر كـ errMessage + fieldErrors محفوظة
      404/400/401/403/500 → response["message"] أو افتراضي
 └─ كل Cubit يخزن failure.errMessage → state Error → Toast/UI محلي
```

---

# 7. توثيق قاعدة البيانات

## 7.1 الواقع في هذا المشروع

**لا توجد قاعدة بيانات محلية.** التطبيق Flutter عميل (Client) بالكامل؛ كل "البيانات" تأتي وتذهب عبر REST API إلى خادم Laravel (نمط الاستجابة `{status, message, data}` + `pagination` في البحث والإشعارات — نمط Laravel معروض في `pagination{current_page, last_page, per_page, total}`). التخزين المحلي الوحيد:

| المفتاح | الآلية | المحتوى | حساسية |
|---|---|---|---|
| `userToken` | FlutterSecureStorage (عبر `CacheTokenManger`) **+ نسخة نصية ثانية في SharedPreferences** | توكن Bearer | **حساس** — النسخة النصية في prefs غير مبررة |
| `fcmToken` | SharedPreferences | FCM device token | متوسط |
| `isGuest`, `language`, `isDarkMode`, `firstRun`, `email`, `userId`, `userPhone` | SharedPreferences | حالة صغيرة | غير حساس |

## 7.2 نماذج البيانات (العقود مع السيرفر) — الجداول المنطقية

> هذه "جداول منطقية" مستنتجة من Models — **ليست** مخططًا فعليًا لقاعدة بيانات يمكن فحصها من هذا الريبو.

### 7.2.1 جدول `users` (من `ProfileModel` / `LoginModel` / `RegisterModel`)

| الحقل | النوع | المصدر | ملاحظات |
|---|---|---|---|
| `id` | int | الكل | المعرف |
| `name` | String | الكل | |
| `email` | String | الكل | |
| `phone` | String | الكل | مصري |
| `age` | dynamic | login/register | |
| `image` | String (URL) | الكل | |
| `token` | String | login/register/verify | **Bearer** |
| `wallet_balance` | int | profile | ج.م |
| `wallet_currency` | String | profile | |
| `subscription_package` | object/null | profile | الباقة الحالية إن وُجدت |
| `center_id`, `city_id` | int | الكل | |
| `cityName`, `centerName` | String | الكل | |
| `created_at` | String | الكل | ISO |

### 7.2.2 جدول `products` (Home / Search / SubCategory / Details / Compare)

| الحقل | النوع |
|---|---|
| `id`, `unique_number?` | int |
| `name`, `desc`, `description?` | String |
| `price` (String), `old_price`, `final_price?`, `discount?`, `currency` | String/num |
| `is_negotiable`, `is_urgent`, `is_paused`, `is_negotiable` | bool (قد تصل 0/1) |
| `status` | int — **`3 = مميز` (featured)** |
| `listing_type`, `listing_type_label` | String (`sale`...) |
| `furnishing`, `shipping_type`, `condition` (+_label) | String |
| `category_id`, `sub_category_id`, `category_type`, `city_id`, `center_id` | int |
| `marka`, `model`, `type` | String (سياق السيارات) |
| `image`, `images[]`, `location`, `date`, `created_at`, `views` | URL/String/int |
| `rate` | String في معظم المواضع، int في `Ads` |
| `seller{id,name,image,phone,rating,reviews_count}` | object (وفي BestView/Fav: مفرود `seller_name`...) |
| `isFavourite`, `reviews_count`, `countCommenets`, `commenets[]`, `reviews[]` | مختلط |

### 7.2.3 جدول `categories` (هرمي)

`AllCategoriesModel`: `categories[{id, name, image, subCategories: [{id, name, image, products_count}]}]`.

### 7.2.4 جداول الرسائل والإشعارات

- **`conversations`**: `{id, is_seller, other_user{id,name,image}, product{id,name,price,image}, last_message{...}, unread_count, updated_at}`.
- **`messages`**: `{id, conversation_id, sender_id, is_mine, type (text|image), body, image, is_read, read_at, is_deleted, created_at}`.
- **`notifications`**: `{id, type, title, body, data (dynamic), is_read, read_at, created_at}` + `pagination` + `unread_count`.

### 7.2.5 جداول الدفع

- **`subscription_packages`**: `{id, code, name, description, price, currency, duration_days, ads_limit, features[], is_subscribed?}`.
- **`payment_methods`**: `{code, name, account}` (من `payment-methods`).
- **`wallet_history`**: `{id, amount|balance, type, type_label|title, status, status_label, payment_method, receipt_url, created_at}` — حقول متعددة الاحتمالات (يتسامح النموذج مع صيغ كثيرة).
- **`ad-publishing-settings`**: `{price, currency, payment_methods:[{code, account}]}` — رسوم نشر ثابتة.
- **`subscriptions/current`**: `{status, is_expired, ads_limit, used_ads, remaining_ads}`.

### 7.2.6 جداول مساعدة

- **`cities`**: `{id, name, centers: [{id, name}]}` (من `getCities`).
- **`statistics`**: `{summary{...}, month, month_name, days[{date, day, day_name, sales_count, sales_amount}], period{from,to,...}, pagination}`.
- **`legal_content`**: `{title, content/html, language, direction, updated_at}`.

## 7.3 العلاقات والتدفق

```
users 1 ─── * products (seller_id)
products * ─── 1 categories / sub_categories
users (buyer) * ─── * products عبر favourites (product_id)
users 1 ─── * conversations ─── * messages
users 1 ─── * notifications
users 1 ─── 1 subscription_package (حالي) / 1 wallet
payments (orders) ─── packages / wallet/top-up / addNewAds fees
```

## 7.4 قيود واضحة في الكود/النماذج

- `status == 3` شرط "مميز" (`kFeaturedStatus`).
- `ad_id` و `product_id` يتطابقان في طلبات الإيقاف/التعديل/الحذف (نفس القيمة تُمرر باسمين مختلفين).
- التوكن الواحد يُستخدم للـ Bearer ولـ OTP ولـ reset (`reset_token: CacheTokenManger.userToken`).
- لا تتعامل النماذج مع transaction isolation أو locks — رهان على خادم Laravel.
- **لا توجد migrations/seeds/schema في هذا الريبو** — مخطط قاعدة البيانات مشتق فقط من النماذج. أي مخطط فعلي (أسماء جداول SQL) **Not Found** ويجب التحقق منه من الـ backend.

---

# 8. توثيق الـ API

> **المسارات كلها relative لـ `Base URL` = `https://by3li.axeviadigital.com/api/`**
> المصادقة: `Authorization: Bearer <token>` يُرفق تلقائيًا في `ApiService` لكل طلب (عند وجود التوكن). ترويسات ثابتة: `Accept: application/json`, `Content-Type: application/json` (multipart تلقائيًا عند الرفع)، `Accept-Language` و`lang` (من كاش `language`، افتراضي `ar`).
> **استجابات 401 في أي endpoint → خروج إجباري إلى Login** (انظر القسم 6.9).
> ترميز الجداول: `GET/POST/PATCH/DELETE` بالـ Methods الفعلية المستدعاة في الكود.

## 8.1 فهرس كل Endpoints المعرفة في `end_points.dart` (وهل تُستدعى فعلًا)

| # | الثابت | المسار | Method | مُستدعى؟ |
|---|---|---|---|---|
| 1 | `viewAllCategories` | `viewAllCategories` | GET | ✔ |
| 2 | `register` | `register` | POST (multipart) | ✔ |
| 3 | `home` | `home` | GET | ✔ |
| 4 | `bestAllView` | `bestAllView` | GET | ✔ |
| 5 | `login` | `login` | POST | ✔ |
| 6 | `getProfileData` | `getProfileData` | GET | ✔ |
| 7 | `logout` | `logout` | POST (بدون body) | ✔ |
| 8 | `verifyCode` | `verifyCode` | POST | ✔ |
| 9 | `getCities` | `getCities` | GET | ✔ |
| 10 | `addLocation` | `addLocation` | POST | ✔ |
| 11 | `favourites` | `favourites` | GET / POST / DELETE | ✔ |
| 12 | `searchProducts` | `searchProducts` | — | ✘ معرّف وغير مُستخدم |
| 13 | `deleteAccount` | `deleteAccount` | POST (بدون body) | ✔ |
| 14 | `productDetials` | `productDetials` | GET | ✔ |
| 15 | `rateProduct` | `rateProduct` | POST | ✔ |
| 16 | `pauseAd` / `resumeAd` | `pauseAd` / `resumeAd` | POST | ✔ |
| 17 | `compareProducts` | `compareProducts` | POST | ✔ |
| 18 | `addCompare` | `addCompare` | GET (`?product_ids[]`) | ✘ (كود ميت) |
| 19 | `addProduct` | `addProduct` | POST (multipart) | ✔ (legacy) |
| 20 | `marka` / `models` / `typies` | `marka` / `models` / `typies` | GET | ✔ (legacy) |
| 21 | `makePurchase` | `makePurchase` | — | ✘ معرّف وغير مُستخدم |
| 22 | `purchaseInstructions` | `purchaseInstructions` | GET | ✔ |
| 23 | `myAds` | `getAllAds` | GET | ✔ |
| 24 | `deleteAds` | `deleteAds` | POST | ✔ |
| 25 | `addNewAds` | `addNewAds` | POST (multipart) | ✔ |
| 26 | `editAd` | `editAds` | POST (multipart) | ✔ |
| 27 | `getSubCategories` | `getSubCategories` | GET (`?category_id`) | ✔ |
| 28 | `productBySubCategory` | `productBySubCategory` | GET (`?sub_category_id`) | ✔ |
| 29 | `sellerProduct` | `sellerDetails` | GET (`?seller_id`) | ✔ |
| 30 | `notifications` + متفرعاتها | `notifications`, `notifications/read-all`, `notifications/:id/read`, `notifications/:id` | GET/PATCH/PATCH/DELETE | ✔ |
| 31 | `complaintsTypes` | `complaintsTypes` | GET | ✔ |
| 32 | `addComplaint` | `addComplaint` | POST | ✔ |
| 33 | `reportReasons` | `reportReasons` | GET | ✔ |
| 34 | `reportAd` | `reportAd` | POST | ✔ |
| 35 | `resendCode` | `resendCode` | POST | ✔ |
| 36 | `updateProfile` | `updateProfile` | POST (multipart) | ✔ |
| 37 | `resetPassword` | `resetPassword` | POST (multipart) | ✔ (بدون واجهة) |
| 38 | `changePassword` | `changePassword` | POST (multipart) | ✔ |
| 39 | `updateDeviceToken` | `null` | — | ✘ (معطل بالتصميم — انظر 11) |
| 40 | `settings` | `settings` | GET / PATCH | ✔ |
| 41 | `about` / `terms` / `privacy` | `about` / `terms` / `privacy` | GET | ✔ |
| 42 | `getBanners` | `getBanners` | GET | ✔ |
| 43 | `products` | `products` | GET (`?page=` + filters) | ✔ |
| 44 | `subscriptionPackages` | `subscriptionPackages` | GET | ✔ |
| 45 | `subscriptions` | `subscriptions` | — | ✘ معرّف وغير مُستخدم |
| 46 | `subscriptionsCheckout` | `subscriptions/checkout` | POST (JSON أو multipart) | ✔ |
| 47 | `paymentMethods` | `payment-methods` | GET | ✔ |
| 48 | `subscriptionsCurrent` | `subscriptions/current` | GET | ✔ |
| 49 | `adPublishingSettings` | `ad-publishing-settings` | GET | ✔ |
| 50 | `walletTopUp` | `wallet/top-up` | POST (multipart) | ✔ |
| 51 | `walletHistory` | `wallet/history` | GET | ✔ |
| 52 | `statistics` | `statistics` | GET (`?page=&month=&date=`) | ✔ |
| 53 | `conversations` + متفرعاتها | `conversations`, `conversations/unread-count`, `conversations/:id`, `conversations/:id/messages`, `conversations/:id/read`, `conversations/:cid/messages/:mid` | GET/POST/DELETE/PATCH | ✔ |

## 8.2 تفاصيل أهم Endpoints

### `POST /login`
- **الغرض**: مصادقة هاتف + كلمة مرور.
- **الجسم**: `{"phone": "^01[0-9]{9}$", "password": "string", "device_token": "fcm"}` (JSON).
- **الرد**: `{status: bool, message: string, data: {user: {...}, isActive: bool, requires_otp: bool}}`.
- **Auth**: لا. **أخطاء شائعة**: رسالة السيرفر (`status=false`)، 401 → خروج إجباري.

### `POST /register` (multipart)
- **الغرض**: إنشاء حساب. الجسم (FormData): `image?` (file)، `phone`, `name`, `email`, `password`, `age`, `center_id: 1`, `city_id: 1` (ثابتة).
- **الرد**: `{status, message, data: {user, isActive, requires_otp, email, code/otp, next_step, expires_in}}`.
- **Auth**: لا.

### `POST /verifyCode` / `POST /resendCode`
- `verifyCode` الجسم: `{email, otp, device_token}` (JSON). الرد: `data{user, isActive(أو is_active), token(أو access_token), ...}` — التوكن قد يأتي من `data.token` أو `data.access_token` أو `data.user.token`.
- `resendCode` الجسم: `{email}` (Map خام). الرد: `{status, message, data: {phone, code: int}}` — **الكود يُعاد للعميل ويُعرض له**.
- **Auth**: لا.

### `GET /home` و `GET /getBanners`
- `home` بدون params؛ الرد: `data{categories[], bestView[], ads[]}`.
- `getBanners` بدون params؛ الرد: `data` قد تكون List أو Map بمفاتيح `banners|data|slides|items` (النموذج متسامح).

### `GET /viewAllCategories`
- بدون params؛ الرد: `data{categories: [{id, name, image, subCategories: [{id, name, image, products_count}]}]}`.

### `GET /getSubCategories?category_id=<int>`
- الرد: `data{subCategories: [...]}`.

### `GET /productBySubCategory?sub_category_id=<int>`
- الرد: `data{products: [...]}` (لا pagination).

### `GET /products` — البحث
- **الـ Query**: `page` (افتراضي 1) + من الفلتر: `category_id, sub_category_id, min_price, max_price, city_id, center_id, shipping_type (free|paid|both), condition (new|used|both)`.
- **الرد**: `data{products[], pagination{current_page, last_page, per_page, total}}`.
- **Auth**: يعمل بدون توكن (الزائر يفضل `products` — التطبيق لا يمنعه).

### `GET /productDetials?product_id=<int>&type=home`
- **`type`**: دائمًا `"home"` عند كل الاستدعاءات (دلالته **Not Found**).
- **الرد**: `data{product{...}, relatedProducts[], similarProducts[], sponsoredProducts[], banners[]}` — الأخيران غير مستخدمان.

### `POST /rateProduct`
- الجسم: `{"product_id": int, "rate": int, "commenet": "string"}`. الرد: `{status, number, message}`.

### `POST /pauseAd` / `POST /resumeAd`
- الجسم: `{"ad_id": int}` (يُمرر `productId`). الرد: `data{ad_id, is_paused, status}`.

### `POST /addNewAds` (multipart)
- الجسم (FormData): `name, description, price, discount?, is_negotiable (0/1), is_urgent (0/1), listing_type='sale', category_id, sub_category_id, shipping_type ('free'|'paid'), condition ('new'|'used'), city_id, center_id` + اختياري `payment_method, transfer_reference` + ملفات `images[]` (1–5) + `receipt?` (عند الدفع بتحويل فقط).
- **قواعد النشر**: بدون دفع إذا مغطى بالاشتراك (`subscriptions/current`)؛ وإلا الرسوم من `ad-publishing-settings`.

### `POST /editAds` (multipart)
- `ad_id` + نفس حقول النشر (بدون حقول دفع) + `images[]` **الجديدة فقط**.

### `GET /getAllAds`
- بدون params؛ الرد: `data{ads: [...]}` — يتضمن `is_paused`, `status`, `views`, `reviews_count`... إلخ.

### `POST /deleteAds`
- الجسم: `{"ad_id": int}`. الرد: `GeneralModel`.

### `GET /subscriptionPackages`
- بدون params؛ قائمة الباقات (المدة تصل ضمنيًا — التطبيق يفلتر محليًا حسب تبويبات شهري/3/6/سنوي).

### `GET /payment-methods`
- الرد: `data{methods: [{code, name, account}]}` — الكود (`vodafone_cash`, `etisalat_cash`, `orange_cash`, `instapay`, `fawry`, `bank_transfer`, `wallet`, `cash`).

### `POST /subscriptions/checkout`
- وضعان: **JSON** `{package_id, payment_method: 'wallet'}` أو **multipart** `{package_id, payment_method: <code>, receipt: file}`.

### `GET /subscriptions/current`
- الرد: `{status, is_expired, ads_limit, used_ads, remaining_ads}` — `isCovered` في الكود: `active && !is_expired && (ads_limit<=0 || remaining_ads>0)`.

### `GET /ad-publishing-settings`
- الرد: `{price, currency, payment_methods: [{code, account}]}`.

### `POST /wallet/top-up` (multipart)
- الجسم: `amount, payment_method (code), transfer_reference?, receipt`.

### `GET /wallet/history`
- بدون params؛ الرد يتسامح مع عدة أشكال (انظر `WalletHistoryModel`).

### `GET /statistics?page=1&month=YYYY-MM` أو `?date=YYYY-MM-DD`
- الرد: `{summary{...}, month, month_name, days[...], period{from,to}, sales[], pagination{...}}`.

### `GET /notifications?type=&page=&per_page=15`
- `type`: `general | unread | purchaseRequests | regularMessages` (الواجهة تستخدم `general` فقط).
- الرد: `data{notifications[], pagination{...}, unread_count}`.

### `PATCH /notifications/:id/read` — `PATCH /notifications/read-all` — `DELETE /notifications/:id` — `DELETE /notifications`
- بلا جسم.

### الشات
- `POST /conversations` — body `{product_id?, user_id?, body?}` → `data{conversation{...}}`.
- `GET /conversations?page=&per_page=` → `data{conversations[], pagination{...}, unread_count}`.
- `GET /conversations/unread-count` → `data{unread_count}`.
- `GET /conversations/:id/messages?page=&per_page=30&before_id=&after_id=`.
- `POST /conversations/:id/messages` — إما `body` (JSON) أو multipart `image`.
- `PATCH /conversations/:id/read`.
- `DELETE /conversations/:cid/messages/:mid` — حذف رسالة.
- `DELETE /conversations/:id` — إخفاء محادثة **من طرف المستخدم فقط**.

### الإبلاغ
- `GET /complaintsTypes` → `data{complaints: [{id: int, text: string}]}`.
- `POST /addComplaint` — `{complaint_id, seller_id?, product_id?, message}`.
- `GET /reportReasons` → `data{reasons: [{id: String!, name}]}`.
- `POST /reportAd` — `{seller_id, product_id, reason, description}`.

### الحساب والإعدادات
- `GET /getCities` → `data{cities: [{id, name, centers: [...]}]}`.
- `POST /addLocation` — `{city_id, center_id}` (strings).
- `POST /changePassword` (multipart): `{email, reset_token: <userToken>, new_password, confirm_new_password}`.
- `POST /resetPassword` (multipart): `{email, otp, password, password_confirmation}`.
- `POST /logout` — بدون جسم.
- `POST /deleteAccount` — بدون جسم.
- `GET /getProfileData` → `data{user{... wallet_balance, subscription_package, ...}, isActive, requires_otp}`.
- `POST /updateProfile` (multipart): `image?, name?, email?, phone?`.
- `GET /settings` / `PATCH /settings` — `{contact_method, contact_phone, notify_new_products, store_name?, store_address?}`.
- `GET /about` / `/terms` / `/privacy` — HTML.
- `GET /purchaseInstructions` — HTML.

## 8.3 الأخطاء المعيارية

| الحالة | المعنى في الكود |
|---|---|
| 400 / 401 / 403 / 404 / 500 | `ServerFailure(response["message"] ?? افتراضي)` |
| 422 | أول حقل من `data{...}` → أول رسالة في قائمته؛ ويُحفظ كـ `fieldErrors` (تُستخدم في النشر لفتح ورقة الدفع) |
| 404 مع `data{...}` | نفس منطق 422 (أول رسالة حقلية) |
| `connectionTimeout` / `sendTimeout` / `receiveTimeout` | رسوخ حسب النوع (`connectionTimeOut`...) |
| `SocketException` في `unknown` | `noInternet` |
| `cancel` | `requestCanceled` |

---

# 9. المصادقة والأمان

## 9.1 المصادقة (Authentication)

| العنصر | التفاصيل |
|---|---|
| نوع التوكن | Bearer Token صادر من السيرفر بعد التفعيل/الدخول |
| التخزين | `flutter_secure_storage` بمفتاح `userToken` (عبر `SecureStorageService` و`CacheTokenManger`) **ونسخة نصية ثانية في SharedPreferences** (`CacheHelper['userToken']` + `StorageKeys.userToken`) — انظر المخاطر أدناه |
| الحالة العالمية | `AuthCubit` في الجذر: `checkAuthStatus()` عند الإقلاع (يقرأ من `CacheHelper` فقط — بينما الـ Splash يقرأ من secure storage) |
| التجديد (Refresh) | **لا يوجد** آلية refresh token؛ `StorageKeys.refreshToken` معرّف وغير مُستخدم فعليًا |
| "نسيت كلمة المرور" | برمجي فقط: `changePassword` بوضع `ForgetPasswordView` يستدعي `POST /resetPassword` — **لا توجد شاشة** لذلك |
| OTP | 6 خانات عبر البريد؛ مؤقت 60 ث؛ **الكود يُرسل ويعاد للعميل ويُعرض** (`ResendOtpButton` + `resendCode` response) — ممارسة سيئة |
| التفعيل إجباري؟ | `isActive=false` بعد login → **لا شاشة تعرض المسار** (انظر 11) |
| الجلسة | لا يوجد timeout صريح للجلسة؛ انتهاء التوكن = 401 → خروج إجباري |

## 9.2 التفويض والأذونات داخل التطبيق

| القاعدة | الموضع |
|---|---|
| `isGuest` → منع Chat/Ads/Account + شاشة `GuestPlaceholder` | `layout_view.dart` + `guest_guard.dart` |
| الشاشات الخاصة بالحساب (profile/fav/notifications/privacy) لا تُحمَّل للزائر | `my_app.dart` (شرط `GuestGuard.isGuest`) |
| تفضيل الإعلانات (إيقاف/تفعيل) للمالك فقط | `product_details_view.dart` (`isOwner`) |
| الشات مع النفس ممنوع | `StartChatButton` (يقارن user id) |
| `requireLogin(context)` قبل استخدام التفضلة/التقييم/التبليغ | `FavHeartButton`, `rate_product_widget`, `product_details` |
| مالك الحساب فقط يرى الإعدادات/الحذف | لا حاجة لحماية إضافية (شاشة واحدة للمستخدم) |

## 9.3 التحقق من المدخلات

- كل القواعد في `MyValidators`: هاتف مصري، كلمة مرور قوية (كبيرة/صغيرة/رقم/رمز، 8–30)، إيميل (regex + فحوص نقطتين/@)، الاسم، العمر 18–100، repeat password.
- ملاحظات على الفجوات: **حقل كلمة مرور الدخول و`oldPassword` بدون validator**؛ خانة OTP تطلب 4 أحرف فقط رغم أنها 6 خانات؛ تسجيل يعيد كتابة phoneValidator بعدد 11 خانة.

## 9.4 الأمان التشغيلي

| البند | الحالة |
|---|---|
| HTTPS | نعم (`https://by3li.axeviadigital.com`)؛ الرابطان القديمان (أحدهما `http://`) في تعليقات الكود |
| ترويسات | Bearer يدويًا، `Accept-Language`, `lang`, `Accept`, `Content-Type` |
| تسجيل البيانات الحساسة | `debugPrint` يرسم كل الطلبات والردود (headers + body) في **debug mode**؛ `getDeviceToken` يطبع **التوكن الكامل**؛ `BlocObserver` يطبع كل الانتقالات — مقبول تطويريًا ومرفوض إنتاجيًا |
| منع Screenshots | **Not Found** — لا يوجد FLAG_SECURE |
| حفظ الأرقام | `ios Info.plist`: مفتاح وحيد `NSPhotoLibraryAddUsageDescription` — **لا توجد أذونات Camera/Mic/Location على iOS رغم استخدام الكاميرا والغاليري**؛ Android: لا صلاحية INTERNET صريحة (تُورث من Flutter) ولا CAMERA صراحةً (الإضافات تضيف ما تحتاجه) |
| الالتزام بالـ Secrets | `google-services.json` (جذر + `android/app/`)، `GoogleService-Info.plist`، `firebase_options.dart` — **كلها مُتتبعة في Git** ومفاتيح FCM ظاهرة؛ الـ API keys لفيربيس عامة بطبيعتها لكنها يجب ألا ترقد في تاريخ Git، وREADME لا ينصح بذلك |
| توقيع الإصدار (Release) | **يستخدم debug keys** في `build.gradle.kts` (TODO موجود صراحةً) |
| applicationId / bundleId | `com.example.by3ly` (TODO صريح بتغييره) |
| تسريب البيانات | رقم الحساب البنكي/فودافون كاش للتحويل **مهاردكود في `addBalance`** (غير مستخدم فعليًا) |
| ProGuard/R8 | **غير مفعّل** — لا يوجد `minifyEnabled true` (الإعداد الافتراضي) |
| Network Security Config | **غير موجود** — لا ملف `network_security_config.xml`، القيمة الافتراضية (يسمح بكل شيء بسياسة افتراضية للنظام على targetSdk 36) |

## 9.5 الخلاصة الأمنية

الكود يلتزم بأساسيات جيدة (HTTPS، secure storage للتوكن، 401 global sign-out، input validation)، لكنه يعاني من ممارسات سيئة (كود OTP يُكشف للعميل، توكن منسوخ في prefs، Debug logging واسع، أسرار في Git، توقيع debug للإصدار، iOS permissions ناقصة). التفاصيل في القسم 11.

---

# 10. التثبيت والإعداد

> **تنبيه**: هذه التعليمات مستمدة من الملفات الفعلية (`pubspec.yaml`, `firebase.json`, `android/`, `ios/`, `firebase_options.dart`).

## 10.1 المتطلبات

| الأداة | الإصدار |
|---|---|
| Flutter SDK | أي إصدار يدعم Dart `^3.12.1` (يُنصح بآخر stable) |
| Android Studio / Xcode | حسب المنصة (iOS يتطلب macOS) |
| Java | 17 |
| Android SDK | compileSdk 36 / minSdk 24 / targetSdk 36 |
| مشروع Firebase | `by3ly-ed414` (Android appId مختلف عن iOS) |

## 10.2 خطوات التثبيت

```bash
# 1) استنساخ
git clone <repo-url> BY3LY && cd BY3LY

# 2) جلب الاعتمادات
flutter pub get

# 3) التحقق من إعدادات Firebase
#    android/app/google-services.json  +  ios/Runner/GoogleService-Info.plist  +  lib/firebase_options.dart
#    (كلها مُتتبعة في Git بالفعل — لا حاجة لـ flutterfire configure ما دام المشروع نفسه)
#    إن أردت مشروع Firebase جديدًا: flutterfire configure --project=<new-project>

# 4) (Android) التأكد من google-services.json داخل android/app/

# 5) تشغيل
flutter run                  # debug
flutter run --release        # release (لاحظ: موقّع حاليًا بمفاتيح debug)
```

## 10.3 متغيرات البيئة / الإعدادات

**لا يوجد `.env` في المشروع** ولا `flutter_dotenv`. كل الإعدادات ثابتة في الكود:

| الضبط | الموضع | القيمة |
|---|---|---|
| Base URL | `lib/core/app_services/remote_services/end_points.dart` | `https://by3li.axeviadigital.com/api/` (نسختان قديمتان معلقتان) |
| Firebase project | `lib/firebase_options.dart` | `by3ly-ed414` (Android + iOS فقط) |
| اللغة الافتراضية | `lib/main.dart` | `ar` |
| حجم التصميم (ScreenUtil) | `lib/my_app.dart` | `390×844` |
| الخطوط | `pubspec.yaml` + `assets/fonts/...` | Cairo |

## 10.4 تهيئة قاعدة البيانات

**لا توجد قاعدة بيانات لتهيئتها.** لا يوجد `sqflite`/`hive`/`drift`، ولا migrations، ولا seeds. النسخة الأولى تُمكّن بفضل `firstRun` في `AppInitializer`: تمسح التخزين وتنشئه نظيفًا (انظر الكود — تمسح `FlutterSecureStorage` و`CacheHelper.clearUserData()` أول مرة فقط).

## 10.5 الأصول والترجمات

- Assets مُعلنة في `pubspec.yaml`: `assets/images/` (72 صورة/أيقونة) + Cairo font.
- الترجمات تعيش في **ملفات Dart** (`lib/lang/ar_lang.dart`, `en_lang.dart`) مع `CodegenLoader` — المسار `path: 'assets/lang'` في `main.dart` **غير مستخدم** (المجلد غير موجود) ولا يُعتبر خطأً تشغيليًا.
- 350 مفتاح في `LocaleKeys`؛ 10 مفاتيح مفقودة في AR (`addCredit, bestView, choose, governorate, loginLater, numbersConversionInfo, paymentMethods, seeAll, selectGovernorate, tipsForYourSafety`) و5 في EN (`addCredit, choose, governorate, or, tipsForYourSafety`).

## 10.6 التعديل على الـ Application ID (خطوة ضرورية للنشر)

```
android/app/build.gradle.kts   → applicationId = "com.example.by3ly"  (TODO صريح)
ios/Runner.xcodeproj           → bundleId = "com.example.by3ly" (في firebase_options)
```

## 10.7 البناء

```bash
flutter build apk --release        # موقّع حاليًا بـ debug keys — غير صالح للنشر
flutter build ipa --release        # يتطلب provisioning profile + صلاحية توزيع
flutter analyze                    # بدون أخطاء متوقعة — lints الافتراضية فقط
```

لا توجد اختبارات ولا CI — أي تحقق إنتاجي يدوي بالكامل.

---

# 11. القيود المعروفة والديون التقنية

## 11.1 أخطاء منطقية مؤكدة (وفق الكود)

| # | الموضع | الوصف | الأثر |
|---|---|---|---|
| 1 | `login_cubit.dart` | عند `isActive == false` لا يُصدر أي state | المستخدم معلق على شاشة التحميل؛ `LoginSuccessWithNoActiveState` مسار ميت |
| 2 | `auth_cubit.dart` | `loginWithToken`: `userToken = userToken;` (إسناد لنفسه) | الـ field لا يُضبط أبدًا؛ الكاش يصمد فقط |
| 3 | `register_cubit.dart` / `register_repo_imple.dart` | `center_id: 1, city_id: 1` مهاردكود | كل حساب جديد يُسجل بموقع (1,1) — تهيئة خاطئة صامتة |
| 4 | `otp` PIN field | الطول 6 لكن الـ validator يقبل ≥ 4 | أخطاء غير متسقة |
| 5 | `change_password_cubit.dart` | `oldPassword` يُجمع ولا يُرسل للسيرفر | تغيير كلمة المرور بدون تحقق من القديمة |
| 6 | `changePassword` | وضع `ForgetPasswordView` كامل لكن **لا توجد شاشة** له | كود ميت كامل |
| 7 | `delete_account` (شاشة الإعدادات) | لا تمسح التوكن/الكاش عند النجاح | التوكن يبقى صالحًا ظاهريًا بعد "الحذف" |
| 8 | `delete_account` | زر "Delete now" **بدون حوار تأكيد** | حذف نهائي بنقرة واحدة |
| 9 | `report_the_product_view_body.dart` | يقارن `state is GetAllCategoriesLoading` (من feature أخرى) بدل حالة الشكاوى | مؤشر التحميل لا يعمل |
| 10 | `otp_view_body.dart` | Resend SnackBar يعرض `LocaleKeys.verificationCodeResent` **كسلسلة خام بدون .tr()** | المستخدم يرى اسم المفتاح حرفيًا |
| 11 | `resend otp` | الكود يُعرض في Toast + في الاستجابة | يفقد بذلك معنى "التحقق" بالكامل |
| 12 | `get_device_token` | يطبع FCM token كاملًا | تسريب محتمل في السجلات |

## 11.2 كود ميت / غير مستخدم

- `Routes.onBoardingView`، `Routes.privacyPolicyView` تُستخدم فعليًا (LegalContentView) — لكن `onBoardingView` غير مسجّل في router.
- `SplashView` و`OnBoardingView`: `Routes.onBoardingView` معرف بدون تسجيل.
- `addCompare` endpoint + `ProductDetailsCubit.addProductToCompare` + `AddProductToCompareModel`.
- `change_lang_states.dart` (`LocalizationState/ChangedState`) غير مستخدمة؛ `LanguageCubit` **مكررة في ملفين**.
- `ProfileViewBody` (النسخة القديمة بـ Item N)، `ProfileViewBodyListItemWidget`, `SettingsItemWidget`, `ProfileViewBodyListItemWidget`.
- `notifications_buttons_types.dart` (تبويبات الشراء/الرسائل العادية)، `ChatProductHeader` (معلّق في layout)، `SearchFilterView`، `ReasonModel`، `countries_list_item.dart`، `AllSubCategoriesProductsListItem` كود جزئي، `HomeAdsStrip` / `BestViewStrip` / `AllAdsView` / `BannerAds` — كلها غير مربوطة في أي Body.
- `similarProducts`, `sponsoredProducts`, `banners` (في `ProductDetailsModel`), `specifications`, `map`, `safety_tips` — تُفك ولا تُعرض.
- `EndPoints.subscriptions`, `searchProducts`, `makePurchase`, `updateDeviceToken = null` (التزامن معطل بالتصميم).
- `use_cases/` كاملة (Clean Architecture contracts) غير مستخدمة.
- `app_strings.dart` (`egypt` فقط)، `new_app_nav` vs `app_nav` vs `extensions/navigate.dart` — ثلاثة أنظمة تنقل متوازيين.
- `cache_token.dart` و`cache_helper.dart` يحتفظان بـ `userToken` مرتين (secure + prefs).

## 11.3 مشاكل بيانات وترجمة

- `en_lang.dart` يحتوي 4 قيم عربية بلا ترجمة (`confirmLogout`, `areYouSureLogout`, `cancel`, `logout`)؛ `ar_lang.dart` يحتوي `bankDes = "fffffff"` (قيمة مكسورة).
- 10 مفاتيح مفقودة في AR و5 في EN (القائمة في 10.5).
- نصوص عربية مهاردكود داخل Widgets (`"الكل"`، `"النشط الان"`، `"أضف رصيد"`، `"اختر طريقة الدفع"`، `"رسوم النشر"`، `"محفظة بيعلي"`...) بدل `LocaleKeys` — يتعذر ترجمتها لاحقًا دون تنقيب.
- صور من `img.freepik.com` و`tse1.mm.bing.net` كـ fallback (`AppImages.testImage`, `product_details_cubit.dart` lines ~25–28).
- `app_images.dart`: أسماء ملفات بمسافات (`Frame 1000003824.png`, `eye (1).svg`, `cpmpration`, `healthiconsMarket`).

## 11.4 الأداء والبنية

- لا pagination إلا في البحث؛ قوائم (fav/ads/seller/best view/sub-category) تحمّل كل شيء دفعة واحدة.
- `AllSubCategoriesProductsCubit` **يُلحق** (append) المنتجات بلا قص — النمو التراكمي لانهائي في نفس الصفحة.
- شات بالـ **polling** (كل دقيقة للشاشة المفتوحة + كل دقيقتين للقائمة) — غير لحظي؛ إلى جانب ذلك، عامِل `after_id` ذكي لكنه لا يصمت إشعاراته لنفس المرسل (يعتمد على السيرفر).
- لا caching للصور المُحللة إلا عبر `CachedNetworkImage` (مقبول).
- `HomeCubit` + `SearchCubit` يجتمعان عند إقلاع التطبيق حتى لو كان الهدف شاشة غير Home — بدء أثقل بلا داعٍ (مقبول لتحسين TTFB للـ Home).
- `my_app.dart` ينشئ Cubits بكثرة على الجذر ويظل كل منهم حيًا طوال الجلسة.

## 11.5 المعمارية والصيانة

- **لا فصل حقيقي للـ Domain layer** — الـ Cubit يستدعي الـ Repo مباشرة (مقبول في الحجم الحالي).
- `main_importants.dart` Barrel واحد بـ 30+ تصدير — أي تغيير يفرض `flutter pub get`/rebuild شامل.
- ازدواج التدفقين (legacy + unified) للنشر والرصيد — يثقل الصيانة ويربك المساهمين الجدد.
- `features/<feature>/presentation/view-model/` (بشرطة) في `helpSupport` مقابل `view_model` في البقية — عدم اتساق في الـ naming.
- `features/allCategories/data/repositories/` بجمع "repositories" مقابل `repos` في البقية.
- `helpSupport` يستخدم placeholder emails/phones (`example.com`, `+1234567890`, `mustafa.bahr12323@gmail.com`) — **يجب استبدالها قبل النشر**.
- حقل الإشعارات في `ProfileCubit.switchValue` محلي فقط وغير متصل بـ `settings.notify_new_products` (في شاشة Privacy) — مفتاحان "إشعارات" مزدوجان أحدهما وهمي.
- `ProfileCubit` يُخزّن `file` صورة avatar لا تُرسل مع أي update (رفع الصورة منصب لـ `updateProfile`).
- `ProfileModel.delete_account_model.dart` مكرر (نسختان متطابقتان) — استخدموا نسخة deleteAccount.
- Android: `applicationId com.example.by3ly` + توقيع debug للإصدار؛ iOS: `NSPhotoLibraryAddUsageDescription` فقط (لا Camera)؛ Android Manifest: لا CAMERA/READ_MEDIA_IMAGES صريحة (تعتمد على الإضافات).
- `google-services.json` **مكررة في الجذر** + `android/app/` — كلاهما مُتتبع.

## 11.6 الاختبار والجودة

- **لا توجد اختبارات** (لا unit/widget/integration، لا `test/`).
- **لا CI/CD** (لا `.github/workflows/`).
- `analysis_options.yaml` بلا قواعد مخصصة — `flutter analyze` لن يلتقط سلوكيات دقيقة.
- `SimpleBlocObserver` يطبع على `print` في `onError`.

## 11.7 ما يجب معالجته بأولوية (توصيات)

1. **أمان**: نقل التوكن من SharedPreferences إلى secure storage فقط؛ إيقاف debug logging (أو tying بـ `kReleaseMode`)؛ إزالة أسرار من Git؛ signing config للإصدار؛ تفعيل R8/ProGuard.
2. **Auth**: إصلاح مسار `isActive == false`؛ إلغاء احتفاظ `otp` بـ `reset_token` إلى حين وجود شاشة reset فعلية؛ منع عرض كود OTP.
3. **التدفقات**: توحيد legacy (`AddAdvertisementsView` / `addBalance` / `confirmPayment`) أو حذفها صراحةً؛ ربط أو حذف `HomeAdsStrip`؛ توحيد `LanguageCubit`.
4. **الجودة**: إضافة اختبارات على الأقل للتحقق (MyValidators) والـ Repos (mock Dio)؛ CI بـ `flutter analyze` + `flutter test`.
5. **الالتزام**: iOS usage descriptions كاملة (Camera/Photo Library)؛ توحيد أسماء المجلدات (`view_model` مقابل `view-model`)؛ إكمال ترجمة المفاتيح الناقصين.

---

# 12. Glossary (قاموس المصطلحات)

| المصطلح | المعنى في هذا التطبيق |
|---|---|
| **BY3LY / بيعلي / By3ly** | اسم التطبيق (Main launcher: `by3ly`، الطائرة الداخلية `title: "BY3LY"`) |
| **Guest / زائر** | وضع بلا حساب: تصفح فقط، بلا token، مقيد بالحوار/الشاشة البديلة `GuestGuard` |
| **Ad / Listing (إعلان)** | عنصر معروض للبيع في السوق (منتج)؛ له حالة `status` (3 = مميز) و`is_urgent`, `is_negotiable`, `is_paused` |
| **Marka / Model / Type** | الماركة / الموديل / النوع — سياق إعلانات السيارات (`GET marka|models|typies`) |
| **Best View** | "الأكثر مشاهدة" — `home.bestView[]` و `GET bestAllView` |
| **ProductsFilter** | كائن الفلترة المشترك (`allSubCategoriesProducts/products_filter_sheet.dart`) مع `toQueryParams()` يُستخدم في البحث |
| **Favourites / المفضلة** | `favourites` endpoint؛ `FavCubit.favouriteIds` (Set) مع toggle تفاؤلي |
| **Chat / Conversation** | محادثة مشتري↔بائع على منتج؛ polling (لا WebSocket) |
| **ChatUnreadCubit** | Singleton عالمي يذيع عداد الرسائل غير المقروءة (شارة تبويب + Home؟) |
| **OTP** | كود تفعيل 6 خانات عبر البريد (وليس SMS) |
| **Polling** | طلب دوري (واجهة `Timer.periodic`) بدل اتصال دائم |
| **`isGuest`** | قيمة كاش بوليانية يكتبها `AuthCubit.loginAsGuest()`/`loginWithToken()`/`logout()` |
| **LayoutCubit** | جدول التبويبات الخمسة في `LayoutView` (index ثابت static) |
| **Subscriptions / الباقة** | باقة اشتراك شهري|3|6|سنوي بنشر إعلانات مجانية ضمن حد |
| **Publishing Fee** | رسوم نشر الإعلان الواحد عند عدم وجود باقة/إعلانات مجانية |
| **Wallet / المحفظة** | رصيد داخلي بالجنيه (`wallet_balance`)؛ يُشحن بتحويل + إيصال؛ يُدفع منه |
| **Transfer Methods** | Vodafone / Orange / Etisalat Cash، InstaPay، Bank، Fawry، Wallet، Cash |
| **GeneralModel** | `{status, number, message}` — رد موحد لعمليات بسيطة (rate/fav/delete...) |
| **Cubit / Bloc** | نمط إدارة الحالة؛ الأحداث = States صادرة |
| **Failure / ServerFailure** | غلاف أخطاء الشبكة/السيرفر (422 field errors...) |
| **DI / GetIt** | حقن الاعتمادية عبر `GetIt.instance` في `service_locator.dart`؛ `setup()` عند الإقلاع |
| **CodegenLoader** | مولد سهل لـ `easy_localization` — يخزن الخرائط كمصدر داخل الكود بدل JSON |
| **firstRun** | علم مسح أولي يمسح كل التخزين عند أول إقلاع |
| **AppOverlay (AdPaymentSheet)** | ورقة دفع رسوم النشر (محفظة أو تحويل) — `ad_payment_sheet.dart` |
| **Featured** | `status == 3` — شارة "مميز" برتقالية/صفراء في كل البطاقات |
| **Urgent** | `is_urgent` — شارة حمراء "عاجل" |
| **Unread Count** | فرعان: الإشعارات (`unread_count` سيرفري) و المحادثات (`ChatUnreadCubit`) |
| **getProfileData** | مصدر الحقيقة الوحيد لحالة المستخدم (status/wallet/package/location) |

---

## ملحق أ — خريطة المجلدات الكاملة (Top 2 levels)

```
.
├── android/ ios/ web/ linux/ macos/ windows/   # منصات Flutter (الفعلي Android+iOS)
├── assets/
│   ├── fonts/cairo/Cairo-VariableFont_slnt,wght.ttf
│   └── images/   (72 ملف: svg/png/jpg — الشعارات، الأيقونات، صور الباقات/الدفع)
├── lib/
│   ├── main.dart / main_importants.dart / my_app.dart / firebase_options.dart
│   ├── core/ (app_services, errors, extensions, general_models, notifications,
│   │         routing, shared_cubits, shared_widgets, use_cases, utils)
│   ├── features/ (addAdvertisements, addBalance, allCategories, allSubCategories,
│   │    allSubCategoriesProducts, changeLang, changePassword, chat,
│   │    chooseLocation, compare, confirmPayment, deleteAccount,
│   │    fav, helpSupport, helpSupportChat, home, howToMakePurchase,
│   │    layout, legalContent, login, notifications, onBoarding, otp,
│   │    packages, PaymentBalance, privacy, productDetails, productSeller,
│   │    profile, register, reportProduct, search, seeAllBestView,
│   │    splash, statistics, updateProfile, advertisements)
│   └── lang/ (ar_lang.dart, en_lang.dart, locale_keys.dart, codegen_loader.g.dart)
├── firebase.json / google-services.json / pubspec.yaml / analysis_options.yaml / README.md
└── APP_DOCUMENTATION.md   ← هذا الملف
```

## ملحق ب — ملاحظات التدقيق والمراجع

هذا التوثيق مبني على قراءة فعلية لكل ملف `.dart` في `lib/` (445 ملفًا) وملفات الإعداد والمِلاذات:
`pubspec.yaml`, `analysis_options.yaml`, `firebase.json`, `google-services.json` (وجودًا فقط),
`android/app/build.gradle.kts`, `android/app/src/main/AndroidManifest.xml`, `ios/Runner/Info.plist`,
`lib/core/**`, `lib/features/**`, `lib/lang/**`.

كل بند موسوم **Not Found** أو **Needs Verification** يحتاج مراجعة مع: (أ) فريق الـ backend (مخطط قاعدة البيانات الفعلي، دلالات حقول `productDetials.type`, `status==3`)، (ب) حساب App Store/Play Console (الأذونات)، (ج) فريق التصميم (النصوص العربية المهاردكود).
