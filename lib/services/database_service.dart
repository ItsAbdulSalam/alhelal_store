import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_model.dart'; // تأكد من صحة المسار لموديل المستخدم لديك

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // 1. دالة حفظ بيانات المستخدم عند التسجيل (التي يفتقدها الـ AuthBloc)
  Future<void> saveUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      print("Error saving user: $e");
      rethrow;
    }
  }

  // 2. دالة جلب بيانات المستخدم (لشاشة البروفايل)
  Future<UserModel?> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error getting user: $e");
    }
    return null;
  }

  // 3. دالة رفع الصورة وتحديث الرابط
  Future<String?> uploadProfileImage(File imageFile, String uid) async {
    try {
      Reference ref = _storage.ref().child('profile_pics').child('$uid.jpg');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // تحديث حقل الصورة في Firestore
      await _db.collection('users').doc(uid).update({
        'profilePic': downloadUrl,
      });

      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
