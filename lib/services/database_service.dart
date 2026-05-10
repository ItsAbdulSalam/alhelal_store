import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/productModel.dart';

class DatabaseService {
  // Singleton Pattern
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // 1. ✅ دالة حفظ بيانات المستخدم (الحل للخطأ الأحمر في الـ Bloc)
  Future<void> saveUser(UserModel user) async {
    try {
      await _db
          .collection('users')
          .doc(user.uid)
          .set(
            user.toMap(),
            SetOptions(merge: true), // يضمن عدم حذف الحقول القديمة عند التحديث
          );
    } catch (e) {
      debugPrint("❌ خطأ في حفظ بيانات المستخدم: $e");
      rethrow;
    }
  }

  // 2. جلب بيانات السلة مع معالجة الأخطاء
  Future<List<CartItem>> getCartItems(String uid) async {
    try {
      final snapshot = await _db
          .collection('users')
          .doc(uid)
          .collection('cart')
          .get();

      final List<CartItem> items = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data.containsKey('product') && data['product'] != null) {
          try {
            items.add(CartItem.fromMap(data));
          } catch (e) {
            debugPrint("⚠️ خطأ في تحويل عنصر واحد بالسلة: $e");
          }
        }
      }
      return items;
    } catch (e) {
      debugPrint("❌ فشل جلب السلة بالكامل: $e");
      return [];
    }
  }

  // 3. رفع الصور والحصول على رابط دائم
  Future<String?> uploadImage({
    required File file,
    required String fileName,
    required String folder,
  }) async {
    try {
      final ref = _storage.ref().child(folder).child('$fileName.jpg');
      final metadata = SettableMetadata(contentType: 'image/jpeg');

      final uploadTask = await ref.putFile(file, metadata);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      debugPrint("❌ خطأ في الرفع: $e");
      return null;
    }
  }

  // 4. تحديث صورة البروفايل
  Future<String?> updateProfileImage(File imageFile, String uid) async {
    final imageUrl = await uploadImage(
      file: imageFile,
      fileName: uid,
      folder: 'profile_pics',
    );

    if (imageUrl != null) {
      await _db.collection('users').doc(uid).update({'profilePic': imageUrl});
    }
    return imageUrl;
  }
}
