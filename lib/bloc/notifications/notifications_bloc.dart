// ← كل الـ imports هنا فقط
import 'package:first_store/models/notification_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc
    extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(const NotificationsState()) {
    on<AddNotification>(_onAdd);
    on<MarkAsRead>(_onMarkRead);
    on<MarkAllAsRead>(_onMarkAllRead);
    on<DeleteNotification>(_onDelete);
    on<ClearAllNotifications>(_onClearAll);
  }

  void _onAdd(AddNotification e, Emitter<NotificationsState> emit) {
    emit(state.copyWith(
      notifications: [e.notification, ...state.notifications],
    ));
  }

  void _onMarkRead(MarkAsRead e, Emitter<NotificationsState> emit) {
    emit(state.copyWith(
      notifications: state.notifications
          .map((n) => n.id == e.id ? n.copyWith(isRead: true) : n)
          .toList(),
    ));
  }

  void _onMarkAllRead(
      MarkAllAsRead e, Emitter<NotificationsState> emit) {
    emit(state.copyWith(
      notifications: state.notifications
          .map((n) => n.copyWith(isRead: true))
          .toList(),
    ));
  }

  void _onDelete(DeleteNotification e, Emitter<NotificationsState> emit) {
    emit(state.copyWith(
      notifications:
          state.notifications.where((n) => n.id != e.id).toList(),
    ));
  }

  void _onClearAll(
      ClearAllNotifications e, Emitter<NotificationsState> emit) {
    emit(const NotificationsState());
  }
}