# تقرير حالة تطبيق BY3LY (بيعلي) — للمراجعة والتقييم

> **ملف مُعدّ خصيصًا لإعطائه لـ ChatGPT / نموذج ذكاء اصطناعي** ليقوم بتقييم نسبة اكتمال التطبيق ويحدد هل هو جاهز للإنتاج (production-ready) أم لا.
>
> **المطلوب من النموذج في نهاية التقرير:** (1) تقدير نسبة الاكتمال، (2) حكم الجاهزية للإطلاق، (3) ترتيب المهام المتبقية حسب الأولوية.
>
> **ملاحظة منهجية:** هذا التقرير مبني على **قراءة الكود الفعلي** في هذا المستودع (وليس على التوثيق القديم). تم التحقق من النقاط الحرجة مباشرة. المصطلحات وأسماء الملفات والـ APIs بقيت بالإنجليزية كما هي في الكود.
>
> تاريخ التقرير: 2026-11-17 — إصدار التطبيق: `1.0.0+1` (من `pubspec.yaml`).

---

## 1. طلب التقييم (اقرأ هذا أولًا)

يرجى من النموذج الإجابة على الأسئلة التالية بناءً على ما ورد في هذا التقرير:

1. **ما نسبة اكتمال التطبيق التقريبية؟** (أعطِ رقمًا مع تبرير، وقسّمها حسب: الوظائف / الاختبارات / الأمان / الجاهزية للإطلاق).
2. **هل التطبيق جاهز للإنتاج (production-ready) على Android و iOS؟** أجب بـ نعم / لا / مشروط، مع التبرير.
3. **ما أهم 5 مهام يجب حلها قبل الإطلاق** مرتبة حسب الأولوية (Critical أولًا)؟
4. **هل هناك تناقضات أو نقاط تبدو غير منطقية** في التقرير تستحق التحقق؟

---

## 2. نظرة عامة

| البند | القيمة |
|---|---|
| اسم التطبيق | BY3LY (بيعلي) — سوق إعلانات مبوبة مصري (Online Marketplace / Classifieds) |
| الإطار | Flutter (Dart SDK `^3.12.1`)، Material 3 |
| المنصات المستهدفة فعليًا | Android و iOS فقط (منصات web/macOS/windows/linux موجودة بالشجرة لكن الـ Firebase يرمي `UnsupportedError` عليها) |
| الـ Backend | REST API عبر Dio — Base URL: `https://by3li.axeviadigital.com/api/` |
| اللغة الافتراضية | العربية (RTL)، مع دعم كامل للإنجليزية (≈350 مفتاح ترجمة) |
| المصادقة | هاتف مصري (`^01[0-9]{9}$`) + كلمة مرور + تفعيل OTP عبر **البريد الإلكتروني** |
| إدارة الحالة | `flutter_bloc` (Cubit فقط — لا يوجد Bloc بالأحداث) + `get_it` لحقن الاعتمادية |
| التخزين | `FlutterSecureStorage` (التوكن) + `SharedPreferences` (نسخة نصية من التوكن + إعدادات صغيرة). لا توجد قاعدة بيانات محلية. |
| تكامل خارجي | Firebase Cloud Messaging (إشعارات) + Firebase Crashlytics + flutter_local_notifications |
| الدفع | باقات اشتراك + محفظة داخلية + تحويلات (Vodafone/Orange/Etisalat Cash, InstaPay, Bank, Fawry) مع رفع إيصال |
| وضع الزائر | مدعوم (Guest Mode) — تصفح بدون حساب |

---

## 3. أرقام إحصائية (من الكود الفعلي)

| الطبقة | العدد |
|---|---|
| إجمالي ملفات Dart في `lib/` | **488** |
| ملفات `lib/features/` (37 ميزة) | **421** |
| ملفات `lib/core/` | **59** |
| ملفات `lib/lang/` | **4** |
| ملفات `test/` | **37 ملفًا** (~358 حالة `test()` / `testWidgets()`) |
| Cubits تقريبًا | ~35 |
| Endpoints تقريبًا | ~53 |
| Singleton مسجلة في GetIt | 31 |

> تنبيه: يوجد ملف `APP_DOCUMENTATION.md` أقدم في المشروع يقول «445 ملفًا» و«لا يوجد مجلد test» — **هذه الأرقام قديمة وغير دقيقة الآن**.

---

## 4. المعمارية (Architecture)

نمط **Feature-first** مع طبقات `data` / `presentation` (شبيه بـ Clean Architecture لكن **بدون طبقة Domain فعّالة**):

```
UI (views)
  ↓ context.read<Cubit>()
Cubit (view_model/*)  ←→  Shared Widgets / Core
  ↓ calls
Repository (abstract + impl, data/repos/)
  ↓ Either<Failure, Model>
ApiService (Dio wrapper) + CacheTokenManger + CacheHelper
  ↓
https://by3li.axeviadigital.com/api/
```

- ملفات `core/use_cases/` موجودة كعقود Clean Architecture لكنها **غير مستخدمة** في أي ميزة (كل Cubit يستدعي الـ Repository مباشرة).
- `main_importants.dart` barrel file بـ 33 export يُستخدم بكثافة (اقتران ضمني).
- `my_app.dart` فيه `MultiBlocProvider` بـ **21 Cubit** عامة + `ThemeProvider` + `ScreenUtilInit` + `ResponsiveBreakpoints`.
- `AppInitializer.init()` ينفّذ التهيئة بالترتيب: Firebase → Crashlytics → CacheHelper → فحص `firstRun` → تحميل التوكن → EasyLocalization → GetIt `setup()` → جلب device token → Bloc observer.
- `main.dart` يلفّ كل شيء بـ `runZonedGuarded` ويرسل الأخطاء إلى `FirebaseCrashlytics`.

---

## 5. حالة الميزات (Feature Completeness)

### 5.1 مكتملة وظيفيًا (منفّذة بالكود + تغطية اختبارات)

| الميزة | الوظيفة | اختبارات |
|---|---|---|
| splash | شاشة 4 ثوانٍ + توجيه حسب التوكن/الزائر | ✔ |
| onBoarding | 3 شرائح تعريفية | ✔ |
| login | دخول بالهاتف (أُصلح مؤخرًا: غير المفعّل يُوجَّه إلى OTP بدل التجمد) | 10 |
| register | تسجيل multipart + صورة | 12 |
| otp | تفعيل 6 خانات + resend ب مؤقت 60 ثانية | 8 |
| chooseLocation | محافظة/مركز + addLocation | 11 |
| home | بانرات + فئات + BestView + بحث | 23 |
| allCategories / allSubCategories / allSubCategoriesProducts | تصفح هرمي + فلترة محلية + كاش جلسة | 20+ |
| search | فلترة سيرفرية + Pagination حقيقي | 8 |
| seeAllBestView | عرض الكل + بحث محلي | 5 |
| productDetails | جاليري/تقييم/مقارنة/إيقاف إعلان/منتجات مرتبطة | 7 |
| compare | مقارنة منتجين (حد أقصى 2) + fallback | 9 |
| productSeller | صفحة البائع بـ 3 تبويبات | 13 |
| fav | مفضلة بنمط optimistic مع تراجع | 12 |
| advertisements | إعلاناتي + pause/resume/delete + فلاتر | 12 |
| addAdvertisements | نشر/تعديل إعلان + بوابة دفع (أكبر ميزة — 31 ملف) | ✔ |
| packages | باقات + طرق تحويل + checkout | 10 |
| PaymentBalance | شحن المحفظة + سجل الحركات + تحميل/مشاركة إيصال | 10 |
| notifications | قائمة + عداد + FCM integration + optimistic | 13 |
| chat | شات مشتري↔بائع بـ **Polling** (دقيقة/دقيقتان) + صور | chat_rules (30+) |
| reportProduct | شكوى عامة + تبليغ عن إعلان | 14 |
| legalContent | About/Terms/Privacy عبر flutter_html | 7 |
| howToMakePurchase | تعليمات شراء HTML من السيرفر | 7 |
| privacy | إعدادات وسيلة التواصل | 10 |
| changePassword | تغيير كلمة المرور | 6 |
| deleteAccount | حذف نهائي (أُصلح: يستدعي clearSession()) | 9 |
| updateProfile | تعديل الاسم/الإيميل/الهاتف/الصورة | 13 |
| changeLang | تبديل ar/en + إعادة جلب كل البيانات | 13 |
| layout | Scaffold الرئيسي بـ 5 تبويبات | ✔ |

### 5.2 ميزات جزئية / قديمة / غير مكتملة

| الميزة | الحالة |
|---|---|
| **helpSupportChat** | **ترقّيت مؤخرًا من محلي إلى API حقيقي** (`support/conversation`, `support/messages`, `support/read`) مع polling وصور — مكتملة كوديًا **لكن بدون اختبارات مخصصة** ⚠ |
| **helpSupport** | FAQ + بريد/هاتف محلي — قنوات **تجريبية** (`bi3lyapp@example.com`, `01110690299`) مع TODO صريح ⚠ |
| **addBalance** | أرقام تحويل **مهاردكود** (`+1234567890`, ...) وحساب InstaPay `123456789023` — **لا يوجد أي اتصال API**؛ التعليق يقول: "Replace with the real support channels before going live" ⚠ |
| **confirmPayment** | زر الإرسال `onPressed: () {}` **فارغ** — لا يوجد أي استدعاء شبكي، شاشة معطّلة فعليًا ⚠ |
| **core/use_cases/** | عقود Clean Architecture غير مستخدمة (دَين معماري) |
| **updateDeviceToken** | `updateDeviceToken = null` — موقوف بالتصميم بانتظار endpoint في السيرفر، قد تضيع الإشعارات بعد refresh |

> تحسنت حديثًا مقابل التوثيق القديم: حُذف الكود الميت (`search_filter_view.dart`, `profile_view_body_2.dart`, `payment_with_insta_pay_widget.dart`) ووُحِّد `LanguageCubit` المكرر.

---

## 6. نقاط القوة (Strengths)

1. معمارية Feature-first منضبطة (421 ملف ميزات) مع فصل `data/presentation`.
2. 37 ميزة تغطي **دورة كاملة**: تسجيل → تفعيل → تصفح → بحث/فلترة/pagination → تفاصيل/مقارنة → نشر إعلان → مدفوعات/محفظة → شات → إشعارات → إعدادات.
3. **358 اختبارًا** حقيقيًا (unit + widget) مع نماذج `fromJson` متسامحة مع تشويه استجابات السيرفر (status كـ `1/"1"/"true"`، ids كنصوص، `data` كـ List بدل Map، حقول بديلة).
4. أنماط حديثة: debounce، optimistic rollback، session cache، in-flight sharing.
5. تحسينات حديثة واضحة: إصلاح `isActive=false`، إصلاح `clearSession()`، ترقية شات الدعم إلى API، إضافة Crashlytics + معالجة أخطاء شاملة.
6. إعدادات Android حديثة: namespace/applicationId `com.zerobugs.by3ly`، minSdk 24، targetSdk 36، Java 17، desugaring.
7. لا توجد استيرادات مفقودة ولا أخطاء compile ظاهرة (المشروع بُني فعليًا، يوجد مجلد `build/`).

---

## 7. المشاكل والثغرات (Issues) — مرتبة بالأولوية

### 🔴 Critical (تمنع الإطلاق)

1. **نسخة `google-services.json` خاطئة في جذر المشروع** `E:\projects\by3ly\google-services.json`:
   - يخص مشروع **`by3ly-app`** / project_number `240519364569` / package `com.example.by3ly_app`.
   - بينما الملفات المستخدمة فعليًا بالبناء (`android/app/google-services.json` و `ios/Runner/GoogleService-Info.plist`) و`firebase_options.dart` تخص **`by3ly-ed414`** / `410177285744` / package `com.zerobugs.by3ly` ✔ (متطابقة).
   - **النسخة الموجودة في الجذر مضلِلة ومُتتبَعة في Git** ويجب حذفها أو تحديثها فورًا لتجنّب استخدامها بالخطأ في CI أو عند النسخ اليدوي.
2. **تسرّب البيانات في سجلات الإنتاج**: في `api_service.dart` (الأسطر 49-68) كل `debugPrint` للهيدرات (بما فيها `Authorization: Bearer <token>`) والـ body والـ response **غير مغلّفة بـ `kDebugMode`**. في Release ستظهر التوكن وبيانات المستخدمين في Logcat. (لاحظ أن `PrettyDioLogger` وحده مغلّف بـ `kDebugMode` بشكل صحيح.)
3. **مزامنة FCM token معطّلة**: `updateDeviceToken = null` في `end_points.dart` + `device_token_sync.dart`. الخادم يقبل device_token فقط أثناء login → الإشعارات قد تضيع بعد أن يحدّث FCM التوكن.

### 🟠 High

4. `ConfirmPaymentView` زره فارغ + `addBalance` أرقام تجريبية → مسار «شحن الرصيد اليدوي» غير قابل للاستخدام الحقيقي.
5. قنوات الدعم تجريبية (`bi3lyapp@example.com`) مع TODO صريح في `help_support_config.dart`.
6. **التوكن مخزّن أيضًا كنص عادي** في `SharedPreferences` (`AuthCubit` يقرأ من `StorageKeys.userToken`) إلى جانب `FlutterSecureStorage`.
7. `helpSupportChat` — أكبر ميزة مضافة حديثًا — **بدون اختبارات مخصصة**.

### 🟡 Medium

8. لا توجد اختبارات لـ `confirmPayment` / `layout` / تكامل `ApiService` interceptors / FCM. وخطة `TEST_SCENARIOS.md` (كل حالاتها `Not Run`) لم تُنفَّذ بعد.
9. لا يوجد CI/CD (لا `.github/` ولا workflows) — لا بوابة `flutter test` / `flutter analyze` تلقائية.
10. `analysis_options.yaml` يستخدم `flutter_lints` فقط مع كل القواعد المخصصة معلّقة → لا حماية lint من `print` (يوجد `print(error)` في `bloc_observer.dart`) أو النمط.
11. `pubspec.yaml` فيه `dependency_overrides: html: 0.15.6` (حل مؤقت لـ flutter_html) وبعض الحزم بدون إصدار ثابت (`get_it`, `file_picker`, `image_picker`, `firebase_messaging`, `flutter_html`, `flutter_secure_storage`) تعتمد على `pubspec.lock`.
12. `core/use_cases/` ميتة؛ Endpoints غير مستخدمة: `makePurchase`, `subscriptions`, `addCompare`, `searchProducts`.
13. Git status يُظهر تعديلات غير ملتزمة على `pubspec.lock` وملفات registrant لـ macOS/Windows (منصات غير مدعومة فعليًا بالـ Firebase).

---

## 8. تغطية الاختبارات (Test Coverage)

- 37 ملف اختبار، ~358 حالة، تغطي معظم الميزات (انظر الجدول في قسم 5.1).
- أنماط ملحوظة: `FakeRepo extends RepoImpl` مع حقن عبر GetIt و`unregister` في `tearDown`؛ اختبارات `fromJson`؛ اختبارات loading/success/error، debounce، optimistic rollback، session cache؛ widget tests تستخدم `EasyLocalization + CodegenLoader + ScreenUtilInit`.
- ملفات مميزة: `chat_rules_test.dart` (30+ حالة مستقلة عن UI)، `products_filter_test.dart`, `language_util_test.dart`, `compare_product_parse_test.dart`, `home_view_semantics_test.dart`.
- **الثغور:** لا اختبارات لـ `helpSupportChat`, `confirmPayment`, `layout`, ولا تكامل مع `ApiService`/interceptor أو FCM.
- `TEST_SCENARIOS.md` يحتوي خطة اختبار يدوي ضخمة (كل الحالات `Not Run`) لم تُنفَّذ.

---

## 9. ملخص التقييم الذاتي (للمقارنة مع تقييم النموذج)

> هذا تقدير أولي من مُعدّ التقرير — يرجى من النموذج التحقق منه أو تصحيحه.

**الحكم: «ناضج وظيفيًا تقريبًا، لكنه ليس جاهزًا للإنتاج» — جاهزية تقريبية 80–85%.**

- الوظائف الأساسية: ~90% (شبه مكتملة، عدا مسارات الدفع اليدوي والدعم التجريبية).
- الاختبارات الآلية: ~75% (كثيرة لكن مع ثغور في أهم ميزة جديدة).
- الأمان/الإعداد: ~65% (ثلاث نقاط Critical).
- الجاهزية للإطلاق: ~70%.

**التوصية:** إصلاح النقاط الحمراء الثلاث + استبدال أرقام/إيميل الدعم بقيم حقيقية + تشغيل `flutter test` كامل و`flutter analyze` كبوابة CI، ثم يمكن اعتباره جاهزًا للإنتاج على Android/iOS.

---

## 10. ملفات تستحق المراجعة النهائية (مسارات مطلقة)

- `E:\projects\by3ly\google-services.json` (الخاطئ — مشروع آخر)
- `E:\projects\by3ly\lib\core\app_services\remote_services\api_service.dart` (تسرّب debugPrint)
- `E:\projects\by3ly\lib\core\app_services\remote_services\end_points.dart` (updateDeviceToken)
- `E:\projects\by3ly\lib\my_app.dart` (الـ 21 Cubit)
- `E:\projects\by3ly\lib\features\confirmPayment\presentation\views\confirm_payment_widgets\confirm_payment_view_body.dart` (زر فارغ)
- `E:\projects\by3ly\lib\features\addBalance\presentation\view_model\add_balance_config.dart` (أرقام تجريبية)
- `E:\projects\by3ly\lib\features\helpSupport\presentation\view-model\help_support_config.dart` (إيميل تجريبي)

---

*نهاية التقرير — يرجى الإجابة على الأسئلة في القسم 1.*
