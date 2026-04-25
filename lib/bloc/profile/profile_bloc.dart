import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<LoadProfile>(_onLoad);
    on<UpdateProfile>(_onUpdate);
    on<MarkAllNotificationsRead>(_onMarkAll);
    on<ToggleNotificationRead>(_onToggleRead);
    on<AddPaymentCard>(_onAddCard);
    on<UpdatePaymentCard>(_onUpdateCard);
    on<SelectPaymentCard>(_onSelectCard);
  }

  // ── تحميل البيانات ──────────────────────────────────────
  Future<void> _onLoad(LoadProfile e, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final prefs = await SharedPreferences.getInstance();

      // بيانات المستخدم
      final name = prefs.getString('user_name') ?? 'عبد السلام الهلال';
      final email = prefs.getString('user_email') ?? 'abdulsalam@gmail.com';
      final phone = prefs.getString('user_phone') ?? '+90 5xx xxx xx xx';

      // الإشعارات
      final notifJson = prefs.getString('notifications');
      final notifications = notifJson != null
          ? List<Map<String, dynamic>>.from(json.decode(notifJson))
          : _defaultNotifications();

      // بطاقات الدفع
      final cardsJson = prefs.getString('user_cards');
      final cards = cardsJson != null
          ? List<Map<String, dynamic>>.from(json.decode(cardsJson))
          : _defaultCards();

      emit(state.copyWith(
        status: ProfileStatus.loaded,
        name: name,
        email: email,
        phone: phone,
        notifications: notifications,
        paymentCards: cards,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'فشل تحميل البيانات',
      ));
    }
  }

  // ── تحديث البيانات ──────────────────────────────────────
  Future<void> _onUpdate(UpdateProfile e, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.saving));
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', e.name);
      await prefs.setString('user_email', e.email);
      await prefs.setString('user_phone', e.phone);

      emit(state.copyWith(
        status: ProfileStatus.loaded,
        name: e.name,
        email: e.email,
        phone: e.phone,
        isSaved: true,
      ));
      // نرجع isSaved لـ false بعد ثانية
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(isSaved: false));
    } catch (_) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'فشل حفظ البيانات',
      ));
    }
  }

  // ── الإشعارات ────────────────────────────────────────────
  Future<void> _onMarkAll(
      MarkAllNotificationsRead e, Emitter<ProfileState> emit) async {
    final updated = state.notifications
        .map((n) => {...n, 'isRead': true})
        .toList();
    await _saveNotifications(updated);
    emit(state.copyWith(notifications: updated));
  }

  Future<void> _onToggleRead(
      ToggleNotificationRead e, Emitter<ProfileState> emit) async {
    final updated = List<Map<String, dynamic>>.from(state.notifications);
    updated[e.index] = {...updated[e.index], 'isRead': true};
    await _saveNotifications(updated);
    emit(state.copyWith(notifications: updated));
  }

  // ── بطاقات الدفع ─────────────────────────────────────────
  Future<void> _onAddCard(
      AddPaymentCard e, Emitter<ProfileState> emit) async {
    final updated = [...state.paymentCards, e.card];
    await _saveCards(updated);
    emit(state.copyWith(paymentCards: updated));
  }

  Future<void> _onUpdateCard(
      UpdatePaymentCard e, Emitter<ProfileState> emit) async {
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
          'title': 'تم تأكيد طلبك!',
          'body': 'طلبك رقم #ALH-202499 قيد التجهيز الآن.',
          'time': 'منذ دقيقتين',
          'icon': 'check',
          'color': 0xFF4CAF50,
          'isRead': false,
        },
        {
          'title': 'عرض خاص لفترة محدودة',
          'body': 'خصم 20% على جميع ملحقات آيفون 15. كود: ALHELAL20',
          'time': 'منذ ساعتين',
          'icon': 'offer',
          'color': 0xFFFF8C00,
          'isRead': false,
        },
        {
          'title': 'تم تحديث حالة الطلب',
          'body': 'طلبك السابق تم تسليمه بنجاح.',
          'time': 'أمس',
          'icon': 'delivery',
          'color': 0xFF2196F3,
          'isRead': true,
        },
      ];

  List<Map<String, dynamic>> _defaultCards() => [
        {
          'type': 'Visa',
          'number': '4422 **** **** ****',
          'expiry': '09/27',
          'color': 0xFF1A1A1A,
        },
        {
          'type': 'MasterCard',
          'number': '8855 **** **** ****',
          'expiry': '12/26',
          'color': 0xFFC5A059,
        },
      ];
}