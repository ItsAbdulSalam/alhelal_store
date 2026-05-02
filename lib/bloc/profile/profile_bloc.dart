import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart'; // أضف هذا
import 'package:firebase_auth/firebase_auth.dart'; // أضف هذا
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  // تعريف الـ Firestore و Auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ProfileBloc() : super(const ProfileState()) {
    on<LoadProfile>(_onLoad);
    on<UpdateProfile>(_onUpdate);
    on<MarkAllNotificationsRead>(_onMarkAll);
    on<ToggleNotificationRead>(_onToggleRead);
    on<AddPaymentCard>(_onAddCard);
    on<UpdatePaymentCard>(_onUpdateCard);
    on<SelectPaymentCard>(_onSelectCard);
  }

  // ── تحميل البيانات من Firestore ──────────────────────────
  Future<void> _onLoad(LoadProfile e, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // جلب البيانات من Firestore
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data()!;

        // جلب الإشعارات والبطاقات (محلياً حالياً أو يمكنك نقلها لـ Firestore لاحقاً)
        final prefs = await SharedPreferences.getInstance();
        final notifJson = prefs.getString('notifications');
        final cardsJson = prefs.getString('user_cards');

        emit(
          state.copyWith(
            status: ProfileStatus.loaded,
            name: data['fullName'] ?? 'عبد السلام الهلال',
            email: data['email'] ?? user.email,
            phone: data['phoneNumber'] ?? '',
            notifications: notifJson != null
                ? List<Map<String, dynamic>>.from(json.decode(notifJson))
                : _defaultNotifications(),
            paymentCards: cardsJson != null
                ? List<Map<String, dynamic>>.from(json.decode(cardsJson))
                : _defaultCards(),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: 'فشل تحميل البيانات من السحاب',
        ),
      );
    }
  }

  // ── تحديث البيانات في Firestore ──────────────────────────
  Future<void> _onUpdate(UpdateProfile e, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.saving));
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("المستخدم غير مسجل");

      // التحديث في Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'fullName': e.name,
        'email': e.email,
        'phoneNumber': e.phone,
      });

      // اختياري: تحديث الإيميل في نظام الحماية أيضاً إذا تغير
      if (e.email != user.email) {
        // ملاحظة: يتطلب إعادة تسجيل دخول أحياناً
        // await user.updateEmail(e.email);
      }

      emit(
        state.copyWith(
          status: ProfileStatus.loaded,
          name: e.name,
          email: e.email,
          phone: e.phone,
          isSaved: true,
        ),
      );

      // نرجع isSaved لـ false لكي لا تتكرر الرسالة
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(isSaved: false));
    } catch (error) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: 'فشل حفظ البيانات في السحاب',
        ),
      );
    }
  }

  // ── الإشعارات (كما هي حالياً) ────────────────────────────
  Future<void> _onMarkAll(
    MarkAllNotificationsRead e,
    Emitter<ProfileState> emit,
  ) async {
    final updated = state.notifications
        .map((n) => {...n, 'isRead': true})
        .toList();
    await _saveNotifications(updated);
    emit(state.copyWith(notifications: updated));
  }

  Future<void> _onToggleRead(
    ToggleNotificationRead e,
    Emitter<ProfileState> emit,
  ) async {
    final updated = List<Map<String, dynamic>>.from(state.notifications);
    updated[e.index] = {...updated[e.index], 'isRead': true};
    await _saveNotifications(updated);
    emit(state.copyWith(notifications: updated));
  }

  // ── بطاقات الدفع (كما هي حالياً) ─────────────────────────
  Future<void> _onAddCard(AddPaymentCard e, Emitter<ProfileState> emit) async {
    final updated = [...state.paymentCards, e.card];
    await _saveCards(updated);
    emit(state.copyWith(paymentCards: updated));
  }

  Future<void> _onUpdateCard(
    UpdatePaymentCard e,
    Emitter<ProfileState> emit,
  ) async {
    final updated = List<Map<String, dynamic>>.from(state.paymentCards);
    updated[e.index] = e.card;
    await _saveCards(updated);
    emit(state.copyWith(paymentCards: updated));
  }

  void _onSelectCard(SelectPaymentCard e, Emitter<ProfileState> emit) {
    emit(state.copyWith(selectedCardIndex: e.index));
  }

  // ── Helpers ──────────────────────────────────────────────
  Future<void> _saveNotifications(List<Map<String, dynamic>> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notifications', json.encode(list));
  }

  Future<void> _saveCards(List<Map<String, dynamic>> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_cards', json.encode(list));
  }

  List<Map<String, dynamic>> _defaultNotifications() => [
    {
      'title': 'مرحباً بك يا عبد السلام!',
      'body': 'نحن سعداء بانضمامك لـ ALHELAL PRIME.',
      'time': 'الآن',
      'icon': 'check',
      'color': 0xFF4CAF50,
      'isRead': false,
    },
  ];

  List<Map<String, dynamic>> _defaultCards() => [
    {
      'type': 'Visa',
      'number': '4422 **** **** ****',
      'expiry': '09/27',
      'color': 0xFF1A1A1A,
    },
  ];
}
