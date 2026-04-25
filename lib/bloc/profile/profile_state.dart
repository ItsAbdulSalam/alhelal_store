part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, loaded, saving, error }

class ProfileState {
  final ProfileStatus status;
  final String name;
  final String email;
  final String phone;
  final String avatarPath;
  final List<Map<String, dynamic>> notifications;
  final List<Map<String, dynamic>> paymentCards;
  final int selectedCardIndex;
  final String? errorMessage;
  final bool isSaved;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.name = '',
    this.email = '',
    this.phone = '',
    this.avatarPath = 'assets/images/me.jpg',
    this.notifications = const [],
    this.paymentCards = const [],
    this.selectedCardIndex = 0,
    this.errorMessage,
    this.isSaved = false,
  });

  int get unreadCount =>
      notifications.where((n) => !(n['isRead'] as bool)).length;

  ProfileState copyWith({
    ProfileStatus? status,
    String? name,
    String? email,
    String? phone,
    String? avatarPath,
    List<Map<String, dynamic>>? notifications,
    List<Map<String, dynamic>>? paymentCards,
    int? selectedCardIndex,
    String? errorMessage,
    bool? isSaved,
  }) {
    return ProfileState(
      status: status ?? this.status,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarPath: avatarPath ?? this.avatarPath,
      notifications: notifications ?? this.notifications,
      paymentCards: paymentCards ?? this.paymentCards,
      selectedCardIndex: selectedCardIndex ?? this.selectedCardIndex,
      errorMessage: errorMessage ?? this.errorMessage,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}