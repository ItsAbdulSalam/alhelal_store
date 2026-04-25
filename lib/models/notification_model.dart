import 'package:flutter/material.dart';

enum NotificationCategory { order, cart, offer, system }

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final NotificationCategory category;
  final bool isRead;
  final String? payload;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.category,
    this.isRead = false,
    this.payload,
  });

  AppNotification copyWith({bool? isRead}) => AppNotification(
        id: id,
        title: title,
        body: body,
        createdAt: createdAt,
        category: category,
        isRead: isRead ?? this.isRead,
        payload: payload,
      );

  Color get color {
    switch (category) {
      case NotificationCategory.order:
        return const Color(0xFF34C759);
      case NotificationCategory.cart:
        return const Color(0xFFE8960C);
      case NotificationCategory.offer:
        return const Color(0xFFFF2D55);
      case NotificationCategory.system:
        return const Color(0xFF007AFF);
    }
  }

  IconData get icon {
    switch (category) {
      case NotificationCategory.order:
        return Icons.receipt_long_outlined;
      case NotificationCategory.cart:
        return Icons.shopping_bag_outlined;
      case NotificationCategory.offer:
        return Icons.local_offer_outlined;
      case NotificationCategory.system:
        return Icons.info_outline_rounded;
    }
  }

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inSeconds < 60) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays == 1) return 'أمس';
    return 'منذ ${diff.inDays} أيام';
  }
}