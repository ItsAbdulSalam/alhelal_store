# 🚀 ALHELAL PRIME - Modern E-Commerce Solution

<p align="center">
  <img src="assets/images/logo.png" width="150" alt="Alhelal Prime Logo">
</p>

**ALHELAL PRIME** هو تطبيق متجر إلكتروني متكامل وعالي الأداء تم بناؤه باستخدام إطار عمل **Flutter**. يهدف التطبيق إلى تقديم تجربة تسوق سلسة، سريعة، وآمنة للمستخدمين، مع الاعتماد على أحدث المعايير الهندسية في تطوير تطبيقات الهاتف المحمول.

---

## 📱 واجهة التطبيق (App Preview)

| الملف الشخصي | الإشعارات اللحظية | تعديل البيانات |
| :---: | :---: | :---: |
| <img src="https://via.placeholder.com/200x400?text=Profile+Screen" width="200"> | <img src="https://via.placeholder.com/200x400?text=Notifications" width="200"> | <img src="https://via.placeholder.com/200x400?text=Edit+Profile" width="200"> |

> *ملاحظة: يمكنك استبدال الروابط أعلاه بصور حقيقية من مجلد `screenshots` الخاص بك لزيادة جاذبية المستودع.*

---

## 🛠 التقنيات المستخدمة (Tech Stack)

تم بناء التطبيق باستخدام مجموعة من التقنيات والأدوات المتقدمة لضمان استقرار الأداء وسهولة التوسع:

*   **State Management**: تم اعتماد نمط **BLoC (Business Logic Component)** لفصل منطق الأعمال عن واجهات المستخدم. مما يضمن أداءً متميزاً وتدفقاً منطقياً للبيانات.
*   **Backend**: التكامل مع **Firebase** لإدارة المستخدمين وقواعد البيانات اللحظية.
*   **Architecture**: يتبع المشروع مبادئ **Clean Code Architecture** حيث تم تقسيم الكود إلى طبقات (Data, Domain, Presentation) لسهولة الصيانة والاختبار.
*   **Local Notifications**: دمج نظام إشعارات محلي متطور لمتابعة حالة الطلبات وإرسال العروض التسويقية.
*   **Data Desugaring**: لضمان توافقية التطبيق مع إصدارات أندرويد المختلفة.
*   **UI Components**: استخدام **Flutter SVG** و **Gap** لتحويل تصاميم **Figma** إلى واجهات برمجية دقيقة.

---

## ✨ المميزات الرئيسية (Key Features)

*   ✅ **نظام إشعارات ذكي**: تنبيهات فورية عند تأكيد الطلب، الشحن، أو التوصيل، بالإضافة إلى إشعارات العروض الخاصة.
*   ✅ **إدارة متقدمة للسلة**: نظام إضافة وتعديل المنتجات في سلة التسوق مع تحديثات لحظية باستخدام BLoC.
*   ✅ **بحث وفلترة متطورة**: محرك بحث داخلي يسمح للمستخدمين بالوصول للمنتجات بسرعة ودقة.
*   ✅ **تصميم متجاوب (Responsive Design)**: واجهات مستخدم عصرية تتناسب مع مختلف أحجام الشاشات.
*   ✅ **هوية بصرية قوية**: تنسيق ألوان متناسق (Black & Orange) يعكس هوية **ALHELAL PRIME**.

---

## 🏗️ هيكلية المشروع (Project Structure)

```text
lib/
├── bloc/          # إدارة الحالات (Auth, Profile, Notifications, Cart, Address)
├── models/        # نماذج البيانات (User, Product, Notification, Order)
├── screens/       # واجهات المستخدم (Auth, Home, Profile, Checkout)
├── services/      # الخدمات الخارجية (Firebase, Database, Notifications)
├── shared/        # الثيمات، الألوان، والثوابت
└── widgets/       # العناصر البرمجية القابلة لإعادة الاستخدام
