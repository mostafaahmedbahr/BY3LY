# BY3LY — تقرير المرحلة الأخيرة قبل الإطلاق

> تاريخ التقرير: 2026-11-17
> المرجع: `APP_STATUS_REPORT_FOR_REVIEW.md` + الكود الفعلي بعد التعديلات
> الإصدار: `1.0.0+1`
>
> **قاعدة الحكم:** لا يُعلن عن جاهزية الإطلاق إلا بأدلة. الأدلة المتوفرة هنا هي **تحليل ثابت + اختبارات آلية فقط**، ولم يُجرَ بناء إصدار موقّع ولا اختبار على أجهزة حقيقية ولا اختبار تكامل مع الباك إند الحقيقي.

---

## 1. ملخص تنفيذي

| البند | النتيجة |
|---|---|
| `flutter analyze` | ✅ **No issues found** (صفر errors / warnings / infos) |
| `flutter test` | ✅ **381/381 نجحت** (تكررت مرتين متتاليتين بنفس النتيجة) |
| CI/CD | ✅ أُضيف GitHub Actions (pub get + analyze + test) |
| تخزين التوكن | ✅ النسخة غير المشفرة أُزيلت + جسر هجرة للجلسات القديمة |
| الدفع اليدوي القديم | ✅ وُجّه للبديل المُتحقق منه على السيرفر؛ لا أرقام تجريبية ظاهرة |
| مزامنة FCM | ⚠️ **موقوفة لحين تزويد الباك إند بعقد الـ endpoint** (لم يُفترض اسم) |
| شات الدعم | ✅ 18 اختبارًا متكاملًا جديدًا |
| Logs | ✅ كل الطباعات محصورة بـ `kDebugMode`؛ صفر طباعة في Release |
| **الحكم النهائي** | ⚠️ **ليس جاهزًا للإطلاق بعد** — انظر القسم 6 |

---

## 2. المشاكل التي تم إصلاحها (بالترتيب)

### 2.1 تخزين التوكن غير الآمن

**المشكلة:** التوكن كان يُخزَّن مرتين: `FlutterSecureStorage` (المصدر الحقيقي) ونسخة نصية في `SharedPreferences` عبر `StorageKeys.userToken`.

**ما اتعمل:**
- `core/shared_cubits/auth_cubit/auth_cubit.dart`: `checkAuthStatus()` يقرأ الآن من `CacheTokenManger.userToken` (المدعوم بـ secure storage) بدل prefs. أُصلح أيضًا خلل `userToken = userToken;` (self-assignment). أُزيلت كل عمليات prefs، و`logout()` أصبح يمسح التوكن الآمن فعليًا.
- `features/otp/.../otp_cubit.dart`: حُذفت كتابة النسخة غير المشفرة بعد OTP.
- `features/profile/.../profile_cubit.dart`: حُذفت إزالة نسخة prefs من `_clearSession()`.
- **جسر هجرة جديد** `core/utils/token_migration.dart` + استدعاؤه في `AppInitializer` قبل تنظيف `firstRun`: يقرأ أي توكن قديم من prefs، ينقله إلى secure storage **فقط إذا كان الـ secure فارغًا**، ثم يمسح النسخة القديمة. بهذا لا تُفقد جلسات المستخدمين القدامى.
- `CacheHelper.clearUserData()` أصبح يمسح مفتاح `userToken` القديم دائمًا كتنظيف وقائي.
- `StorageKeys.userToken` بقي معرَّفًا **للهجرة فقط** مع تعليق يوضح ذلك.

**الدليل:** ملف اختبار جديد `test/features/auth/token_storage_test.dart` (5 حالات: الهجرة، عدم الكتابة فوق توكن آمن، قراءة AuthCubit من المصدر الآمن، عدم كتابة نسخة prefs، تنظيف `clearUserData`). اختبارات `auth + login + otp + profile`: **39/39 نجحت**.

---

### 2.2 confirmPayment / addBalance

**تحديد المسارات (من الفحص):**
- **نشطة فعليًا:** `PaymentAndBalanceView` → `TransferView(topUpMode: true)` → `POST wallet/top-up` (إيصال + تحقق السيرفر) — تُفتح من البروفايل.
- **ميتة/مهجورة:** `AddBalanceView` لا يُستدعى من أي route أو واجهة؛ السلسلة القديمة `AddBalanceViewBody` → `ConfirmPaymentView` كانت تعرض أرقامًا وهمية وتنتهي بزر إرسال فارغ `onPressed: () {}`.

**ما اتعمل (بدون حذف وظيفة مستخدمة):**
- `AddBalanceView` و`ConfirmPaymentView` أصبحا يعرضان `PaymentAndBalanceView` مباشرة — أي دخول قديم يصل إلى المسار الحقيقي المُتحقق منه.
- `AddBalanceViewBody` لم يعد يعرض أرقامًا؛ يعرضرسالة توجيه + زر «فتح شحن الرصيد».
- `AddBalanceConfig`: الأرقام الثلاثة الوهمية وحساب الإنستا بي الوهمي أُزيلت. رقم الدعم الحقيقي `+201110690299` هو المصدر الوحيد، والحساب فارغ افتراضيًا وقابل للضبط عبر `BI3LY_INSTAPAY_ACCOUNT` (لا يظهر للمستخدم).
- **منع النجاح الكاذب:** `WalletCubit.topUp` و`PackagesCubit.checkoutWithWallet/checkoutWithTransfer` أصبحت تعتبر `status: false` في رد 2xx خطأً برسالة مترجمة (`topUpRejected` / `subscriptionRejected`) بدل إصدار state نجاح.
-بقيت Endpoints كما هي؛ **لم يُخترع أي API**.

**الدليل:** اختبارات `addBalance + PaymentBalance + packages`: **28/28 نجحت**، من ضمنها اختبار يؤكد أن الأرقام الوهمية غير موجودة وأن زر التوجيه يفتح شاشة المحفظة الحقيقية.

---

### 2.3 DeviceTokenSync — عقد الباك إند

**المشكلة:** كان الكود يفترض اسم endpoint (`updateDeviceToken`) من تعليق قديم، رغم عدم وجود أي عقد منشور للباك إند.

**ما اتعمل:**
- فحص شامل لكل الوثائق والكود: **العقد الوحيد المؤكد** هو أن `login` و`verifyCode` يستقبلان `device_token`. لا يوجد أي endpoint موثّق لتحديثه.
- أُزيل الافتراض: `EndPoints.updateDeviceToken` الآن `String.fromEnvironment('FCM_UPDATE_ENDPOINT')` **بدون defaultValue** → فارغ إلا إذا زُوّد صراحةً وقت البناء.
- `DeviceTokenSync.isConfigured` يمنع أي طلب عندما لا يكون الـ endpoint مضبوطًا، مع تحذير واضح في Debug. منطق فحص `status` وإعادة المحاولة بقي كما هو عند الضبط.

**الدليل:** اختبار `test/features/notifications/device_token_sync_test.dart` يؤكد أنه **لا يُفترض أي endpoint** وأن الـ contracts المؤكدة فقط هي login/verifyCode (حالتان نجحتا).

> ⚠️ هذا يعني أن مزامنة التوكن **معطّلة حاليًا عن قصد** إلى أن يزوّد الباك إند بالمسار الصحيح. الإشعارات تعمل عند login/OTP فقط في الوضع الحالي.

---

### 2.4 اختبارات helpSupportChat المتكاملة

ملف جديد: `test/features/helpSupportChat/support_chat_test.dart` — **18 اختبارًا** تغطي:
- **الرسائل:** init، تحميل المحادثة، فشل المحادثة لا يمنع الرسائل، إرسال نصي + debounce عند الضغط المزدوج، حالة الفشل.
- **الصور:** رفع ملف jpg حقيقي، رفض الامتداد غير المسموح، رفض الملف المفقود، فشل الإرسال.
- **القراءة:** `markRead` يحدّث العدّاد ويعلّم الرسائل مقروءة،CLUDING عند وصول رد جديد عبر الـ polling.
- **الأخطاء وإعادة المحاولة:** خطأ تحميل + retry، خطأ تحميل الأرشيف، و**اختبار widget** يتحقق أن شاشة الخطأ تعيد الطلب عند اللمس.
- **القواعد والنماذج:** التحقق من الامتداد/الحجم، الترتيب، إزالة التكرار، تعليم الكل كمقروء، وتسامح الـ `fromJson` مع تشويه الاستجابة.
- **SupportUnreadCubit:** النجاح، الفشل الصامت، قص العدّاد السالب، وضع الزائر بدون طلبات.

**الدليل:** `flutter test test/features/helpSupportChat` → **18/18 نجحت**.

---

### 2.5 إصلاح الاختبارات الثلاثة الفاشلة

| الاختبار | السبب | الإصلاح |
|---|---|---|
| `helpSupport … renders contact tiles` | اختبار لا يوفّر `SupportUnreadCubit` المطلوب من الشجرة | أُضيف stub repository + `BlocProvider<SupportUnreadCubit>` في `_testApp()` |
| `helpSupport … FAQ expands on tap` | قسم FAQ معلّق في التصميم الحالي (اختبار قديم) | يُختبر `CommonQuestionsWidget` بمفرده — **بدون تغيير تصميم الواجهة** |
| `changePassword … clearUserData` | قناة secure storage غير مُخمّدة + fire-and-forget futures + `LayoutCubit.pageIndex` ثابت |.mock للقناة، تصفير statics في `setUp`/`tearDown`، و transient flush قبل الـ assertions |

**منع الاعتماد على الترتيب:** كل اختبار يعيد تعيين `CacheTokenManger.userToken` و`LayoutCubit.pageIndex`، ويعيد ضبط `SharedPreferences` mock قبل `CacheHelper.init()`، ويلغي تسجيل GetIt في `tearDown`.

**الدليل:** `flutter test` كامل → **381/381** مرتين متتاليتين (كان 355 نجح / 3 فشل).

---

### 2.6 CI/CD

أُضيف `.github/workflows/flutter.yml`:
- `actions/checkout@v4` + `subosito/flutter-action@v2` مع تثبيت **Flutter 3.47.1** (المطابق محليًا, Dart 3.13.1 يلبي `^3.12.1`) وتفعيل الكاش.
- الخطوات: `flutter pub get` → `flutter analyze` → `flutter test`.

**الدليل:** كل خطوة نُفّذت محليًا بنجاح: `pub get` (Got dependencies)، `analyze` (No issues)، `test` (381/381).

---

### 2.7 المراجعة النهائية للأمان والـ Logs

- وُجد **تسريب فعلي**: `layout_view.dart` كان يطبع `CacheTokenManger.userToken` بـ `debugPrint` غير محصور → **أُزيل السطر**.
- تحويل **52 ملفًا** من `debugPrint(...)` إلى دوال `logWarning/logError/logSuccess` المحصورة بـ `if (kDebugMode)` في `core/extensions/log.dart` → **صفر طباعة في Release**. لم يبقَ `debugPrint`Outside الملف المحصور.
- حُذفت نسخ Dart قديمة تحت `android/app/src/main/res/profile/` كانت تطبع التوكن (غير مُترجمة وغير مستخدمة).
- `google-services.json` الخاطئ في جذر المشروع (مشروع `by3ly-app`) كان محذوفًا مسبقًا؛ الملفات الصحيحة (`by3ly-ed414` / `com.zerobugs.by3ly`) موجودة ومتطابقة مع `firebase.json` و`firebase_options.dart`.
- مسح شامل: **لا أرقام ولا حسابات تحويل تجريبية في `lib/`**، ولا كتابة توكن في prefs (إلا للتنظيف/الهجرة).
- لتحقيق صفر issues في `flutter analyze` طُبّق `dart format` على المشروع و`dart fix --apply` لإصلاح lints قديمة (بلا تغيير سلوك أو معمارية).

---

## 3. الأدلة المجمّعة (Evidence)

| الفحص | النتيجة |
|---|---|
| `flutter analyze` | No issues found (0 errors, 0 warnings, 0 infos) |
| `flutter test` (كامل، مرتين) | 381/381 pass |
| `flutter pub get` | Got dependencies |
| اختبارات التوكن | 39/39 pass |
| اختبارات الدفع | 28/28 pass |
| اختبارات شات الدعم | 18/18 pass |
| اختبارات helpSupport + changePassword | 13/13 pass |
| GitHub Actions | ملف مُضاف بثلاث خطوات مُتحقَّق منها محليًا |

---

## 4. مشاكل ما زالت تحتاج تدخل Backend

| # | المشكلة | الأثر | المطلوب |
|---|---|---|---|
| 1 | **لا يوجد endpoint موثّق لتحديث FCM token** | مزامنة الدوران معطّلة؛ إشعارات قد تضيع بعد تحديث توكن الجهاز | تزويد المسار الصحيح + عقد الطلب/الرد، ثم تمريره بـ `--dart-define=FCM_UPDATE_ENDPOINT=...` |
| 2 | **طرق التحويل/الحسابات تأتي من `GET payment-methods`** | أزلنا الأرقام التجريبية من العميل؛ correctness تعتمد على بيانات السيرفر | التأكد أن السيرفر يعيد أرقام/حسابات صحيحة ومحدّثة لكل طريقة تحويل |
| 3 | **اتساق حقل `status` في ردود 2xx** | العميل يتعامل مع `status:false` كخطأ الآن، لكن السيرفر قد يرجع أشكالًا مختلفة | توحيد شكل الرد (`status` bool) لـ `wallet/top-up` و`subscriptions/checkout` |
| 4 | **قناة الدعم** | الإيميل/الهاتف ضُبطا حسب توجيهك (`by3ly3app@gmail.com` / `01110690299`) | تأكيد أن رقم الهاتف هو الأساسي للإنتاج |

---

## 5. القيود الإثباتية (ما لم يتحقق)

- ❌ لا يوجد **بناء Release موقّع** لـ Android (AAB/APK) أو iOS (IPA).
- ❌ لم تُجرَ **تجربة على أجهزة حقيقية** (Android/iOS) للإشعارات، الكاميرا/المعرض، الدفع، والشات.
- ❌ لم يُجرَ **اختبار تكامل مع الباك إند الحقيقي**؛ كل الاختبارات تستخدم fake repositories.
- ❌ لا توجد مقاييس أداء أو اختبار حمل أو فحص أمني خارجي (penetration testing).
- ❌ لا توجد حسابات مستخدمين حقيقية لاختبارEnd-to-end.

---

## 6. الحكم النهائي على جاهزية Android و iOS

| المنصة | الحكم |
|---|---|
| **Android** | ⚠️ **جاهز تقنيًا على مستوى الكود والاختبارات الآلية — غير معتمد للإطلاق** |
| **iOS** | ⚠️ **جاهز تقنيًا على مستوى الكود والاختبارات الآلية — غير معتمد للإطلاق** |

**التبرير:** بوابات الجودة التي يمكن التحقق منها آليًا أصبحت خضراء (analyze نظيف + 381 اختبار + CI). لكن **أدلة الإطلاق غير مكتملة**: عقد FCM مع الباك إند غير متوفر، ولا يوجد بناء موقّع ولا اختبار أجهزة ولا تكامل حقيقي مع السيرفر. لذلك لا أُعلن جاهزية الإطلاق.

**الخطوات المتبقية قبل الاعتماد (بعد تدخل الباك إند):**
1. تزويد `FCM_UPDATE_ENDPOINT` وإعادة تفعيل/اختبار مزامنة التوكن على جهاز حقيقي (إشعار بعد refresh).
2. التحقق من `GET payment-methods` وردود `wallet/top-up` / `subscriptions/checkout` مع حسابات اختبار حقيقية.
3. بناء Release موقّع + TestFlight/Internal Testing + اختبار يدوي حسب `TEST_SCENARIOS.md`.
4. تشغيل `flutter analyze` و`flutter test` في CI على كل PR قبل دمج أي تغيير.

---

*نهاية التقرير — جميع الأرقام مبنية على تنفيذ فعلي في هذه الجلسة.*
