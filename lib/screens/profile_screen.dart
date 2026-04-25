
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:first_store/bloc/profile/profile_bloc.dart';
import 'package:first_store/screens/AddressScreen.dart';
import 'package:first_store/screens/EditProfileScreen.dart';
import 'package:first_store/screens/notifications_screen.dart';
import 'package:first_store/screens/order_history_screen.dart';
import 'package:first_store/screens/payment_methods_screen.dart';
import 'package:first_store/shared/app_colors.dart';
import 'package:first_store/shared/theme_provider.dart';

// ═══════════════════════════════════════════════════════════
//  ProfileScreen — Luxury refined, BLoC-powered
//  Dark mode: clean dark with subtle gold accents
//  Light mode: warm ivory — no orange flooding
// ═══════════════════════════════════════════════════════════

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            c.isDark ? Brightness.light : Brightness.dark,
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
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.status == ProfileStatus.loading) {
              return Center(
                child: CircularProgressIndicator(
                  color: c.gold,
                  strokeWidth: 2,
                ),
              );
            }
            if (state.status == ProfileStatus.error) {
              return _ErrorView(
                message: state.errorMessage,
                onRetry: () =>
                    context.read<ProfileBloc>().add(LoadProfile()),
              );
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _ProfileHeader(state: state),
                  const Gap(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _StatsCard(state: state),
                  ),
                  const Gap(28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _SectionLabel(label: 'الحساب'),
                  ),
                  const Gap(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _MenuCard(
                      unreadCount: state.unreadCount,
                    ),
                  ),
                  const Gap(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const _LogoutButton(),
                  ),
                  const Gap(36),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  Profile Header — clean gradient, no color bleeding
// ══════════════════════════════════════════════════════════
class _ProfileHeader extends StatelessWidget {
  final ProfileState state;
  const _ProfileHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Container(
      width: double.infinity,
      // Clean gradient — dark mode: near-black with subtle warmth
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: c.profileGradient,
        ),
        border: Border(
          bottom: BorderSide(color: c.border, width: 0.5),
        ),
      ),
      child: Column(
        children: [
          const Gap(24),

          // Avatar
          Stack(
            children: [
              // Outer ring — gold accent, subtle
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: c.gold.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  radius: 44,
                  backgroundColor: c.surfaceHigh,
                  backgroundImage: state.avatarPath.isNotEmpty
                      ? AssetImage(state.avatarPath)
                      : null,
                  child: state.avatarPath.isEmpty
                      ? Icon(Icons.person_rounded,
                          size: 40, color: c.textMuted)
                      : null,
                ),
              ),

              // Camera badge
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: c.gold,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: c.isDark
                          ? const Color(0xFF0F0A00)
                          : const Color(0xFFFFF8EE),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            ],
          ),

          const Gap(14),

          // Name
          Text(
            state.name.isEmpty ? 'عبد السلام الهلال' : state.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
              letterSpacing: -0.3,
            ),
          ),

          const Gap(4),

          // Email
          Text(
            state.email.isEmpty ? 'abdulsalam@gmail.com' : state.email,
            style: TextStyle(
              fontSize: 12,
              color: c.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),

          const Gap(6),

          // Prime badge
          Container(
            margin: const EdgeInsets.only(bottom: 24, top: 6),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: c.gold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: c.gold.withOpacity(0.25),
                width: 0.5,
              ),
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
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  Stats Card
// ══════════════════════════════════════════════════════════
class _StatsCard extends StatelessWidget {
  final ProfileState state;
  const _StatsCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border, width: 0.5),
      ),
      child: Row(
        children: [
          _StatItem(label: 'طلب', value: '12', c: c),
          _StatDivider(c: c),
          _StatItem(label: 'مفضلة', value: '3', c: c),
          _StatDivider(c: c),
          _StatItem(label: 'عنوان', value: '2', c: c),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final AppColors c;
  const _StatItem({
    required this.label,
    required this.value,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: c.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  final AppColors c;
  const _StatDivider({required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(width: 0.5, height: 32, color: c.border);
  }
}

// ══════════════════════════════════════════════════════════
//  Section Label
// ══════════════════════════════════════════════════════════
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: c.textMuted,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  Menu Card
// ══════════════════════════════════════════════════════════
class _MenuCard extends StatelessWidget {
  final int unreadCount;
  const _MenuCard({required this.unreadCount});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    final items = [
      _MenuItemData(
        icon: Icons.person_outline_rounded,
        iconColor: const Color(0xFFE8960C),
        title: 'تعديل البيانات',
        subtitle: 'الاسم، البريد الإلكتروني',
        target: const EditProfileScreen(),
      ),
      _MenuItemData(
        icon: Icons.receipt_long_outlined,
        iconColor: const Color(0xFF34C759),
        title: 'طلباتي',
        subtitle: 'سجل المشتريات السابق',
        target: const OrderHistoryScreen(),
      ),
      _MenuItemData(
        icon: Icons.location_on_outlined,
        iconColor: const Color(0xFF007AFF),
        title: 'عناوين التوصيل',
        subtitle: 'إدارة مواقع الاستلام',
        target: const AddressScreen(),
      ),
      _MenuItemData(
        icon: Icons.credit_card_outlined,
        iconColor: const Color(0xFFFF2D55),
        title: 'طرق الدفع',
        subtitle: 'Visa **** 4422',
        target: const PaymentMethodsScreen(),
      ),
      _MenuItemData(
        icon: Icons.notifications_none_outlined,
        iconColor: const Color(0xFFAF52DE),
        title: 'الإشعارات',
        subtitle: 'تنبيهات العروض والطلبات',
        badge: unreadCount,
        target: const NotificationsScreen(),
      ),
      _MenuItemData(
        icon: Icons.language_outlined,
        iconColor: const Color(0xFF32ADE6),
        title: 'اللغة',
        subtitle: 'العربية',
        target: null,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border, width: 0.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length, (i) {
          return _MenuTile(
            item: items[i],
            isLast: i == items.length - 1,
            isFirst: i == 0,
          );
        }),
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? target;
  final int badge;

  const _MenuItemData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.target,
    this.badge = 0,
  });
}

class _MenuTile extends StatefulWidget {
  final _MenuItemData item;
  final bool isLast;
  final bool isFirst;
  const _MenuTile({
    required this.item,
    required this.isLast,
    required this.isFirst,
  });

  @override
  State<_MenuTile> createState() => _MenuTileState();
}

class _MenuTileState extends State<_MenuTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final item = widget.item;

    final radius = BorderRadius.only(
      topLeft: widget.isFirst ? const Radius.circular(16) : Radius.zero,
      topRight: widget.isFirst ? const Radius.circular(16) : Radius.zero,
      bottomLeft: widget.isLast ? const Radius.circular(16) : Radius.zero,
      bottomRight: widget.isLast ? const Radius.circular(16) : Radius.zero,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) {
            setState(() => _pressed = false);
            if (item.target != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => item.target!),
              );
            }
          },
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            decoration: BoxDecoration(
              color: _pressed ? c.surfaceHigh : Colors.transparent,
              borderRadius: radius,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Icon container
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: c.iconBg(item.iconColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item.icon,
                        color: item.iconColor, size: 19),
                  ),

                  const Gap(12),

                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: c.textPrimary,
                          ),
                        ),
                        const Gap(2),
                        Text(
                          item.subtitle,
                          style: TextStyle(
                            fontSize: 11,
                            color: c.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Badge
                  if (item.badge > 0) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: c.gold,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${item.badge}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Gap(8),
                  ],

                  Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 12,
                    color: c.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ),

        if (!widget.isLast)
          Padding(
            padding: const EdgeInsets.only(right: 66),
            child: Divider(
              height: 0.5,
              thickness: 0.5,
              color: c.borderLight,
              endIndent: 16,
            ),
          ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
//  Theme Toggle — works across entire app
// ══════════════════════════════════════════════════════════
class _ThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThemeProvider>();
    final isDark = provider.isDark;
    final c = AppColors.of(context);

    return GestureDetector(
      onTap: provider.toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 48,
        height: 27,
        decoration: BoxDecoration(
          color: isDark ? c.gold : c.surfaceHigh,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? c.gold : c.border,
            width: 0.5,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment:
              isDark ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(3),
            width: 21,
            height: 21,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              size: 12,
              color: isDark ? c.gold : const Color(0xFFAAAAAA),
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  Logout Button
// ══════════════════════════════════════════════════════════
class _LogoutButton extends StatefulWidget {
  const _LogoutButton();

  @override
  State<_LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<_LogoutButton> {
  bool _pressed = false;

  void _confirm() {
    final c = AppColors.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: c.border, width: 0.5),
        ),
        title: Text(
          'تسجيل الخروج',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: c.textPrimary,
          ),
        ),
        content: Text(
          'هل أنت متأكد من تسجيل الخروج؟',
          style: TextStyle(
            color: c.textSecondary,
            fontSize: 13,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء',
                style: TextStyle(color: c.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/welcome', (_) => false);
            },
            child: Text(
              'خروج',
              style: TextStyle(
                color: c.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        _confirm();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: c.error.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: c.error.withOpacity(0.15),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded,
                  color: c.error, size: 18),
              const Gap(8),
              Text(
                'تسجيل الخروج',
                style: TextStyle(
                  color: c.error,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  Error View
// ══════════════════════════════════════════════════════════
class _ErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;
  const _ErrorView({this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded,
                color: c.error, size: 48),
            const Gap(16),
            Text(
              message ?? 'حدث خطأ غير معروف',
              style: TextStyle(color: c.textSecondary, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const Gap(20),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: c.gold,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
