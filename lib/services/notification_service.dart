import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // الدالة العامة لإرسال أي إشعار
  Future<void> sendNotification({
    required String title,
    required String body,
    required String type,
  }) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .add({
            'title': title,
            'body': body,
            'type': type,
            'isRead': false,
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      debugPrint("خطأ في إرسال الإشعار: $e");
    }
  }

  // إشعار تلقائي عند تحديث الملف الشخصي
  Future<void> notifyProfileUpdate() async {
    await sendNotification(
      title: "تم تحديث بياناتك ",
      body:
          "  تم تحديث ملفك الشخصي بنجاح. استمتع بتجربة تسوق أفضل مع الهلال PRIME!",
      type: "promo",
    );
  }

  // إشعار تلقائي عند نجاح طلب شراء
  Future<void> notifyOrderConfirmed(String orderId) async {
    await sendNotification(
      title: "طلبك قيد التحضير 🚚",
      body: "شكراً لثقتك بالهلال برايم. طلبك رقم $orderId تم تأكيده بنجاح.",
      type: "order",
    );
  }
}
