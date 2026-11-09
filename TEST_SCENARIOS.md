# بيعلي (BY3LY) — وثيقة اختبارات القبول اليدوي (TEST_SCENARIOS.md)

> **TEST_SCENARIOS.md** — خطة اختبار يدوي شاملة مبنية على قراءة الكود الفعلي للتطبيق (`lib/` — 445 ملف Dart) وعلى `APP_DOCUMENTATION.md`.
> كل حالة اختبار تعكس سلوكًا موجودًا فعليًا في الكود. أي نقطة لا يمكن تنفيذها يدويًا بالكامل مُعلّمة بـ **(Needs Dev Support)**.
> المصطلحات التقنية وأسماء الشاشات والـ API بقيت بالإنجليزية كما في الكود.
>
> تاريخ الإعداد: 2026-11-09 — إصدار التطبيق تحت الاختبار: `1.0.0+1`.
> **جميع الحالات الحالة الافتراضية لها: `Status: Not Run` — لم يُنفذ أي اختبار بعد.**

---

## جدول المحتويات

1. [نظرة عامة على الاختبار](#1-نظرة-عامة-على-الاختبار)
2. [تعليمات تنفيذ الاختبار](#2-تعليمات-تنفيذ-الاختبار)
3. [سيناريوهات الاختبار (حسب Feature)](#3-سيناريوهات-الاختبار-حسب-feature)
4. [اختبارات المصادقة (Authentication)](#4-اختبارات-المصادقة-authentication)
5. [اختبارات الواجهة والتنقل (UI & Navigation)](#5-اختبارات-الواجهة-والتنقل-ui--navigation)
6. [اختبارات الوظائف (Functional)](#6-اختبارات-الوظائف-functional)
7. [اختبارات التحقق من المدخلات (Input Validation)](#7-اختبارات-التحقق-من-المدخلات-input-validation)
8. [اختبارات الـ API والتكامل (API & Integration)](#8-اختبارات-الـ-api-والتكامل-api--integration)
9. [اختبارات قاعدة البيانات والتخزين المحلي](#9-اختبارات-قاعدة-البيانات-والتخزين-المحلي)
10. [اختبارات الأمان (Security)](#10-اختبارات-الأمان-security)
11. [اختبارات معالجة الأخطاء (Error Handling)](#11-اختبارات-معالجة-الأخطاء-error-handling)
12. [اختبارات المسارات الكاملة (End-to-End)](#12-اختبارات-المسارات-الكاملة-end-to-end)
13. [قائمة اختبارات الانحدار (Regression Checklist)](#13-قائمة-اختبارات-الانحدار-regression-checklist)
14. [التقرير النهائي للاختبار (Final Testing Report)](#14-التقرير-النهائي-للاختبار-final-testing-report)

---

# 1. نظرة عامة على الاختبار

## 1.1 نظرة على التطبيق تحت الاختبار

| البند | القيمة |
|---|---|
| اسم التطبيق | BY3LY (بيعلي) — Android / iOS |
| نوعه | سوق إعلانات مبوبة مصري (Flutter + REST API) |
| الـ Backend | `https://by3li.axeviadigital.com/api/` |
| اللغة الافتراضية | العربية (RTL) مع دعم كامل للإنجليزية (LTR) |
| وضع الزائر | مدعوم (Guest Mode) — تصفح بدون حساب |
| المصادقة | هاتف مصري + كلمة مرور + OTP عبر **البريد الإلكتروني** |
| التوكن | Bearer Token — يُخزن في `FlutterSecureStorage` (وبنسخة في `SharedPreferences`) |
| إدارة الحالة | `flutter_bloc` (Cubit) + `get_it` للحقن |
| تكامل خارجي | Firebase Cloud Messaging (إشعارات) |
| الدفع | باقات اشتراك + محفظة داخلية + تحويلات (Vodafone/Orange/Etisalat Cash, InstaPay, Bank, Fawry) مع رفع إيصال |

## 1.2 أهداف الاختبار

1. التحقق من أن كل feature موجود في الكود يعمل كما هو متوقع (Positive + Negative).
2. التحقق من حدود ومدخلات النماذج (Validation).
3. التحقق من تكامل التطبيق مع الـ API والـ FCM والسلوك عند انقطاع الاتصال والسيرفر المعطل.
4. التحقق من صلاحيات الأدوار: Guest / مستخدم مسجل / مالك الإعلان / مشترك بباقة.
5. كشف العيوب الحرجة قبل الإطلاق: تدفقات الدفع، النشر، التوكن، الحذف.
6. بناء Regression Checklist لإعادة الاستخدام بعد كل تعديل.

## 1.3 نطاق الاختبار

**ضمن النطاق (In Scope):** كل ما هو منفذ في الكود فعليًا — الشاشات، الـ forms، الـ validators، الـ APIs، الدفع، الشات، الإشعارات، وضع الزائر، الثيم، اللغتان، المشاركة والتحميل.
**خارج النطاق (Out of Scope):**
- أداء السيرفر الداخلي وضبط قاعدة البيانات الخلفية (لا وصول له من هذا الريبو).
- اختبارات الحمل (Load/Stress) وPenetration testing المتعمق.
- ميزات غير موجودة (Admin panel، forget-password UI، WebSocket chat) — غير قابلة للاختبار لأنها غير منفذة.
- الشاشات القديمة (Legacy) ما لم تُستدعَ من مسار نشط: `addBalance`, `confirmPayment`, `search_filter_view` — موثقة فقط في قسم ملاحظات إن وُجدت.

## 1.4 بيئة الاختبار المطلوبة

| العنصر | المواصفات |
|---|---|
| جهاز Android | إصدار Android 8+ (minSdk 24)؛ شاشة 1080×2400 أو قريب |
| جهاز iOS | iPhone بإصدار iOS متوافق (التطبيق على App Store/ TestFlight) |
| Flutter | SDK يدعم Dart `^3.12.1` — لبناء التطبيق |
| اتصال الإنترنت | WiFi/4G — مع إمكانية قطعه للحالات السلبية |
| أدوات مساعدة | `adb logcat` (أو Xcode Console) لفحص السجلات، Charles/Proxy اختياري لـ (Needs Dev Support) |
| Firebase | مشروع `by3ly-ed414` — يجب أن يكون FCM مفعّلًا لاختبارات الإشعارات |
| الخادم | بيئة staging أو production حسب المتاح — يُفضّل بيئة تجريبية |

## 1.5 الحسابات المطلوبة

| الحساب/الدور | الاستخدام | ملاحظة |
|---|---|---|
| **Guest (بدون تسجيل)** | تصفح الزائر وقيود الأذونات | لا يتطلب إعدادًا — زر "Continue as guest" |
| **مستخدم عادي مفعل A** | معظم سيناريوهات الاختبار | حساب اختبار مع بريد يمكن الوصول إليه لاستقبال OTP |
| **مستخدم B (طرف ثانٍ)** | اختبار الشات والتقارير والتواصل بين بائعين | حساب ثانٍ مفضل |
| **حساب بائع بباقة نشطة** | نشر إعلان بدون رسوم | شراء باقة اختبار أو إنشاء عبر مدير النظام |
| **حساب بائع بدون باقة** | مسار دفع رسوم النشر | الحساب الافتراضي (لا اشتراك) |
| **حساب برصيد محفظة** | الدفع عبر المحفظة + دخول insufficient balance | شحن عبر تحويل ثم قبول من الإدارة، أو رصيد مُعَد مسبقًا |

> ملاحظة: لا توجد حسابات Admin داخل التطبيق. الأدوار الإدارية تتم من لوحة تحكم خارجية — غير قابلة للاختبار من التطبيق.

## 1.6 تجهيز بيانات الاختبار (Test Data)

| البيان | قيمة مقترحة |
|---|---|
| رقم هاتف صالح | `01012345678` (مصري `^01[0-9]{9}$`) |
| رقم هاتف غير صالح | `0101234567` (قصير)، `+201012345678`، `11012345678` |
| بريد اختبار | حساب قابل للوصول (Gmail/Outlook) |
| كلمة مرور قوية | `Test1234!` (كبيرة+صغيرة+رقم+رمز، 8–30) |
| كلمة مرور ضعيفة | `test` / `testtest` / `TEST1234` / `Testpass` |
| اسم منتج للاختبار | `QA Product - اختبار آلي` |
| سعر صالح | `15000` / سعر مع خصم `20000` – خصم `10%` |
| عمر صالح | `25` (حدود: 18 و100) |
| رابط صورة صالح | `https://...` (يُرفق من الجهاز) |
| صورة كبيرة | > 5MB لاختبار حدود الشات/الرفع |
| ملفات إيصال | JPG/PNG حقيقية للتحويل البنكي |

## 1.7 دليل أولويات الحالات

| الأولوية | المعنى |
|---|---|
| **Critical** | يمنع الإطلاق — أمان/مال/بيانات/مصادقة |
| **High** | مسار رئيسي يفشل |
| **Medium** | سلوك ثانوي/رسائل |
| **Low** | تجميلي/هامشي |

## 1.8 طريقة كتابة النتائج

- **Actual Results**: اترك فارغًا أثناء التنفيذ، املأه بما حدث فعليًا.
- **Status**: ابدأ دائمًا بـ `Not Run`؛ عدّلها إلى `Pass / Fail / Blocked` بعد التنفيذ.
- **Notes**: أي تفاصيل إضافية (رقم الإصدار، الجهاز، رقم الـ build، روابط السجلات).
- استخدم صناديق `- [ ]` في قسم 13 للتتبّع السريع.

---

# 2. تعليمات تنفيذ الاختبار

## 2.1 التجهيز

1. تأكد من وجود وصول لخادم API (`by3li.axeviadigital.com`) من شبكة الاختبار.
2. ابنِ التطبيق: `flutter pub get` ثم `flutter run` أو ثبّت APK/IPA مبني.
3. **امسح البيانات قبل كل جولة نظيفة** (أو على الأقل أول مرة):
   - Android Studio → App inspector، أو:
   - `adb shell pm clear com.example.by3ly` — يعيد التطبيق كما أول تشغيل (يحفّز مسح `firstRun`).
4. تحقق من اللغة الافتراضية: يجب أن يفتح التطبيق بالعربية (RTL) ما لم يتغيّر سابقًا.
5. فعّل وضع المطور إن احتجت `logcat` لمراقبة سجلات التطبيق (خصوصًا عند التحقيق في FCM/401).
6. جهّز خطّي إنترنت (WiFi + بيانات الجوال) للتبديل في حالات الانقطاع.
7. جهّز حساب البريد لاستقبال OTP.

## 2.2 ترتيب التنفيذ المقترح

1. **Environment sanity**: شغّل التطبيق → شاشة سبلاش → (أول مرة) مسح صامت → Onboarding.
2. نفّذ قسم 4 (Authentication) أولًا — كل ما عداه يعتمد على تسجيل الدخول.
3. نفّذ Section 3 حسب الأولوية (Critical من Splash → Register → Login → Home → Add Ad → Payment).
4. Section 12 (E2E) بعد اجتياز Unit-like cases للميزات المنفردة.
5. Section 11 (Error Handling) مع قطع الإنترنت فعليًا.
6. Section 13 (Regression) تُعاد عند أي تعديل لاحق.

## 2.3 قواعد التنفيذ

- نفّذ الخطوات **حرفيًا** كما هي مكتوبة؛ لا تتجاوز خطوات بتقديرك الشخصي.
- سجّل لقطة شاشة عند أي انحراف (Fail) مع إرفاقها بتقرير الـ Bug.
- لا تتخطَّ `Preconditions`؛ فشل التجهيز = الحالة `Blocked` وليس `Fail`.
- إذا انقطع السيرفر أثناء جولة — أعد جدولة الحالات المتأثرة ولا تعتبرها Fail تلقائيًا.
- الحالات الموسومة **(Needs Dev Support)** تتطلب مساعدة مطور للتحقق (فحص التخزين، السجلات، استجابات محاكية).

## 2.4 الحالة الافتراضية للحالات

كل الحالات في هذا الملف بحالتها الافتراضية `Not Run`. لا تفترض Pass قبل التنفيذ.

---

# 3. سيناريوهات الاختبار (حسب Feature)

---

## 3.1 Splash & Onboarding

**Test Case ID:** TC-001
**Test Scenario:** ظهور شاشة البداية بشكل صحيح
**Feature:** Splash (`splash/`)
**Priority:** High
**Test Type:** UI
**Preconditions:** التطبيق مثبت؛ الجهاز على وضع الطائرة لاختبار ما دون الإنترنت لاحقًا.
**Test Data:** لا شيء.
**Steps to Execute:**
1. ثبّت التطبيق وافتحه.
2. راقب أول 4 ثوانٍ.
**Expected Results:**
- خلفية الشاشة بلون `AppColors.mainColor` (`0xff0E8565`).
- شعار التطبيق (`AppImages.logo2`) يظهر في المنتصف مع حركة `Curves.bounceOut` متحركة خلال ~4 ثوانٍ.
- لا توجد أخطاء على الشاشة، ثم الانتقال تلقائيًا للشاشة التالية (حسب حالة الحساب).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-002
**Test Scenario:** أول تشغيل يمسح بيانات التخزين
**Feature:** `AppInitializer` / `firstRun`
**Priority:** High
**Test Type:** Regression
**Preconditions:** التطبيق كان مثبتًا من قبل ويوجد token محفوظ.
**Test Data:** لا شيء.
**Steps to Execute:**
1. `adb shell pm clear com.example.by3ly` (أول تشغيل "نظيف").
2. افتح التطبيق.
3. لاحظ التوجيه: يجب ألا يدخل مباشرة إلى LayoutView.
**Expected Results:**
- الانتقال إلى `OnBoardingView` (لا يوجد token ولا Guest flag بعد المسح).
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) للتحقق من `FlutterSecureStorage` و`SharedPreferences` عبر App Inspector إن رغبت.

---

**Test Case ID:** TC-003
**Test Scenario:** فتح Onboarding من أول تشغيل ثم تخطيه
**Feature:** OnBoarding
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** حالة تثبيت نظيفة (TC-002).
**Test Data:** لا شيء.
**Steps to Execute:**
1. من شاشة Onboarding، اضغط `Skip` (أو زر التخطي) في الشريحة الأولى.
**Expected Results:**
- الانتقال فورًا إلى `LoginView` (pushAndRemoveAll). Flutter `IntroductionScreen` تُنهي بدون استكمال الشرائح.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-004
**Test Scenario:** إكمال Onboarding عبر زر Done في الشريحة الأخيرة
**Feature:** OnBoarding
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** حالة أول تشغيل.
**Test Data:** لا شيء.
**Steps to Execute:**
1. من Onboarding، اسحب/انتقل حتى الشريحة الثالثة.
2. اضغط زر Done.
**Expected Results:**
- الانتقال إلى `LoginView` مع مسح الـ stack (لا عودة بـ Back).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-005
**Test Scenario:** توجيه المستخدم المُسجل إلى LayoutView مباشرة
**Feature:** Splash / routing
**Priority:** Critical
**Test Type:** Regression
**Preconditions:** يوجد token صالح محفوظ (سجّل دخولًا في جلسة سابقة).
**Test Data:** حساب مستخدم A.
**Steps to Execute:**
1. أغلق التطبيق بالكامل (kill) ثم افتحه مجددًا.
2. راقب شاشة Splash ثم ما بعدها.
**Expected Results:**
- خلال ~4 ثوانٍ يتم التوجيه إلى `LayoutView` مباشرة (بدون Onboarding/Login).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

## 3.2 Register & OTP

**Test Case ID:** TC-006
**Test Scenario:** إنشاء حساب بنجاح (المسار السعيد)
**Feature:** Register
**Priority:** Critical
**Test Type:** Functional
**Preconditions:** تثبيت نظيف؛ بريد اختبار قابل للوصول.
**Test Data:** الاسم `QA Tester`، إيميل فريد، هاتف فريد `01012345679`، كلمة المرور `Test1234!`، العمر `25`.
**Steps to Execute:**
1. من LoginView اضغط زر التسجيل.
2. املأ الحقول (الاسم، الإيميل، الهاتف، العمر، كلمة المرور، تأكيد كلمة المرور).
3. (اختياري) ارفع صورة شخصية.
4. اضغط زر "إنشاء الحساب".
**Expected Results:**
- يظهر `CustomLoading` أثناء الإرسال، ثم Toast بنجاح + الانتقال إلى `OtpView` مع بريد المستخدم كمُعامل.
- تصل رسالة/كود إلى البريد المسجل.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-007
**Test Scenario:** التحقق من OTP بنجاح
**Feature:** OTP
**Priority:** Critical
**Test Type:** Functional
**Preconditions:** TC-006 تم بنجاح؛ الكود الأخير متاح في البريد.
**Test Data:** الكود المستلم من البريد (6 خانات).
**Steps to Execute:**
1. في `OtpView`، أدخل الكود في الخانات الست.
2. اضغط زر "Verify/تحقق".
**Expected Results:**
- Toast نجاح؛ يتم حفظ التوكن (secure storage) وتتحول حالة `isGuest=false`؛ الانتقال إلى `ChooseLocationView`.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-008
**Test Scenario:** اختيار المحافظة والمركز وحفظ الموقع
**Feature:** ChooseLocation
**Priority:** High
**Test Type:** Functional
**Preconditions:** TC-007 تم بنجاح؛ تجميع `getCities` من السيرفر نجح.
**Test Data:** محافظة + مركز بالقائمة.
**Steps to Execute:**
1. في `ChooseLocationView`، اختر محافظة من القائمة.
2. لاحظ ظهور قائمة المراكز المفلترة.
3. اختر مركزًا.
4. اضغط زر "تأكيد / Choose".
**Expected Results:**
- تظهر المراكز الخاصة بالمحافظة فقط (فلترة).
- عند التأكيد: CherryToast نجاح والانتقال إلى `LayoutView` (إنهاء كامل للـ stack) وتحديث بيانات البروفايل (`ProfileCubit.getProfile()`).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-009
**Test Scenario:** حقول التسجيل فارغة بالكامل
**Feature:** Register — Validation
**Priority:** High
**Test Type:** Validation
**Preconditions:** شاشة Register مفتوحة.
**Test Data:** لا شيء (كل الحقول فارغة).
**Steps to Execute:**
1. اترك كل الحقول فارغة.
2. اضغط زر إنشاء الحساب.
**Expected Results:**
- لكل حقل مطلوب تظهر رسالة التحقق المترجمة الخاصة به (لا يوجد submit ناجح).
- لا يبدأ أي طلب شبكة (يمكن مراقبته عبر logcat: لا يوجد `POST register`).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-010
**Test Scenario:** هاتف مصري غير صالح (بادئة/طول)
**Feature:** Register — Validation
**Priority:** High
**Test Type:** Validation
**Preconditions:** شاشة Register.
**Test Data:** `02012345678` (بداية 02)، `0101234567` (10 خانات)، `010123456789` (12 خانة)، `0112345678` (10 خانات تبدأ 01 — يجب قبولها).
**Steps to Execute:**
1. لكل قيمة: أدخلها في حقل الهاتف ثم اضغط زر إنشاء.
**Expected Results:**
- القيم غير المطابقة للنمط `^01[0-9]{9}$` تُرفض برسالة تحقق.
- `01012345678` (11 خانة تبدأ بـ 01) تُقبل على مستوى الحقل.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-011
**Test Scenario:** كلمة المرور مخالفة لقواعد القوة
**Feature:** Register — Validation
**Priority:** High
**Test Type:** Validation
**Preconditions:** شاشة Register.
**Test Data:** `test` (قصيرة)، `testtesttest` (بدون كبيرة/رقم/رمز)، `TEST1234!` (بدون صغيرة)، `Testtest!` (بدون رقم).
**Steps to Execute:**
1. لكل قيمة: أدخلها ككلمة مرور وكتأكيد.
2. اضغط زر إنشاء.
**Expected Results:**
- كل قيمة تُرفض برسالة توضح المتطلبات (8–30 + كبيرة + صغيرة + رقم + رمز `!@#$%^&*(),.?":{}|<>`).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-012
**Test Scenario:** تأكيد كلمة المرور غير مطابق
**Feature:** Register — Validation
**Priority:** High
**Test Type:** Validation
**Preconditions:** شاشة Register.
**Test Data:** كلمة المرور `Test1234!` والتأكيد `Test1235!`.
**Steps to Execute:**
1. أدخل كلمة المرور.
2. أدخل تأكيدًا مختلفًا وصحح باقي الحقول صالحة.
3. اضغط إنشاء.
**Expected Results:**
- رسالة تحقق بأن كلمتي المرور غير متطابقتين؛ لا يتم الإرسال.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-013
**Test Scenario:** العمر خارج الحدود 18–100
**Feature:** Register — Validation (ageValidator)
**Priority:** Medium
**Test Type:** Validation
**Preconditions:** شاشة Register.
**Test Data:** `17`, `101`, `0`, `abc`, `-5`, `18` (حد أدنى صالح)، `100` (حد أقصى صالح).
**Steps to Execute:**
1. أدخل كل قيمة في حقل العمر واضغط إنشاء.
**Expected Results:**
- `17`, `101`, `0`, `-5`, `abc` تُرفض برسالة نطاق العمر (18–100) ورسالة عدد صحيح.
- `18` و`100` تُقبل.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-014
**Test Scenario:** OTP خاطئ ثم صحيح
**Feature:** OTP — Negative
**Priority:** High
**Test Type:** Functional
**Preconditions:** جلسة تسجيل وصلتك إلى OtpView.
**Test Data:** كود خاطئ `000000` ثم الكود الصحيح من البريد.
**Steps to Execute:**
1. أدخل `000000` واضغط تحقق.
2. لاحظ النتيجة.
3. أدخل الكود الصحيح واضغط تحقق.
**Expected Results:**
- (1) رسالة خطأ من السيرفر/التحقق، لا يتم الدخول.
- (3) نجاح والانتقال إلى ChooseLocationView.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-015
**Test Scenario:** إعادة إرسال OTP بعد انتهاء مؤقت 60 ثانية
**Feature:** OTP — Resend
**Priority:** High
**Test Type:** Functional
**Preconditions:** OtpView مفتوحة؛ لم يمر 60 ثانية بعد.
**Test Data:** لا شيء.
**Steps to Execute:**
1. لاحظ أن زر "Resend code in N s" غير متاح قبل انتهاء العد.
2. انتظر حتى ينتهي العد ويظهر "Resend Code".
3. اضغط Resend Code.
**Expected Results:**
- يظهر CherryToast يعرض **الكود الجديد من السيرفر** (السلوك الفعلي الحالي — انظر ملاحظة)، ويعود العد التنازلي 60 ثانية.
**Actual Results:**
**Status:** Not Run
**Notes:** ملاحظة توثيقية: هذا السلوك (عرض الكود للمستخدم) يُضعف معنى التحقق — يُوثَّق كملاحظة أمنية في القسم 10.

---

## 3.3 Home

**Test Case ID:** TC-016
**Test Scenario:** تحميل بيانات الرئيسية بنجاح
**Feature:** Home — `GET /home`
**Priority:** Critical
**Test Type:** Functional
**Preconditions:** إنترنت يعمل؛ حساب مسجل.
**Test Data:** لا شيء.
**Steps to Execute:**
1. سجّل الدخول.
2. راقب Shimmer ثم المحتوى.
**Expected Results:**
- تظهر البانرات (إن وُجدت)، شريط الفئات (أول 5)، شبكة "أفضل المشاهدات"؛ لا أخطاء؛ `RefreshIndicator` يعمل عند السحب لأسفل.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-017
**Test Scenario:** البانرات تفتح روابطها خارجية
**Feature:** Home — Banners `GET /getBanners`
**Priority:** Medium
**Test Type:** Integration
**Preconditions:** يوجد banner برابط `link` من السيرفر.
**Test Data:** Banner حقيقي من الإنتاج/البيئة التجريبية.
**Steps to Execute:**
1. من الرئيسية اضغط على بانر إعلاني.
**Expected Results:**
- إذا كان للبانر `link`: يُفتح في المتصفح الخارجي عبر `url_launcher`.
- إذا لم يكن له رابط: لا يحدث شيء (أو لا ينهار).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-018
**Test Scenario:** السحب لأسفل لإعادة تحميل الرئيسية
**Feature:** Home — Pull to refresh
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** الرئيسية معروضة.
**Test Data:** لا شيء.
**Steps to Execute:**
1. اسحب الشاشة من الأعلى لأسفل وحرّر.
**Expected Results:**
- يظهر مؤشر التحديث؛ يُعاد طلب `getHome()` و`getBanners()`؛ المحتوى يتحدث؛ لا تكرار غير مرغوب للبانرات.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-019
**Test Scenario:** الضغط على فئة ينقل إلى صفحة الفئات كلها
**Feature:** Home — Categories
**Priority:** High
**Test Type:** Navigation
**Preconditions:** الرئيسية محملة؛ يوجد انتقال "See all" أو زر الفئات.
**Test Data:** لا شيء.
**Steps to Execute:**
1. اضغط "See all"/عرض الكل بجانب قسم الفئات.
**Expected Results:**
- الانتقال إلى `AllCategoriesView` (عنوان مهاردكود: "جميع الفئات").
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-020
**Test Scenario:** الضغط على منتج في Best View يفتح التفاصيل
**Feature:** Home — Best View grid
**Priority:** High
**Test Type:** Navigation
**Preconditions:** الرئيسية محملة؛ يوجد منتج واحد على الأقل.
**Test Data:** لا شيء.
**Steps to Execute:**
1. اضغط على أي بطاقة منتج في شبكة "أفضل المشاهدات".
**Expected Results:**
- الانتقال إلى `ProductDetailsView` مع `type: "home"`؛ الشاشة تجلب تفاصيل المنتج نفسها من `GET /productDetials`.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-021
**Test Scenario:** زر البحث في الرئيسية ينقل إلى تبويب البحث
**Feature:** Home — Search entry
**Priority:** High
**Test Type:** Navigation
**Preconditions:** في التبويب Home.
**Test Data:** لا شيء.
**Steps to Execute:**
1. اضغط حقل/زر البحث في الرئيسية.
**Expected Results:**
- الانتقال إلى تبويب Search (الفهرس 2 من `LayoutCubit`).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-022
**Test Scenario:** حالة عدم وجود بيانات (Home فارغة) تعرض حالة مناسبة
**Feature:** Home — Empty state
**Priority:** Medium
**Test Type:** UI
**Preconditions:** (Needs Dev Support) محاكاة رد `home` بدون bestView — مثلا في بيئة تجريبية فارغة.
**Test Data:** رد سيرفر فارغ `{status:true, data:{categories:[],bestView:[],ads:[]}}`.
**Steps to Execute:**
1. افتح الرئيسية في بيئة بلا بيانات.
**Expected Results:**
- تعرض الشاشة هيكلها بدون انهيار (لا توجد عناصر bestView، ولا خطأ شاشة كاملة).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

## 3.4 All Categories

**Test Case ID:** TC-023
**Test Scenario:** عرض جميع الفئات الرئيسية
**Feature:** AllCategories — `GET /viewAllCategories`
**Priority:** High
**Test Type:** Functional
**Preconditions:** إنترنت يعمل.
**Test Data:** لا شيء.
**Steps to Execute:**
1. من الرئيسية اضغط "See all" للفئات (أو افتح `allCategoriesView` من أي نقطة دخول).
2. راقب القائمة.
**Expected Results:**
- قائمة staggered animated تعرض كل الفئات بصورها وأسمائها وعدد الفئات الفرعية (`{n} قسم فرعي`).
- أثناء التحميل تظهر قائمة Shimmer (20 عنصرًا).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-024
**Test Scenario:** الضغط على فئة ينقل إلى أقسامها الفرعية
**Feature:** AllCategories → AllSubCategories
**Priority:** High
**Test Type:** Navigation
**Preconditions:** شاشة جميع الفئات مفتوحة.
**Test Data:** أي فئة (مثلاً سيارات إن وُجدت).
**Steps to Execute:**
1. اضغط أي عنصر فئة.
**Expected Results:**
- الانتقال إلى `AllSubCategoriesView` مع تمرير `mainCategoryId` و`mainCategoryName` و`mainCategoryImage`؛ تظهر ترويصة الفئة الرئيسية فوق شبكة الأقسام الفرعية.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-025
**Test Scenario:** فشل تحميل الفئات يعرض خطأ قابل للمحاولة
**Feature:** AllCategories — Error
**Priority:** Medium
**Test Type:** Error Handling
**Preconditions:** افصل الإنترنت ثم افتح الشاشة (أو اجعل السيرفر يرجع 500).
**Test Data:** لا شيء.
**Steps to Execute:**
1. افتح جميع الفئات بدون إنترنت.
**Expected Results:**
- تظهر حالة خطأ واضحة (رسالة مترجمة) مع زر/إمكانية إعادة المحاولة؛ لا يحدث انهيار ولا شاشة بيضاء.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-026
**Test Scenario:** كاش الفئات جلسة-واحدة (لا إعادة تحميل متكررة)
**Feature:** AllCategories — caching
**Priority:** Low
**Test Type:** Regression
**Preconditions:** الإنترنت يعمل؛ زر للتبديل بين المفضلة/البحث ينطوي على استخدام الفئات في الفلتر.
**Test Data:** لا شيء.
**Steps to Execute:**
1. افتح جميع الفئات ولاحظ طلب الشبكة الواحد (logcat: `GET viewAllCategories`).
2. ارجع وافتح ورقة الفلتر في صفحة منتجات قسم فرعي.
3. لاحظ عدد الطلبات لنفس المسار.
**Expected Results:**
- خلال الجلسة الواحدة يُرسل الطلب مرة واحدة فقط (الكاش المشترك `cachedModel`)؛ الورقة تستهلك الكاش دون طلب جديد.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) لمراقبة السجلات عبر logcat.

---

**Test Case ID:** TC-027
**Test Scenario:** انتقالات الشاشة تحتفظ بوضع RTL
**Feature:** AllCategories — UI/RTL
**Priority:** Low
**Test Type:** UI
**Preconditions:** اللغة العربية مفعلة.
**Test Data:** لا شيء.
**Steps to Execute:**
1. افتح شاشة الفئات في العربية ثم بدّل الإنجليزية وافتحها مجددًا.
**Expected Results:**
- العربية: محاذاة RTL (يمين)، الإنجليزية: LTR مع انعكاس الأيقونات الاتجاهية؛ لا تراكب (overlap) للنصوص.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

## 3.5 Sub-Categories & منتجات الفئة الفرعية

**Test Case ID:** TC-028
**Test Scenario:** عرض الأقسام الفرعية مع عدد المنتجات
**Feature:** AllSubCategories — `GET /getSubCategories`
**Priority:** High
**Test Type:** Functional
**Preconditions:** فئة رئيسية فيها أقسام فرعية.
**Test Data:** فئة تحتوي ≥ 2 قسم فرعي.
**Steps to Execute:**
1. افتح جميع الفئات ← اختر فئة.
2. لاحظ الترويصة وعدد الأقسام.
**Expected Results:**
- تعرض الترويصة صورة الفئة واسمها وعدد الأقسام (`{n} تصنيفات`).
- كل قسم فرعي يعرض: صورته، اسمه، وشارة بعدد المنتجات (`products_count`).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-029
**Test Scenario:** الضغط على قسم فرعي برصيد صفر منتجات
**Feature:** AllSubCategories — zero products
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** قسم فرعي بحقل `products_count = 0`.
**Test Data:** القسم المعني.
**Steps to Execute:**
1. اضغط القسم ذي العدد صفر.
**Expected Results:**
- Snackbar رسالة: "لا يوجد منتجات في هذا القسم" (النص مهاردكود بالعربية) — لا انتقال إلى شاشة المنتجات.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-030
**Test Scenario:** الانتقال من قسم فرعي إلى شبكة منتجاته
**Feature:** AllSubCategories → AllSubCategoriesProducts
**Priority:** High
**Test Type:** Navigation
**Preconditions:** قسم بمنتجات > 0.
**Test Data:** لا شيء.
**Steps to Execute:**
1. اضغط القسم.
**Expected Results:**
- الانتقال إلى `AllSubCategoriesProductsView` بعنوان "allProducts (اسم القسم)" وشبكة عمودين للمنتجات.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-031
**Test Scenario:** بحث محلي داخل منتجات القسم
**Feature:** AllSubCategoriesProducts — client-side search
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** منتجات القسم محملة.
**Test Data:** جزء من اسم منتج معروف.
**Steps to Execute:**
1. اكتب جزءًا من الاسم في حقل البحث أعلى الشبكة.
**Expected Results:**
- تتضيق الشبكة فورًا إلى المنتجات المطابقة (name/desc/type/Ids/price/city/center/shipping/condition — الفلترة هنا محلية على القائمة المحملة).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-032
**Test Scenario:** ورقة الفلتر تطبق جميع الفلاتر مجتمعة
**Feature:** ProductsFilterSheet — in sub-category screen
**Priority:** High
**Test Type:** Functional
**Preconditions:** منتجات القسم محملة.
**Test Data:** فئة + فئة فرعية + سعر min/max + محافظة/مركز + شحن (free/paid/الكل) + حالة (new/used/الكل).
**Steps to Execute:**
1. اضغط زر الفلتر (الأيقونة).
2. اختر: فئة، فئة فرعية، نوعًا، سعرًا (من-إلى)، محافظة ومركز، شحن، حالة.
3. اضغط Apply.
4. لاحظ الشارات النشطة فوق الشبكة (chips بحذف فردي).
5. اضغط Clear All.
**Expected Results:**
- الشبكة تصفي وفقًا للفلاتر مجتمعة؛ الشارات تعكس الاختيارات؛ Clear All تعيد القائمة كاملة؛ عدّاد النشط على زر الفلتر يعكس العدد.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-033
**Test Scenario:** الانتقال من منتج في الشبكة إلى تفاصيله
**Feature:** AllSubCategoriesProducts → ProductDetails
**Priority:** High
**Test Type:** Navigation
**Preconditions:** منتجات القسم محملة.
**Test Data:** لا شيء.
**Steps to Execute:**
1. اضغط أي بطاقة منتج.
**Expected Results:**
- الانتقال إلى `ProductDetailsView` — `type=home`.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-034
**Test Scenario:** خطأ تحميل منتجات القسم
**Feature:** AllSubCategoriesProducts — Error
**Priority:** Medium
**Test Type:** Error Handling
**Preconditions:** افصل الإنترنت قبل الدخول للشاشة.
**Test Data:** لا شيء.
**Steps to Execute:**
1. ادخل شاشة منتجات القسم بدون إنترنت.
**Expected Results:**
- حالة خطأ مع إمكانية إعادة المحاولة؛ لا انهيار.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-035
**Test Scenario:** رسالة تراكم القائمة عند إعادة التحميل
**Feature:** AllSubCategoriesProducts — append behavior
**Priority:** Low
**Test Type:** Regression
**Preconditions:** الدخول للشاشة ثم الخروج والعودة (Needs Dev Support للتأكد من استهلاك الحالة).
**Test Data:** لا شيء.
**Steps to Execute:**
1. افتح شاشة منتجات القسم.
2. احصِ العناصر المعروضة.
3. ارجع ثم افتح مجددًا.
4. احصِ مجددًا.
**Expected Results:**
- لا يظهر تفريغ للقائمة؛ التطبيق يعيد الجلب؛ (سلوك معروف: الكيوبت يُلحق بالقائمة — راقب أي تضاعف للعناصر).
**Actual Results:**
**Status:** Not Run
**Notes:** كلمة سلوك معروف: `AllSubCategoriesProductsCubit` يُلحق النتائج بالقائمة.

---

## 3.6 Search

**Test Case ID:** TC-036
**Test Scenario:** بحث نصي عن منتج موجود
**Feature:** Search — `GET /products?page=1`
**Priority:** Critical
**Test Type:** Functional
**Preconditions:** حساب مستخدم؛ إنترنت؛ يوجد منتج معروف.
**Test Data:** كلمة من اسم منتج موجود في السوق.
**Steps to Execute:**
1. افتح تبويب Search (التبويب الثالث من الـ layout).
2. اكتب الكلمة في حقل البحث.
**Expected Results:**
- تظهر النتائج المطابقة قائمة `ListView`؛ العدّاد يعرض "{العدد} (n)"؛ كل النتائج نسبة إلى النص (فلترة محلية للصفحة المحملة).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-037
**Test Scenario:** البحث بدون نتائج
**Feature:** Search — empty result
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** Search محملة.
**Test Data:** `zzzzzzzzzzzz_no_such_product_123`.
**Steps to Execute:**
1. اكتب القيمة المذكورة.
**Expected Results:**
- تظهر حالة عدم وجود نتائج (أو قائمة فارغة بدون انهيار)؛ لا خطأ شاشة كاملة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-038
**Test Scenario:** الفلتر السيرفري يطبق ويعيد تحميل الصفحة الأولى
**Feature:** Search — server-side filter
**Priority:** High
**Test Type:** Functional
**Preconditions:** Search محملة؛ توجد فئات وأقسام فرعية من `AllCategoriesCubit`.
**Test Data:** فئة + قسم فرعي + سعر min/max + محافظة + مركز + شحن + حالة.
**Steps to Execute:**
1. اضغط زر الفلتر (الأيقونة) أعلى البحث.
2. املأ الفلاتر المذكورة.
3. اضغط Apply؛ راقب إعادة تحميل الصفحة الأولى بالنظر إلى logcat: `GET products?...`.
**Expected Results:**
- URL يحتوي: `category_id, sub_category_id, min_price, max_price, city_id, center_id, shipping_type, condition` + `page=1`.
- العدّاد النشط يعكس عدد الفلاتر المختارة؛ الشارات قابلة للحذف الفردي.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) لالتقاط URL عبر Proxy/logcat.

---

**Test Case ID:** TC-039
**Test Scenario:** تحميل المزيد عند الوصول لـ 300px من النهاية (Infinite Scroll)
**Feature:** Search — pagination
**Priority:** High
**Test Type:** Functional
**Preconditions:** يوجد أكثر من صفحة نتائج (تحتاج سوقًا فيه > عدد العناصر للصفحة الأولى).
**Test Data:** استعلام واسع النتائج.
**Steps to Execute:**
1. ابحث باستعلام يعيد عدة صفحات.
2. مرّر لأسفل ببطء حتى النهاية.
**Expected Results:**
- يبدأ جلب الصفحة التالية تلقائيًا (لا يوجد تقطع أثناء التمرير بلا قفزات)؛ عدّاد `page` يتزايد؛ تتوقف القائمة عند `last_page`.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-040
**Test Scenario:** فشل تحميل الصفحات التالية يظهر زر إعادة المحاولة
**Feature:** Search — pagination error
**Priority:** Medium
**Test Type:** Error Handling
**Preconditions:** ابدأ البحث ثم افصل الإنترنت عند التمرير للأسفل.
**Test Data:** استعلام متعدد الصفحات.
**Steps to Execute:**
1. ابحث وناقش إلى آخر الصفحة الأولى.
2. افصل الإنترنت.
3. مرّر للأسفل.
**Expected Results:**
- يظهر تذييل "خطأ مع زر Retry"؛ النتائج المحملة تبقى ظاهرة؛ لا استبدال للقائمة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-041
**Test Scenario:** حذف جميع الفلاتر يعيد القائمة الأصلية
**Feature:** Search — clear filters
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** فلاتر مطبقة (TC-038).
**Test Data:** كما في TC-038.
**Steps to Execute:**
1. اضغط "Clear All" من ورقة الفلتر.
2. راقب النتائج والشارات.
**Expected Results:**
- تختفي كل الشارات؛ يُعاد الطلب بدون params؛ الشاشة كما بعد البحث الحر.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-042
**Test Scenario:** الانتقال من نتيجة بحث إلى تفاصيل المنتج
**Feature:** Search → ProductDetails
**Priority:** High
**Test Type:** Navigation
**Preconditions:** نتائج موجودة.
**Test Data:** لا شيء.
**Steps to Execute:**
1. اضغط أي `SearchItemWidget`.
**Expected Results:**
- الانتقال إلى `ProductDetailsView` بـ `type: "home"`.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-043
**Test Scenario:** حالة التحميل الأولى في البحث (Shimmer)
**Feature:** Search — loading skeleton
**Priority:** Low
**Test Type:** UI
**Preconditions:** امسح الكاش ثم افتح البحث.
**Test Data:** لا شيء.
**Steps to Execute:**
1. افتح تبويب البحث ولاحظ أول لحظة.
**Expected Results:**
- 10 عناصر Shimmer متموجة (Staggered) تظهر أثناء التحميل ثم تستبدل بالنتائج.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-044
**Test Scenario:** استجابة 401 أثناء البحث تخرج المستخدم (سلوك شامل)
**Feature:** Search — auth failure
**Priority:** High
**Test Type:** Security/Integration
**Preconditions:** جلسة نشطة بتوكن ستُبطله (Needs Dev Support لتعديل/انتهاء التوكن).
**Test Data:** لا شيء.
**Steps to Execute:**
1. بعد تسجيل الدخول، اجعل التوكن منتهيًا (أو سجّل خروج المستخدم من الخادم).
2. نفّذ بحثًا.
**Expected Results:**
- عند 401: تظهر Toast "youLoggedOutPleaseLoginAgain" ويُمسح التوكن وينتقل المستخدم إلى `LoginView` (سلوك `ApiService._performLogout`).
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) لإبطال التوكن من الخادم.

---

## 3.7 SeeAllBestView (أفضل المشاهدات — عرض الكل)

**Test Case ID:** TC-045
**Test Scenario:** صفحة عرض الكل تحمل شبكة منتجات Best View
**Feature:** SeeAllBestView — `GET /bestAllView`
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** إنترنت.
**Test Data:** لا شيء.
**Steps to Execute:**
1. من الرئيسية اضغط "See all" بجانب شبكة أفضل المشاهدات.
**Expected Results:**
- عنوان "bestView"؛ شبكة عمودين؛ كل بطاقة تُفيدك بسعر/موقع/تقييم؛ التحميل يظهر Shimmer 20 عنصرًا ولو فشلت حالة `status != true` تظهر رسالة خطأ.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-046
**Test Scenario:** بحث محلي داخل صفحة عرض الكل
**Feature:** SeeAllBestView — client-side search
**Priority:** Low
**Test Type:** Functional
**Preconditions:** القائمة محملة.
**Test Data:** كلمة من اسم منتج.
**Steps to Execute:**
1. اكتب في حقل البحث أعلى الشبكة.
**Expected Results:**
- تضيق القائمة للعناصر المطابقة (name/desc/price)؛ لا إعادة طلب شبكة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-047
**Test Scenario:** فتح منتج من شبكة عرض الكل
**Feature:** SeeAllBestView → ProductDetails
**Priority:** Medium
**Test Type:** Navigation
**Preconditions:** القائمة محملة.
**Test Data:** لا شيء.
**Steps to Execute:**
1. اضغط أي منتج.
**Expected Results:**
- الانتقال إلى `ProductDetailsView` — `type=home`.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

## 3.8 Product Details

**Test Case ID:** TC-048
**Test Scenario:** تحميل تفاصيل المنتج بالكامل
**Feature:** ProductDetails — `GET /productDetials?product_id&type=home`
**Priority:** Critical
**Test Type:** Functional
**Preconditions:** إنترنت؛ منتج معروف ID.
**Test Data:** `product_id` حقيقي.
**Steps to Execute:**
1. افتح تفاصيل أي منتج من الرئيسية أو البحث.
**Expected Results:**
- تظهر: صورة رئيسية 300px، شريط مصغرات (حد أقصى 56px بحدود accent للحالية)، الاسم، تاريخ وعدد المشاهدات، الموقع (إن وُجد)، السعر والجنيه، وصف (2 سطر مع Read more)، شارة "عاجل"/"مميز" إن وجدا.
- الأزرار: قلب مفضلة، مقارنة، (دردشة) تُخفى للمالك، زر تعليمات شراء، زر الإبلاغ.
- Shimmer أثناء التحميل، وحالات خطأ قابلة للمحاولة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-049
**Test Scenario:** معرض الصور ملء الشاشة
**Feature:** ProductDetails — FullScreenGallery
**Priority:** Medium
**Test Type:** UI
**Preconditions:** منتج بأكثر من صورة.
**Test Data:** لا شيء.
**Steps to Execute:**
1. اضغط الصورة الرئيسية.
2. اسحب بين الصور؛ قرص للتقريب.
3. أغلق المعرض.
**Expected Results:**
- `FullScreenGallery` بخلفية سوداء + عنوان "i / n"؛ التكبير حتى 4x؛ الإغلاق يعيدك للشاشة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-050
**Test Scenario:** تقييم المنتج بتعليق ونجوم
**Feature:** ProductDetails — rateProduct
**Priority:** High
**Test Type:** Functional
**Preconditions:** مستخدم مسجل (ليس مالك المنتج).
**Test Data:** نجمتين 4 + تعليق `QA مراجعة اختبار`.
**Steps to Execute:**
1. افتح "معدل المنتج"/لوحة التقييم في نهاية الشاشة.
2. اختر عدد النجوم واكتب تعليقًا.
3. اضغط إرسال.
**Expected Results:**
- Toast نجاح (أو رسالة السيرفر)؛ تُعاد جلب التفاصيل (الطلب يتكرر في logcat: `GET productDetials`) ويظهر التقييم/العدد محدثًا.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-051
**Test Scenario:** الزائر يحاول التقييم — يُطلب تسجيل دخول
**Feature:** ProductDetails — rate as guest
**Priority:** High
**Test Type:** Security
**Preconditions:** الزائر (Guest) داخل الشاشة.
**Test Data:** لا شيء.
**Steps to Execute:**
1. كزائر، افتح شاشة منتج.
2. حاول التفاعل مع التقييم/القلب.
**Expected Results:**
- يظهر حوار "تسجيل مطلوب" (`loginRequiredTitle/Message`)؛ التأكيد ينقلك إلى LoginView؛ الإلغاء يبقي الزائر على الشاشة دون التقييم.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-052
**Test Scenario:** مالك الإعلان يرى قائمة إيقاف/تفعيل
**Feature:** ProductDetails — pause/resume own ad
**Priority:** High
**Test Type:** Functional
**Preconditions:** حساب مالك الإعلان؛ المنتج له.
**Test Data:** لا شيء.
**Steps to Execute:**
1. افتح تفاصيل إعلانك.
2. اضغط أيقونة الـ PopupMenu (⋮) في شريط التطبيق.
3. اختر "إيقاف الإعلان" ثم أكد في حوار `AppConfirmDialog`.
4. افتح  مجددًا ثم اختر "تفعيل الإعلان".
**Expected Results:**
- (3) `LinearProgressIndicator` يظهر أثناء الطلب؛ Toast نجاح؛ قيمة `is_paused` محليًا تتغير؛ الإعلان يختفي من الحالة "نشط".
- (4) يعود نشطًا بالعكس؛ أزرار "التواصل الآن" ودردشة تختفي تلقائيًا للمالك في جميع الأحوال.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-053
**Test Scenario:** المستخدم العادي لا يرى قائمة الإيقاف/التفعيل
**Feature:** ProductDetails — owner restriction
**Priority:** High
**Test Type:** Security
**Preconditions:** مستخدم مسجل ليس مالك الإعلان.
**Test Data:** لا شيء.
**Steps to Execute:**
1. افتح تفاصيل إعلان شخص آخر.
**Expected Results:**
- لا تظهر قائمة ⋮ (pause/resume) في شريط التطبيق؛ زر الشات/التواصل ظاهر.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-054
**Test Scenario:** التقرير عن المنتج يفتح مسار "التبليغ عن إعلان"
**Feature:** ProductDetails → Report ad flow
**Priority:** High
**Test Type:** Navigation/Integration
**Preconditions:** مستخدم مسجل.
**Test Data:** لا شيء.
**Steps to Execute:**
1. اضغط "الإبلاغ والدعم" أسفل شاشة المنتج.
**Expected Results:**
- الانتقال إلى `ReportTheProductView` بسياق `sellerId + productId` → عرض `ReportAdViewBody` (أسباب من `GET /reportReasons`).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-055
**Test Scenario:** زر "تعليمات الشراء" يعرض HTML من السيرفر
**Feature:** ProductDetails → HowToMakePurchase
**Priority:** Medium
**Test Type:** Integration
**Preconditions:** إنترنت.
**Steps to Execute:**
1. اضغط "كيف يتم الشراء؟".
**Expected Results:**
- `HowToMakePurchaseView` تعرض `Html` من `GET /purchaseInstructions` مع RTL (أو حسب `direction`)؛ روابط تواصل خارجي تفتح المتصفح؛ عند الخطأ تظهر `CustomErrorWidget` مع إعادة محاولة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-056
**Test Scenario:** قائمة المنتجات المرتبطة (Related Products)
**Feature:** ProductDetails — related products
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** منتج له `relatedProducts` في الرد.
**Test Data:** لا شيء.
**Steps to Execute:**
1. انزل إلى نهاية الشاشة؛ لاحظ قسم "المنتجات المرتبطة".
2. اضغط "مشاهدة الكل".
**Expected Results:**
- القسم يعرض بطاقات أفقية؛ "مشاهدة الكل" تفتح `AllRelatedProductsView` (شبكة كاملة)؛ الضغط على بطاقة يفتح تفاصيل ذلك المنتج.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-057
**Test Scenario:** الصورة المصغرة في شريط المصغرات تُحدّث المعروضة
**Feature:** ProductDetails — thumbnails
**Priority:** Low
**Test Type:** UI
**Preconditions:** منتج بأكثر من صورة.
**Test Data:** لا شيء.
**Steps to Execute:**
1. اضغط ثاني صورة مصغرة.
**Expected Results:**
- الصورة الرئيسية تتحول للثانية بحد accent 3px حول المصغرة المختارة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-058
**Test Scenario:** زر المشاركة (Share) لا يسبب انهيارًا
**Feature:** ProductDetails — share icon
**Priority:** Low
**Test Type:** UI
**Preconditions:** شاشة المنتج.
**Test Data:** لا شيء.
**Steps to Execute:**
1. اضغط أيقونة المشاركة في شريط التطبيق.
**Expected Results:**
- لا انهيار؛ (السلوك الحالي: الزر فارغ `onPressed: () {}` — لا يحدث شيء؛ يُوثّق كملاحظة).
**Actual Results:**
**Status:** Not Run
**Notes:** ملاحظة: زر المشاركة غير وظيفي في الكود الحالي.

---

**Test Case ID:** TC-059
**Test Scenario:** زر المقارنة على المنتج الأول
**Feature:** ProductDetails → Compare (1/2)
**Priority:** High
**Test Type:** Functional
**Preconditions:** سلة المقارنة فارغة.
**Test Data:** منتج A.
**Steps to Execute:**
1. اضغط زر "مقارنة" (الشريط العائم على الصورة).
**Expected Results:**
- Toast يعرض "addToCompare (1/2)"؛ المنتج يُضاف لسلة المقارنة؛ لا يحدث انتقال.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-060
**Test Scenario:** إضافة منتج ثانٍ تنقل إلى شاشة المقارنة
**Feature:** ProductDetails → Compare (2/2)
**Priority:** High
**Test Type:** Navigation
**Preconditions:** أضيف منتج A (TC-059).
**Test Data:** منتج B آخر.
**Steps to Execute:**
1. افتح تفاصيل منتج B.
2. اضغط زر "مقارنة".
**Expected Results:**
- الانتقال تلقائيًا إلى `CompareView` بالمنتجين؛ الجدول يعرض: السعر، القديم (مشطوب)، النوع، الموديل، الماركة، المكان، التقييم، تاريخ الإضافة + بطاقة الوصف.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

## 3.9 Compare

**Test Case ID:** TC-061
**Test Scenario:** إزالة المنتج الأقدم عند إضافة ثالث
**Feature:** Compare — max items = 2
**Priority:** Medium
**Test Type:** Edge Case
**Preconditions:** السلة فيها A و B.
**Test Data:** منتج C ثالث.
**Steps to Execute:**
1. افتح منتج C.
2. اضغط زر المقارنة.
**Expected Results:**
- تُزال A (الأقدم) وتُضاف C؛ تنتقل للشاشة بالزوج (B, C).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-062
**Test Scenario:** إفراغ سلة المقارنة من شاشة المقارنة
**Feature:** Compare — clear basket
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** شاشة المقارنة مفتوحة بالمنتجين.
**Test Data:** لا شيء.
**Steps to Execute:**
1. اضغط "clear all" (أيقونة في الـ AppBar).
2. أكد في `AppConfirmDialog`.
**Expected Results:**
- تفرغ السلة؛ تعرض الشاشة حالة "اختر المنتج الثاني" فارغة مع زر رجوع.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-063
**Test Scenario:** منتج واحد فقط في السلة — رسالة الانتظار
**Feature:** Compare — one product state
**Priority:** Medium
**Test Type:** UI
**Preconditions:** السلة فيها منتج واحد.
**Test Data:** لا شيء.
**Steps to Execute:**
1. افتح شاشة المقارنة.
**Expected Results:**
- تظهر رسالة "اختر المنتج الثاني" + زر رجوع؛ لا يتم استدعاء `POST /compareProducts` (يتطلب 2).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-064
**Test Scenario:** فشل مقارنة السيرفر يرجع لتفاصيل المنتج (fallback)
**Feature:** Compare — fallback merge
**Priority:** Medium
**Test Type:** Integration (Needs Dev Support)
**Preconditions:** محاكاة فشل `compareProducts` (Needs Dev Support).
**Test Data:** منتجان A و B.
**Steps to Execute:**
1. سلة بها A و B.
2. احجب `compareProducts` عبر proxy.
3. افتح شاشة المقارنة.
**Expected Results:**
- (Needs Dev Support) التطبيق يطلب `productDetials` لـ A و B ويدمجهما للعرض بدل خطأ كامل.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) يتطلب اعتراض الطلبات.

---

**Test Case ID:** TC-065
**Test Scenario:** جدول المقارنة يعرض فروقات الأسعار والتقييمات
**Feature:** Compare — rendering
**Priority:** Low
**Test Type:** UI
**Preconditions:** منتجان مختلفان بأسعارهما وتقييميهما.
**Test Data:** منتجان A/B ببيانات مختلفة.
**Steps to Execute:**
1. افتح شاشة المقارنة.
**Expected Results:**
- السعر مميز بخلفية؛ السعر القديم مشطوب عند وجوده؛ التقييم بجانب `reviews_count`؛ صف التاريخ بتنسيق واضح؛ "VS" بين البطاقتين.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-066
**Test Scenario:** إزالة منتج من المقارنة من داخل التفاصيل
**Feature:** Compare — toggle off
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** المنتج A في السلة (المقارنة ليست ممتلئة).
**Test Data:** لا شيء.
**Steps to Execute:**
1. افتح تفاصيل المنتج A.
2. اضغط زر المقارنة مجددًا.
**Expected Results:**
- Toast "removeFromCompare"؛ يخرج A من السلة؛ عدّاد (0/2) في الضغطات التالية.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

## 3.10 Favorites

**Test Case ID:** TC-067
**Test Scenario:** إضافة منتج للمفضلة من البطاقة
**Feature:** Favorites — POST `/favourites`
**Priority:** High
**Test Type:** Functional
**Preconditions:** مستخدم مسجل؛ إنترنت.
**Test Data:** منتج غير مفضّل.
**Steps to Execute:**
1. في الرئيسية/البحث، اضغط قلب أي بطاقة.
**Expected Results:**
- القلب يتحول ممتلئًا فورًا (تفاؤل)؛ Toast "addedToFav" أو رسالة السيرفر؛ عند re-fetch يتزامن القيد؛ عنصر logcat: `POST favourites` بـ `product_id`.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-068
**Test Scenario:** إزالة منتج من المفضلة
**Feature:** Favorites — DELETE `/favourites`
**Priority:** High
**Test Type:** Functional
**Preconditions:** المنتج مفضّل.
**Test Data:** منتج مفضّل.
**Steps to Execute:**
1. اضغط القلب مجددًا على نفس البطاقة.
**Expected Results:**
- القلب يعود فارغًا فورًا؛ Toast "removedFromFav"؛ (logcat: `DELETE favourites?product_id=`).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-069
**Test Scenario:** فشل إضافة للمفضلة يُرجع القلب ويظهر Snackbar
**Feature:** Favorites — failure revert
**Priority:** Medium
**Test Type:** Error Handling
**Preconditions:** افصل الإنترنت ثم اضغط قلب.
**Test Data:** أي منتج.
**Steps to Execute:**
1. افصل الإنترنت.
2. اضغط قلب أحد المنتجات.
**Expected Results:**
- القلب يتغير فورًا ثم يرتد لحالته الأصلية بعد فشل الطلب؛ Snackbar/Toast خطأ؛ الحالة متسقة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-070
**Test Scenario:** شاشة المفضلة تعرض المنتجات المفضلة وتبحث فيها
**Feature:** FavView — GET `/favourites`
**Priority:** High
**Test Type:** Functional
**Preconditions:** يوجد منتج مفضّل واحد على الأقل.
**Test Data:** كلمة من اسم المفضّل.
**Steps to Execute:**
1. من تبويب الحساب → "Favorite" (الدفع والرصيد ← Favorite).
2. لاحظ القائمة ثم اكتب في البحث.
**Expected Results:**
- قائمة `ProductRowCard` للمفضّلة؛ بحث محلي بالاسم/الوصف؛ زر قلب بداخل كل عنصر للإزالة؛ Shimmer أثناء التحميل ثم RefreshIndicator.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-071
**Test Scenario:** إزالة من المفضلة داخل شاشة المفضلة بقلب
**Feature:** FavView — item removal
**Priority:** High
**Test Type:** Functional
**Preconditions:** شاشة المفضلة مفتوحة بمنتج.
**Test Data:** لا شيء.
**Steps to Execute:**
1. اضغط القلب في أحد العناصر بالقائمة.
**Expected Results:**
- يُحذَف العنصر من القائمة فورًا (تفاؤل) وToast تأكيد؛ بعد المزامنة تبقى القائمة متسقة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-072
**Test Scenario:** الزائر لا يستطيع إضافة مفضلة
**Feature:** Favorites — guest restriction
**Priority:** High
**Test Type:** Security
**Preconditions:** Guest في أي قائمة.
**Test Data:** لا شيء.
**Steps to Execute:**
1. كزائر اضغط قلب أي منتج.
**Expected Results:**
- يظهر حوار "تسجيل مطلوب"؛ لا يتم أي طلب شبكة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-073
**Test Scenario:** تزامن حالة القلب عبر الشاشات (Fav → Home → Details)
**Feature:** Favorites — cross-screen sync
**Priority:** High
**Test Type:** Integration
**Preconditions:** مستخدم؛ المنتج نفسه مرئ في ≥ شاشتين.
**Test Data:** منتج A.
**Steps to Execute:**
1. من الرئيسية أضف A للمفضلة.
2. افتح تفاصيل A — لاحظ القلب.
3. ارجع للرئيسية — لاحظ القلب.
4. أزل A من شاشة المفضلة.
5. افتح تفاصيل A — لاحظ القلب.
**Expected Results:**
- القلب يظهر ممتلئًا في كل الشاشات بعد الإضافة، وفارغًا بعد الإزالة (لوجود |FavouriteIds|Set مشترك في `FavCubit`).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

## 3.11 Add New Ad (التدفق الموحّد)

**Test Case ID:** TC-074
**Test Scenario:** فتح شاشة إضافة إعلان من "إعلاناتي"
**Feature:** AddAdvertisements — AddNewAdView (entry)
**Priority:** High
**Test Type:** Navigation
**Preconditions:** مستخدم مسجل (Guest سيُمنع — انظر قسم 4/5).
**Test Data:** لا شيء.
**Steps to Execute:**
1. افتح تبويب "Ads" (إعلاناتي).
2. اضغط زر (+) العائم.
**Expected Results:**
- الانتقال إلى `AddNewAdView` بخمسة بطاقات مرقمة (صور → بيانات → فئة → شحن → موقع).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-075
**Test Scenario:** رفع صورة من الكاميرا ومن المعرض (حد أقصى 5)
**Feature:** AddNewAd — images
**Priority:** High
**Test Type:** Functional
**Preconditions:** الأذونات ممنوحة (Camera/Photos).
**Test Data:** 6 صور اختبار.
**Steps to Execute:**
1. اضغط بلاطة "add" → اختر من الكاميرا → التقط صورة.
2. اضغط add مجددًا → اختر من المعرض → أضف حتى 5 صور.
3. حاول إضافة صورة سادسة.
**Expected Results:**
- تظهر المصغرات؛ بلاطة "add" تُظهر العداد `3/5` وتختفي عند الامتلاء (5/5) — لا يمكن تجاوز 5.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-076
**Test Scenario:** النشر بدون صور يُرفض بالتحقق
**Feature:** AddNewAd — validation (images)
**Priority:** High
**Test Type:** Validation
**Preconditions:** شاشة إضافة إعلان.
**Test Data:** لا توجد صور.
**Steps to Execute:**
1. املأ البيانات (الاسم/الوصف/السعر/الفئة/القسم/المحافظة/المركز) فقط بدون صور.
2. اضغط "نشر الإعلان".
**Expected Results:**
- رسالة تحقق `imagesRequired` تُعرض؛ لا يبدأ أي إرسال.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-077
**Test Scenario:** حساب نسبة الخصم تلقائيًا بجانب السعر
**Feature:** AddNewAd — discount %
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** الشاشة مفتوحة.
**Test Data:** price `1000`، discount `150`.
**Steps to Execute:**
1. اكتب السعر 1000 والخصم 150.
**Expected Results:**
- تظهر نسبة الخصم المحسوبة (~15%) بجوار السعر بخط أحمر (`-15%`).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-078
**Test Scenario:** النشر مع تغطية اشتراك كاملة — بدون حقول دفع
**Feature:** AddNewAd — publish covered (subscription)
**Priority:** Critical
**Test Type:** Integration
**Preconditions:** حساب له اشتراك نشط غير منتهٍ (ads_remaining > 0).
**Test Data:** بيانات إعلان صالحة.
**Steps to Execute:**
1. املأ الإعلان بالبيانات والصور.
2. اضغط "نشر الإعلان".
**Expected Results:**
- (Needs Dev Support للتأكد من رد `subscriptions/current`) لا تُفتح ورقة الدفع؛ يبدأ إرسال `POST addNewAds` بدون `payment_method/receipt`؛ Toast نجاح؛ الصفحة تُغلق بـ `true`.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) لمراقبة الطلبات.

---

**Test Case ID:** TC-079
**Test Scenario:** النشر بدون تغطية — تُفتح ورقة الدفع
**Feature:** AddNewAd — payment sheet (not covered)
**Priority:** Critical
**Test Type:** Functional
**Preconditions:** حساب بدون اشتراك فعال (الحالة الافتراضية غالبًا).
**Test Data:** بيانات إعلان صالحة.
**Steps to Execute:**
1. اضغط "نشر الإعلان" بحساب غير مشترك.
**Expected Results:**
- تُفتح ورقة "اختر طريقة الدفع" (Arabic): تشرح أن الباقة/الإعلانات المجانية خلصت؛ تُظهر "رسوم النشر" و"رصيد المحفظة".
- خيار "محفظة بيعلي" معطّل إن كان الرصيد < الرسوم.
- خيار "تحويل" قابل للتوسعة inline.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-080
**Test Scenario:** الدفع عبر المحفظة بقيمة كافية ينشر الإعلان
**Feature:** AddNewAd — wallet payment
**Priority:** Critical
**Test Type:** Functional
**Preconditions:** رصيد المحفظة ≥ الرسوم المطلوبة.
**Test Data:** رصيد محفظة معبأ مسبقًا (Needs Backend).
**Steps to Execute:**
1. افتح ورقة الدفع.
2. اختر "محفظة بيعلي".
**Expected Results:**
- Toast "تم خصم الرسوم ونُشر الإعلان" (أو رسالة السيرفر)؛ `addNewAds` يُرسل بـ `payment_method: 'wallet'`؛ الصفحة تُغلق بـ `true`.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-081
**Test Scenario:** الدفع عبر المحفظة برصيد غير كافٍ — Snackbar رفض
**Feature:** AddNewAd — insufficient balance
**Priority:** High
**Test Type:** Functional
**Preconditions:** رصيد المحفظة < الرسوم.
**Test Data:** رصيد صفري/منخفض.
**Steps to Execute:**
1. افتح ورقة الدفع.
**Expected Results:**
- خيار المحفظة يظهر معطّل/غير قابل للضغط؛ عند الضغط بالقوة تظهر Snackbar "الرصيد غير كافٍ".
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-082
**Test Scenario:** الدفع بتحويل بنكي بدون رفع إيصال يُرفض
**Feature:** AddNewAd — transfer validation
**Priority:** High
**Test Type:** Validation
**Preconditions:** ورقة الدفع مفتوحة على "تحويل".
**Test Data:** لا يوجد إيصال مرفوع.
**Steps to Execute:**
1. اختر طريقة تحويل (مثلاً Vodafone Cash).
2. اضغط "نشر الإعلان" في الورقة.
**Expected Results:**
- Toast/Snackbar تطلب رفع صورة الإيصال ("ارفع صورة التحويل")؛ لا يُرسل الطلب.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-083
**Test Scenario:** الدفع بتحويل مع إيصال ينشر الإعلان
**Feature:** AddNewAd — transfer payment success
**Priority:** Critical
**Test Type:** Functional
**Preconditions:** الإيصال متاح كصورة (JPG/PNG).
**Test Data:** صورة إيصال اختبار + رقم مرجع اختياري.
**Steps to Execute:**
1. اختر طريقة تحويل.
2. أدخل رقم مرجع اختياري `TRX123456`.
3. اضغط "ارفع صورة التحويل" واختر صورة.
4. اضغط "نشر الإعلان".
**Expected Results:**
- يُرسل `POST addNewAds` multipart بـ `payment_method: <code>` و`transfer_reference` و`receipt: file`؛ Toast "تم إرسال طلب النشر"؛ الصفحة تُغلق بـ `true`.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-084
**Test Scenario:** رفض السيرفر لحقول الدفع يعيد فتح الورقة (safety net)
**Feature:** AddNewAd — AddNewAdPaymentRequired
**Priority:** Medium
**Test Type:** Integration (Needs Dev Support)
**Preconditions:** محاكاة رد 422 مع fieldErrors (payment_method/receipt).
**Test Data:** بيانات إعلان عادية.
**Steps to Execute:**
1. املأ إعلانًا وانشر (يحتاج تغطية معطلة).
**Expected Results:**
- (Needs Dev Support) رسالة خطأ تُصنف كـ PaymentRequired؛ يُعاد فتح ورقة الدفع تلقائيًا بدل خطأ عام.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) يُتحقق بفحص رد السيرفر.

---

**Test Case ID:** TC-085
**Test Scenario:** الفئات المعتمدة: اختيار الفئة يحمّل أقسامها الفرعية
**Feature:** AddNewAd — dependent dropdowns
**Priority:** High
**Test Type:** Functional
**Preconditions:** `viewAllCategories` متاح.
**Test Data:** فئة "سيارات" مثلاً.
**Steps to Execute:**
1. اختر الفئة الرئيسية من القائمة المنسدلة.
2. لاحظ القائمة الفرعية.
**Expected Results:**
- تُحمَّل الأقسام الفرعية لتلك الفئة فقط (`AllSubCategoriesCubit.getAllSubCategories(categoryId:)`)؛ القيم السابقة تُمسح عند تغيير الفئة (ValueKey).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-086
**Test Scenario:** تغيير الشحن والحالة (chips) يعمل كاختيار مفرد
**Feature:** AddNewAd — shipping & condition chips
**Priority:** Low
**Test Type:** UI
**Preconditions:** الشاشة مفتوحة.
**Test Data:** لا شيء.
**Steps to Execute:**
1. اضغط "Paid Shipping" ثم "Free Shipping" ثم "Used" ثم "New".
**Expected Results:**
- يتبقى خيار واحد محدد في كل مجموعة؛ الألوان/الحدود تدل على التحديد (ChoiceChip).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-087
**Test Scenario:** اختيار المحافظة يرشح المراكز + الافتراضيات من البروفايل
**Feature:** AddNewAd — location dropdowns
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** البروفايل مكتمل (city/center).
**Test Data:** محافظة وجميع مراكزها.
**Steps to Execute:**
1. لاحظ قيم القائمتين عند فتح الشاشة (الافتراضيات).
2. غيّر المحافظة.
**Expected Results:**
- الافتراضيات = مدينة/مركز البروفايل؛ تغيير المحافظة يعيد بناء قائمة المراكز المفلترة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-088
**Test Scenario:** النموذج بكل الحقول صالح ينشر الإعلان بدون اشتراك وبناءً على fee=0
**Feature:** AddNewAd — free publish (fee=0)
**Priority:** Low
**Test Type:** Edge Case (Needs Dev Support)
**Preconditions:** إعدادات نشر بـ `price <= 0` (Needs Backend).
**Steps to Execute:**
1. بحساب بدون اشتراك، حاول النشر.
**Expected Results:**
- (Needs Dev Support) ورقة الدفع تُنشأ وتُستدعى submit تلقائيًا (fee=0 → نشر مجاني) دون تدخل المستخدم.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) لضبط `ad-publishing-settings`.

---

## 3.12 Edit Ad

**Test Case ID:** TC-089
**Test Scenario:** فتح شاشة تعديل إعلان مملوك
**Feature:** EditAdView — reuse AddNewAdViewBody
**Priority:** High
**Test Type:** Functional
**Preconditions:** مالك إعلان (إعلان موجود في "إعلاناتي").
**Test Data:** إعلان منشور.
**Steps to Execute:**
1. من "إعلاناتي" افتح قائمة تعديل/زر "تعديل" في العنصر (إن وجد).
**Expected Results:**
- تنفتح `EditAdView` مع pre-fill: الاسم، الوصف، السعر، الخصم، الفئة والمسار الفرعي، الشحن/الحالة، المحافظة والمركز، الصور الحالية كبطاقة `existingImages`.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-090
**Test Scenario:** تعديل السعر والحفظ
**Feature:** EditAd — submit edit
**Priority:** High
**Test Type:** Functional
**Preconditions:** TC-089.
**Test Data:** سعر جديد `12345`.
**Steps to Execute:**
1. غيّر السعر.
2. اضغط "تعديل الإعلان".
**Expected Results:**
- `POST /editAds` multipart بـ `ad_id` وبيانات التحديث؛ Toast "تم التعديل"؛ الصفحة تُغلق بـ `true`.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-091
**Test Scenario:** إضافة صور جديدة والإبقاء على القديمة
**Feature:** EditAd — images merge
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** إعلان بصورتين.
**Test Data:** صورة إضافية.
**Steps to Execute:**
1. احذف صورة واحدة من القديمة محليًا (X).
2. أضف صورتين جديدتين.
3. احفظ.
**Expected Results:**
- العدد الإجمالي ≤ 5؛ تُرسل `images[]` = **الجديدة فقط**؛ (ملاحظة: لا يُعاد إرسال الصور القديمة — يعتمد على السيرفر لحذف المحذوف).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-092
**Test Scenario:** تعديل بدون أي تغييرات يُقبل ولا يفسد شيئًا
**Feature:** EditAd — no-op edit
**Priority:** Low
**Test Type:** Edge Case
**Preconditions:** TC-089.
**Steps to Execute:**
1. اضغط "تعديل الإعلان" مباشرة بدون أي تغيير.
**Expected Results:**
- يُقبل الطلب؛ Toast نجاح؛ لا Corruption للبيانات (رد `GeneralModel` بـ `status: true`).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-093
**Test Scenario:** رجوع بدون حفظ لا يغيّر الإعلان
**Feature:** EditAd — back discard
**Priority:** Low
**Test Type:** Functional
**Preconditions:** TC-089.
**Steps to Execute:**
1. عدّل الاسم ثم اضغط زر الرجوع.
**Expected Results:**
- تُغلق الشاشة بدون طلب `editAds`؛ الإعلان على السيرفر كما هو (يظهر بالاسم القديم في "إعلاناتي").
**Actual Results:**
**Status:** Not Run
**Notes:**

---

## 3.13 My Ads (إعلاناتي)

**Test Case ID:** TC-094
**Test Scenario:** تبويبات الحالة تحصر العدادات بشكل صحيح
**Feature:** Advertisements — tabs (الكل / النشط الان / الغير نشط)
**Priority:** High
**Test Type:** Functional
**Preconditions:** حساب بإعلانات منشورة بعضها `is_paused=true`.
**Test Data:** لا شيء.
**Steps to Execute:**
1. افتح تبويب "Ads".
2. بدّل بين التبويبات الثلاثة.
**Expected Results:**
- كل تبويب يعرض العناصر المناسبة فقط (`is_paused == true` → "الغير نشط"؛ غير ذلك "النشط الان"؛ الكل = المجموع) والعدادات صحيحة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-095
**Test Scenario:** بحث في إعلاناتي بالاسم
**Feature:** Advertisements — local search
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** ≥ 2 إعلانات.
**Test Data:** جزء من اسم إعلان.
**Steps to Execute:**
1. اكتب في حقل "ابحث باسم الإعلان...".
**Expected Results:**
- تتضيق القائمة بالاسم/الوصف؛ العدّادات تتبع المصنّف والفرز محلي.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-096
**Test Scenario:** إيقاف إعلان من إعلاناتي مع حوار تأكيد
**Feature:** MyAds — pause ad
**Priority:** High
**Test Type:** Functional
**Preconditions:** إعلان نشط مملوك.
**Test Data:** لا شيء.
**Steps to Execute:**
1. افتح خيارات أحد الإعلانات ← "pause"/"pauseAd".
2. أكد في الحوار.
**Expected Results:**
- `LinearProgress` أثناء الطلب؛ `POST pauseAd` بـ `{ad_id}`؛ تُحدّث القائمة محليًا؛ Toast نجاح.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-097
**Test Scenario:** إعادة تفعيل إعلان متوقف
**Feature:** MyAds — resume ad
**Priority:** High
**Test Type:** Functional
**Preconditions:** إعلان بحالة paused.
**Test Data:** لا شيء.
**Steps to Execute:**
1. افتح قائمة الإعلان ← "resumeAd" ← أكد.
**Expected Results:**
- `POST resumeAd` بـ `{ad_id}`؛ `is_paused=false` محليًا؛ يعود للتبويب "النشط الان".
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-098
**Test Scenario:** حذف إعلان مع حوار تأكيد
**Feature:** MyAds — delete ad
**Priority:** High
**Test Type:** Functional
**Preconditions:** إعلان مملوك.
**Test Data:** لا شيء.
**Steps to Execute:**
1. افتح خيارات الإعلان ← "حذف".
2. أكد في الحوار.
**Expected Results:**
- `POST deleteAds` بـ `{ad_id}`؛ يُزال العنصر من القائمة نهائيًا؛ Toast تأكيد.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-099
**Test Scenario:** الضغط المزدوج على زر إيقاف لا يُرسل مرتين
**Feature:** MyAds — double-tap protection
**Priority:** Medium
**Test Type:** Edge Case
**Preconditions:** إعلان نشط.
**Test Data:** لا شيء.
**Steps to Execute:**
1. اضغط "pause" مرتين بسرعة متتالية.
**Expected Results:**
- يصل طلب واحد فقط للسيرفر (`_pauseResumeInFlight`)؛ لا تكرار للتوست ولا للطلب.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-100
**Test Scenario:** الاشتراك بباقة من زر "الباقات" داخل إعلاناتي
**Feature:** MyAds — packages entry
**Priority:** Medium
**Test Type:** Navigation
**Preconditions:** مستخدم.
**Test Data:** لا شيء.
**Steps to Execute:**
1. اضغط زر "الباقات" (AddBundleButton).
**Expected Results:**
- الانتقال إلى `PackagesView` (`GET subscriptionPackages`)؛ العنوان/الخطط كما في قسم 3.14.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

## 3.14 Packages & Subscription (الباقات)

**Test Case ID:** TC-101
**Test Scenario:** عرض الباقات المتاحة بالتبويبات الزمنية
**Feature:** Packages — `GET /subscriptionPackages`
**Priority:** High
**Test Type:** Functional
**Preconditions:** إنترنت.
**Test Data:** لا شيء.
**Steps to Execute:**
1. افتح "الباقات".
2. بدّل بين التبويبات: شهري / 3 شهور / 6 شهور / سنوي.
**Expected Results:**
- تُفلتر البطاقات محليًا حسب المدة؛ كل بطاقة تعرض: الاسم، السعر، `features[]`، زر "اشترك الآن" أو "تجديد الاشتراك" للمشترك.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-102
**Test Scenario:** الاشتراك عبر المحفظة (مبلغ كافٍ)
**Feature:** Packages — checkout wallet
**Priority:** Critical
**Test Type:** Functional
**Preconditions:** رصيد محفظة ≥ سعر الباقة.
**Test Data:** باقة شهرية اختبارية.
**Steps to Execute:**
1. افتح الباقة ← "اشترك الآن".
2. اختر "محفظة" من الورقة.
**Expected Results:**
- `POST /subscriptions/checkout` بجسم JSON `{package_id, payment_method: 'wallet'}`؛ Toast نجاح؛ إعادة تحميل الباقات؛ زر التجديد يظهر للباقة المشترك بها.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-103
**Test Scenario:** الاشتراك عبر التحويل: اختيار الطريقة ورفع الإيصال
**Feature:** Packages — checkout transfer
**Priority:** Critical
**Test Type:** Functional
**Preconditions:** صورة إيصال جاهزة.
**Test Data:** طريقة Vodafone Cash + إيصال.
**Steps to Execute:**
1. افتح الباقة ← التحويل ← انتقل إلى `TransferView`.
2. لاحظ قائمة طرق الدفع (`GET /payment-methods` — قد تعرض فودافون/اورانج/اتصالات/انستاباي/فوري/بنك/محفظة/كاش).
3. اختر طريقة ← أدخل رقم مرجع اختياري ← ارفع الإيصال.
4. اضغط "تأكيد الاشتراك".
**Expected Results:**
- `POST /subscriptions/checkout` multipart بـ `package_id, payment_method, receipt`؛ Toast نجاح؛ (تفعيل عبر الخادم قد يتطلب مراجعة الإيصال — يختلف حسب السيرفر).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-104
**Test Scenario:** نسخ رقم الحساب من بطاقة طريقة الدفع
**Feature:** Packages — copy transfer account
**Priority:** Medium
**Test Type:** UI
**Preconditions:** شاشة التحويل مفتوحة.
**Test Data:** لا شيء.
**Steps to Execute:**
1. اضغط زر النسخ (أيقونة النسخ) في بطاقة طريقة الدفع.
**Expected Results:**
- رقم/حساب الطريقة يُنسخ للحافظة؛ Toast "تم نسخ الرقم"؛ (يحتاج صلاحية الحافظة — على iOS قد تُطلب أول مرة).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-105
**Test Scenario:** عرض الباقة الحالية في شاشة المحفظة
**Feature:** Packages — current subscription card
**Priority:** Medium
**Test Type:** Integration
**Preconditions:** مشترك بباقة نشطة.
**Steps to Execute:**
1. افتح الدفع والرصيد (تبويب الحساب ← Payment and Balance).
**Expected Results:**
- بطاقة "الباقة الحالية" تُعرض (الباقة حيث `is_subscribed == true`) مع تفاصيلها.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-106
**Test Scenario:** الاشتراك برصيد محفظة غير كافٍ (السيرفر يرفض)
**Feature:** Packages — insufficient wallet (server)
**Priority:** High
**Test Type:** Negative
**Preconditions:** رصيد المحفظة < السعر.
**Test Data:** رصيد صفري.
**Steps to Execute:**
1. خلال الورقة اختر "محفظة".
**Expected Results:**
- السيرفر يرفض (4xx برسالة) ويعرضها التطبيق كـ Toast/رسالة؛ لا اشتراك يُسجل؛ ولا يتغير الرصيد.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-107
**Test Scenario:** بيانات الطرق المجلوبة من السيرفر تُعرض بالكامل
**Feature:** Packages — payment-methods rendering
**Priority:** Medium
**Test Type:** Integration
**Preconditions:** `payment-methods` يتضمن أكثر من طريقة.
**Steps to Execute:**
1. افتح `TransferView`.
**Expected Results:**
- تظهر كل طرق الدفع القادمة من السيرفر بـ `name` و `account`؛ الأحرف العربية تتعرف عبر `brandForPaymentMethod()` (فودافون/أورانج/اتصالات/انستاباي/فوري/بنك/محفظة/كاش) لوجو/لون صحيح.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-108
**Test Scenario:** تجديد اشتراك منتهٍ
**Feature:** Packages — renew
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** باقة منتهية (Needs Backend لإنشاء حالة تنتهي).
**Test Data:** لا شيء.
**Steps to Execute:**
1. افتح الباقات.
2. لاحظ زر الباقة المنتهية: "تجديد الاشتراك" بدل "اشترك الآن".
3. أكمل مسار الدفع مجددًا.
**Expected Results:**
- يُنشأ اشتراك جديد عبر checkout عادي؛ لا يظهر انتهاء القديمة معطلًا للدفع.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) لتوفير باقة منتهية في بيئة الاختبار.

---

## 3.15 Wallet & Payment (الدفع والرصيد)

**Test Case ID:** TC-109
**Test Scenario:** شاشة الدفع والرصيد تُظهر الرصيد والحركات
**Feature:** PaymentBalance — `GET /wallet/history` + profile balance
**Priority:** High
**Test Type:** Functional
**Preconditions:** حساب مستخدم؛ يوجد رصيد وحركات سابقة.
**Test Data:** لا شيء.
**Steps to Execute:**
1. تبويب الحساب ← "Payment and Balance".
**Expected Results:**
- يُظهر رصيد المحفظة بعملة `wallet_balance` (من البروفايل) + قائمة الحركات مع: النوع (إيداع/خصم)، التاريخ، المبلغ، حالة (approved/rejected/pending)، طريقة الدفع مترجمة، زر "عرض الإيصال" عند توفره.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-110
**Test Scenario:** شحن الرصيد بتحويل (Wallet Top-up)
**Feature:** Wallet — `POST /wallet/top-up`
**Priority:** Critical
**Test Type:** Functional
**Preconditions:** صورة إيصال؛ مبلغ `100`.
**Steps to Execute:**
1. في شاشة الدفع اضغط "أضف رصيد".
2. أدخل المبلغ `100`.
3. اختر طريقة تحويل ← ارفع إيصال ← رقم مرجع اختياري.
4. اضغط "تأكيد الشحن".
**Expected Results:**
- `POST /wallet/top-up` multipart `{amount, payment_method, transfer_reference?, receipt}`؛ Toast "تم إرسال طلب الشحن"؛ الصفحة تصعد `true`؛ تتحدث بيانات البروفايل والسجل بعد العودة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-111
**Test Scenario:** مبلغ شحن غير صالح (سالب/صفر/حروف)
**Feature:** Wallet — amount validation
**Priority:** High
**Test Type:** Validation
**Preconditions:** شاشة الشحن.
**Test Data:** `0`, `-50`, `abc`, `999999999999`.
**Steps to Execute:**
1. أدخل كل قيمة في حقل المبلغ ثم اضغط تأكيد.
**Expected Results:**
- `0` أو سالب أو حروف تُمنع/ترفض برسالة واضحة؛ رقم ضخم جدًا يُرفض من السيرفر برسالة (422) وتظهر كـ Toast.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-112
**Test Scenario:** عرض الإيصال من سجل الحركات (تحميل/مشاركة)
**Feature:** Wallet — receipt actions
**Priority:** Medium
**Test Type:** Functional/Integration
**Preconditions:** حركة قبول لها `receipt_url`.
**Test Data:** حركة approved بها إيصال.
**Steps to Execute:**
1. من سجل الحركات اضغط "عرض الإيصال".
2. في الـ bottom sheet: اضغط "تحميل" (Save to gallery) ثم "مشاركة".
**Expected Results:**
- تُفتح صورة الإيصال؛ التحميل يحفظها في المعرض (`Gal`) بإذن؛ المشاركة تفتح ورقة مشاركة النظام (`share_plus`).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-113
**Test Scenario:** السجل يميز بين الإيداع والخصم بالألوان
**Feature:** Wallet — credit/debit coloring
**Priority:** Low
**Test Type:** UI
**Preconditions:** يوجد حركتان (credit/debit) على الأقل.
**Test Data:** حركات مختلطة.
**Steps to Execute:**
1. لاحظ مؤشرات الحركات في السجل.
**Expected Results:**
- الإيداع بالأخضر/لون التطبيق (▼) والخصم بالأحمر (▲) "خصم" حسب `isCredit` heuristic.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-114
**Test Scenario:** السجل يعرض حالات "قيد المراجعة" للتحويلات الجديدة
**Feature:** Wallet — pending status
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** شحنة جديدة بانتظار الموافقة (تحتاج إداريًا).
**Test Data:** حركة جديدة.
**Steps to Execute:**
1. أجرِ شحنًا ثم ارجع فورًا للسجل.
**Expected Results:**
- الحركة تظهر بحالة "قيد المراجعة"/"انتظار" (pill بخلفية مناسبة) حسب تمييز `status` في الكود.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-115
**Test Scenario:** سجل فارغ (لا حركات سابقة)
**Feature:** Wallet — empty history
**Priority:** Low
**Test Type:** UI
**Preconditions:** حساب جديد بدون حركات (أو محاكاة).
**Steps to Execute:**
1. افتح شاشة الدفع والرصيد.
**Expected Results:**
- تُعرض الشاشة بلا حركات (قائمة فارغة/حالة مناسبة) دون انهيار.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-116
**Test Scenario:** خطأ أثناء جلب سجل الحركات (offline)
**Feature:** Wallet — history error
**Priority:** Medium
**Test Type:** Error Handling
**Preconditions:** عدم إنترنت + رصيد موجود.
**Steps to Execute:**
1. افصل الإنترنت ← ادخل شاشة الدفع والرصيد.
**Expected Results:**
- تظهر حالة خطأ/رسالة مناسبة؛ لا انهيار؛ عند توفر الإنترنت + إعادة المحاولة يُحل.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-117
**Test Scenario:** الدفع للباقة عبر المحفظة يُخصم من الرصيد (تكامل كامل)
**Feature:** Wallet ↔ Packages integration
**Priority:** Critical
**Test Type:** Integration
**Preconditions:** رصيد محفظة كافٍ؛ باقة سعرها أقل من الرصيد.
**Test Data:** رصيد معروف X؛ سعر الباقة Y < X.
**Steps to Execute:**
1. سجل الرصيد الحالي (X).
2. اشترك بباقة عبر "محفظة".
3. عد إلى شاشة الدفع والرصيد.
**Expected Results:**
- الرصيد ≤ X (ناقص سعر الباقة Y) بمجرد موافقة السيرفر على الشحنة؛ حركة "خصم" تظهر بالسجل؛ الباقة الحالية تُعرض.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

## 3.16 Statistics (إحصائيات البائع)

**Test Case ID:** TC-118
**Test Scenario:** عرض ملخص الشهر الحالي
**Feature:** Statistics — `GET /statistics?page=1&month=YYYY-MM`
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** مستخدم بائع؛ إنترنت.
**Test Data:** لا شيء.
**Steps to Execute:**
1. الحساب ← "Statistics".
**Expected Results:**
- تُعرض 6 بطاقات: إجمالي المبيعات، المبلغ، المنتجات المعروضة، المهتمون، المفضلة، الشكاوى؛ بطاقة "periodTotal"؛ خط زمني للأيام (EasyDateTimeLine)؛ أسهم تنقل الشهر (‖LTR‖).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-119
**Test Scenario:** التنقل بين الأشهر السابقة/التالية
**Feature:** Statistics — previous/next month
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** الشاشة مفتوحة.
**Test Data:** لا شيء.
**Steps to Execute:**
1. اضغط سهم الشهر السابق ← لاحظ الاسم والبيانات.
2. اضغط سهم الشهر التالي حتى الشهر الحالي.
**Expected Results:**
- تتغير `month_name` والبيانات (تُطلب من السيرفر `month=YYYY-MM`)؛ التحميل يظهر `LinearProgressIndicator` رفيعًا.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-120
**Test Scenario:** اختيار يوم من الخط الزمني لا يُعيد طلب الشبكة
**Feature:** Statistics — day selection
**Priority:** Low
**Test Type:** Functional (Needs Dev Support)
**Preconditions:** الشهر معروض.
**Test Data:** لا شيء.
**Steps to Execute:**
1. اضغط على أي يوم في الخط الزمني.
**Expected Results:**
- تتحدث بطاقة `period` بأرقام ذلك اليوم محليًا (بدون طلب شبكة جديد — البيانات مضمنة في `days[]`).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

## 3.17 Profile & Update Profile

**Test Case ID:** TC-121
**Test Scenario:** بيانات البروفايل تُعرض بشكل صحيح
**Feature:** Profile — `GET /getProfileData`
**Priority:** High
**Test Type:** Functional
**Preconditions:** مستخدم مسجل.
**Test Data:** لا شيء.
**Steps to Execute:**
1. تبويب "Account".
2. لاحظ القسم العلوي.
**Expected Results:**
- الصورة (أو placeholder)، الاسم، الهاتف، "Member From" + تاريخ `created_at`، زر "Change" بجانب الاسم.
- أثناء التحميل تظهر `ProfileInfoShimmer`؛ خطأ → نص "Error".
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-122
**Test Scenario:** تعديل الاسم والبريد والهاتف وحفظ
**Feature:** UpdateProfile — `POST /updateProfile` (multipart)
**Priority:** High
**Test Type:** Functional
**Preconditions:** شاشة البروفايل.
**Test Data:** اسم `QA Updated`، هاتف `01099998888`، إيميل فريد.
**Steps to Execute:**
1. اضغط "Change".
2. عدّل الاسم والهاتف واضغط "Save".
**Expected Results:**
- `POST updateProfile` multipart بالحقول غير الفارغة فقط؛ Toast نجاح؛ الانتقال إلى LayoutView؛ البروفايل يُحدّث (`ProfileCubit.getProfile()`).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-123
**Test Scenario:** تغيير صورة البروفايل من المعرض
**Feature:** UpdateProfile — avatar
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** صلاحية الصور.
**Test Data:** صورة من المعرض.
**Steps to Execute:**
1. شاشة التعديل ← اضغط الدائرة → "change" → اختر صورة.
2. اضغط Save.
**Expected Results:**
- الصورة تُعالج (800px / جودة 85) وتُرفع multipart (`image`)؛ تظهر الصورة الجديدة في البروفايل بعد الحفظ.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-124
**Test Scenario:** حذف الصورة المعلّقة ("delete") يرجع للصورة الأصلية
**Feature:** UpdateProfile — clear picked image
**Priority:** Low
**Test Type:** Functional
**Preconditions:** صورة معلقة مرفوعة.
**Steps to Execute:**
1. اختر صورة جديدة.
2. اضغط "delete".
**Expected Results:**
- تُلغى الصورة المعلّقة؛ تظهر صورة البروفايل الأصلية من السيرفر مجددًا؛ عند الحفظ لا تُرفق صورة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-125
**Test Scenario:** التحقق من حقول الاسم/الإيميل في تعديل البروفايل
**Feature:** UpdateProfile — validation
**Priority:** Medium
**Test Type:** Validation
**Preconditions:** شاشة التعديل.
**Test Data:** اسم `A` (قصير جدًا)، إيميل `notanemail`، اسم بأرقام `User123`.
**Steps to Execute:**
1. أدخل كل قيمة واضغط Save.
**Expected Results:**
- الاسم: يرفض (< 2 أو أرقام/رموز) برسالة displayName؛ الإيميل يرفض برسالة email.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-126
**Test Scenario:** الاختصارات الأربعة في البروفايل تعمل كلها
**Feature:** Profile — quick actions (Payment and Balance / Favorite / Statistics / Comparison)
**Priority:** Medium
**Test Type:** Navigation
**Preconditions:** مستخدم.
**Steps to Execute:**
1. اضغط كلًّا من الأزرار الأربعة بالتتابع.
**Expected Results:**
- Payment and Balance → `PaymentAndBalanceView`؛ Favorite → `FavView`؛ Statistics → `StatisticsView`؛ Comparison → `CompareView`؛ كلها تفتح بدون انهيار.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-127
**Test Scenario:** عرض صورة بروفايل مكسورة لا ينهار
**Feature:** Profile — broken avatar
**Priority:** Low
**Test Type:** UI
**Preconditions:** صورة المستخدم برابط ميت (Needs Backend لتعيين رابط 404 لصورة).
**Steps to Execute:**
1. افتح تبويب الحساب.
**Expected Results:**
- تظهر أيقونة/widget الخطأ بدل الصورة (errorBuilder)؛ لا انهيار؛ لا شاشة بيضاء.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

## 3.18 Settings / Change Password / Delete Account

**Test Case ID:** TC-128
**Test Scenario:** شاشة الإعدادات تعرض كل العناصر بالترتيب
**Feature:** Profile — Settings list
**Priority:** Medium
**Test Type:** UI
**Preconditions:** مستخدم.
**Test Data:** لا شيء.
**Steps to Execute:**
1. انزل في تبويب الحساب إلى قسم "Settings".
**Expected Results:**
- العناصر بالترتيب: Reporting and Support ← Privacy ← Change Password ← Change Language ← Theme (مفتاح فاتح/داكن) ← Notify (مفتاح محلي) ← Legal info (قابل للطي: About / Terms / Privacy Policy) ← Delete Account (أحمر) ← زر Sign Out الأحمر في الأسفل.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-129
**Test Scenario:** Change Language — التبديل للإنجليزية LTR
**Feature:** ChangeLang — showChangeLangSheet
**Priority:** High
**Test Type:** Functional
**Preconditions:** العربية افتراضية.
**Steps to Execute:**
1. الإعدادات ← "Change Language" (أو `showChangeLangSheet`).
2. اختر "English".
**Expected Results:**
- ورقة سفلية بقائمتين (العربية/English) مع علامة الصح على الحالي؛ عند الاختيار: يحفظ `language=en` ثم `EasyLocalization.setLocale`؛ كل النصوص تتحول للإنجليزية فورًا (LTR)؛ تُعاد كل البيانات (Home/Search/…) تلقائيًا.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-130
**Test Scenario:** Change Language — العودة للعربية RTL
**Feature:** ChangeLang — back to Arabic
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** الإنجليزية مفعلة (TC-129).
**Steps to Execute:**
1. افتح ورقة تغيير اللغة ← اختر "اللغة العربية".
**Expected Results:**
- تعود كل الواجهات للعربية RTL؛ `Accept-Language` يُرسل ar في الطلبات التالية (logcat).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-131
**Test Scenario:** Theme — التبديل للوضع الداكن وحفظه
**Feature:** ThemeModeSwitch / AppThemes
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** الوضع الفاتح.
**Steps to Execute:**
1. الإعدادات ← "Theme" — بدّل للوضع الداكن.
2. اخرج من التطبيق وأعد فتحه.
**Expected Results:**
- تتغير كل الألوان للوضع الداكن فورًا (خلفية `0xff0F172A` إلخ)؛ بعد إعادة الفتح يبقى الوضع الداكن (`isDarkMode` محفوظ في prefs).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-132
**Test Scenario:** تغيير كلمة المرور بنجاح
**Feature:** ChangePassword — `POST /changePassword`
**Priority:** High
**Test Type:** Functional
**Preconditions:** مستخدم مسجل بكلمة معرفة.
**Test Data:** الجديدة `NewTest1234!`.
**Steps to Execute:**
1. الإعدادات ← "Change Password".
2. (حقل كلمة المرور القديمة موجود لكن **بدون تحقق**).
3. أدخل الجديدة `NewTest1234!` والتأكيد نفسه.
4. اضغط Save.
**Expected Results:**
- `POST changePassword` multipart بـ `{email, reset_token: <userToken>, new_password, confirm_new_password}`؛ Toast نجاح؛ الانتقال إلى LoginView (إخراج كامل) ومسح بيانات الدخول؛ `LayoutCubit.pageIndex = 0`.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-133
**Test Scenario:** تأكيد كلمة المرور غير المتطابق مرفوض
**Feature:** ChangePassword — mismatch
**Priority:** High
**Test Type:** Validation
**Preconditions:** TC-132.
**Test Data:** الجديدة `NewTest1234!` والتأكيد `NewTest1235!`.
**Steps to Execute:**
1. أدخل القيمتين واضغط Save.
**Expected Results:**
- رسالة تحقق تطابق كلمتي المرور؛ لا يُرسل الطلب.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-134
**Test Scenario:** كلمة مرور ضعيفة في تغيير كلمة المرور
**Feature:** ChangePassword — weak password
**Priority:** High
**Test Type:** Validation
**Preconditions:** شاشة تغيير كلمة المرور.
**Test Data:** الجديدة `test`.
**Steps to Execute:**
1. أدخل `test` مرتين واضغط Save.
**Expected Results:**
- رسالة المتطلبات (8–30 + كبيرة + صغيرة + رقم + رمز)؛ مرفوض.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-135
**Test Scenario:** حذف الحساب نهائيًا من الإعدادات
**Feature:** DeleteAccount — `POST /deleteAccount`
**Priority:** Critical
**Test Type:** Functional (Destructive!)
**Preconditions:** حساب اختبار قابل للاستغناء (يُفضّل حساب ثانوي يُحذف).
**Test Data:** حساب ثانوي.
**Steps to Execute:**
1. الإعدادات ← "Delete Account".
2. اقرأ التحذيرين (`accountDeletionWarning`, `accountRestorationInfo`).
3. اضغط الزر الأحمر "Delete now".
**Expected Results:**
- (سلوك الكود الحالي): `POST deleteAccount` بلا جسم؛ Toast نجاح؛ الانتقال إلى LoginView (finish)؛ **ملاحظة**: التوكن والكاش **لا يُمسح** (لا يحدث Logout صريح) — انظر القسم 11/10؛ اضغط Back للتأكد أنك لا تعود للحساب المحذوف بدون تسجيل جديد.
**Actual Results:**
**Status:** Not Run
**Notes:** احذر: استخدام حساب يُراد اختباره على بقية المهام الأخرى.

---

## 3.19 Notifications

**Test Case ID:** TC-136
**Test Scenario:** عرض الإشعارات مع عدّاد غير المقروء
**Feature:** Notifications — `GET /notifications?type=general&page=1&per_page=15`
**Priority:** High
**Test Type:** Functional
**Preconditions:** حساب وصلته إشعارات (promo/order/chat).
**Steps to Execute:**
1. من جرس الإشعارات في Home (الأيقونة العلوية) افتح Notifications.
**Expected Results:**
- قائمة الكروت: غير المقروء بخلفية بلون التطبيق الفاتح ونقطة accent؛ العنوان بسطر والجسم بثلاثة؛ التاريخ؛ عدّاد "غير مقروء" في AppBar إن وُجد.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-137
**Test Scenario:** تحديد إشعار كمقروء عند الضغط عليه
**Feature:** Notifications — `PATCH /notifications/:id/read`
**Priority:** High
**Test Type:** Functional
**Preconditions:** إشعار غير مقروء موجود.
**Steps to Execute:**
1. اضغط على الإشعار غير المقروء.
**Expected Results:**
- تومض البطاقة كمقروءة على الفور (optimistic)؛ يتناقص عدّاد AppBar؛ يُرسل `PATCH notifications/:id/read`؛ (عند فشل الشبكة يتراجع القلب ومعها العدّاد).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-138
**Test Scenario:** تحديد الكل كمقروء
**Feature:** Notifications — `PATCH /notifications/read-all`
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** إشعارات غير مقروءة موجودة.
**Steps to Execute:**
1. اضغط أيقونة `done_all_rounded` (تظهر فقط إن كان unreadCount > 0).
**Expected Results:**
- الكل يصبح مقروءًا فورًا؛ يعود العدّاد صفرًا؛ (logcat: `PATCH notifications/read-all`).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-139
**Test Scenario:** حذف إشعار بالسحب (Swipe to delete)
**Feature:** Notifications — `DELETE /notifications/:id`
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** إشعار موجود.
**Steps to Execute:**
1. اسحب إشعارًا لليسار (Dismissible).
2. أكد في الحوار (`deleteNotificationConfirm`).
**Expected Results:**
- يظهر خلفية حمراء للسحب؛ بعد التأكيد يُحذف العنصر؛ يتناقص العدّاد إن كان غير مقروء؛ (logcat: `DELETE notifications/:id`).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-140
**Test Scenario:** حذف الكل (Clear all) مع تأكيد
**Feature:** Notifications — `DELETE /notifications` (delete all)
**Priority:** High
**Test Type:** Functional (Destructive!)
**Preconditions:** توجد إشعارات.
**Steps to Execute:**
1. اضغط أيقونة `delete_sweep_outlined` ← أكد في الحوار العربي ("سيتم حذف كل الإشعارات نهائيًا؟").
**Expected Results:**
- تُمسح القائمة كلها (تفاؤلي مع تراجع عند الفشل)؛ عدّاد صفر؛ logcat: `DELETE notifications`.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-141
**Test Scenario:** فلتر All / Read / Unread المحلية
**Feature:** Notifications — local read filter
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** إشعارات مختلطة القراءة/غير القراءة.
**Steps to Execute:**
1. بدّل الشرائح: `All` ← `Read` ← `Unread`.
**Expected Results:**
- كل فلتر يعرض المناسب فقط؛ لا طلبات شبكة مع كل تبديل (فصل محلي).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-142
**Test Scenario:** عدّاد الجرس على Home يتزامن مع القراءة/الحذف
**Feature:** Notifications — badge sync
**Priority:** High
**Test Type:** Integration
**Preconditions:** عدّاد Home > 0.
**Steps to Execute:**
1. سجّل عدّاد الجرس في Home.
2. افتح الإشعارات ← اقرأ واحدًا (বা الكل).
3. ارجع للـ Home.
**Expected Results:**
- عدّاد الجرس متراجع بنفس المقدار (نفس `NotificationsCubit` instance app-wide)؛ يختفي عند 0.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-143
**Test Scenario:** حالة عدم وجود إشعارات
**Feature:** Notifications — empty state
**Priority:** Low
**Test Type:** UI
**Preconditions:** حساب بلا إشعارات (أو بعد مسح الكل).
**Steps to Execute:**
1. افتح الإشعارات.
**Expected Results:**
- `NoDataWidget` (أيقونة Validation.svg + رسالة `noNotificationsOfThisType`)؛ لا شريط أخطاء.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

## 3.20 Chat

**Test Case ID:** TC-144
**Test Scenario:** فتح محادثة مع بائع من شاشة المنتج
**Feature:** Chat — `POST /conversations` (create-or-reopen)
**Priority:** Critical
**Test Type:** Functional
**Preconditions:** مستخدم ≠ البائع؛ البائع يقبل الدردشة.
**Steps to Execute:**
1. من تفاصيل منتج بائع آخر اضغط "تواصل الآن" (`StartChatButton`).
**Expected Results:**
- يُنشأ/يُعاد فتح `Conversation` وتنتقل للمحادثات بـ `pushNamed(Routes.chatView)`؛ يحدث قرص/تحديث القائمة؛ الزر مخفي إن كنت مالك المنتج (زرار التواصل لا يظهر لك أصلًا).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-145
**Test Scenario:** إرسال رسالة نصية
**Feature:** Chat — `POST /conversations/:id/messages` (text)
**Priority:** Critical
**Test Type:** Functional
**Preconditions:** محادثة مفتوحة.
**Test Data:** نص `مرحبا QA`.
**Steps to Execute:**
1. اكتب النص في حقل الكتابة.
2. اضغط زر الإرسال (الممتلئ accent).
**Expected Results:**
- تظهر فقاعتي "أنا" فورًا (optimistic) على اليمين بأرضية accent ونص أبيض + ticks (✓✓ زرقاء إن قُرئت)؛ الإرسال للسيرفر في الخلفية؛ النص يبقى في القائمة بلا تكرار.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-146
**Test Scenario:** إرسال صورة (كاميرا ثم معرض)
**Feature:** Chat — send image (multipart)
**Priority:** High
**Test Type:** Functional
**Preconditions:** الأذونات ممنوحة؛ صورة < 5MB (JPG/PNG/WEBP).
**Test Data:** صورة اختبار.
**Steps to Execute:**
1. افتح attachment sheet ← اختر "كاميرا" ← التقط الصورة.
2. كرّر بخيار "معرض" ← اختر صورة.
**Expected Results:**
- تُعرض المصغرات في المحادثة immmediately (optimistic)؛ تُرفع `multipart image`؛ النوع `image`؛ حجم ≤ 5MB يُقبل؛ أكبر يُرفض برسالة محلية.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-147
**Test Scenario:** استقبال رسائل من الطرف الآخر (Polling)
**Feature:** Chat — polling (1 min)
**Priority:** High
**Test Type:** Integration
**Preconditions:** المحادثة مفتوحة وحساب الطرف الآخر على جهاز ثانٍ.
**Test Data:** رسالة من الطرف الثاني.
**Steps to Execute:**
1. من حساب B أرسل "اختبار الطرف الآخر".
2. على شاشة A انتظر التحديث التلقائي.
**Expected Results:**
- تظهر الرسالة تلقائيًا خلال دقيقة (poll بـ `after_id`) بعد عودة التطبيق للواجهة (resume)؛ إن كانت الواجهة مفتوحة تُدمج لحظيًا؛ ticks أزرق على رسائلك بعد قراءة B.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-148
**Test Scenario:** تعليم المحادثة كمقروءة وتصفير العدادات
**Feature:** Chat — `PATCH /conversations/:id/read`
**Priority:** High
**Test Type:** Functional
**Preconditions:** محادثة بها رسائل غير مقروءة للعمود A.
**Steps to Execute:**
1. افتح المحادثة.
**Expected Results:**
- `PATCH .../read` يُرسل؛ تُكتب `is_read=true` محليًا؛ عدّاد المحادثة يُصفر؛ `ChatUnreadCubit` يتناقص عالميًا؛ شارة تبويب الشات تتناقص.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-149
**Test Scenario:** حذف رسالتك (stub "رسالة محذوفة")
**Feature:** Chat — `DELETE /conversations/:cid/messages/:mid`
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** رسالة لك مرسلة مسبقًا.
**Steps to Execute:**
1. Long-press رسالتك ← "حذف" (أو delete icon).
**Expected Results:**
- تُستبدل ببطاقة "رسالة محذوفة" (blocked icon، أحمر) محل fallback؛ يُنفذ `DELETE message`؛ الطرف الآخر عند poll يرى نفس الـ stub.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-150
**Test Scenario:** حذف/إخفاء محادثة من القائمة
**Feature:** Chat — `DELETE /conversations/:id` (hide)
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** محادثة موجودة.
**Steps to Execute:**
1. في القائمة: اضغط مطولًا أو أيقونة الحذف ← أكد.
**Expected Results:**
- تختفي المحادثة من قائمتك فقط (hide, not delete for other party)؛ عدّاد غير المقروء يتناقص؛ السجل لطرف A فقط لا يتأثر.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-151
**Test Scenario:** عداد التبويب غير المقروء على Tabs يعكس الواقع
**Feature:** ChatUnreadCubit — badges
**Priority:** High
**Test Type:** Functional
**Preconditions:** حساب A به محادثات غير مقروءة.
**Steps to Execute:**
1. من الحساب B أرسل 3 رسائل.
2. على A تعطّل التطبيق وافتحه (resume).
3. لاحظ شارة تبويب الشات.
**Expected Results:**
- الشارة تُظهر عدد غير المقروء (99+ cap)؛ عند فتح المحادثات تُحدّث/تصفر حسب ما قرأ؛ `99+` إن تجاوزت 99.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-152
**Test Scenario:** صفحة المحادثات — حالة فارغة + حالة تحميل + خطأ
**Feature:** Conversations — states
**Priority:** Medium
**Test Type:** UI
**Preconditions:** حساب بلا محادثات.
**Steps to Execute:**
1. افتح تبويب المحادثات بحساب جديد.
**Expected Results:**
- تظهر `ConversationsEmpty` (أيقونة forum + رسالة `noConversations`)؛ أثناء الجلب Shimmer 6 عناصر؛ عند خطأ: زر "محاولة مرة أخرى".
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-153
**Test Scenario:** السيرفر يعيد unread_count → ألويتها للمحفوظ محليًا
**Feature:** Chat — server unread_count sync
**Priority:** Medium
**Test Type:** Integration (Needs Dev Support)
**Preconditions:** A به 3 غير مقروء؛ السيناريو: افتح المحادثة من جهاز آخر.
**Steps to Execute:**
1. بحساب A: افتح المحادثة من جهاز ثانٍ وقرأ الكل.
2. على الجهاز الأول انتظر التحديث (poll 2 دقيقة/resume).
**Expected Results:**
- تُصفر الشارات بعد التزامن مع `unread_count` السيرفري (اللي بدوره يتحدث مع كل قراءة).
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) جهاز ثانٍ للقراءة.

---

**Test Case ID:** TC-154
**Test Scenario:** صورة أكبر من 5MB تُرفض برسالة محلية
**Feature:** Chat — image size validation
**Priority:** Medium
**Test Type:** Validation
**Preconditions:** صورة > 5MB متاحة.
**Test Data:** ملف صورة أكبر من 5MB.
**Steps to Execute:**
1. حاول إرسال الصورة من المرفقات.
**Expected Results:**
- رسالة محلية "حجم الصورة يجب ألا يتجاوز 5MB"؛ لا يُرفع الملف.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-155
**Test Scenario:** Send button معطل عند فارغ النص
**Feature:** Chat — send button state
**Priority:** Low
**Test Type:** UI
**Preconditions:** المحادثة مفتوحة.
**Steps to Execute:**
1. راقب زر الإرسال بحقل فارغ ثم اكتب شيئًا ثم امسحه.
**Expected Results:**
- أخضر معبأ accent إلا والنص فارغ → رمادي/غير مفعل؛ توقيت إرسال ≈ لحظة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-156
**Test Scenario:** الكتابة بالعربية متعددة الأسطر في حقل الرسالة
**Feature:** Chat — multiline input
**Priority:** Low
**Test Type:** UI
**Preconditions:** المحادثة مفتوحة.
**Test Data:** نص عربي بصيغته متعددة الأسطر.
**Steps to Execute:**
1. اكتب نصًا فيها سطرًا جديدًا (Enter).
**Expected Results:**
- الحقل يتوسع حتى ~42px ارتفاع؛ النص يُرسل بفواصله الحقيقية؛ الفقاعات تعرض التنسيق بطريقة سليمة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

## 3.21 Report & Complaints (الإبلاغ)

**Test Case ID:** TC-157
**Test Scenario:** التبليغ عن إعلان من شاشة تفاصيّل: اختيار سبب والإرسال
**Feature:** ReportProduct — `GET /reportReasons` + `POST /reportAd`
**Priority:** High
**Test Type:** Functional
**Preconditions:** مستخدم ≠ مالك الإعلان.
**Test Data:** وصف `هذا المنتج ينتهك الشروط QA`.
**Steps to Execute:**
1. من تفاصيل المنتج ← "الإبلاغ والدعم".
2. اختر سببًا من القائمة (شارة accent + ✓).
3. أضف وصفًا اضافيًا.
4. اضغط "Send".
**Expected Results:**
- Toast نجاح (`reportSent`)؛ `POST reportAd` بـ `{seller_id, product_id, reason, description}`؛ تُعاد الشاشة `pop(true)`؛ تُمسح الاختيارات.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-158
**Test Scenario:** الإرسال بدون اختيار سبب يُظهر رسالة تحقق
**Feature:** ReportProduct — reason required
**Priority:** High
**Test Type:** Validation
**Preconditions:** شاشة التبليغ مفتوحة.
**Test Data:** لا شيء مختار.
**Steps to Execute:**
1. لا تختر أي سبب؛ اكتب وصفًا فقط.
2. اضغط "Send".
**Expected Results:**
- Snackbar `pleaseSelectReason`؛ لا يُرسل الطلب.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-159
**Test Scenario:** شكوى عامة (من المساعدة) بأنواع من السيرفر
**Feature:** ReportProduct — general complaint (`GET /complaintsTypes` + `POST /addComplaint`)
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** حساب مسجل.
**Test Data:** رسالة `QA شكوى اختبار`.
**Steps to Execute:**
1. المساعدة ← "Report" (Subtitle: reportProduct).
2. اختر نوع الشكوى من القائمة.
3. اكتب الرسالة ← اضغط "Send".
**Expected Results:**
- القائمة ممتلئة بأنواع من السيرفر (ديناميكية)؛ `POST addComplaint` بـ `{complaint_id, message}`؛ Toast نجاح؛ تُصفَر الحقول.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-160
**Test Scenario:** قائمة أنواع الشكاوى الفاشلة (لا تُحمّل)
**Feature:** ReportProduct — complaints load failure
**Priority:** Low
**Test Type:** Error Handling
**Preconditions:** افصل الإنترنت بعد الإقلاع (الأنواع تجلب عند الإقلاع).
**Steps to Execute:**
1. بدون إنترنت افتح مسار الشكوى العامة.
**Expected Results:**
- القائمة فارغة/أو خطأ بحالة مناسبة؛ لا انهيار؛ (ملاحظة: ما يجيب `getAllComplaintsTypesData` يقع مرة واحدة عند الإقلاع).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-161
**Test Scenario:** التبليغ كـ Guest يُمنع بالدخول
**Feature:** ReportProduct — guest restriction
**Priority:** High
**Test Type:** Security
**Preconditions:** Guest في شاشة المنتج.
**Steps to Execute:**
1. كزائر اضغط "الإبلاغ والدعم".
**Expected Results:**
- حوار "تسجيل مطلوب" يظهر؛ لا يفتح مسار التبليغ.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

## 3.22 Help & Support (بيعلي — المساعدة والدعم)

**Test Case ID:** TC-162
**Test Scenario:** فتح شاشة المساعدة وكل عناصرها
**Feature:** HelpSupport — static page
**Priority:** Medium
**Test Type:** UI/Functional
**Preconditions:** أي دور.
**Steps to Execute:**
1. من الإعدادات ← "Reporting and Support".
2. راجع كل العناصر: Chat / Email / Call us / Report / Common Questions.
**Expected Results:**
- Chat → `HelpSupportChatView`؛ Email → `mailto` (يفتح تطبيق البريد برسالة بمفتاح subject)؛ Call us → حوار الاتصال بـ `tel:`؛ Report → `ReportTheProductView` (الشكوى العامة)؛ "Common Questions" → بطاقتي الأسئلة الشائعة القابلة للتمديد (نصوص عربية ثابتة).
- **ملاحظة**: أرقام الهاتف/البريد في الشاشة مهاردكود وقد لا تتطابق مع الروابط الفعلية (بين `bi3lyapp@example.com` المعروض و`mustafa.bahr12323@gmail.com` في `mailto`).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-163
**Test Scenario:** شات الدعم المحلي — إرسال رسالة
**Feature:** HelpSupportChat — local (no API)
**Priority:** Low
**Test Type:** Functional
**Preconditions:** شاشة HelpSupportChat مفتوحة.
**Test Data:** نص `مشكلتي المثال QA`.
**Steps to Execute:**
1. اكتب في الحقل ← اضغط أيقونة الإرسال.
**Expected Results:**
- تُضاف رسالتك إلى القائمة (newest-first)؛ التمرير للأسفل تلقائيًا؛ **الرسائل محفوظة في الذاكرة فقط وتُفقد عند مغادرة الشاشة**.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-164
**Test Scenario:** زر الكاميرا في شات الدعم لا يفعل شيئًا
**Feature:** HelpSupportChat — camera icon (dead)
**Priority:** Low
**Test Type:** UI (Documentation)
**Preconditions:** شاشة HelpSupportChat.
**Steps to Execute:**
1. اضغط أيقونة الكاميرا.
**Expected Results:**
- (سلوك الكود الحالي) لا يحدث شيء — توثيق ملاحظة فقط، وليست دليل فشل متوقع.
**Actual Results:**
**Status:** Not Run
**Notes:** ملاحظة: الكاميرا غير مربوطة بوظيفة — انظر قسم 11 (الديون التقنية).

---

## 3.23 Legal Content & How to Purchase

**Test Case ID:** TC-165
**Test Scenario:** صفحة About تعرض HTML السيرفر
**Feature:** LegalContent — `GET /about`
**Priority:** Low
**Test Type:** Integration
**Preconditions:** إنترنت.
**Steps to Execute:**
1. الإعدادات ← Legal info ← "About the App".
**Expected Results:**
- `LegalContentView` بنوع About؛ تعرض HTML بـ `flutter_html`؛ العناوين بلون التطبيق؛ الخط RTL إن كانت `direction=rtl`؛ لدى الخطأ: `CustomErrorWidget` + إعادة محاولة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-166
**Test Scenario:** صفحة Terms & Conditions
**Feature:** LegalContent — `GET /terms`
**Priority:** Low
**Test Type:** Integration
**Steps to Execute:**
1. الإعدادات ← Legal info ← "Terms & Conditions".
**Expected Results:**
- تعرض محتوى الشروط بتنسيق HTML؛ روابط السيرفر تفتح بالمتصفح الخارجي.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-167
**Test Scenario:** صفحة Privacy Policy
**Feature:** LegalContent — `GET /privacy`
**Priority:** Low
**Test Type:** Integration
**Steps to Execute:**
1. الإعدادات ← Legal info ← "Privacy Policy".
**Expected Results:**
- تعرض سياسة الخصوصية HTML؛ نفس سلوك RTL والخطأ أعلاه.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-168
**Test Scenario:** صفحة "تعليمات الشراء" من تفاصيل المنتج
**Feature:** HowToMakePurchase — `GET /purchaseInstructions`
**Priority:** Medium
**Test Type:** Integration
**Steps to Execute:**
1. من تفاصيل أي منتج اضغط "How is the purchase made?" / "تعليمات الشراء".
**Expected Results:**
- تعرض HTML من السيرفر؛ RTL إن كان `direction=rtl`؛ عند خطأ: زر إعادة المحاولة يعمل.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-169
**Test Scenario:** الروابط داخل المحتويات القانونية تفتح خارجيًا
**Feature:** LegalContent — onLinkTap
**Priority:** Low
**Test Type:** Integration
**Preconditions:** المحتوى يحتوي رابطًا.
**Steps to Execute:**
1. افتح About ← اضغط أي رابط داخل النص.
**Expected Results:**
- الرابط يُفتح في المتصفح الخارجي (`LaunchMode.externalApplication`)؛ لا داخل التطبيق.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

## 3.24 Privacy Settings / Change Language / Theme

**Test Case ID:** TC-170
**Test Scenario:** إعدادات الخصوصية — وسيلة التواصل المفضلة
**Feature:** Privacy — `GET /settings` + `PATCH /settings`
**Priority:** High
**Test Type:** Functional
**Preconditions:** مستخدم.
**Test Data:** الهاتف `01099998888`.
**Steps to Execute:**
1. الإعدادات ← "Privacy".
2. لاحظ رقائق الطرق الثلاث (شات بيعلي / هاتف / كلاهما — أو كما يرجع السيرفر `contact_methods`).
3. اختر "Phone"؛ عدّل رقم الهاتف.
4. اضغط Save.
**Expected Results:**
- `GET settings` يعبئ القيم الحالية؛ `PATCH settings` بـ `{contact_method, contact_phone, notify_new_products, store_name?, store_address?}`؛ Toast تأكيد (`settingsUpdated`)؛ الصفحة تُغلق بـ `pop` والبريد البروفايل يُزامَن.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-171
**Test Scenario:** مفتاح "إشعارات المنتجات الجديدة" يُحفظ
**Feature:** Privacy — notify_new_products
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** شاشة الخصوصية.
**Steps to Execute:**
1. بدّل مفتاح "New products notifications" ← اضغط Save ← ارجع ← افتح مجددًا.
**Expected Results:**
- الحالة تُحفظ بعد الـ PATCH؛ عند إعادة الفتح تبقى الحالة الجديدة (من السيرفر).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-172
**Test Scenario:** بطاقة المتجر تُعرض عند وجود بيانات متجر
**Feature:** Privacy — store card
**Priority:** Low
**Test Type:** UI
**Preconditions:** البروفايل يحتوي `store_name`/`store_address` (Needs Backend لتعيينهما).
**Steps to Execute:**
1. افتح الخصوصية.
**Expected Results:**
- تظهر بطاقة "المتجر"/العنوان مع أيقونة المتجر؛ لا تظهر إن كانت فارغة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-173
**Test Scenario:** مفتاح "Notify" في البروفايل لا يُحفظ ولا يؤثر
**Feature:** Profile — fake Notify switch (documentation)
**Priority:** Low
**Test Type:** UI/Documentation
**Preconditions:** تبويب الحساب.
**Steps to Execute:**
1. بدّل مفتاح Notify في بطاقة الإعدادات.
2. أغلق التطبيق وافتح مجددًا.
**Expected Results:**
- (سلوك الكود الحالي) المفتاح يعود افتراضيًا (`switchValue` محلي وغير محفوظ ولا متصل بأي API)؛ توثيق ملاحظة فقط.
**Actual Results:**
**Status:** Not Run
**Notes:** موثق في قسم الديون التقنية (11).

---

**Test Case ID:** TC-174
**Test Scenario:** حفظ/فشل حفظ إعدادات الخصوصية
**Feature:** Privacy — save failure
**Priority:** Medium
**Test Type:** Error Handling
**Preconditions:** افصل الإنترنت ← ادخل الخصوصية ← عدّل ثم Save.
**Steps to Execute:**
1. بدون إنترنت غيّر وسيلة التواصل واضغط Save.
**Expected Results:**
- رسالة خطأ (إن لم يوجد تخزين مؤقت للحالة)؛ لا انهيار؛ القيم تعود للسابقة بعد إعادة الفتح مع الإنترنت.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

## 3.25 Guest Mode (وضع الزائر)

**Test Case ID:** TC-175
**Test Scenario:** الدخول كزائر — كل شيء مقروء
**Feature:** GuestGuard — enterAsGuest
**Priority:** Critical
**Test Type:** Functional
**Preconditions:** تثبيت نظيف.
**Test Data:** لا شيء.
**Steps to Execute:**
1. في LoginView ← اضغط "Continue as guest" (أو زر المتابعة كزائر).
**Expected Results:**
- `AuthCubit.loginAsGuest()` → `isGuest=true`؛ الانتقال إلى `LayoutView`؛ التبويبات 0 (Home) و2 (Search) تعمل بحرية.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-176
**Test Scenario:** الزائر يُمنع من تبويب Chat
**Feature:** GuestGuard — restricted tabs
**Priority:** High
**Test Type:** Security
**Preconditions:** Guest.
**Steps to Execute:**
1. كزائر اضغط تبويب Chat.
**Expected Results:**
- لا يتبدل التبويب؛ حوار "تسجيل مطلوب" مع خيار "تسجيل دخول"؛ (إلغاء → تبقى على Home).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-177
**Test Scenario:** الزائر يُمنع من تبويب Ads وتبويب Account
**Feature:** GuestGuard — Ads & Account tabs
**Priority:** High
**Test Type:** Security
**Preconditions:** Guest.
**Steps to Execute:**
1. كزائر اضغط تبويب Ads.
2. كزائر اضغط تبويب Account.
**Expected Results:**
- نفس الحوار في كليهما؛ التبويبات لا تفتح.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-178
**Test Scenario:** الزائر يرى GuestPlaceholder في تبويب الحساب بعد قفزة غير متوقعة
**Feature:** GuestGuard — GuestPlaceholder
**Priority:** Medium
**Test Type:** UI
**Preconditions:** Guest.
**Steps to Execute:**
1. كزائر حاول فتح الحساب بطريقة غير مباشرة إن أمكن (مثلاً وقت تشغيل `ProfileView` مباشرة — Needs Dev Support).
**Expected Results:**
- `GuestPlaceholder` مع أيقونة شخص وزر "تسجيل الدخول" يعيد `exitToLogin` → LoginView + مسح `LayoutCubit.pageIndex = 0`.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) لتشغيل المسار بطريقة غير تقليدية.

---

**Test Case ID:** TC-179
**Test Scenario:** من الزائر إلى حساب مسجل (ترقية الجلسة)
**Feature:** GuestGuard — login upgrade
**Priority:** High
**Test Type:** Functional
**Preconditions:** Guest داخل التطبيق.
**Test Data:** حساب مسجل صالح.
**Steps to Execute:**
1. كزائر اضغط أيقونة شخص/تسجيل دخول (أو سجّل خروج ثم ادخل ببياناته).
2. سجّل دخولًا بحساب حقيقي.
**Expected Results:**
- `AuthCubit.loginWithToken` يحذف علم guest (`isGuest=false`) ويحفظ التوكن؛ تصبح التبويبات Chat/Ads/Account متاحة فورًا؛ Home تعيد جلب البيانات بحساب جديد (بما فيها البروفايل والعدادات).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

# 4. اختبارات المصادقة (Authentication)

**Test Case ID:** TC-180
**Test Scenario:** تسجيل دخول ببيانات صحيحة (مسموح)
**Feature:** Login — happy path
**Priority:** Critical
**Test Type:** Functional
**Preconditions:** حساب مفعل موجود.
**Test Data:** هاتف `01012345678`/`Test1234!` (أو حسابك الحقيقي).
**Steps to Execute:**
1. من Onboarding ← Login.
2. أدخل الهاتف وكلمة المرور.
3. اضغط "تسجيل الدخول".
**Expected Results:**
- `CustomLoading` ثم Toast نجاح (رسالة السيرفر)؛ `AuthCubit.loginWithToken` يحفظ التوكن؛ الانتقال إلى `LayoutView` (إزالة كل الـ stack)؛ البروفايل يتحدث.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-181
**Test Scenario:** تسجيل دخول بكلمة مرور خاطئة
**Feature:** Login — invalid credentials
**Priority:** Critical
**Test Type:** Functional/Negative
**Preconditions:** حساب موجود.
**Test Data:** الهاتف الصحيح + كلمة المرور `WrongPass999`.
**Steps to Execute:**
1. أدخل الهاتف الصحيح بكلمة مرور خاطئة.
2. اضغط تسجيل الدخول.
**Expected Results:**
- رسالة خطأ واضحة (رسالة السيرفر — `status=false`) في Toast؛ لا انتقال؛ التوكن لا يُحفظ (التطبيق لا يدخل).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-182
**Test Scenario:** حقول الدخول فارغة
**Feature:** Login — empty fields
**Priority:** High
**Test Type:** Validation
**Preconditions:** شاشة Login.
**Test Data:** لا شيء.
**Steps to Execute:**
1. اضغط "تسجيل الدخول" مع حقل فارغ/فارغين.
**Expected Results:**
- رسالة تحقق للهاتف (حقل مطلوب) تظهر؛ (كلمة المرور **ليست لها validator** في الكود الحالي — أي قيمة تُمر رغم عدم وجودها) — ملاحظة توثيقية.
**Actual Results:**
**Status:** Not Run
**Notes:** ملاحظة: حقل كلمة المرور في الدخول بدون validator حاليًا.

---

**Test Case ID:** TC-183
**Test Scenario:** هاتف مرخص/فارغ غير موجود في النظام
**Feature:** Login — unknown phone
**Priority:** High
**Test Type:** Functional/Negative
**Preconditions:** هاتف غير مستخدم في التسجيل.
**Test Data:** `01000000001`.
**Steps to Execute:**
1. سجّل دخولًا بهذا الهاتف مع أي كلمة.
**Expected Results:**
- رسالة خطأ واضحة؛ لا الدخول؛ لا توكن.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-184
**Test Scenario:** تكرار كلمة المرور الخاطئة — لا قفل واضح
**Feature:** Login — repeated failures
**Priority:** Medium
**Test Type:** Security
**Preconditions:** حساب موجود.
**Test Data:** كلمة مرور خاطئة مكررة ×5.
**Steps to Execute:**
1. أدخل كلمة المرور الخاطئة 5 مرات متتالية.
**Expected Results:**
- (السلوك الحالي) **لا يوجد قفل للحساب** على مستوى التطبيق (لا حد للمحاولات، لا captcha)؛ كل محاولة تُظهر خطأ فقط. يُوثّق كملاحظة أمنية.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-185
**Test Scenario:** تسجيل خروج ثم Back لا يعيد الدخول للجلسة
**Feature:** Logout + stack clearing
**Priority:** High
**Test Type:** Security
**Preconditions:** مستخدم مسجل داخل التطبيق.
**Steps to Execute:**
1. من Profile ← Sign Out ← أكد.
2. اضغط Back عدة مرات.
**Expected Results:**
- الانتقال إلى LoginView (`pushNamedAndRemoveUntil` مسح كامل للـ stack)؛ لا رجوع إلى LayoutView بدون تسجيل دخول جديد؛ التوكن ممسوح.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-186
**Test Scenario:** استمرارية الجلسة عبر إعادة تشغيل التطبيق
**Feature:** Login — token persistence
**Priority:** High
**Test Type:** Functional
**Preconditions:** مستخدم قام بتسجيل دخول.
**Steps to Execute:**
1. Kill التطبيق كليًا.
2. افتحه مجددًا.
**Expected Results:**
- شاشة سبلاش تمضي ثم LayoutView مباشرة (لا Onboarding/Login) بفضل التوكن المحفوظ في secure storage.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-187
**Test Scenario:** انتهاء الجلسة (401) يجبر الخروج إلى Login
**Feature:** ApiService — global 401 logout
**Priority:** Critical
**Test Type:** Security/Integration
**Preconditions:** جلسة نشطة + القدرة على إبطال التوكن (Needs Dev Support — مثلا بإبطال من الخادم).
**Steps to Execute:**
1. بعد تسجيل الدخول، اجعل التوكن منتهيًا.
2. نفّذ أي طلب (مثلاً افتح Profile).
**Expected Results:**
- تظهر Toast "youLoggedOutPleaseLoginAgain"؛ يُمسح التوكن والكاش؛ الانتقال القسري إلى LoginView؛ (لا داعي لطلب آخر لإثبات الخروج).
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) لإبطال التوكن من الخادم.

---

**Test Case ID:** TC-188
**Test Scenario:** الدخول كزائر ← تسجيل دخول ← يعود للحساب
**Feature:** Guest → Login upgrade flow
**Priority:** High
**Test Type:** Functional
**Preconditions:** Guest داخل السوق.
**Test Data:** حساب حقيقي.
**Steps to Execute:**
1. كزائر افتح صفحة أي منتج.
2. ارجع إلى الحساب/الإعدادات ← سجّل دخول.
**Expected Results:**
- بعد الدخول تتحول فئة المستخدم (Guest→User)؛ كل الشاشات المقيدة تتفعل؛ البيانات الخاصة بالحساب (profile/fav/notifications) تُجلب.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-189
**Test Scenario:** تسجيل الدخول بدون إنترنت
**Feature:** Login — network failure
**Priority:** High
**Test Type:** Error Handling
**Preconditions:** إنترنت مقطوع.
**Steps to Execute:**
1. افصل الإنترنت.
2. أدخل بيانات صحيحة واضغط تسجيل الدخول.
**Expected Results:**
- Toast/Error بنوع "noInternet"/فشل الاتصال؛ لا انتقال؛ الحقول تبقى بما هو مكتوب.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-190
**Test Scenario:** التسجيل ببريد/هاتف مستخدم سابقًا
**Feature:** Register — duplicate
**Priority:** High
**Test Type:** Functional/Negative
**Preconditions:** حساب مسجل بنفس البريد/الهاتف.
**Test Data:** نفس بيانات حساب موجود.
**Steps to Execute:**
1. حاول التسجيل بنفس البريد والهدف.
**Expected Results:**
- رسالة خطأ من السيرفر (بالبريد أو الهاتف مكرر) تظهر في Toast؛ لا يتم الدخول.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-191
**Test Scenario:** تسجيل دخول ثم إغلاق التطبيق أثناء التنقل
**Feature:** Login — interruption
**Priority:** Low
**Test Type:** Edge Case
**Preconditions:** جلسة login ناجحة.
**Steps to Execute:**
1. سجّل دخولًا ناجحًا.
2. Kill التطبيق فورًا عند الوصول للـ LayoutView.
3. افتح مجددًا.
**Expected Results:**
- لا دخول مكسور للشاشة السابقة؛ يفتح على LayoutView بحالة سليمة؛ العدادات تتجدد.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-192
**Test Scenario:** تأكيد مسح التوكن من التخزين عند تسجيل الخروج
**Feature:** Logout — storage verification
**Priority:** High
**Test Type:** Security (Needs Dev Support)
**Preconditions:** مستخدم مسجل.
**Steps to Execute:**
1. تحقق عبر App Inspector/adb من وجود `userToken` في FlutterSecureStorage.
2. سجّل خروجًا.
3. تحقق مرة أخرى.
**Expected Results:**
- بعد الخروج يمسح التطبيق: `FlutterSecureStorage.deleteAll()` + `CacheTokenManger.clearUserToken()` + `CacheHelper.clearUserData()`؛ لا توكن متبقٍ.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) لـ App Inspector / adb backup.

---

**Test Case ID:** TC-193
**Test Scenario:** مصفوفة الوصول حسب الدور (Guest vs User)
**Feature:** Roles — access matrix
**Priority:** Critical
**Test Type:** Security
**Preconditions:** حساب Guest وحساب مسجل.
**Steps to Execute:**
1. كزائر حاول كلًا من: فتح Chat، فتح Ads، فتح Account، فتح شاشة التفضلة (Fav)، فتح الإشعارات، إضافة مفضلة، تقييم، تبليغ، نشر إعلان.
2. سجّل دخولًا كمستخدم وكرر نفس المسار.
**Expected Results:**
- Guest: لا تصل لأيٍّ منها (حوار تسجيل مطلوب أو `GuestPlaceholder`)؛ المقيّد لا يُنفّذ عبر أي مسار.
- User: كل ما سبق متاح ويُنفّذ.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-194
**Test Scenario:** تسجيل دخول بحساب غير مفعل (إن وجد)
**Feature:** Login — inactive account (documented gap)
**Priority:** Medium
**Test Type:** Functional (Documentation)
**Preconditions:** حساب بحقل `is_active=false` في الخادم (Needs Backend).
**Steps to Execute:**
1. سجّل دخولًا بالحساب غير المفعل.
**Expected Results:**
- (السلوك الحالي) **الشاشة تجمد على حالة تحميل** (`isActive == false` لا تُصدر أي state في الكود)؛ ملاحظة توثيقية موجهة للمطور — سلوك فعلي حالي وليس مفترضًا.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) لتوفير حساب غير مفعل — السلوك الحالي موثق كعيب في القسم 11.

---

**Test Case ID:** TC-195
**Test Scenario:** OTP منتهي الصلاحية / تستخدم كودًا قديمًا
**Feature:** OTP — expired code
**Priority:** Medium
**Test Type:** Negative
**Preconditions:** نفس الإيميل بسجل OTP قديم من جلسة سابقة.
**Test Data:** كود OTP قديم.
**Steps to Execute:**
1. أدخل كود OTP القديم في OtpView.
**Expected Results:**
- رسالة خطأ واضحة من السيرفر (كود خاطئ/منتهي)؛ لا الدخول؛ خيار Resend متاح بعد 60 ث لطلب كود جديد.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-196
**Test Scenario:** تحويل الحساب من Guest إلى مسجل ثم نفس المحتوى يُزامن
**Feature:** Roles — content after upgrade
**Priority:** High
**Test Type:** Integration
**Preconditions:** Guest تصفح بعض المنتجات؛ بعضها أضيف مفضلة (يُرفض)، ثم سُجل دخول.
**Steps to Execute:**
1. كزائر لاحظ تفاصيل منتج X.
2. سجّل دخولًا.
3. ارجع لنفس تفاصيل X.
**Expected Results:**
- بعد الدخول يظهر زر القلب/التفضلة يعمل وحالة المفضلة تتناغم مع السيرفر (لا تُورث أي قلب "وهمي" من جلسة Guest).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

# 5. اختبارات الواجهة والتنقل (UI & Navigation)

**Test Case ID:** TC-197
**Test Scenario:** زر الرجوع مرتين للخروج من التطبيق
**Feature:** LayoutView — PopScope
**Priority:** Medium
**Test Type:** UI
**Preconditions:** LayoutView مفتوحة على تبويب Home.
**Steps to Execute:**
1. اضغط Back مرة واحدة — لاحظ Snackbar `goBackExit`.
2. خلال ثانيتين اضغط Back مرة أخرى.
**Expected Results:**
- الضغطة الأولى: Snackbar "اذهب للخلف مرة أخرى للخروج"؛ الضغطة الثانية خلال المهلة: خروج التطبيق (`SystemNavigator.pop`).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-198
**Test Scenario:** التبديل بين التبويبات الخمسة كلها
**Feature:** Layout — bottom tabs (FlashyTabBar)
**Priority:** High
**Test Type:** Navigation
**Preconditions:** مستخدم مسجل.
**Steps to Execute:**
1. اضغط بالتتابع: Home ← Chat ← Search ← Ads ← Account.
**Expected Results:**
- كل تبويب يفتح محتواه الصحيح؛ التحديد الحالي بلون accent؛ الشات يُظهر شارة بجانب الأيقونة إن وُجدت رسائل غير مقروءة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-199
**Test Scenario:** شارة تبويب الشات تُظهر 99+ عند تجاوز 99
**Feature:** Layout — chat badge cap
**Priority:** Medium
**Test Type:** UI (Needs Dev Support)
**Preconditions:** حساب برسائل غير مقروءة > 99 (يحتاج تجهيز — حساب مزدحم).
**Steps to Execute:**
1. افتح LayoutView.
**Expected Results:**
- الشارة تعرض `99+` بدل الرقم الكامل (حد أقصى).
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) لتجهيز حساب بـ 99+ رسالة غير مقروءة.

---

**Test Case ID:** TC-200
**Test Scenario:** جرس الإشعارات على Home يعرض العدّاد
**Feature:** Home — notifications badge
**Priority:** Medium
**Test Type:** UI
**Preconditions:** unreadCount > 0.
**Steps to Execute:**
1. راقب أيقونة الجرس أعلى Home.
**Expected Results:**
- شارة بالرقم غير المقروء؛ تختفي عند صفر؛ عند فتح الإشعارات وقراءة الكل يختفي فورًا.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-201
**Test Scenario:** RTL كامل عند العربية
**Feature:** RTL — Arabic layout
**Priority:** High
**Test Type:** UI
**Preconditions:** العربية مفعلة.
**Steps to Execute:**
1. تنقل بين: Home، Search، Profile، ProductDetails، Settings.
**Expected Results:**
- المحاذاة يمين، الأيقونات الاتجاهية معكوسة، حقول تبدأ من اليمين؛ لا تراكبات للنصوص العربية؛ الشعارات والتبويبات متناسقة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-202
**Test Scenario:** LTR كامل عند الإنجليزية
**Feature:** LTR — English layout
**Priority:** Medium
**Test Type:** UI
**Preconditions:** الإنجليزية مفعلة (TC-129).
**Steps to Execute:**
1. تنقل بين نفس الشاشات بالإنجليزية.
**Expected Results:**
- المحاذاة يسار؛ النصوص الإنجليزية سلسة؛ لا العربية المهاردكود المكسورة أوضحت نفسها (نصوص ثابتة مثل "Resend Code", "لا يوجد منتجات في هذا القسم" تبقى عربية — ملاحظة فقط).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-203
**Test Scenario:** Skeleton/Shimmer في كل الشاشات أثناء التحميل
**Feature:** Loading states
**Priority:** Medium
**Test Type:** UI
**Preconditions:** شاشات: Home، Categories، Search، Fav، Notifications، Ads، Details.
**Steps to Execute:**
1. امسح الكاش وافتح كل شاشة على حدة.
**Expected Results:**
- لكل شاشة يظهر Shimmer مطابق لهيكلها (لا أشرطة سوداء فارغة)؛ ينتهي ويُستبدل بالمحتوى.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-204
**Test Scenario:** Responsive — سلوك على شاشة تابلت/صغيرة
**Feature:** ResponsiveBreakpoints
**Priority:** Low
**Test Type:** UI
**Preconditions:** جهاز تابلت أو محاكي بقياس كبير، وجهاز صغير (مثلاً 320dp).
**Steps to Execute:**
1. افتح Home على تابلت.
2. صغّر النافذة/استخدم محاكٍ صغير.
**Expected Results:**
- عند `450+` → TABLET (أعمدة أكثر/أقسام أعرض حسب استخدام `responsive_framework`)؛ عند ~320 لا قص للنصوص ولا تكسر للأزرار؛ `.sp` تتكيف.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-205
**Test Scenario:** كل Empty State تظهر ولا تُخطئ
**Feature:** Empty states
**Priority:** Medium
**Test Type:** UI
**Preconditions:** حساب نظيف: بلا محادثات، بلا مفضلة، بلا إعلانات، بلا إشعارات، بلا حركات محفظة.
**Steps to Execute:**
1. افتح بالتتابع: Ads ← Fav ← Conversations ← Notifications ← Wallet history.
**Expected Results:**
- كل شاشة تعرض حالة عدم وجود بيانات مترجمة أو مناسبة (أيقونة + نص) بدون انهيار وبدون أشرطة خطأ.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-206
**Test Scenario:** صور مكسورة لا تُسقط الشاشات
**Feature:** Image error builders
**Priority:** Medium
**Test Type:** UI
**Preconditions:** منتج/مستخدم برابط صورة ميت (Needs Backend).
**Steps to Execute:**
1. افتح الشاشة التي تعرض الصورة المكسورة.
**Expected Results:**
- تظهر أيقونة خطأ بدل الصورة (errorBuilder / CustomNetWorkImage) بقياس متسق؛ لا قفزات مرئية.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-207
**Test Scenario:** أيقونات وأزرار كل شاشة تعمل (sanity sweep)
**Feature:** Buttons sanity
**Priority:** High
**Test Type:** UI
**Preconditions:** جولة على كل الشاشات الرئيسية.
**Steps to Execute:**
1. مرّ بكل شاشة الرئيسية، واضغط كل زر/أيقونة تكامل معًا (Back، Edit، Share، Search، Filter...).
2. لاحظ الأزرار الفارغة (share في المنتج، عدّل حجم الحملة) ولا تنهار الشاشة.
**Expected Results:**
- الأزرار الوظيفية تستجيب؛ الأزرار غير المربوطة (Share في productDetails) لا تسقط عند الضغط (توثيق فقط).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-208
**Test Scenario:** الانتقال بروابط باسم المسار + وسائط صحيحة/خاطئة
**Feature:** AppRouter — route arguments
**Priority:** High
**Test Type:** Functional (Needs Dev Support)
**Preconditions:** (Needs Dev Support) `Navigator.pushNamed` داخلية.
**Steps to Execute:**
1. (Dev) أرسلت `otpView` بـ arguments كـ `int` بدل `String` عبر route name hand-crafted.
**Expected Results:**
- (Needs Dev Support): التطبيق **ينهار (Type cast crash)** لأن الـ route يتوقع `String` — توثيق فعلى لسلوك الكود؛ لا يجب على الواجهة القائمة أن تسببه، لكن توثيق ضروري للـ Deep Link readiness.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) يتطلب أدوات تطوير/debugging.

---

**Test Case ID:** TC-209
**Test Scenario:** الانتقال لحفظ/استعادة حالة التبويب بعد تسجيل الدخول
**Feature:** Layout — state preservation
**Priority:** Low
**Test Type:** Regression
**Preconditions:** كنت في تبويب Search ثم سجّل دخولًا خارج التطبيق ثم عُد.
**Steps to Execute:**
1. (Needs Dev Support لمحاكاة العودة) بعد إعادة الدخول لاحظ التبويب النشط يعود الافتراضي (Home = 0) بعد تسجيل خروج كامل.
**Expected Results:**
- `LayoutCubit.pageIndex = 0` بعد Logout (السلوك الموثق) — التبويب يعاد إلى Home.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-210
**Test Scenario:** كل أيقونة Back تعيد للوراء بشكل طبيعي
**Feature:** Navigation — back buttons
**Priority:** High
**Test Type:** Navigation
**Preconditions:** التنقل بين عدة شاشات فرعية.
**Steps to Execute:**
1. افتح سلسلة: Home ← Search ← Details ← شاشة التواصل… اضغط Back في كل واحدة.
**Expected Results:**
- كل Back ينقل للوراء خطوة واحدة؛ لا خروج كامل من التطبيق؛ لا مكث على شاشة فارغة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-211
**Test Scenario:** Splash يظهر الشعار بلا اختفاء مفاجئ
**Feature:** Splash — logo animation
**Priority:** Low
**Test Type:** UI
**Preconditions:** تثبيت نظيف.
**Steps to Execute:**
1. راقب أول 4 ثوانٍ ببطء.
**Expected Results:**
- حجم الشعار يكبر بسلاسة (scale animation Curves.bounceOut) ثم يُستبدل بالشاشة التالية بدون وميض أسود.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-212
**Test Scenario:** الانتقال إلى شاشة غير معرفة عبر deep link (لا انهيار صريح)
**Feature:** AppRouter — unknown route
**Priority:** Medium
**Test Type:** Error Handling (Needs Dev Support)
**Preconditions:** (Needs Dev Support) محاكاة route غير مسجل.
**Steps to Execute:**
1. (Dev) حاول push لمسار غير مسجل مثل `/nonExistent`.
**Expected Results:**
- يعود `null` من `generateRoute` (السلوك الحالي) — لا تنهار الشاشات المعروفة؛ (تحذير: هذه تعتمد على Flutter behavior للـ unknown routes).
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) يتطلب أدوات تطوير.

---

**Test Case ID:** TC-213
**Test Scenario:** Flutter system back على Android يطابق أيقونة Back الداخلية
**Feature:** Navigation — system back vs app bar
**Priority:** Medium
**Test Type:** Navigation
**Preconditions:** Android.
**Steps to Execute:**
1. في شاشة فرعية اضغط زر الرجوع الخاص بالنظام (gesture/3-button) ثم زر Back داخل الـ AppBar ولاحظ نفس السلوك.
**Expected Results:**
- كلاهما يعود للشاشة السابقة؛ لا يوجد تناقض بين النظام والواجهة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

# 6. اختبارات الوظائف (Functional)

**Test Case ID:** TC-214
**Test Scenario:** دورة حياة إعلان كامل: نشر ← ظهور ← إيقاف ← تفعيل ← حذف
**Feature:** Ad lifecycle (cross-screen)
**Priority:** Critical
**Test Type:** Regression
**Preconditions:** مستخدم بدون اشتراك (للمسار المدفوع) أو باقة (للمجاني).
**Test Data:** بيانات إعلان اختبارية بصور.
**Steps to Execute:**
1. انشر إعلانًا (اختر المسار المدفوع/المجاني حسب الحساب).
2. ابحث عنه في "إعلاناتي" ← تبويب "النشط".
3. أوقفه ← تأكد أنه في "الغير نشط".
4. فعّله ← تأكد أنه نشط من جديد.
5. احذفه ← تأكد اختفائه.
**Expected Results:**
- بعد كل خطوة تتغير الحالة في القائمة/التبويبات فورًا (تفاؤل محلي + تزامن مع السيرفر)؛ لا حاجة لإعادة تشغيل التطبيق.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-215
**Test Scenario:** تكامل الغريبين: البحث ← المنتج ← الشات ← التقييم بعد "الشراء"
**Feature:** Buyer flow (cross-feature)
**Priority:** Critical
**Test Type:** Regression
**Preconditions:** حسابان (A بائع، B مشتري).
**Test Data:** منتج للاختبار.
**Steps to Execute:**
1. (A) انشر منتجًا معروفًا بـ `QA Flow Product`.
2. (B) ابحث عنه، افتح تفاصيله.
3. (B) اضغط "تواصل الآن".
4. (B) أرسل رسالة `هل المنتج متاح؟`.
5. (B) بعد استلام الرد افتح شاشة التقييم ← قيّم بـ 5 نجوم وتعليق `تعامل ممتاز`.
**Expected Results:**
- كل تسليم يعمل بسلاسة؛ الشات يُنشئ المحادثة؛ التقييم يعيد جلب التفاصيل؛ تترافق البيانات في كل الشاشات باستمرار.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-216
**Test Scenario:** تفضلة من تفاصيل ثم العودة ومراقبتها في المفضلة
**Feature:** Fav cross-screen
**Priority:** High
**Test Type:** Integration
**Preconditions:** مستخدم.
**Steps to Execute:**
1. افتح تفاصيل منتج ← اضغط القلب.
2. تبويب الحساب ← Favorite.
**Expected Results:**
- المنتج ظاهر في شاشة المفضلة فورًا؛ القلب ممتلئ أيضًا في شاشة التفاصيل والنتائج الأصلية.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-217
**Test Scenario:** شراء باقة ← اشتراك يغطي النشر ← نشر مجاني
**Feature:** Subscription → free publishing
**Priority:** Critical
**Test Type:** Integration
**Preconditions:** رصيد محفظة كافٍ؛ حساب بلا اشتراك؛ باقة واحدة على الأقل بسعر ≤ الرصيد.
**Test Data:** رصيد ← باقة ← إعلان جديد.
**Steps to Execute:**
1. اشترِ الباقة عبر "محفظة".
2. فورًا أضف إعلانًا جديدًا بـ addNewAds حتى اكتماله.
**Expected Results:**
- لا تُفتح ورقة رسوم النشر؛ الإعلان يُنشر مباشرة عبر بوابة `subscriptions/current` (حالته سارية وغير منتهية).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-218
**Test Scenario:** شراء باقة بالتحويل ثم ظهورها كـ "معلقة" ثم التفعيل
**Feature:** Subscription transfer → pending → active
**Priority:** High
**Test Type:** Integration
**Preconditions:** مسار تحويل بإيصال مرفوع.
**Test Data:** إيصال + مرجع `QA-TX-1`.
**Steps to Execute:**
1. اشترِ باقة عبر التحويل، ارفع الإيصال.
2. افتح شاشة المحفظة والدفع.
3. (Needs Backend) الإدارة تقبل الإيصال.
**Expected Results:**
- (قبل الموافقة) الحركة تُعرض بحالة "قيد المراجعة"؛ بعد الموافقة تظهر الباقة كـ اشتراك نشط (`is_subscribed`)؛ النشر التالي يكون مجانيًا.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev/Backoffice Support) لقبول الإيصال من لوحة الإدارة.

---

**Test Case ID:** TC-219
**Test Scenario:** شحن المحفظة ثم الدفع منها للنشر المتتابع
**Feature:** Top-up → Pay publishing fees
**Priority:** High
**Test Type:** Integration
**Preconditions:** حساب بدون اشتراك؛ رصيد كافٍ للرسوم.
**Test Data:** شحنة `100` + إعلانان.
**Steps to Execute:**
1. اشحن المحفظة `100`.
2. بعد قبول الإدارة (أو رصيد متاح) انشر الإعلان الأول من ورقة الدفع بـ "محفظة".
3. انشر الإعلان الثاني بنفس الطريقة.
**Expected Results:**
- كل نشر يُخصم من الرصيد؛ الحركات تظهر في السجل كرسم نشر/إيداع على الترتيب؛ لا طلبات انتقال دون دفع.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-220
**Test Scenario:** التصفية المركبة: فئة + سعر + شحن "مجاني فقط" في البحث
**Feature:** Search — combined server filter
**Priority:** High
**Test Type:** Integration
**Preconditions:** توجد منتجات بشحنات مختلفة.
**Steps to Execute:**
1. افتح ورقة الفلتر في البحث.
2. اختر: فئة محددة، `min_price=1000`, `max_price=10000`, shipment=`free`, condition=`new`.
3. Apply؛ لاحظ النتائج.
**Expected Results:**
- كل النتائج تطابق الشروط معًا؛ Query params في logcat: `category_id=X&sub_category_id=Y&min_price=1000&max_price=10000&shipping_type=free&condition=new&page=1`.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-221
**Test Scenario:** إحصائيات البائع: نشر منتج ← ترى عدّاد "المنتجات المعروضة" يرتفع
**Feature:** Statistics — displayed products counter
**Priority:** Medium
**Test Type:** Integration
**Preconditions:** حساب بائع؛ رصيد/اشتراك للنشر.
**Steps to Execute:**
1. لاحظ بطاقة "المنتجات المعروضة" في الإحصائيات.
2. انشر إعلانًا جديدًا.
3. ارجع للإحصائيات (refresh).
**Expected Results:**
- عدّاد "المنتجات المعروضة" يزداد بوحدات ما أُضيف من إعلان نشط؛ لا أخطاء.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-222
**Test Scenario:** التزامن الشامل للقلب: Home ← Details ← Fav ← Search
**Feature:** Fav heart sync — all entry points
**Priority:** High
**Test Type:** Regression
**Preconditions:** مستخدم.
**Steps to Execute:**
1. من Home اضغط قلب A.
2. افتح Details ← لاحظ القلب.
3. افتح Search ← ابحث A ← لاحظ القلب.
4. تبويب الحساب ← Favorite ← لاحظ وجود A.
5. اضغط القلب من أي نقطة لإلغاء التفضيل.
6. تحقق من كل النقاط مجددًا.
**Expected Results:**
- كل النقاط تعكس نفس حالة التفضيل (قلب ممتلئ/فارغ) بدون تناقض؛ الحذف يزيل من شاشة المفضلة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-223
**Test Scenario:** الفلاتر تتراكم على شاشة منتجات القسم الفرعي وتُزال بشارات
**Feature:** SubCategoriesProducts — chips management
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** منتجات القسم محملة.
**Steps to Execute:**
1. افتح الفلتر ← اختر: فئة، سعر، محافظة.
2. Apply ← لاحظ 3 شارات.
3. احذف شارة السعر (×).
**Expected Results:**
- الشارات تعرض الحقل المناسب؛ حذف شارة السعر يزيلها من المعادلة والقائمة تصفي للباقي.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-224
**Test Scenario:** إيقاف إشعار الكل ← تظهر فارغة ← تفعيل أوراق أخرى
**Feature:** Notifications — filter interplay
**Priority:** Low
**Test Type:** UI
**Preconditions:** إشعارات مقروءة وغيرها غير مقروءة.
**Steps to Execute:**
1. فلتر "Unread" ← لاحظ.
2. فلتر "Read" ← لاحظ.
3. فلتر "All".
**Expected Results:**
- كل فلتر متسق مع حالات العناصر الحالية؛ عند تحديد الكل لا تبقى عناصر "غير مقروء" كاذبة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

# 7. اختبارات التحقق من المدخلات (Input Validation)

**Test Case ID:** TC-225
**Test Scenario:** صيغ الهاتف المصري — جدول كامل (بادئة 01/11 خانة/أرقام فقط)
**Feature:** MyValidators.phoneValidator
**Priority:** High
**Test Type:** Validation
**Preconditions:** شاشة Register.
**Test Data:** مقبولة: `01012345678`, `01112345678`, `01212345678`, `01512345678` — مرفوضة: `02012345678` (بادئة 02)، `0112345678` (10 خانات)، `011012345678` (12 خانة)، `010123456a8` (حرف).
**Steps to Execute:**
1. أدخل كل قيمة واضغط زر إنشاء.
**Expected Results:**
- كل 11 خانة تبدأ بـ 01 تُقبل على مستوى الحقل؛ باقي الصيغ مرفوضة برسالة المترجم `phoneEgyptInvalid`.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-226
**Test Scenario:** حدود كلمة المرور — حرف واحد فوق/تحت الحد الأدنى
**Feature:** MyValidators.passwordValidator
**Priority:** High
**Test Type:** Boundary
**Preconditions:** شاشة Register.
**Test Data:** `Test123!` (8 — الحد الأدنى)، `Test1234!5678Test1234!5678Test1234!56` (>30)، `Aa1!aaaa` (8)، `Aa1!aaa` (7).
**Steps to Execute:**
1. أدخل كل قيمة ولاحظ الرسالة.
**Expected Results:**
- 8 أحرف بكل الشروط تُقبل؛ 7 تُرفض ("الحد الأدنى")؛ >30 تُرفض ("الحد الأقصى").
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-227
**Test Scenario:** كلمة مرور بلا رموز خاصة / بلا أرقام / بلا أحرف كبيرة
**Feature:** passwordValidator — requirement matrix
**Priority:** High
**Test Type:** Validation
**Preconditions:** شاشة Register.
**Test Data:** `testtesttest` (بلا شيء)، `Testtesttest` (بلا رقم/رمز)، `Test1234567` (بلا رمز)، `TEST1234!` (بلا صغيرة)، `test1234!` (بلا كبيرة).
**Steps to Execute:**
1. أدخل كل قيمة واضغط إنشاء.
**Expected Results:**
- كل قيمة تُرفض مع رسالة المتطلبات المرقمة (تتضمن: حرف صغير ≥1، كبير ≥1، رقم ≥1، رمز `!@#$%^&*(),.?":{}|<>` ≥1).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-228
**Test Scenario:** حدود الاسم المعروض (2–50 بدون أرقام/رموز)
**Feature:** MyValidators.displayNameValidator
**Priority:** Medium
**Test Type:** Boundary
**Preconditions:** شاشة Register.
**Test Data:** `A` (خطأ)، `ab` (مقبولة)، 50 حرفًا (مقبولة)، 51 (خطأ)، `User123` (خطأ — أرقام)، `User@#` (خطأ — رموز).
**Steps to Execute:**
1. أدخل كل قيمة واضغط إنشاء.
**Expected Results:**
- الحدود المقبولة وحدها تُقبل؛ بقية مرفوضة برسالة الاسم.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-229
**Test Scenario:** حدود العمر 18–100 وأيام وأرقام غير عددية
**Feature:** MyValidators.ageValidator
**Priority:** Medium
**Test Type:** Boundary
**Preconditions:** شاشة Register.
**Test Data:** `17`، `18`، `100`، `101`، `25.5`، `-3`، `٩` (عربي فقط).
**Steps to Execute:**
1. أدخل كل قيمة واضغط إنشاء.
**Expected Results:**
- `17` و`101` و`-3` و`25.5` و`٩` و`abc` تُرفض (عدد صحيح ضمن 18–100)؛ `18` و`100` تُقبل.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-230
**Test Scenario:** تنسيقات البريد الإلكتروني الصالحة والباطلة
**Feature:** MyValidators.emailValidator
**Priority:** High
**Test Type:** Validation
**Preconditions:** شاشة Register.
**Test Data:** `q@arob.com` (✔)، `q@a.b` (✔؟ حسب الـ regex)، `q@a.b-c.com` (✔)، `q.@a.com` (✗ — نقطة في النهاية)، `q@a.com.` (✗)، `q a@a.com` (✗ — مسافة)، `q@@a.com` (✗ — تكرار @)، `@a.com` (✗).
**Steps to Execute:**
1. أدخل كل قيمة واضغط إنشاء.
**Expected Results:**
- الصحيحة تُقبل؛ الباطلة مرفوضة برسالة البريد المترجم.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-231
**Test Scenario:** تأكيد كلمة المرور — تطابق حساس لحالة الأحرف
**Feature:** MyValidators.repeatPasswordValidator
**Priority:** High
**Test Type:** Validation
**Preconditions:** شاشة Register.
**Test Data:** الكلمة `Test1234!` والتأكيد `test1234!` (حالة مختلفة).
**Steps to Execute:**
1. أدخل الكلمة والتأكيد المختلف الحالة.
**Expected Results:**
- رسالة "كلمتا المرور غير متطابقتين"؛ لا إرسال (حساس لحالة الأحرف).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-232
**Test Scenario:** السعر — صفر/سالب/حروف/قيمة ضخمة
**Feature:** AddNewAd — price input
**Priority:** High
**Test Type:** Boundary
**Preconditions:** شاشة إضافة إعلان.
**Test Data:** `0`، `-100`، `abc`، `99999999999999` (حد كبير)، `١٥٠` (أرقام عربية)، `150.50`.
**Steps to Execute:**
1. أدخل كل قيمة كسعر واضغط "نشر الإعلان".
**Expected Results:**
- `0` مرفوض (priceRequired): يُرفض فارغٌ أو صفر؛ `-100` حروف؛ `abc` غير رقمي؛ قيمة ضخمة جدًا يرفضها السيرفر برسالة (422) وتظهر لك؛ `150.50` تُقبل.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-233
**Test Scenario:** نسبة الخصم أكبر من 100
**Feature:** AddNewAd — discount boundary
**Priority:** Medium
**Test Type:** Boundary
**Preconditions:** شاشة إضافة إعلان.
**Test Data:** `price=1000`, `discount=1500` (أي >100%).
**Steps to Execute:**
1. أدخل السعر والخصم الأكبر منه، لاحظ نسبة الخصم.
**Expected Results:**
- النسبة القصدية تُظهر > 100% ضغطة حمراء، ولا كراش؛ (لا يُتحقق في الكود أن discount ≤ price — يرسلها للسيرفر ما دام الرقم رقميًا وقد يرفضه هو).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-234
**Test Scenario:** حقول مسافة غير مرئية (whitespace only)
**Feature:** TextFormField — spaces-only input
**Priority:** Medium
**Test Type:** Edge Case
**Preconditions:** شاشة Register.
**Test Data:** `"   "` (3 مسافات) للاسم.
**Steps to Execute:**
1. املأ الحقول بـ مسافات فقط واضغط إنشاء.
**Expected Results:**
- الاسم يُرفض (displayName لا يقبل فراغات/طول مناسب)؛ لا إرسال.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-235
**Test Scenario:** محارف خاصة في حقول البحث (RTL مع رموز)
**Feature:** Search — special characters
**Priority:** Medium
**Test Type:** Validation/Edge
**Preconditions:** شاشة البحث.
**Test Data:** `#@!_+-=*()`، `بحث \
 متعدد`، `' OR 1=1 --`.
**Steps to Execute:**
1. اكتب كل قيمة في حقل البحث.
**Expected Results:**
- لا انهيار؛ لا نتائج
(على الأقل) أو نتائج عادية؛ أي خطأ شبكة يُلتقط كـ Error state لا crash.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-236
**Test Scenario:** حقن XSS في حقول النص (`<script>alert(1)</script>`)
**Feature:** AddNewAd — XSS attempt
**Priority:** Medium
**Test Type:** Security/Validation
**Preconditions:** شاشة إضافة إعلان.
**Test Data:** الاسم `<script>alert('x')</script>QA`.
**Steps to Execute:**
1. انشر إعلانًا باسم `<script>alert('x')</script>QA`.
**Expected Results:**
- النص يُعرض حرفيًا (لا يُنفذ كـ HTML)؛ إن عرضه HTML قانوني/محتوى، يبقى معروضًا كسلاسل عادية؛ لا شيء يفتح أو ينفذ في WebView.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-237
**Test Scenario:** حقن SQL-like (`' OR '1'='1`) في حقول التسجيل
**Feature:** Register — SQL injection string
**Priority:** Medium
**Test Type:** Security/Validation
**Preconditions:** شاشة Register.
**Test Data:** الاسم `' OR '1'='1`.
**Steps to Execute:**
1. أدخل وحاول إنشاء الحساب.
**Expected Results:**
- لا انهيار ولا دخول غير مشروع؛ الحقل يرفض (displayName بـ regex) أو يرسل كقيمة عادية والسيرفر يرفضها برسالة؛ لا اختراق.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-238
**Test Scenario:** رموز تعبيرية (Emoji) في حقل الاسم
**Feature:** DisplayName — emoji
**Priority:** Low
**Test Type:** Edge Case
**Preconditions:** شاشة Register.
**Test Data:** `اختبار🧪✓`.
**Steps to Execute:**
1. أدخل واضغط إنشاء.
**Expected Results:**
- (regex الحالي يقبل/يرفض حسب الصيغة — لا انهيار)؛ إن قبل: الحقل يعرض الإيموجي دون تقطيع؛ إن رفض: رسالة displayName.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-239
**Test Scenario:** مسافة في اسم المستخدم بالعربية
**Feature:** displayNameValidator — Arabic + space
**Priority:** Low
**Test Type:** Validation
**Preconditions:** شاشة Register.
**Test Data:** `أحمد محمد` (اسم عربي بمسافة).
**Steps to Execute:**
1. أدخل وراقب الحقل.
**Expected Results:**
- (displayName regex الحالي — كلمة واحدة بدون رموز؟) — لاحظ سلوك الكود: الاسم مع مسافة يُقبل إن كان النمط يسمح بالمسافات؛ إن لم يسمح ستُرفض بمسافة — وثّق السلوك الفعلي.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-240
**Test Scenario:** أرقام عربية (١٢٣) في حقل الهاتف
**Feature:** Phone field — Arabic numerals
**Priority:** Medium
**Test Type:** Edge Case
**Preconditions:** شاشة Register (لوحة مفاتيح عربية).
**Test Data:** `٠١٠١٢٣٤٥٦٧٨` (11 خانة أرقام عربية).
**Steps to Execute:**
1. أدخل على لوحة مفاتيح عربية واضغط زر إنشاء.
**Expected Results:**
- الحقل (`TextInputType.number`) على أندرويد قد يحول الأرقام — الاختبار فقط يوثق ما يحدث (قبول/رفض/كتابة كأرقام إنجليزية)؛ لا انهيار.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

# 8. اختبارات الـ API والتكامل (API & Integration)

**Test Case ID:** TC-241
**Test Scenario:** استجابة /login الناجحة تُحلل بشكل صحيح
**Feature:** Login API — parsing
**Priority:** High
**Test Type:** Integration (Needs Dev Support)
**Preconditions:** جلسة خادم اختبارية.
**Steps to Execute:**
1. (تحتاج اعتراض proxy) لاحظ رد login raw.
**Expected Results:**
- `{status:true, message, data:{user:{...}, isActive:true}}`؛ LoginModel يُبنى بلا استثناء parsing؛ التوكن ينحفظ؛ لا حقول غامضة تكسر الشاشة.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) اعتراض الطلب.

---

**Test Case ID:** TC-242
**Test Scenario:** رد /login الفاشل (status=false) يُعرض برسالة السيرفر
**Feature:** Login API — error mapping
**Priority:** High
**Test Type:** Integration
**Preconditions:** بيانات خاطئة معروفة.
**Steps to Execute:**
1. سجّل دخولًا بكلمة مرور خاطئة.
**Expected Results:**
- رسالة السيرفر تُعرض كما هي (العربية/الإنجليزية حسب `lang` السابق) — لا رسالة عامة فقط؛ لا يتغير الـ stack.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-243
**Test Scenario:** رد 422 على /register يعرض أول حقل خطأ
**Feature:** Register API — 422 field errors
**Priority:** High
**Test Type:** Integration (Needs Dev Support)
**Preconditions:** محاكاة رد 422 (Needs Dev Support — أو بريد مكرر حقيقي).
**Test Data:** بريد مستخدم مسبقًا.
**Steps to Execute:**
1. سجّل ببريد مستخدم.
**Expected Results:**
- (Needs Dev Support) Toast يعرض أول رسالة حقلية (مثلاً "البريد مستخدم بالفعل")؛ لا ينهار؛ (422 تُرسل كـ `fieldErrors` وتُستدعى في النشر).
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) يتطلب اعتراض شكل رد الخادم.

---

**Test Case ID:** TC-244
**Test Scenario:** /verifyCode بكود خاطئ يستجيب بخطأ واضح
**Feature:** OTP API — wrong code response
**Priority:** High
**Test Type:** Integration
**Preconditions:** جلسة بانتظار التفعيل.
**Test Data:** `999999`.
**Steps to Execute:**
1. أدخل الكود الخاطئ واضغط تحقق.
**Expected Results:**
- رسالة سيرفر عربية/إنجليزية واضحة (كود غير صحيح)؛ لا الدخول؛ لا توكن.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-245
**Test Scenario:** /home عند الضغط المزدوج السريع (لا race condition)
**Feature:** Home API — double request
**Priority:** Medium
**Test Type:** Integration
**Preconditions:** الرئيسية مفتوحة ويمكن سحبها بسرعة.
**Steps to Execute:**
1. اسحب للتحديث 3 مرات متتالية.
**Expected Results:**
- لا تكرار للـ Shimmer nor فساد للعرض؛ كل طلب يعود ويُحل بأمان؛ (HomeCubit عند الخطأ يظهر خطأ أو يهمله بصمت حسب الخيار).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-246
**Test Scenario:** استجابة getBanners بصيغة غير متوقعة لا تطيح الشاشة
**Feature:** Banners API — malformed response
**Priority:** Medium
**Test Type:** Integration (Needs Dev Support)
**Preconditions:** محاكاة رد غير متوقع (مثلًا `data` كـ String).
**Test Data:** رد Banners خاطئ الصيغة.
**Steps to Execute:**
1. (Needs Dev Support) حقن رد سيئ صيغته عبر أداة اعتراض.
**Expected Results:**
- (Needs Dev Support) `BannersModel` تتسامح مع صيغ متعددة (`banners|data|slides|items`) وتتجاهل ما لا تفهمه؛ لا انهيار؛ البانرات تبقى فارغة فحسب.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) اعتراض الطلبات.

---

**Test Case ID:** TC-247
**Test Scenario:** أي endpoint يُرجع 401 → خروج كامل
**Feature:** Global 401 handling
**Priority:** Critical
**Test Type:** Security/Integration
**Preconditions:** (Needs Dev Support) إبطال التوكن من الخادم.
**Steps to Execute:**
1. سجّل دخولًا ثم اجعل التوكن منتهيًا ثم افتح أي شاشة تُنفذ طلبًا (Home/Profile/Ads).
**Expected Results:**
- خروج قسري إلى Login + Toast "youLoggedOutPleaseLoginAgain" + مسح كل التخزين.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) لإبطال التوكن.

---

**Test Case ID:** TC-248
**Test Scenario:** استجابة 500 على /home → حالة خطأ قابلة للتعامل
**Feature:** Home API — 500 error
**Priority:** High
**Test Type:** Error Handling (Needs Dev Support)
**Preconditions:** محاكاة سيرفر 500 (أو بيئة اختبار معطلة).
**Steps to Execute:**
1. افتح الرئيسية.
**Expected Results:**
- (Needs Dev Support) `HomeCubit` يُصدر `GetHomeDataError` → واجهة مناسبة (رسالة + زر محاولة حسب الشاشات)؛ لا انهيار.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support).

---

**Test Case ID:** TC-249
**Test Scenario:** مهلة الاتصال 30 ثانية ترجع timeout
**Feature:** ApiService — timeouts
**Priority:** Medium
**Test Type:** Error Handling (Needs Dev Support)
**Preconditions:** محاكاة رد بطيء (>30 ثانية).
**Steps to Execute:**
1. (Needs Dev Support) اجعل الاستجابة بطيئة ثم افتح الشاشة.
**Expected Results:**
- `connectionTimeout/receiveTimeout` → `ServerFailure("connectionTimeOut")` → حالة خطأ مناسبة — لا تجميد لا نهائي.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) للتحكم ببطء السيرفر.

---

**Test Case ID:** TC-250
**Test Scenario:** التصفح عبر صفحات البحث بعد `last_page`
**Feature:** Products API — pagination end
**Priority:** Medium
**Test Type:** Integration
**Preconditions:** سوق فيه نتائج متعدد صفحات.
**Steps to Execute:**
1. ابحث بكلمة واسعة ← تنقل للصفحة `last_page + 1` (يراقب `page`).
**Expected Results:**
- `hasMore` تصبح false عند `currentPage >= lastPage`؛ لا يُطلب بعد ذلك؛ القائمة تنتهي بشكل طبيعي.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-251
**Test Scenario:** PATCH read-all يُطبق دفعة واحدة دون طلب لكل إشعار
**Feature:** Notifications API — bulk read
**Priority:** Medium
**Test Type:** Integration (Needs Dev Support)
**Preconditions:** ≥ 3 إشعارات غير مقروءة.
**Steps to Execute:**
1. اضغط done_all؛ راقب logcat.
**Expected Results:**
- طلب `PATCH notifications/read-all` **واحد فقط** (لا N طلب PATCH فردي)؛ كل العناصر تُحدث محليًا تفاؤليًا.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) لمراقبة الشبكة.

---

**Test Case ID:** TC-252
**Test Scenario:** polling للمحادثات كل 2 دقيقة يُرجع unread_count
**Feature:** Conversations API — polling refresh
**Priority:** Medium
**Test Type:** Integration (Needs Dev Support)
**Preconditions:** تطبيق مفتوح في الخلفية > 2 دقيقة مع رسائل واردة.
**Steps to Execute:**
1. على A: افتح قائمة المحادثات ودعها ظاهرة.
2. من B أرسل رسالة.
3. على A انتظر حتى لحظة الـ poll (أوان resume).
**Expected Results:**
- خلال ≤ 2 دقائق (أو عند resume فورًا) تظهر الرسالة/الشارة تُحدث — logcat: `GET /conversations/unread-count`.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) جهاز ثانٍ.

---

**Test Case ID:** TC-253
**Test Scenario:** FCM — إشعار Foreground يزيد العداد ويُظهر local notification
**Feature:** FCM — onMessage
**Priority:** High
**Test Type:** Integration
**Preconditions:** FCM مفعل للحساب؛ جهاز Android؛ من السيرفر يُرسل push test للمستخدم.
**Test Data:** push payload بـ `title/body`.
**Steps to Execute:**
1. التطبيق **مفتوح** وعلى أي شاشة.
2. أرسل FCM من Admin/Backoffice.
**Expected Results:**
- يُعرض إشعار محلي BigTextStyle في شريط الإشعارات؛ عدّاد الجرس يزيد بالرقم؛ وعند المسح الإجمالي/الفتح يتزامن.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Backoffice Support) لإرسال push يدوي.

---

**Test Case ID:** TC-254
**Test Scenario:** FCM — التطبيق مغلقة (Terminated) وفتحها بالنقر على الإشعار
**Feature:** FCM — background/terminated tap
**Priority:** High
**Test Type:** Integration
**Preconditions:** التطبيق مغلق كليًا؛ FCM مفعل.
**Test Data:** push payload.
**Steps to Execute:**
1. أرسل FCM للمستخدم.
2. التطبيق مغلق — اضغط الإشعار.
**Expected Results:**
- التطبيق يفتح ويُعرض شاشة الإشعارات (`Routes.notificationsView`) مباشرة عبر pending navigation (مع استثناء Guest).
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Backoffice Support).

---

**Test Case ID:** TC-255
**Test Scenario:** حذف مفضلة من جهاز آخر يتزامن (re-fetch resync)
**Feature:** Favourites API — cross-device
**Priority:** Medium
**Test Type:** Integration (Needs Dev Support)
**Preconditions:** حساب مسجل على جهازين.
**Steps to Execute:**
1. على الجهاز الثاني فعّل/أزل مفضلة منتج X.
2. على الجهاز الأول اسحب للتحديث أو افتح شاشة المفضلة.
**Expected Results:**
- تُعالج البيانات من جديد من السيرفر (toggle → `getFavData` silent resync)؛ الحالة تصطف النهائي.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) جهاز ثانٍ.

---

**Test Case ID:** TC-256
**Test Scenario:** الدفع بالتحويل ← admin إدارة قبول ← تجربة النشر مجانًا
**Feature:** Checkout API — transfer → activate → free publish
**Priority:** Critical
**Test Type:** Integration (Needs Backoffice)
**Preconditions:** رصيد غير مطلوب هنا؛ باقة متاحة.
**Test Data:** إيصال + مرجع `QA-ACTIVATE-1`.
**Steps to Execute:**
1. اشترك عبر تحويل ← ارفع إيصالًا ← انتظر تفعيل الإدارة.
2. بعد التفعيل انشر إعلانًا جديدًا.
**Expected Results:**
- الإدارة تقبل الإيصال؛ `subscriptions/current` تُرجع باقة نشطة؛ النشر التالي بدون حقول دفع.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Backoffice) لقبول الإيصال.

---

**Test Case ID:** TC-257
**Test Scenario:** سجل الحركات — الصيغتَان تتعاملا معهما بمرونة
**Feature:** WalletHistory API — parsing tolerance
**Priority:** Low
**Test Type:** Integration (Needs Dev Support)
**Preconditions:** محاكاة شكل رد يقدّم `amount/balance` كمفاتيح بديلة (Needs Dev Support).
**Steps to Execute:**
1. (Needs Dev Support) قدم ردًا بديل الصيغة عبر أداة اعتراض.
**Expected Results:**
- `WalletHistoryModel.fromJson` يقرأ `amount|balance` و`type_label|title` و`created_at|date|created` — لا انهيار.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) للتحكم بالرد.

---

**Test Case ID:** TC-258
**Test Scenario:** إحصائيات ردود الشهر التالي: قيم صفرية واضحة
**Feature:** Statistics API — zero-values month
**Priority:** Low
**Test Type:** Edge Case
**Preconditions:** شهر بدون مبيعات.
**Test Data:** حساب جديد أو شهر مستقبلي.
**Steps to Execute:**
1. تنقل بـ"الشهر التالي" (شهر فارغ).
**Expected Results:**
- كل العدادات تظهر `0` مع فواصل آلاف؛ لا تكرار للأصفاد بكسور؛ الخانتين فارغتين.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-259
**Test Scenario:** Accept-Language: تبديل اللغة يغيّر ترويسة الطلبات
**Feature:** ApiService — lang header
**Priority:** Medium
**Test Type:** Integration (Needs Dev Support)
**Preconditions:** التبديل بين اللغتين مفعّل.
**Steps to Execute:**
1. بدّل اللغة؛ راقب logcat headers لطلب `GET home`.
**Expected Results:**
- الترويستان `Accept-Language` و`lang` تتحولان للغة المحفوظة: `ar` ثم `en` بعد التبديل.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) لالتقاط الترويسات.

---

**Test Case ID:** TC-260
**Test Scenario:** حقول نشرت (payment_method/receipt/transfer_reference) → الورقة تظهر مجددًا
**Feature:** Publish API — 422 field errors → sheet
**Priority:** High
**Test Type:** Integration (Needs Dev Support)
**Preconditions:** محاكاة رد 422 بـ fieldErrors في حقول الدفع.
**Steps to Execute:**
1. (Needs Dev Support) حقن رد 422 مع fieldErrors بالدفعات.
**Expected Results:**
- التطبيق يُحوّل الحالة إلى `AddNewAdPaymentRequired`؛ ورقة الدفع تُعاد فتحها بدل Toast عام؛ المستخدم يكمل الدفع من الورقة.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support).

---

# 9. اختبارات قاعدة البيانات والتخزين المحلي

> لا توجد قاعدة بيانات محلية (لا sqflite / hive / drift). "Database" هنا يعني: التخزين المحلي + تزامن البيانات مع السيرفر.

**Test Case ID:** TC-261
**Test Scenario:** firstRun يمسح كل التخزين في أول تشغيل فقط
**Feature:** AppInitializer — firstRun flag
**Priority:** High
**Test Type:** Functional (Needs Dev Support)
**Preconditions:** (Needs Dev Support) `pm clear` للتطبيق.
**Steps to Execute:**
1. ثبّت التطبيق/امسح بياناته ثم افتحه (التشغيل الأول).
2. تحقق من التخزين بعد الإقلاع.
3. أغلق وافتح التطبيق مرة ثانية.
**Expected Results:**
- (1) `FlutterSecureStorage.deleteAll()` + `clearUserData()` يُنفذان؛ `firstRun=false` يُحفظ.
- (2) الثانية: المسح **لا** يعاد (firstRun=false موجود).
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) App Inspector.

---

**Test Case ID:** TC-262
**Test Scenario:** التوكن محفوظ في secure storage (وليس في prefs كنص صريح لنقطة الدخول الحالية)
**Feature:** Secure storage — token at rest
**Priority:** Critical
**Test Type:** Security (Needs Dev Support)
**Preconditions:** مستخدم مسجل.
**Steps to Execute:**
1. (Needs Dev Support) افحص FlutterSecureStorage عبر App Inspector بعد الدخول.
**Expected Results:**
- التوكن موجود بمفتاح `userToken` داخل secure storage (مشفر)؛ و**ملاحظة**: `shared_preferences` يحوي `userToken` بنص صريح (التطبيق يحتفظ بنسختين) — تُوثّق كملاحظة أمنية في القسم 10.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) App Inspector / adb backup.

---

**Test Case ID:** TC-263
**Test Scenario:** فحص مفاتيح prefs بعد دورة كاملة (firstRun/language/fcmToken/isDarkMode/isGuest)
**Feature:** SharedPreferences — keys inventory
**Priority:** Medium
**Test Type:** Integration (Needs Dev Support)
**Preconditions:** جلسة نظيفة؛ تبديل اللغة والثيم.
**Steps to Execute:**
1. (Needs Dev Support) افحص prefs: غيّر اللغة والثيم وguest ← ادخل خروج ← تحقق من المفاتيح.
**Expected Results:**
- المفاتيح: `language` (ar/en)، `isDarkMode` (true/false)، `firstRun=false`، `isGuest`، `fcmToken`، `userToken` (نصية — ملاحظة أمنية)، `email` — كلها مكتوبة بقيم متوقعة.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) App Inspector.

---

**Test Case ID:** TC-264
**Test Scenario:** تسجيل الخروج يمسح التوكن من التخزينين
**Feature:** Logout — storage wipe
**Priority:** Critical
**Test Type:** Security (Needs Dev Support)
**Preconditions:** مستخدم مسجل داخل التطبيق.
**Steps to Execute:**
1. (Needs Dev Support) تحقق من التخزين قبل الخروج.
2. سجّل خروجًا.
3. تحقق من التخزين مرة أخرى.
**Expected Results:**
- بعد الخروج: لا `userToken` في secure storage؛ **لكن** `CacheHelper.clearUserData()` تمسح فقط مفاتيح محددة (otp/userEmail/userId/userPhone) — **لا تمسح `userToken` من prefs صراحةً**؛ ملاحظة موثقة (الدخول القسري يعتمد أساسًا على مسح secure storage).
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) App Inspector.

---

**Test Case ID:** TC-265
**Test Scenario:** اللغة المحفوظة تبقى بعد إعادة التشغيل
**Feature:** Persistence — language
**Priority:** Medium
**Test Type:** Functional
**Preconditions:** العربية افتراضية.
**Steps to Execute:**
1. بدّل الإنجليزية.
2. Kill التطبيق ثم افتحه.
**Expected Results:**
- يفتح مباشرة بالإنجليزية (من `CacheHelper[language]`) مع Tier LTR.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-266
**Test Scenario:** الثيم المحفوظ يبقى بعد إعادة التشغيل
**Feature:** Persistence — theme
**Priority:** Medium
**Test Type:** Functional
**Steps to Execute:**
1. بدّل للداكن.
2. Kill وافتح التطبيق.
**Expected Results:**
- التطبيق يفتح بالوضع الداكن (`initial = dark` من `StorageKeys.isDarkMode`)؛ كل الشاشات تُحمّل داكنة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-267
**Test Scenario:** اتساق بيانات البروفايل بين السيرفر والكاش بعد التعديل
**Feature:** Consistency — profile sync
**Priority:** High
**Test Type:** Integration
**Preconditions:** مستخدم.
**Steps to Execute:**
1. عدّل الاسم.
2. لاحظ Toast + البروفايل + Home location chip.
**Expected Results:**
- بعد الحفظ (`updateProfile` ثم `getProfile`): كل الشاشات (Home/Profile/Details ownership checks) تستخدم نفس الاسم/الإيميل/الهاتف المحدثة؛ لا قِيَم قديمة متبقية.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

# 10. اختبارات الأمان (Security)

> اختبارات يدوية آمنة (بدون كسر/اختراق).

**Test Case ID:** TC-268
**Test Scenario:** كل الطلبات تذهب لـ HTTPS فقط
**Feature:** Transport security
**Priority:** Critical
**Test Type:** Security (Needs Dev Support)
**Preconditions:** التقاط الطلبات.
**Steps to Execute:**
1. (Needs Dev Support) راقب كل الطلبات الصادرة.
**Expected Results:**
- كل العناوين تبدأ بـ `https://by3li.axeviadigital.com`؛ لا طلب HTTP عادي أصلًا في المسار الحالي (الراوئتان القديمتان معلقتان في الكود).
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) Proxy/logcat.

---

**Test Case ID:** TC-269
**Test Scenario:** لا مفاتيح/أسرار معروضة على الشاشة أو السجلات في البناء العادي
**Feature:** Secrets exposure — logs
**Priority:** High
**Test Type:** Security
**Preconditions:** بناء debug.
**Steps to Execute:**
1. راقب logcat في حوارات الدخول/OTP/الإشعارات.
**Expected Results:**
- (debug) السجلات تعرض headers وbody وFCM **كامل** (ملاحظة — الكود يطبعها)؛ في بناء release `kDebugMode` يعطل PrettyDioLogger لكن `debugPrint` العادي والتصريحات الملونة تظل؛ لا مفاتيح خاصة (private keys) في السجلات.
**Actual Results:**
**Status:** Not Run
**Notes:** ملاحظة: log verbosity في debug أعلى من المقبول — انظر قسم 11.

---

**Test Case ID:** TC-270
**Test Scenario:** كود OTP لا يظهر في الشاشات للإنتاج
**Feature:** OTP — code exposure (documented)
**Priority:** Critical
**Test Type:** Security
**Preconditions:** جلسة OTP.
**Steps to Execute:**
1. بعد التسجيل (TC-006) راقب toast النجاح وشاشة OtpView (زر Resend بعد 60 ث).
**Expected Results:**
- (السلوك الحالي) toast يعرض `OTP : <code>` والتوست عند Resend يعرض الكود — **ملاحظة أمنية حرجة** محددة في القسم 11 ويجب إزالتها قبل الإطلاق.
**Actual Results:**
**Status:** Not Run
**Notes:** موثق كعيب أمني — القسم 11.

---

**Test Case ID:** TC-271
**Test Scenario:** الزائر لا يصل لأي endpoint خاص بالحساب (حتى بالتحايل)
**Feature:** Authorization — guest vs API
**Priority:** Critical
**Test Type:** Security
**Preconditions:** Guest.
**Steps to Execute:**
1. كزائر حاول مباشرة (عبر شاشة التفاصيل ← زر الشراء؟ لا يوجد؛ احتاج محاولة عبر مسارات UI).
**Expected Results:**
- كل الأزرار/الأفعال الخاصة بالحساب مقيدة بالحوار (loginRequired)؛ لا تُرسل طلبات للسيرفر أصلًا من مسارات الزائر (مثلاً: التفضلة → لا طلب، الإشعارات ← لا fetch للـ 401).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-272
**Test Scenario:** مستخدم يحاول إيقاف/تفعيل إعلان شخص آخر (لا يظهر له الخيار)
**Feature:** Authorization — owner-only ad actions
**Priority:** Critical
**Test Type:** Security
**Preconditions:** مستخدم مسجل غير مالك للإعلان.
**Steps to Execute:**
1. افتح تفاصيل إعلان شخص آخر في كل مكان (Home/Search/Details).
2. ابحث عن أيقونة ⋮ (القائمة) وعن إيقاف/تفعيل.
**Expected Results:**
- تظهر قائمة ⋮ فقط عندما `profile.id == seller.id`؛ مستخدم آخر لا يراها أصلًا. (ملاحظة: الأمان على مستوى العرض؛ السيرفر يجب أن يفرض الصلاحية وهو حقل خارج هذا الريبو.)
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-273
**Test Scenario:** شريط بيانات داخل شاشات مشتركة لا يعرض توكنًا من السجلات عند الاسترخاء في عام
**Feature:** Session handling — logs of token
**Priority:** Medium
**Test Type:** Security (Needs Dev Support)
**Preconditions:** (Needs Dev Support) بناء debug يعمل.
**Steps to Execute:**
1. سجل logcat ← أدخل أي شاشة ← ابحث عن `Bearer`.
**Expected Results:**
- (debug) الترويسة `Authorization: Bearer <token>` تظهر عبر `PrettyDioLogger` فقط في وضع debug — في release يغيب (kDebugMode) لكن `debugPrint` العادي في onRequest/onResponse يبقى — يوثق.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) logcat.

---

**Test Case ID:** TC-274
**Test Scenario:** لا تظهر كلمة المرور دائمًا في حقل الدخول/التسجيل (إلا أثناء الضغط على عين الإظهار)
**Feature:** Password masking
**Priority:** High
**Test Type:** Security
**Preconditions:** شاشات Login/Register/ChangePassword.
**Steps to Execute:**
1. اكتب كلمة المرور في كل حقل وراقب الإخفاء.
2. اضغط أيقونة العين لإظهار/إخفاء.
**Expected Results:**
- الكلمة مخفية بنقوط؛ الضغط على العين يُظهرها (أو العكس) بالتبادل؛ لا يبقى النص واضحًا بمجرد الخروج من الحقل (للتسجيل/التغيير).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-275
**Test Scenario:** حذف الحساب بدون أي تأكيد ثانٍ (موثق كخطر)
**Feature:** DeleteAccount — one-tap destructive (documented)
**Priority:** High
**Test Type:** Security (Documentation)
**Preconditions:** حساب اختبار ثانوي.
**Steps to Execute:**
1. افتح شاشة حذف الحساب ← اضغط "Delete now" مباشرة.
**Expected Results:**
- (السلوك الحالي) الحذف يبدأ **فورًا بدون حوار تأكيد ثانٍ** — موثق كخطر في القسم 11؛ تأكد أن كل مستخدم QA يعلم أن هذا الزر نهائي.
**Actual Results:**
**Status:** Not Run
**Notes:** ملاحظة: لا حوار تأكيد — موثق كعيب أمني.

---

**Test Case ID:** TC-276
**Test Scenario:** التحقق من غياب FLAG_SECURE (معلومات فقط)
**Feature:** Screen capture protection — absence
**Priority:** Low
**Test Type:** Security (Documentation)
**Preconditions:** Android.
**Steps to Execute:**
1. التقط screenshot لشاشة المحفظة/البيانات الشخصية.
**Expected Results:**
- الالتقاط ينجح (لا FLAG_SECURE) — يوثق كحالة مقبولة للتطبيق الحالي؛ (ينصح بالإضافة لشاشات المحفظة فقط).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-277
**Test Scenario:** توكن المستخدم المحذوف يبقى في التخزين (Local token after delete — موثق)
**Feature:** DeleteAccount — token retention
**Priority:** High
**Test Type:** Security (Needs Dev Support)
**Preconditions:** حذف حساب عبر زر "Delete now".
**Steps to Execute:**
1. احذف حسابًا ← (Needs Dev Support) افحص التخزين.
**Expected Results:**
- (السلوك الحالي) التوكن **يبقى في secure storage** بعد الحذف لأن الشاشة لا تمسح Storage ولا تستدعي logout؛ يوثق كعيب. (على الجانب: `LoginView` يفتح لكن الدخول سيفشل بالسيرفر عند بقاء التوكن غير صالح).
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) App Inspector.

---

**Test Case ID:** TC-278
**Test Scenario:** لا يوجد شهادات مثبتة (Certificate Pinning) — للمراجعة فقط
**Feature:** Cert pinning — absence
**Priority:** Low
**Test Type:** Security (Documentation)
**Steps to Execute:**
1. (Needs Dev Support) اعترض الطلب عبر proxy وMITM لاختبار السيرفر (بيئة خاصة).
**Expected Results:**
- الاتصال يمر دون خطأ certificate pinning — التطبيق يعتمد على ثقة النظام (طبيعي لـ Flutter الافتراضي) — توثق كملاحظة عدم وجود pinning وليس عيبًا بالضرورة.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support).

---

**Test Case ID:** TC-279
**Test Scenario:** لا بيانات حساسة محفوظة في النسخ الاحتياطية (android:allowBackup) — للمراجعة
**Feature:** Backup — token in backup (documentation)
**Priority:** Medium
**Test Type:** Security (Documentation)
**Preconditions:** Android.
**Steps to Execute:**
1. (Needs Dev Support) راجع `AndroidManifest.xml` — لا يوجد `allowBackup` مضبوط صراحة (الافتراضي true).
**Expected Results:**
- النسخ الاحتياطية قد تحتوي `SharedPreferences` (منها نسخة `userToken` النصية) — التسريب محتمل عبر نسخ Pixel/Google — موثق للمطور بتعيين `android:allowBackup="false"` أو استبعاد الملفات الحساسة.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support).

---

# 11. اختبارات معالجة الأخطاء (Error Handling)

**Test Case ID:** TC-280
**Test Scenario:** انقطاع الإنترنت تمامًا — التطبيق كامل سلوك
**Feature:** Global — offline mode
**Priority:** High
**Test Type:** Error Handling
**Preconditions:** الإنترنت يعمل ثم يقطع كليًا.
**Steps to Execute:**
1. افتح التطبيق مع قطع الإنترنت وفتح كل الشاشات: Home ← Search ← Details ← Notifications ← Ads ← Profile.
**Expected Results:**
- كل شاشة تعرض حالة خطأ مترجمة + إمكانية إعادة المحاولة؛ لا انهيار؛ لا شاشة بيضاء؛ عند عودة الإنترنت + refresh يعود كل شيء.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-281
**Test Scenario:** انقطاع أثناء عملية إيقاف إعلان — هل تتسق الحالة؟
**Feature:** Mid-action failure — pause ad
**Priority:** High
**Test Type:** Error Handling
**Preconditions:** إعلان نشط؛ افصل الإنترنت مباشرة بعد الضغط.
**Steps to Execute:**
1. من إعلاناتي اضغط "إيقاف" ← افصل الإنترنت أثناء الحوار/الطلب.
2. لاحظ النتيجة.
**Expected Results:**
- `LinearProgress` يظهر ثم خط أخطاء (Toast/Snackbar)؛ القائمة تحتفظ بالحالة الأصلية (لا تتغير بصمت إلى "غير نشط" بدون تأكيد)؛ عند عودة الإنترنت + refresh يُحل.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-282
**Test Scenario:** فشل الدفع أثناء checkout — لا رصيد يُخصم ولا باقة تُفعّل
**Feature:** Checkout — failure atomicity
**Priority:** Critical
**Test Type:** Error Handling
**Preconditions:** باقة غير مشتركة؛ افصل الإنترنت أثناء اختيار "محفظة".
**Steps to Execute:**
1. افتح ورقة الدفع ← اختر "محفظة" ← افصل الإنترنت في اللحظة الحاسمة.
**Expected Results:**
- فشل الطلب يُعرض برسالة واضحة؛ لا يُخصم الرصيد (السيرفر هو من يخصم — تعتمد النتيجة على السيرفر)؛ لا تتفعل الباقة؛ يمكن إعادة المحاولة بأمان.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-283
**Test Scenario:** السيرفر يُرجع 500 — رسالة مفهومة للمستخدم
**Feature:** Global — 5xx mapping
**Priority:** High
**Test Type:** Error Handling (Needs Dev Support)
**Preconditions:** محاكاة سيرفر 500 لكل المسارات.
**Steps to Execute:**
1. (Needs Dev Support) اجعل السيرفر يرجع 500 لكل طلب؛ افتح 3 شاشات.
**Expected Results:**
- كل شاشة تعرض خطأ (رسالة مترجمة من `ServerFailure` — `response["message"]` إن وُجد) +زر محاولة إن وُجد؛ لا سلوك غير متوقع.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support).

---

**Test Case ID:** TC-284
**Test Scenario:** منتج محذوف/غير موجود — 404 على productDetials
**Feature:** ProductDetails — 404 handling
**Priority:** High
**Test Type:** Error Handling (Needs Dev Support)
**Preconditions:** معرف منتج غير موجود.
**Steps to Execute:**
1. (Needs Dev Support) افتح `productDetials` بمعرف وهمي عبر route يدوي.
**Expected Results:**
- `CustomErrorWidget` مع رسالة + زر "Retry"؛ لا انهيار.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) للدخول بمعرف وهمي.

---

**Test Case ID:** TC-285
**Test Scenario:** رفع ملف ليس صورة (PDF/APK) كإيصال/إعلان
**Feature:** Upload — wrong file type
**Priority:** Medium
**Test Type:** Validation
**Preconditions:** ملفات PDF/APK جاهزة.
**Steps to Execute:**
1. حاول رفع PDF كإيصال (من gallery).
**Expected Results:**
- أداة الاختيار (image_picker) تعذر أجيال محددة للصور (JPG/PNG) — تُرفع صور فقط؛ إن رفع شيء ليس صورة: رسالة خطأ أو لوحة اختيار تُبرز الصور فقط؛ لا إرسال.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-286
**Test Scenario:** صورة/إيصال أكبر من 5MB في الشات والنشر
**Feature:** Upload — size limit
**Priority:** Medium
**Test Type:** Boundary
**Preconditions:** ملف > 5MB.
**Steps to Execute:**
1. حاول رفع الملف كصورة شات عابرة للحجم.
**Expected Results:**
- الشات: رفض برسالة حجم (≤ 5MB)؛ الدفع والنشر: الحد يحدده السيرفر ويرد (422) إن تجاوز — يرى المستخدم الرسالة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-287
**Test Scenario:** رفض إذن الكاميرا/المعرض عند رفع صورة إعلان
**Feature:** Permissions — camera/gallery denial
**Priority:** Medium
**Test Type:** Error Handling
**Preconditions:** الأذونات مرفوضة من إعدادات التطبيق.
**Steps to Execute:**
1. ارفض إذن الصور/الكاميرا؛ اضغط زر الإضافة/الالتقاط.
**Expected Results:**
- لا انهيار؛ تُعرض رسالة/لا يحدث شيء (image_picker لا يفتح)؛ (يفضل التطبيق يعرض Snackbar إرشادي — وإن لم يفعل يوثق).
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-288
**Test Scenario:** الضغط المزدوج السريع على زر الدفع/الحفظ لا يصدر مرتين
**Feature:** Double-submit guard
**Priority:** High
**Test Type:** Edge Case
**Preconditions:** شاشة الدفع/حفظ البروفايل/تعديل الإعلان.
**Steps to Execute:**
1. اضغط "نشر الإعلان"/"Save" مرتين بسرعة شديدة.
**Expected Results:**
- حالة التحميل تعمل كمانع (`IgnorePointer`/`CustomLoading`)؛ لا يُرسل إلا طلب واحد؛ لا duplicate charges.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-289
**Test Scenario:** العودة أثناء التحميل (شاشة معلقة)
**Feature:** Navigation during loading
**Priority:** Low
**Test Type:** Edge Case
**Preconditions:** شاشة بـ spinner كامل (مثلاً Details).
**Steps to Execute:**
1. افتح التفاصيل (التحميل بطيئة) ← اضغط Back أثناء التحميل.
**Expected Results:**
- لا انهيار؛ عند عودة الرد يعالج للكيوبت/الشاشة المناسبة دون `setState after dispose`؛ Debug log إن وُجد تحذير يوثق.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-290
**Test Scenario:** الرد بقائمة منتجات فارغة (0 منتج) — شاشة صريمة
**Feature:** Empty lists — network success but empty
**Priority:** Medium
**Test Type:** Edge Case
**Preconditions:** قسم فرعي بدون منتجات في السيرفر.
**Steps to Execute:**
1. تحقق من قسم فيه `products_count = 0`.
**Expected Results:**
- الشبكة تعرض حالة مناسبة ("لا يوجد عناصر") أو تمنع حتى فتح الشاشة (السلوك الحالي: Snackbar "لا يوجد منتجات في هذا القسم").
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-291
**Test Scenario:** انتهاء التوكن أثناء محادثة مفتوحة
**Feature:** Session expiry — chat open
**Priority:** High
**Test Type:** Error Handling/Integration (Needs Dev Support)
**Preconditions:** محادثة مفتوحة + إبطال التوكن من الخادم (Needs Dev Support).
**Steps to Execute:**
1. مع محادثة مفتوحة، اجعل التوكن منتهيًا.
2. حاول إرسال رسالة.
**Expected Results:**
- يُرد 401 → يتم خروج كامل إلى Login + Toast "youLoggedOutPleaseLoginAgain"؛ المحادثة تُغلق.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Dev Support) إبطال التوكن.

---

**Test Case ID:** TC-292
**Test Scenario:** التبديل السريع بين التبويبات أثناء طلبات معلقة
**Feature:** Tab switching — race conditions
**Priority:** Low
**Test Type:** Edge Case
**Preconditions:** إنترنت بطيء.
**Steps to Execute:**
1. بدّل بين Home ← Chat ← Search ← Ads بسرعة (×10).
**Expected Results:**
- لا انهيار ولا تسجيل أخطاء widget tree؛ كل تبويب يكتفي بطلباته؛ لا تكلفة تتزايد بعد العودة للتبويب المطلوب.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

# 12. اختبارات المسارات الكاملة (End-to-End)

**Test Case ID:** TC-293
**E2E Scenario:** رحلة المشتري الكاملة: تثبيت ← تصفح ← تسجيل ← شراء عبر شات
**Feature:** Buyer E2E
**Priority:** Critical
**Test Type:** End-to-End
**Preconditions:** تثبيت نظيف؛ حسابا A (بائع بباقة نشطة — أو منشور) و B (مشتري جديد).
**Steps to Execute:**
1. (B) افتح التطبيق ← Onboarding ← تسجيل ← OTP ← اختيار الموقع.
2. (B) افتح الرئيسية ← ابحث "QA E2E Bike" ← افتح تفاصيل المنتج المنشور من A.
3. (B) اضغط "تواصل الآن".
4. (B) أرسل "هل يمكن التسليم اليوم؟".
5. (A) رد "نعم بإذن الله".
6. (B) ارجع للتفاصيل ← قيّم 5 نجوم ← علق "بائع ممتاز".
7. (B) أضف للسلة؟ لا — اضغط "طلب الشراء"؟ لا — ببساطة أضف للتفضلة.
**Expected Results:**
- كل خطوة تنجح بالترتيب؛ المحادثة تُنشأ بين الاثنين؛ التقييم يُحفظ؛ التفضلة تُضاف؛ لا فقدان للسياق بين الشاشات؛ التجربة سلسة لكل من A وB.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-294
**E2E Scenario:** رحلة البائع المدفوعة: التسجيل ← نشر أول إعلان بدفع رسوم ← نشر ثاني بباقة مشتركة
**Feature:** Seller publish E2E
**Priority:** Critical
**Test Type:** End-to-End
**Preconditions:** بائع جديد بدون باقة؛ رصيد محفظة كافٍ للرسوم.
**Steps to Execute:**
1. سجّل حسابًا بائعًا كاملًا حتى ChooseLocation.
2. أضف إعلانًا (صور/بيانات) ← اضغط نشر ← اختر "محفظة" ← أكد.
3. تحقق أن الإعلان يظهر في "إعلاناتي"/Home.
4. افتح الباقات ← اشترِ الباقة الشهرية بـ "محفظة".
5. أضف إعلانًا ثانيًا ← اضغط نشر ← **يجب** أن يُنشر مباشرة دون ورقة دفع.
**Expected Results:**
- الإعلان الأول يخصم الرسوم ويظهر؛ الثاني ينشر مجانًا بعد الاشتراك؛ كل الحركات تظهر في سجل المحفظة بالتوالي؛ إحصائيات البائع تتصاعد.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-295
**E2E Scenario:** Guest → تسجيل ← تحويل كل تفاعليته إلى الحساب
**Feature:** Guest-to-User funnel E2E
**Priority:** High
**Test Type:** End-to-End
**Preconditions:** تثبيت نظيف.
**Steps to Execute:**
1. سجّل دخولًا كزائر ← تصفح: Home ← تفاصيل منتج ← حاول التفضلة (يُمنع).
2. من الحوار → "تسجيل الدخول" ← أنشئ حسابًا ← OTP ← الموقع ← LayoutView.
3. ارجع لنفس المنتج ← أضف للتفضلة ← تحقق من تبويب Ads/Account يعمل.
**Expected Results:**
- الترقية تنجح دون إعادة تشغيل؛ كل ما كان ممنوعًا كـ Guest أصبح متاحًا؛ كل شاشة تعرض بيانات الحساب الجديد؛ لا بيانات/عدادات Guest مختلطة تظهر للمستخدم.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-296
**E2E Scenario:** دورة الاشتراك الكاملة: شراء ← استخدام ← انتهاء ← تجديد
**Feature:** Subscription lifecycle E2E
**Priority:** High
**Test Type:** End-to-End (Needs Backoffice)
**Preconditions:** رصيد محفظة كافٍ؛ صبر للانتهاء/الحاجة محاكاة.
**Steps to Execute:**
1. اشترِ الباقة الشهرية.
2. تحقق أن النشر مجاني.
3. (Needs Backoffice/الوقت) انتظر انتهاء الباقة (أو Needs Backend session).
4. حاول نشر إعلان ← يجب أن تُفتح ورقة الدفع مجددًا.
5. جدد الاشتراك ← النشر مجاني مجددًا.
**Expected Results:**
- قبل الانتهاء: نشر مجاني؛ بعد الانتهاء: تُفرض الرسوم؛ بعد التجديد: مجاني؛ جميع الطبقات تزامنت (Ads/Statistics/My Ads).
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Backoffice) لتعيين باقة منتهية للاختبار الزمني.

---

**Test Case ID:** TC-297
**E2E Scenario:** رحلة الدفع بالتحويل: شحن المحفظة ← التفعيل ← النشر المجاني
**Feature:** Transfer top-up → activate → publish E2E
**Priority:** High
**Test Type:** End-to-End (Needs Backoffice)
**Preconditions:** باقة؛ إيصال؛ صورة تحويل.
**Steps to Execute:**
1. بائع جديد بدون رصيد.
2. اشحن المحفظة بتحويل ← ارفع الإيصال ← انتظر تفعيل الإدارة.
3. بعد القبول: الرصيد يظهر؛ انشر إعلان الدفع الأولى بـ "محفظة" (Apps uses same TransferView for top-up).
4. تنقل إلى الإحصائيات ← تحقق من التحديثات.
**Expected Results:**
- الشحن بالتحويل ← موافقة ← الرصيد يزيد ← النشر يتسرب بالخصم التلقائي؛ الإحصائيات + سجل الحركات مصطفة.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Backoffice) للموافقة على الشحنة.

---

**Test Case ID:** TC-298
**E2E Scenario:** رحلة حذف الحساب من البداية للنهاية
**Feature:** Delete account E2E
**Priority:** High
**Test Type:** End-to-End (Destructive)
**Preconditions:** حساب اختبار ثانوي مصنوع خصيصًا للحذف.
**Steps to Execute:**
1. سجّل بالحانتين ← انشر إعلانين ← اشحن المحفظة بتحويل ← تفاعل (مفضلة/رسائل).
2. من الإعدادات ← Delete Account ← "Delete now".
3. حاول تسجيل الدخول بنفس الجلسة/البيانات.
**Expected Results:**
- الحذف يتم بالكامل؛ الحساب يختفي من بيانات السيرفر (لا يملك الدخول مجددًا إلا بإعادة التسجيل)؛ المنتج/الرسائل المتاحة للطرف الآخر وفقًا لسياسات السيرفر.
**Actual Results:**
**Status:** Not Run
**Notes:** استخدم حسابًا ثانويًا — لا يمكن الاسترجاع.

---

**Test Case ID:** TC-299
**E2E Scenario:** رحلة تبديل اللغة أثناء مراجعة إحصائيات/إعدادات معقدة
**Feature:** Language switch E2E
**Priority:** Medium
**Test Type:** End-to-End
**Preconditions:** العربية افتراضية.
**Steps to Execute:**
1. بالعربية: افتح الإحصائيات ← لاحظ الأسهم وردود الشهر.
2. افتح ورقة تغيير اللغة ← اختر English.
3. لاحظ كل الشاشات: Home ← Search ← Statistics ← Settings ← Details.
4. ارجع للعربية.
**Expected Results:**
- كل النصوص تتبدل فورًا؛ RTL↔LTR يتبدل كاملًا؛ اتجاهات الشهور (الشهر السابق/التالي) تتبع الاتجاه؛ لا تراكبات في أي شاشة.
**Actual Results:**
**Status:** Not Run
**Notes:**

---

**Test Case ID:** TC-300
**E2E Scenario:** رحلة الإشعار ← فتح الإشعار ← الشات ← Mark all read
**Feature:** FCM → Notifications → Chat E2E
**Priority:** High
**Test Type:** End-to-End (Needs Backoffice)
**Preconditions:** حساب B سيرسل FCM من الخادم (يحتاج إداري)؛ A مفتوح بالخلفية.
**Steps to Execute:**
1. من Backoffice أرسل FCM إلى حساب A بعنوان "رسالة من البائع".
2. على A (مفتوح بالخلفية): لاحظ الإشعار المحلي + زيادة عدّاد الجرس.
3. اضغط الإشعار ← تُفتح شاشة الإشعارات.
4. اضغط على الإشعار ← يصبح مقروءًا.
5. افتح المنشور المرتبط بالشات ← تجد رسالة البائع؛ رد عليها.
**Expected Results:**
- كل دورة الاتصال تعمل من إشعار إلى رد؛ عدّادات الجرس والتبويب متوافقة؛ الإشعار يعالج حتى عند الخلفية عبر resume path.
**Actual Results:**
**Status:** Not Run
**Notes:** (Needs Backoffice) لإرسال FCM.

---

# 13. قائمة اختبارات الانحدار (Regression Checklist)

> أعد تنفيذ هذه القائمة بعد **أي** تعديل في الكود قبل النشر. ضع علامة [x] عند كل اجتياز.

**Authentication & Account**
- [ ] تسجيل الدخول ناجح ← LayoutView (TC-180)
- [ ] دخول توكن محفوظ ← LayoutView مباشرة بعد kill (TC-186)
- [ ] تسجيل الخروج يمسح التوكن عبر logout (TC-185)
- [ ] OTP ناجح ← ChooseLocation ← LayoutView (TC-006 → TC-008)
- [ ] مقاطعة تفعيل — fallback سلوك واضح (TC-194)

**Guest Mode**
- [ ] الدخول كزائر يعرض السوق بحرية (TC-175)
- [ ] تبويبات Chat/Ads/Account مقيدة (TC-176, TC-177)
- [ ] قلب التفضلة/التقييم/التبليغ مقيدة للزائر (TC-051, TC-072, TC-161)

**Home & Catalog**
- [ ] الرئيسية تجلب البيانات والبانرات والفئات وBest View (TC-016)
- [ ] AllCategories/AllSubCategories/ProductsGrid تتنقل بحرية (TC-023 → TC-030)
- [ ] البحث يعيد الصفحة الأولى مع الفلتر السيرفري (TC-036, TC-038)
- [ ] Pagination: يحمّل المزيد وينتهي عند last_page (TC-039, TC-250)

**Product & Interaction**
- [ ] تفاصيل المنتج تُحمّل كل الأقسام (TC-048)
- [ ] تقييم منتج يعمل ويُحدث العدد (TC-050)
- [ ] إضافة/إزالة مفضلة متسقة عبر الشاشات (TC-067 → TC-073, TC-222)
- [ ] مقارنة منتجين والسلوك عند تجاوز 2 (TC-060, TC-061, TC-062)

**Publishing & Payment**
- [ ] نشر إعلان بدون اشتراك ← ورقة الدفع تظهر (TC-079)
- [ ] نشر بمحفظة كافية ينشر ويخصم (TC-080, TC-117)
- [ ] نشر مغطى بالاشتراك ← بدون حقول دفع (TC-078, TC-217)
- [ ] تعديل إعلان يُرسل التعديلات فقط (TC-090, TC-091)
- [ ] إيقاف/تفعيل إعلان من إعلاناتي (TC-096, TC-097)
- [ ] حذف إعلان بحوار التأكيد (TC-098)

**Chat**
- [ ] إنشاء محادثة من تفاصيل المنتج (TC-144)
- [ ] إرسال/استقبال نص وصورة (TC-145, TC-146, TC-147)
- [ ] عدّاد غير المقروء يحدّث (TC-151)
- [ ] حذف/إخفاء محادثة (TC-149, TC-150)

**System**
- [ ] الإشعار المحلي يظهر عند FCM foreground (TC-253)
- [ ] ضغط الإشعار في الخلفية/المنطفئ يفتح الإشعارات (TC-254)
- [ ] أي endpoint 401 يجبر الخروج إلى Login (TC-187, TC-247)
- [ ] اللغة تتبدل مع كل الشاشات دون إعادة تشغيل (TC-129, TC-130, TC-299)
- [ ] الـ Theme داكن/فاتح محفوظ (TC-131, TC-203)
- [ ] لا انهيار مع صور مكسورة/روابط ميتة/حقول فارغة (TC-091, TC-127, TC-205)

---

# 14. التقرير النهائي للاختبار (Final Testing Report)

> حدّث هذا القسم تلقائيًا بعد انتهاء التنفيذ، أو انسخه إلى أداة إدارة اختبارات (TestRail/Zephyr/Xray).

## 14.1 إحصاءات الحالات

| المقياس | العدد | ملاحظة |
|---|---|---|
| إجمالي حالات الاختبار | **300** | TC-001 إلى TC-300 |
| Passed | — | تُحدّث بعد التنفيذ |
| Failed | — | تُحدّث بعد التنفيذ |
| Blocked | — | تُحدّث بعد التنفيذ |
| Not Run | **300** | الوضع الافتراضي الحالي |
| اختبارات Critical | — | املأ بعد الجرد |
| اختبارات High | — | |
| اختبارات Medium | — | |
| اختبارات Low | — | |

## 14.2 العيوب المكتشفة

| فئة العيب | العدد | أمثلة من هذا الملف (موثقة كـ "Behavior حالي") |
|---|---|---|
| Critical | — | OTP الكود يُعرض للمستخدم (TC-270)؛ حذف الحساب بلا تأكيد ثانٍ (TC-275) |
| Major | — | isActive == false تجميد تحميل (TC-194)؛ التوكن بعد حذف الحساب يبقى (TC-277)؛ النشر/قديم legacy non-functional |
| Minor | — | نصوص العربية المهاردكود بكل الشاشات؛ Share بلا وظيفة (TC-058)؛ Notify switch غير محفوظ (TC-173)؛ EN متضمنة العربية بلا ترجمة (TC-202) |

## 14.3 قائمة العيوب التفصيلية (تُملا بعد التنفيذ)

| # | TC المصدر | الوصف | الخطورة | الخطوات | المتوقع | الفعلي | الحالة |
|---|---|---|---|---|---|---|---|
| BUG-001 | TC-270 | OTP يعرض الكود في الـ Toast (سلوك الكود الفعلي) | Critical | — | لا يظهر الكود | `OTP : <code>` | Open |
| BUG-002 | TC-275 | "Delete now" بلا حوار تأكيد ثانٍ | High | — | حوار تأكيد | تنفيذ فوري | Open |
| BUG-003 | TC-277 | التوكن يبقى بعد حذف الحساب | High | — | مسح التوكن | يبقى في secure storage | Open |
| BUG-004 | TC-194 | isActive=false → الشاشة تجمد | Medium | — | شاشة تفعيل واضحة | لا state يُصدر | Open |
| BUG-005 | TC-058 | زر المشاركة Share بلا وظيفة | Low | — | فتح ورقة مشاركة | `() {}` | Open |
| BUG-006 | TC-173 | مفتاح Notify في البروفايل وهمي | Low | — | حفظ الحالة | محلي غير محفوظ | Open |
| | | | | | | | |

## 14.4 النتيجة الإجمالية (تُملا بعد التنفيذ)

**معيار اجتياز الإطلاق المقترح:**
- كل حالات **Critical** = Pass أو Bugs معروفة ودونها إغلاق بقرار موقّع.
- كل حالات **High** = Pass أو Bugs مُسجلة بخطورة متفق عليها.
- صفر Critical مفتوح في: المصادقة، الدفع، النشر، حذف الحساب، 401.
- ≥ 90% من إجمالي الحالات Pass أو Blocked بسبب بيئي معلَن.

| البند | النتيجة |
|---|---|
| إجمالي الحالات المنفذة | — / 300 |
| % Pass | — % |
| عدد الأخطاء Critical/Major المفتوحة | — |
| التوصية | ⬜ يعتمد للإطلاق — ⬜ يعتمد بشرط — ⬜ لا يعتمد حتى الإصلاح |

## 14.5 ملاحظات تكميلية

1. **قبل أول تنفيذ حقيقي**: تأكد أنك تستخدم حساب اختبار ثانوي للحذف/النشر حتى لا تفقد بيانات حقيقية.
2. أكثر الحالات تعتمد على **إنترنت مستقر + خادم سليم**؛ أي عيب بيئة يُسجل كـ Blocked وليس Fail.
3. الحالات الموسومة **(Needs Dev Support)** تحتاج مساعدة مطور أو حساب Admin/Backoffice — يُفضّل QA مستقل مع مطور أثناء التنفيذ.
4. الحالات الخاصة بالدفع/الشحن تحتاج رصيد اختبار في المحفظة — نتّبع إجراء الشحن مرة واحدة ثم يعاد استخدام الرصيد.
5. هذا الملف ليس بديلًا عن اختبار الأداء والحمل (خارج النطاق).
6. عند العثور على سلوك يتعارض مع هذا الملف وليس توثيقًا هنا — سجّله Defect جديد وأبلغ مدير المشروع، ولا تعدّل خطوات الحالة دون موافقة.

---

*نهاية الوثيقة — TEST_SCENARIOS.md — أنشئت وفق الكود الفعلي بدون تعديل أي مصدر في التطبيق.*
