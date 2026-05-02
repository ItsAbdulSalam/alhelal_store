class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String? profilePic;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
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
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}