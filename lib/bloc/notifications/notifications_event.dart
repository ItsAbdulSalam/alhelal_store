part of 'notifications_bloc.dart';

abstract class NotificationsEvent {
  const NotificationsEvent();
}

class LoadNotifications extends NotificationsEvent {}

class NotificationsUpdated extends NotificationsEvent {
  final List<AppNotification> notifications;
  const NotificationsUpdated(this.notifications);
}

class MarkAsRead extends NotificationsEvent {
  final String id;
  const MarkAsRead(this.id);
}

class MarkAllAsRead extends NotificationsEvent {}

class DeleteNotification extends NotificationsEvent {
  final String id;
  const DeleteNotification(this.id);
}