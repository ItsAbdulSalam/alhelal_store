import 'package:first_store/bloc/notifications/notifications_bloc.dart';
import 'package:first_store/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum NotifType {
  orderConfirmed,
  orderShipped,
  orderDelivered,
  addedToCart,
  offer,
  general,
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // ✅ تصحيح استدعاء initialize بإضافة settings:
    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onTap,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundTap,
    );

    // ✅ تصحيح استدعاء iOS Implementation
    final iosImpl = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    await iosImpl?.requestPermissions(alert: true, badge: true, sound: true);

    // ✅ تصحيح استدعاء Android Implementation
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImpl?.requestNotificationsPermission();

    _initialized = true;
  }

  static void _onTap(NotificationResponse response) {}

  @pragma('vm:entry-point')
  static void _onBackgroundTap(NotificationResponse response) {}

  Future<void> _show({
    required int id,
    required String title,
    required String body,
    NotifType type = NotifType.general,
    String? payload,
  }) async {
    await init();

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId(type),
        _channelName(type),
        channelDescription: 'إشعارات المتجر',
        importance: Importance.high,
        priority: Priority.high,
        color: _color(type),
        enableLights: true,
        playSound: true,
        enableVibration: true,
        styleInformation: const BigTextStyleInformation(''),
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    // ✅ تصحيح السطر 101: تمرير الباراميترات بأسمائها (Named Parameters)
  }

  Future<void> notify({
    required BuildContext context,
    required int localId,
    required String title,
    required String body,
    required NotificationCategory category,
    NotifType type = NotifType.general,
    String? payload,
  }) async {
    await _show(
      id: localId,
      title: title,
      body: body,
      type: type,
      payload: payload,
    );

    if (context.mounted) {
      context.read<NotificationsBloc>().add(
        AddNotification(
          AppNotification(
            id: '${category.name}_${DateTime.now().millisecondsSinceEpoch}',
            title: title,
            body: body,
            createdAt: DateTime.now(),
            category: category,
            payload: payload,
          ),
        ),
      );
    }
  }

  // --- دوال الإشعارات الجاهزة للاستخدام ---

  Future<void> notifyAddedToCart(BuildContext context, String productName) =>
      notify(
        context: context,
        localId: 100,
        title: 'تمت الإضافة للسلة 🛍️',
        body: 'تم إضافة "$productName" إلى حقيبة التسوق',
        category: NotificationCategory.cart,
        type: NotifType.addedToCart,
        payload: '/cart',
      );

  Future<void> notifyOrderConfirmed(BuildContext context, String orderId) =>
      notify(
        context: context,
        localId: 200,
        title: 'تم تأكيد طلبك! ✅',
        body: 'طلبك رقم $orderId قيد التجهيز الآن',
        category: NotificationCategory.order,
        type: NotifType.orderConfirmed,
        payload: '/orders',
      );

  Future<void> notifyOrderShipped(BuildContext context, String orderId) =>
      notify(
        context: context,
        localId: 201,
        title: 'طلبك في الطريق 🚚',
        body: 'تم شحن طلبك رقم $orderId وسيصل قريباً',
        category: NotificationCategory.order,
        type: NotifType.orderShipped,
        payload: '/orders',
      );

  Future<void> notifyOrderDelivered(BuildContext context, String orderId) =>
      notify(
        context: context,
        localId: 202,
        title: 'تم التوصيل بنجاح 🎉',
        body: 'وصل طلبك رقم $orderId — نتمنى أن ينال إعجابك!',
        category: NotificationCategory.order,
        type: NotifType.orderDelivered,
        payload: '/orders',
      );

  Future<void> notifyOffer(
    BuildContext context, {
    required String title,
    required String body,
  }) => notify(
    context: context,
    localId: 300,
    title: title,
    body: body,
    category: NotificationCategory.offer,
    type: NotifType.offer,
    payload: '/home',
  );

  // --- إعدادات القنوات والألوان ---

  String _channelId(NotifType t) {
    switch (t) {
      case NotifType.orderConfirmed:
      case NotifType.orderShipped:
      case NotifType.orderDelivered:
        return 'alhelal_orders';
      case NotifType.addedToCart:
        return 'alhelal_cart';
      case NotifType.offer:
        return 'alhelal_offers';
      default:
        return 'alhelal_main';
    }
  }

  String _channelName(NotifType t) {
    switch (t) {
      case NotifType.orderConfirmed:
      case NotifType.orderShipped:
      case NotifType.orderDelivered:
        return 'الطلبات';
      case NotifType.addedToCart:
        return 'السلة';
      case NotifType.offer:
        return 'العروض';
      default:
        return 'عام';
    }
  }

  Color _color(NotifType t) {
    switch (t) {
      case NotifType.orderConfirmed:
        return const Color(0xFF34C759);
      case NotifType.orderShipped:
        return const Color(0xFF007AFF);
      case NotifType.orderDelivered:
        return const Color(0xFF34C759);
      case NotifType.addedToCart:
        return const Color(0xFFE8960C);
      case NotifType.offer:
        return const Color(0xFFFF2D55);
      default:
        return const Color(0xFFE8960C);
    }
  }
}
