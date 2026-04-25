part of 'notifications_bloc.dart';

// ← لا imports هنا أيضاً

class NotificationsState {
  final List<AppNotification> notifications;

  const NotificationsState({
    this.notifications = const [],
  });

  int get unreadCount =>
      notifications.where((n) => !n.isRead).length;

  NotificationsState copyWith({
    List<AppNotification>? notifications,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
    );
  }
}