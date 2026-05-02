import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_store/services/database_service.dart';
import 'package:first_store/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:first_store/bloc/profile/profile_bloc.dart';
import 'package:first_store/bloc/Auth/auth_bloc.dart';
import 'package:first_store/bloc/favorites_bloc.dart';
import 'package:first_store/bloc/notifications/notifications_bloc.dart';

import 'package:first_store/screens/AddressScreen.dart';
import 'package:first_store/screens/EditProfileScreen.dart';
import 'package:first_store/screens/notifications_screen.dart';
import 'package:first_store/screens/order_history_screen.dart';
import 'package:first_store/shared/app_colors.dart';
import 'package:first_store/shared/theme_provider.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: c.isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: c.bg,
        appBar: AppBar(
          backgroundColor: c.bg,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'الملف الشخصي',
            style: TextStyle(
              color: c.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: _ThemeToggle(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const _RealtimeProfileHeader(),
              const Gap(20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _StatsCard(),
              ),
              const Gap(28),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _SectionLabel(label: 'الحساب'),
              ),
              const Gap(10),
              // ربط القائمة بالبلوك لتحديث عداد الإشعارات لحظياً
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<NotificationsBloc, NotificationsState>(
                  builder: (context, state) {
                    return _MenuCard(unreadCount: state.unreadCount);
                  },
                ),
              ),
              const Gap(20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _LogoutButton(),
              ),
              const Gap(36),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// المكونات الفرعية (Widgets)
// ══════════════════════════════════════════════════════════

class _RealtimeProfileHeader extends StatelessWidget {
  const _RealtimeProfileHeader();
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        String name = "جارِ التحميل...";
        String? avatar;
        if (snapshot.hasData && snapshot.data!.exists) {
          var data = snapshot.data!.data() as Map<String, dynamic>;
          name = data['fullName'] ?? "مستخدم";
          avatar = data['profilePic'];
        }
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: c.profileGradient,
            ),
            border: Border(bottom: BorderSide(color: c.border, width: 0.5)),
          ),
          child: Column(
            children: [
              const Gap(24),
              _AvatarWidget(avatarUrl: avatar),
              const Gap(14),
              Text(
                name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
              const Gap(4),
              Text(
                user?.email ?? "",
                style: TextStyle(fontSize: 12, color: c.textSecondary),
              ),
              const _PrimeBadge(),
            ],
          ),
        );
      },
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard();
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border, width: 0.5),
      ),
      child: Row(
        children: [
          _buildStat(uid, 'orders', 'طلب', c),
          Container(width: 0.5, height: 32, color: c.border),
          Expanded(
            child: BlocBuilder<FavoritesBloc, FavoritesState>(
              builder: (context, state) {
                String val = (state is FavoritesUpdated)
                    ? state.items.length.toString()
                    : "0";
                return _StatItem(label: 'مفضلة', value: val, c: c);
              },
            ),
          ),
          Container(width: 0.5, height: 32, color: c.border),
          _buildStat(uid, 'addresses', 'عنوان', c),
        ],
      ),
    );
  }

  Widget _buildStat(String? uid, String col, String lab, AppColors c) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection(col)
            .snapshots(),
        builder: (context, snap) => _StatItem(
          label: lab,
          value: snap.hasData ? snap.data!.docs.length.toString() : "0",
          c: c,
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final int unreadCount;
  const _MenuCard({required this.unreadCount});

  @override
  Widget build(BuildContext context) {
    final List<_MenuItemData> items = [
      _MenuItemData(
        icon: Icons.person_outline_rounded,
        title: 'تعديل البيانات',
        subtitle: 'الاسم، البريد الإلكتروني',
        target: const EditProfileScreen(),
      ),
      _MenuItemData(
        icon: Icons.receipt_long_outlined,
        title: 'طلباتي',
        subtitle: 'سجل المشتريات السابق',
        target: const OrderHistoryScreen(),
      ),
      _MenuItemData(
        icon: Icons.location_on_outlined,
        title: 'عناوين التوصيل',
        subtitle: 'إدارة مواقع الاستلام',
        target: const AddressScreen(),
      ),
      _MenuItemData(
        icon: Icons.notifications_none_outlined,
        title: 'الإشعارات',
        subtitle: 'تنبيهات العروض',
        badge: unreadCount,
        target: const NotificationsScreen(),
      ),
    ];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.of(context).border, width: 0.5),
      ),
      child: Column(
        children: items
            .asMap()
            .entries
            .map(
              (e) =>
                  _MenuTile(item: e.value, isLast: e.key == items.length - 1),
            )
            .toList(),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final _MenuItemData item;
  final bool isLast;
  const _MenuTile({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => item.target!),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(item.icon, color: c.gold, size: 20),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: c.textPrimary,
                        ),
                      ),
                      Text(
                        item.subtitle,
                        style: TextStyle(fontSize: 11, color: c.textSecondary),
                      ),
                    ],
                  ),
                ),
                if (item.badge > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: c.gold,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${item.badge}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: c.textMuted,
                ),
              ],
            ),
          ),
        ),
        if (!isLast) Divider(height: 1, indent: 50, color: c.border),
      ],
    );
  }
}

// الـ Widgets المساعدة (ThemeToggle, Avatar, Badge, Logout, Data Classes)
class _ThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThemeProvider>();
    final c = AppColors.of(context);
    return GestureDetector(
      onTap: provider.toggle,
      child: Container(
        width: 48,
        height: 24,
        decoration: BoxDecoration(
          color: provider.isDark ? c.gold : c.surfaceHigh,
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: provider.isDark
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(2),
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _AvatarWidget extends StatelessWidget {
  final String? avatarUrl;
  const _AvatarWidget({this.avatarUrl});
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: c.gold.withOpacity(0.5), width: 1.5),
      ),
      child: CircleAvatar(
        radius: 44,
        backgroundColor: c.surfaceHigh,
        backgroundImage: (avatarUrl != null && avatarUrl!.startsWith('http'))
            ? NetworkImage(avatarUrl!)
            : null,
        child: (avatarUrl == null)
            ? Icon(Icons.person_rounded, size: 40, color: c.textMuted)
            : null,
      ),
    );
  }
}

class _PrimeBadge extends StatelessWidget {
  const _PrimeBadge();
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 24, top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: c.gold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.gold.withOpacity(0.25), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, color: c.gold, size: 12),
          const Gap(4),
          Text(
            'PRIME MEMBER',
            style: TextStyle(
              color: c.gold,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerRight,
    child: Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.of(context).textMuted,
      ),
    ),
  );
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final AppColors c;
  const _StatItem({required this.label, required this.value, required this.c});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 18),
    child: Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: c.gold,
          ),
        ),
        const Gap(3),
        Text(label, style: TextStyle(fontSize: 11, color: c.textSecondary)),
      ],
    ),
  );
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return InkWell(
      onTap: () => context.read<AuthBloc>().add(LogoutRequested()),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: c.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.error.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: c.error, size: 18),
            const Gap(8),
            Text(
              'تسجيل الخروج',
              style: TextStyle(color: c.error, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? target;
  final int badge;
  _MenuItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.target,
    this.badge = 0,
  });
}
