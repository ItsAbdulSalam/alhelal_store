class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String? profilePic;
  final String createdAt; // ✅ 1. أضفنا هذا الحقل ليحفظ تاريخ الإنشاء الحقيقي

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.createdAt, // ✅ 2. جعلناه مطلوباً عند إنشاء الكائن
    this.profilePic,
  });

  // تحويل البيانات من Firestore إلى كلاس
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      profilePic: map['profilePic'],
      // ✅ 3. جلب التاريخ من Firestore أو وضع تاريخ اللحظة الحالية كبديل افتراضي
      createdAt: map['createdAt'] ?? DateTime.now().toIso8601String(),
    );
  }

  // تحويل الكلاس إلى خريطة لحفظها في Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'profilePic': profilePic,
      'createdAt': createdAt, // ✅ 4. حفظ التاريخ الثابت المخزن في الكلاس
    };
  }
}
