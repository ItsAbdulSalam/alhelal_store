// ═══════════════════════════════════════════════════════════
//  cart_screen.dart — BLoC-powered, AppColors themed
// ═══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../models/productModel.dart';
import '../shared/app_colors.dart';
import 'order_summary_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Scaffold(
      backgroundColor: c.bg,
      appBar: AppBar(
        backgroundColor: c.bg,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'حقيبة التسوق',
          style: TextStyle(
            color: c.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          // زر مسح السلة
          BlocBuilder<CartBloc, CartState>(
            buildWhen: (p, n) =>
                (p is CartUpdated) != (n is CartUpdated) ||
                (p is CartUpdated &&
                    n is CartUpdated &&
                    p.itemCount != n.itemCount),
            builder: (context, state) {
              if (state is! CartUpdated || state.cartItems.isEmpty) {
                return const SizedBox.shrink();
              }
              return TextButton(
                onPressed: () => _confirmClear(context, c),
                child: Text(
                  'مسح الكل',
                  style: TextStyle(color: c.error, fontSize: 12),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is! CartUpdated || state.cartItems.isEmpty) {
            return _EmptyCart(c: c);
          }
          return Stack(
            children: [
              _CartList(items: state.cartItems, c: c),
              _CheckoutBar(state: state, c: c),
            ],
          );
        },
      ),
    );
  }

  void _confirmClear(BuildContext context, AppColors c) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: c.border, width: 0.5),
        ),
        title: Text('مسح السلة',
            style: TextStyle(
                color: c.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        content: Text('هل تريد مسح جميع المنتجات؟',
            style: TextStyle(color: c.textSecondary, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text('إلغاء', style: TextStyle(color: c.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CartBloc>().add(const ClearCart());
            },
            child: Text('مسح',
                style: TextStyle(
                    color: c.error, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ── Empty State ──────────────────────────────────────────
class _EmptyCart extends StatelessWidget {
  final AppColors c;
  const _EmptyCart({required this.c});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 72, color: c.textMuted),
          const Gap(16),
          Text('حقيبة التسوق فارغة',
              style: TextStyle(
                  color: c.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          const Gap(8),
          Text('أضف منتجاتك المفضلة',
              style: TextStyle(color: c.textMuted, fontSize: 13)),
        ],
      ),
    );
  }
}

// ── Cart List ────────────────────────────────────────────
class _CartList extends StatelessWidget {
  final List<CartItem> items;
  final AppColors c;
  const _CartList({required this.items, required this.c});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 200),
      itemCount: items.length,
      itemBuilder: (_, i) => _CartTile(item: items[i], c: c),
    );
  }
}

// ── Cart Tile ────────────────────────────────────────────
class _CartTile extends StatelessWidget {
  final CartItem item;
  final AppColors c;
  const _CartTile({required this.item, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border, width: 0.5),
      ),
      child: Row(
        children: [
          // صورة المنتج
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 76,
              height: 76,
              color: c.surfaceHigh,
              child: Image.asset(item.product.image,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                      Icons.image_outlined,
                      color: c.textMuted)),
            ),
          ),
          const Gap(12),

          // تفاصيل
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name,
                    style: TextStyle(
                      color: c.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const Gap(6),
                Text(
                  '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                  style: TextStyle(
                    color: c.gold,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          // التحكم في الكمية
          Column(
            children: [
              // حذف
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  context
                      .read<CartBloc>()
                      .add(RemoveFromCart(product: item.product));
                },
                child: Icon(Icons.delete_outline_rounded,
                    color: c.error, size: 18),
              ),
              const Gap(10),
              _QtyControl(item: item, c: c),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Quantity Control ─────────────────────────────────────
class _QtyControl extends StatelessWidget {
  final CartItem item;
  final AppColors c;
  const _QtyControl({required this.item, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: c.surfaceHigh,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.border, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyBtn(
            icon: Icons.remove,
            onTap: () => context.read<CartBloc>().add(
                UpdateQuantity(product: item.product, isIncrement: false)),
            c: c,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('${item.quantity}',
                style: TextStyle(
                    color: c.textPrimary, fontWeight: FontWeight.w700)),
          ),
          _QtyBtn(
            icon: Icons.add,
            onTap: () => context.read<CartBloc>().add(
                UpdateQuantity(product: item.product, isIncrement: true)),
            c: c,
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final AppColors c;
  const _QtyBtn({required this.icon, required this.onTap, required this.c});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Icon(icon, size: 15, color: c.textSecondary),
      ),
    );
  }
}

// ── Checkout Bar ─────────────────────────────────────────
class _CheckoutBar extends StatelessWidget {
  final CartUpdated state;
  final AppColors c;
  const _CheckoutBar({required this.state, required this.c});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding:
            EdgeInsets.fromLTRB(20, 16, 20, bottom + 16),
        decoration: BoxDecoration(
          color: c.surface,
          border: Border(top: BorderSide(color: c.border, width: 0.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الإجمالي
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('الإجمالي',
                    style: TextStyle(
                        color: c.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
                Text(
                  '\$${state.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: c.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const Gap(14),

            // زر الدفع
            _CheckoutButton(c: c),
          ],
        ),
      ),
    );
  }
}

class _CheckoutButton extends StatefulWidget {
  final AppColors c;
  const _CheckoutButton({required this.c});

  @override
  State<_CheckoutButton> createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends State<_CheckoutButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.c;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const OrderSummaryScreen()));
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            color: c.gold,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'إتمام الدفع',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
