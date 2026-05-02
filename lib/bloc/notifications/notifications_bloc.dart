import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/notification_model.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription? _subscription;

  NotificationsBloc() : super(const NotificationsState()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<NotificationsUpdated>(_onUpdated);
    on<MarkAsRead>(_onMarkAsRead);
    on<MarkAllAsRead>(_onMarkAllAsRead);
    on<DeleteNotification>(_onDelete);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    emit(state.copyWith(isLoading: true));

    await _subscription?.cancel();
    _subscription = _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
          final notifs = snapshot.docs
              .map((doc) => AppNotification.fromFirestore(doc))
              .toList();
          add(NotificationsUpdated(notifs));
        });
  }

  void _onUpdated(
    NotificationsUpdated event,
    Emitter<NotificationsState> emit,
  ) {
    final unread = event.notifications.where((n) => !n.isRead).length;
    emit(
      state.copyWith(
        notifications: event.notifications,
        unreadCount: unread,
        isLoading: false,
      ),
    );
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<NotificationsState> emit,
  ) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      // تحديث محلي فوري لضمان سرعة الاستجابة
      final updatedNotifs = state.notifications.map((n) {
        return n.id == event.id ? n.copyWith(isRead: true) : n;
      }).toList();

      emit(
        state.copyWith(
          notifications: updatedNotifs,
          unreadCount: updatedNotifs.where((n) => !n.isRead).length,
        ),
      );

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .doc(event.id)
          .update({'isRead': true});
    }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<NotificationsState> emit,
  ) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    // تصفير العداد محلياً فوراً أمام المستخدم
    final updatedNotifs = state.notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    emit(state.copyWith(notifications: updatedNotifs, unreadCount: 0));

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();
    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  Future<void> _onDelete(
    DeleteNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .doc(event.id)
          .delete();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
