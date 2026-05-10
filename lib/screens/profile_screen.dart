import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:first_store/bloc/Auth/auth_bloc.dart';
import 'package:first_store/bloc/favorites_bloc.dart';
import 'package:first_store/bloc/notifications/notifications_bloc.dart';
import 'package:first_store/shared/app_colors.dart';
import 'package:first_store/shared/theme_provider.dart';

import 'package:first_store/screens/AddressScreen.dart';
import 'package:first_store/screens/EditProfileScreen.dart';
import 'package:first_store/screens/notifications_screen.dart';
import 'package:first_store/screens/order_history_screen.dart';

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
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          actions: const [_NewThemeAction(), Gap(10)],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const _RealtimeProfileHeader(),
                const Gap(12),
                const _StatsCard(),
                const Gap(15),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: c.border.withOpacity(0.5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: BlocBuilder<NotificationsBloc, NotificationsState>(
                      builder: (context, state) {
                        return _buildMenuList(context, state.unreadCount, c);
                      },
                    ),
                  ),
                ),
                const Gap(12),
                const _LogoutButton(),
                const Gap(12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuList(BuildContext context, int unreadCount, AppColors c) {
    final List<_MenuItemData> items = [
      _MenuItemData(
        icon: Icons.person_rounded,
        title: 'تعديل البيانات',
        subtitle: 'إدارة معلوماتك الشخصية',
        target: const EditProfileScreen(),
      ),
      _MenuItemData(
        icon: Icons.shopping_bag_rounded,
        title: 'طلباتي',
        subtitle: 'تتبع مشترياتك السابقة',
        target: const OrderHistoryScreen(),
      ),
      _MenuItemData(
        icon: Icons.location_on_rounded,
        title: 'عناوين التوصيل',
        subtitle: 'مواقع استلام الطلبات',
        target: const AddressScreen(),
      ),
      _MenuItemData(
        icon: Icons.notifications_rounded,
        title: 'الإشعارات',
        subtitle: 'العروض والتنبيهات الجديدة',
        badge: unreadCount,
        target: const NotificationsScreen(),
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        indent: 60,
        endIndent: 20,
        color: c.border.withOpacity(0.4),
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          visualDensity: VisualDensity.compact,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: c.gold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: c.gold, size: 20),
          ),
          title: Text(
            item.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: c.textPrimary,
            ),
          ),
          subtitle: Text(
            item.subtitle,
            style: TextStyle(fontSize: 11, color: c.textSecondary),
          ),
          trailing: item.badge > 0
              ? _buildBadge(item.badge, c)
              : Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: c.textMuted,
                ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => item.target!),
          ),
        );
      },
    );
  }

  Widget _buildBadge(int count, AppColors c) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Colors.orange,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _NewThemeAction extends StatelessWidget {
  const _NewThemeAction();
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThemeProvider>();
    return IconButton(
      onPressed: provider.toggle,
      icon: Icon(
        provider.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
        color: provider.isDark ? Colors.amber : Colors.blueGrey,
      ),
    );
  }
}

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
          final data = snapshot.data!.data() as Map<String, dynamic>;
          name = data['fullName'] ?? "مستخدم";
          avatar = data['profilePic'];
        }
        return Column(
          children: [
            _AvatarWidget(avatarUrl: avatar),
            const Gap(8),
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: c.textPrimary,
              ),
            ),
            Text(
              user?.email ?? "",
              style: TextStyle(fontSize: 12, color: c.textSecondary),
            ),
            const _PrimeBadge(),
          ],
        );
      },
    );
  }
}

class _AvatarWidget extends StatelessWidget {
  final String? avatarUrl;
  const _AvatarWidget({this.avatarUrl});
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return CircleAvatar(
      radius: 42,
      backgroundColor: c.gold.withOpacity(0.2),
      child: CircleAvatar(
        radius: 39,
        backgroundColor: c.surfaceHigh,
        backgroundImage: (avatarUrl != null && avatarUrl!.startsWith('http'))
            ? NetworkImage(avatarUrl!)
            : null,
        child: (avatarUrl == null)
            ? Icon(Icons.person_rounded, size: 35, color: c.textMuted)
            : null,
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.border.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatStream(uid, 'orders', 'طلب', c),
          _buildStatBloc('مفضلة', c),
          _buildStatStream(uid, 'addresses', 'عنوان', c),
        ],
      ),
    );
  }

  Widget _buildStatStream(String? uid, String col, String lab, AppColors c) {
    return StreamBuilder<QuerySnapshot>(
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
    );
  }

  Widget _buildStatBloc(String lab, AppColors c) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        final String val = (state is FavoritesUpdated)
            ? state.items.length.toString()
            : "0";
        return _StatItem(label: lab, value: val, c: c);
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label, value;
  final AppColors c;
  const _StatItem({required this.label, required this.value, required this.c});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        value,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: c.gold,
        ),
      ),
      Text(label, style: TextStyle(fontSize: 11, color: c.textSecondary)),
    ],
  );
}

// ── القسم الذي قمنا بحل مشكلة الـ 3000ms فيه ──────────────────────────────
class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return InkWell(
      onTap: () => _showLogoutConfirm(context, c),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withOpacity(0.1)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.power_settings_new_rounded,
              color: Colors.redAccent,
              size: 20,
            ),
            Gap(8),
            Text(
              'تسجيل الخروج',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirm(BuildContext context, AppColors c) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: c.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('تسجيل الخروج', textAlign: TextAlign.center),
        content: const Text(
          'هل أنت متأكد أنك تريد مغادرة الحساب؟',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('إلغاء', style: TextStyle(color: c.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              // 1. إغلاق الديالوج فوراً باستخدام rootNavigator
              Navigator.of(context, rootNavigator: true).pop();

              // 2. القفز اللحظي وتنظيف الذاكرة قبل حدوث الـ Lag
              Future.microtask(() {
                // ✅ مسح كاش الصور فوراً لتجنب الـ 3000ms
                PaintingBinding.instance.imageCache.clear();
                PaintingBinding.instance.imageCache.clearLiveImages();

                // ✅ القفز الفوري لصفحة الترحيب (الهروب من صفحة البروفايل الثقيلة)
                // ignore: use_build_context_synchronously
                Navigator.of(
                  // ignore: use_build_context_synchronously
                  context,
                ).pushNamedAndRemoveUntil('/welcome', (route) => false);

                // ✅ إرسال حدث الخروج (سيتم تنفيذه في الخلفية)
                // ignore: use_build_context_synchronously
                context.read<AuthBloc>().add(LogoutRequested());
              });
            },
            child: const Text(
              'خروج',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
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
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: c.gold,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'PRIME MEMBER ✨',
        style: TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String title, subtitle;
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
