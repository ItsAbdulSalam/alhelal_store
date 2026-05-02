part of 'profile_bloc.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}

// تحميل بيانات الملف الشخصي
class LoadProfile extends ProfileEvent {}

// تحديث البيانات النصية (الاسم، البريد، الهاتف)
class UpdateProfile extends ProfileEvent {
  final String name;
  final String email;
  final String phone;

  UpdateProfile({required this.name, required this.email, required this.phone});
}

// --- الحدث الجديد الذي أضفناه لحل مشكلة الصورة ---
class UpdateAvatar extends ProfileEvent {
  final String newPath;
  const UpdateAvatar({required this.newPath});
}

// إدارة الإشعارات
class MarkAllNotificationsRead extends ProfileEvent {}

class ToggleNotificationRead extends ProfileEvent {
  final int index;
  ToggleNotificationRead(this.index);
}

// إدارة بطاقات الدفع
class AddPaymentCard extends ProfileEvent {
  final Map<String, dynamic> card;
  AddPaymentCard(this.card);
}

class UpdatePaymentCard extends ProfileEvent {
  final int index;
  final Map<String, dynamic> card;
  UpdatePaymentCard(this.index, this.card);
}

class SelectPaymentCard extends ProfileEvent {
  final int index;
  SelectPaymentCard(this.index);
}
