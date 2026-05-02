import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final IconData icon;
  final Color color;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
    required this.icon,
    required this.color,
  });

  // دالة لتعديل حالة الإشعار محلياً (ضرورية لتصفير الرقم فوراً)
  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? createdAt,
    bool? isRead,
    IconData? icon,
    Color? color,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  factory AppNotification.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    final type = data?['type'] as String?;

    return AppNotification(
      id: doc.id,
      title: data?['title'] ?? '',
      body: data?['body'] ?? '',
      createdAt: (data?['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data?['isRead'] ?? false,
      icon: _getIcon(type),
      color: _getColor(type),
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    // إذا كان الفرق سالباً أو أقل من دقيقة، نعتبره "منذ ثوانٍ"
    if (diff.isNegative || diff.inSeconds < 60) {
      return 'منذ ثوانٍ';
    }

    if (diff.inMinutes < 60) {
      return 'منذ ${diff.inMinutes} دقيقة';
    }

    if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعة';
    }

    return 'منذ ${diff.inDays} يوم';
  }

  static IconData _getIcon(String? type) {
    switch (type) {
      case 'order':
        return Icons.shopping_bag_rounded;
      case 'promo':
        return Icons.local_offer_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  static Color _getColor(String? type) {
    switch (type) {
      case 'order':
        return Colors.blue;
      case 'promo':
        return Colors.orange;
      default:
        return Colors.amber;
    }
  }
}
