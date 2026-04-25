// ═══════════════════════════════════════════════════════════
//  main_wrapper.dart — themed bottom nav, BLoC badges
// ═══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';
import '../bloc/favorites_bloc.dart';
import '../bloc/favorites_state.dart' hide FavoritesUpdated, FavoritesState;
import '../shared/app_colors.dart';
import 'home.dart';
import 'cartPage.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _index = 0;

  static const _pages = [
    HomeScreen(),
    FavoritesScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  void _onTap(int i) {
    if (i != _index) {
      HapticFeedback.selectionClick();
      setState(() => _index = i);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Scaffold(
      backgroundColor: c.bg,
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: _BottomNav(
        selected: _index,
        onTap: _onTap,
        c: c,
      ),
    );
  }
}

// ── Bottom Nav ───────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;
  final AppColors c;
  const _BottomNav(
      {required this.selected, required this.onTap, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 8,
        top: 8,
        left: 8,
        right: 8,
      ),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.border, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            label: 'الرئيسية',
            index: 0,
            selected: selected,
            onTap: onTap,
            c: c,
          ),
          _FavNavItem(selected: selected, onTap: onTap, c: c),
          _CartNavItem(selected: selected, onTap: onTap, c: c),
          _NavItem(
            icon: Icons.person_outline_rounded,
            label: 'حسابي',
            index: 3,
            selected: selected,
            onTap: onTap,
            c: c,
          ),
        ],
      ),
    );
  }
}

// ── Nav Item ─────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selected;
  final ValueChanged<int> onTap;
  final AppColors c;
  final int badge;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.selected,
    required this.onTap,
    required this.c,
    this.badge = 0,
  });

  bool get _isSelected => index == selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _isSelected ? c.gold.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon,
                    color: _isSelected ? c.gold : c.textMuted, size: 22),
                if (badge > 0)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: c.gold,
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: c.surface, width: 1.5),
                      ),
                      child: Center(
                        child: Text('$badge',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: _isSelected ? c.gold : c.textMuted,
                fontSize: 10,
                fontWeight: _isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Favorites Nav (with BLoC badge) ──────────────────────
class _FavNavItem extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;
  final AppColors c;
  const _FavNavItem(
      {required this.selected, required this.onTap, required this.c});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      buildWhen: (p, n) =>
          (p as FavoritesUpdated).items.length !=
          (n as FavoritesUpdated).items.length,
      builder: (_, state) {
        final count = (state as FavoritesUpdated).items.length;
        return _NavItem(
          icon: count > 0
              ? Icons.favorite_rounded
              : Icons.favorite_outline_rounded,
          label: 'المفضلة',
          index: 1,
          selected: selected,
          onTap: onTap,
          c: c,
          badge: count,
        );
      },
    );
  }
}

// ── Cart Nav (with BLoC badge) ────────────────────────────
class _CartNavItem extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;
  final AppColors c;
  const _CartNavItem(
      {required this.selected, required this.onTap, required this.c});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (p, n) {
        final pCount =
            p is CartUpdated ? p.itemCount : 0;
        final nCount =
            n is CartUpdated ? n.itemCount : 0;
        return pCount != nCount;
      },
      builder: (_, state) {
        final count =
            state is CartUpdated ? state.itemCount : 0;
        return _NavItem(
          icon: Icons.shopping_bag_outlined,
          label: 'السلة',
          index: 2,
          selected: selected,
          onTap: onTap,
          c: c,
          badge: count,
        );
      },
    );
  }
}
