part of 'notifications_bloc.dart';

// ← احذف أي import من هنا، الـ part لا يحتاج imports

abstract class NotificationsEvent {
  const NotificationsEvent();
}

class AddNotification extends NotificationsEvent {
  final AppNotification notification;
  const AddNotification(this.notification);
}

class MarkAsRead extends NotificationsEvent {
  final String id;
  const MarkAsRead(this.id);
}

class MarkAllAsRead extends NotificationsEvent {
  const MarkAllAsRead();
}

class DeleteNotification extends NotificationsEvent {
  final String id;
  const DeleteNotification(this.id);
}

class ClearAllNotifications extends NotificationsEvent {
  const ClearAllNotifications();
}