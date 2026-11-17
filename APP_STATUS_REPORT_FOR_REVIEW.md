# تقرير حالة تطبيق BY3LY (بيعلي) — بعد الإصلاحات — للمراجعة والتقييم

> **ملف مُعدّ خصيصًا لإعطائه لـ ChatGPT / نموذج ذكاء اصطناعي** ليقيّم نسبة اكتمال التطبيق ويحدد هل هو جاهز للإنتاج (production-ready) أم لا.
>
> **المطلوب من النموذج في نهاية التقرير:** (1) تقدير نسبة الاكتمال، (2) حكم الجاهزية للإطلاق، (3) ترتيب المهام المتبقية حسب الأولوية.
>
> **ملاحظة منهجية:** التقرير مبني على **قراءة الكود الفعلي** + نتائج `flutter analyze` / `flutter test` بعد التعديلات. المصطلحات وأسماء الملفات والـ APIs بقيت بالإنجليزية كما هي في الكود.
>
> تاريخ التقرير: 2026-11-17 (تحديث بعد جولة إصلاحات) — إصدار التطبيق: `1.0.0+1`.

---

## 1. طلب التقييم (اقرأ هذا أولًا)

يرجى من النموذج الإجابة على الأسئلة التالية:

1. **ما نسبة اكتمال التطبيق التقريبية الآن؟** (رقم مع تبرير، وتقسيم: الوظائف / الاختبارات / الأمان / الجاهزية للإطلاق).
2. **هل التطبيق جاهز للإنتاج على Android و iOS؟** نعم / لا / مشروط، مع التبرير.
3. **ما أهم 5 مهام متبقية قبل الإطلاق** مرتبة بالأولوية؟
4. **هل توجد تناقضات أو نقاط تستحق التحقق** في التقرير؟

---

## 2. نظرة عامة

| البند | القيمة |
|---|---|
| اسم التطبيق | BY3LY (بيعلي) — سوق إعلانات مبوبة مصري |
| الإطار | Flutter (Dart SDK `^3.12.1`)، Material 3 |
| المنصات الفعلية | Android / iOS فقط (web/desktop يرمون `UnsupportedError` من Firebase) |
| الـ Backend | `https://by3li.axeviadigital.com/api/` |
| اللغة | العربية (RTL) افتراضيًا + دعم كامل للإنجليزية |
| المصادقة | هاتف مصري + كلمة مرور + OTP عبر البريد |
| إدارة الحالة | `flutter_bloc` (Cubit) + `get_it` |
| التخزين | `FlutterSecureStorage` + `SharedPreferences` + لا توجد قاعدة بيانات محلية |
| التكامل | FCM + Crashlytics + flutter_local_notifications |

---

## 3. أرقام إحصائية (بعد التعديلات)

| الطبقة | العدد |
|---|---|
| ملفات Dart في `lib/` | **488** |
| ملفات `features/` (37 ميزة) | **421** |
| ملفات `core/` | **59** |
| ملفات `lang/` | **4** |
| ملفات `test/` | **37** (~358 حالة) |
| Cubits | ~35 |
| Endpoints | ~53 |
| Singleton في GetIt | 31 |

> ملفات `APP_DOCUMENTATION.md` و`TEST_SCENARIOS.md` الموجودة أقدم من الكود (تقول «445 ملفًا» و«لا يوجد test»). تجاهل أرقامها.

---

## 4. المعمارية

Feature-first + طبقات `data/presentation` (بدون طبقة Domain فعّالة):

```
UI (views) → Cubit → Repository → ApiService (Dio) → REST API
                  ↘ GetIt DI
```

- `main.dart`: `runZonedGuarded` + Crashlytics + FCM background handler + EasyLocalization.
- `AppInitializer.init()`: Firebase → Crashlytics → CacheHelper → firstRun → تحميل التوكن → EasyLocalization → GetIt → device token → Bloc observer.
- `my_app.dart`: `MultiBlocProvider` بـ 21 Cubit + ThemeProvider + ScreenUtil + ResponsiveBreakpoints.
- `core/use_cases/` موجودة لكن غير مستخدمة (دَين معماري).

---

## 5. الإصلاحات اللي اتعملت في جولة المراجعة دي ✅

| # | المشكلة | الحل | الملفات |
|---|---|---|---|
| 1 | تسريب التوكن والبيانات في الـ Logs | كل الطباعات بقت عبر `logError/logSuccess/logWarning` (المغلّفة بـ `kDebugMode`) → **طباعة كاملة في Debug، صفر في Release**. `PrettyDioLogger` جوّه `kDebugMode`. شيلت أي تقنيع كان مُضاف. | `core/app_services/remote_services/api_service.dart`, `core/extensions/log.dart` |
| 2 | `updateDeviceToken = null` → الإشعارات تتوقف | Endpoint حقيقي (قابل للإعداد بـ `--dart-define=FCM_UPDATE_ENDPOINT=...`) + `DeviceTokenSync` يعمل POST عند التشغيل وعند `onTokenRefresh` وبعد login/OTP، مع فحص `status:false` وإعادة محاولة ومنع تكرار الطلبات وحفظ آخر توكن متزامن. | `end_points.dart`, `device_token_sync.dart`, `storage_keys.dart`, `login_cubit.dart`, `otp_cubit.dart` |
| 3 | `google-services.json` خاطئ في جذر المشروع | **حُذف** بعد التحقق إن `firebase.json` بيكتب لـ `android/app/` و`ios/Runner/` بس، ومفيش CI بيشير للجذر. الملفات الصحيحة (`by3ly-ed414` / `com.zerobugs.by3ly`) لسه موجودة. | حذف `google-services.json` |
| 4 | قنوات دعم تجريبية | الإيميل بقى `by3ly3app@gmail.com`، ورقم الهاتف الأساسي `01110690299` / `+201110690299` زي ما هو، مع شيل TODO. | `help_support_config.dart` |
| 5 | رفع إيصال التحويل من المعرض فقط + صمت عند عدم الرفع | أُضيفت ورقة مشتركة `core/shared_widgets/image_source_sheet.dart` (كاميرا/معرض) مُستخدم في شحن المحفظة والاشتراك ونشر الإعلان والشات. زر التأكيد بقى يظهر Toast منظّم: «من فضلك ارفع صورة التحويل أولًا» / «من فضلك اختر طريقة التحويل أولًا» (عربي + إنجليزي). | `image_source_sheet.dart`, `packages_cubit.dart`, `transfer_view.dart`, `transfer_form.dart`, `ad_payment_sheet.dart`, `lang/*` |
| 6 | شاشة «كيف تتم عملية الشراء/البيع» تعتمد على السيرفر فقط | أُضيف محتوى ثابت ثنائي اللغة (شراء / بيع / تنبيه أمان + بيانات الدعم) مبني على مسارات الكود الفعلية، مع عرض HTML السيرفر كإضافة لو موجود. | `how_to_make_purchase_view_body.dart`, `purchase_instructions_card.dart`, `lang/*` |

---

## 6. حالة الميزات بعد الإصلاح

**مكتملة:** splash, onBoarding, login, register, otp, chooseLocation, home, allCategories, allSubCategories, allSubCategoriesProducts, search, seeAllBestView, productDetails, compare, productSeller, fav, advertisements, addAdvertisements, packages, PaymentBalance, notifications, chat, helpSupportChat, reportProduct, helpSupport, legalContent, howToMakePurchase, privacy, changePassword, deleteAccount, updateProfile, changeLang, layout.

**جزئية/قديمة متبقية:**
- `addBalance`: أرقام تحويل وهمية (`+1234567890`...) + حساب إنستا بي وهمي، مسار قديم معطّل.
- `confirmPayment`: زر الإرسال `onPressed: () {}` فارغ، لا يوجد استدعاء شبكي.
- `core/use_cases/`: عقود غير مستخدمة.
- Endpoints غير مستخدمة: `makePurchase`, `subscriptions`, `addCompare`, `searchProducts`.

---

## 7. المشاكل المتبقية (مرتبة بالأولوية)

### 🟠 High
1. `confirmPayment` زره فارغ + `addBalance` أرقام/حساب وهمية → مسار «شحن الرصيد اليدوي» غير قابل للاستخدام الحقيقي.
2. التوكن مخزّن أيضًا كنص عادي في `SharedPreferences` (`AuthCubit` يقرأ من `StorageKeys.userToken`) بجانب `FlutterSecureStorage`.
3. `helpSupportChat` — أكبر ميزة مضافة حديثًا — بدون اختبارات مخصصة.

### 🟡 Medium
4. اسم endpoint المزامنة (`updateDeviceToken`) مُفترض من تعليق الكود؛ **يحتاج تأكيد من الباك إند** أو تمريره بـ `--dart-define`.
5. لا يوجد CI/CD (لا `.github/`) → لا بوابة `flutter test` / `flutter analyze` تلقائية.
6. `analysis_options.yaml` متساهل (45 info/warning قديمة مثل `print` في `bloc_observer.dart` و`withOpacity`).
7. نتائج الاختبارات الكاملة: فشلان معروفان في `helpSupport` (`ProviderNotFoundException: SupportUnreadCubit` في الـ test setup) + فشل متقطع في `change_password_cubit_test` ينجح عند تشغيله منفردًا (حالة static متغيرة).
8. `pubspec.yaml` فيه `dependency_overrides: html: 0.15.6` وبعض الحزم بدون إصدار ثابت.
9. لا قاعدة بيانات محلية (كل شيء عبر API).

---

## 8. نتائج التحقق بعد التعديلات

| الفحص | النتيجة |
|---|---|
| `flutter analyze` (ملفات معدّلة) | **No issues found** ✅ |
| `flutter analyze` (كامل المشروع) | 45 info/warning قديمة، **صفر errors** |
| `flutter test test/features/howToMakePurchase` | **7/7 نجحوا** ✅ |
| `flutter test test/features/login test/features/otp` | **18/18 نجحوا** ✅ |
| `flutter test test/features/packages test/features/chat test/features/addBalance` | **50/50 نجحوا** ✅ |
| `flutter test test/features/helpSupport --plain-name HelpSupportConfig` | **4/4 نجحوا** ✅ |
| `flutter test` (كامل) | 355 نجح / 3 فشل (2 معروفين + 1 متقطع ينجح منفردًا) |

---

## 9. التقييم الذاتي (للمقارنة مع تقييم النموذج)

> تقدير مُعدّ التقرير بعد الإصلاحات — يرجى التحقق منه.

**الحكم: «ناضج وظيفيًا، ونقاط الإطلاق الحرجة اتعالجت — جاهز مشروطيًا بعد تأكيد endpoint الـ FCM وتنظيف مسار الدفع اليدوي».**

- الوظائف الأساسية: ~93%
- الاختبارات الآلية: ~78% (كثيرة لكن مع ثغور و3 حالات فاشلة/متقطعة)
- الأمان/الإعداد: ~88% (بعد إصلاح اللوجات والـ Firebase config)
- الجاهزية للإطلاق: ~88–90%

**التوصية:** تأكيد اسم `FCM_UPDATE_ENDPOINT` مع الباك إند + استبدال أرقام/حساب `addBalance` أو إزالة المسار + تعطيل `confirmPayment` أو إكماله + إضافة بوابة CI تشغّل `flutter test` و`flutter analyze` + إصلاح اختبارات `helpSupport` (توفير `SupportUnreadCubit`).

---

## 10. الملفات الأكثر أهمية للمراجعة النهائية

- `E:\projects\by3ly\lib\core\app_services\remote_services\api_service.dart`
- `E:\projects\by3ly\lib\core\notifications\device_token_sync.dart`
- `E:\projects\by3ly\lib\core\app_services\remote_services\end_points.dart`
- `E:\projects\by3ly\lib\core\shared_widgets\image_source_sheet.dart`
- `E:\projects\by3ly\lib\features\howToMakePurchase\presentation\views\how_to_make_purchase_widgets\how_to_make_purchase_view_body.dart`
- `E:\projects\by3ly\lib\features\addBalance\presentation\view_model\add_balance_config.dart`
- `E:\projects\by3ly\lib\features\confirmPayment\presentation\views\confirm_payment_widgets\confirm_payment_view_body.dart`

---

*نهاية التقرير — يرجى الإجابة على الأسئلة في القسم 1.*
