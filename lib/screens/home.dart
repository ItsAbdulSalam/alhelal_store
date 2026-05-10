import 'dart:ui';
import 'package:first_store/bloc/notifications/notifications_bloc.dart';
import 'package:first_store/screens/professionalSearchBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../bloc/home_bloc.dart';
import '../data/categoriesData.dart';
import '../models/productModel.dart';
import '../shared/app_colors.dart';
import '../widgets/product_grid_view.dart';

// ═══════════════════════════════════════════════════════════
//  HomeScreen — المدخل الرئيسي
// ═══════════════════════════════════════════════════════════
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Scaffold(backgroundColor: c.bg, body: const _HomeBody());
  }
}

class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const _HomeAppBar(),
        const SliverToBoxAdapter(child: Gap(12)),
        SliverToBoxAdapter(
          child: ProfessionalSearchBar(controller: _searchCtrl),
        ),
        const SliverToBoxAdapter(child: Gap(16)),
        const SliverToBoxAdapter(child: RepaintBoundary(child: _EliteSlider())),
        const SliverToBoxAdapter(child: Gap(24)),
        SliverToBoxAdapter(
          child: _SectionHeader(
            title: 'التصنيفات',
            actionLabel: 'عرض الكل',
            onAction: () {
              context.read<HomeBloc>().add(LoadProducts());
              _searchCtrl.clear();
            },
          ),
        ),
        const SliverToBoxAdapter(child: Gap(12)),
        // ✅ تم تحسين صف التصنيفات ليكون أكثر ثباتاً
        SliverToBoxAdapter(child: _CategoriesRow(searchCtrl: _searchCtrl)),
        const SliverToBoxAdapter(child: Gap(24)),
        SliverToBoxAdapter(
          child: _SectionHeader(
            title: 'أحدث المنتجات',
            actionLabel: 'الأفضل',
            onAction: () => context.read<HomeBloc>().add(LoadProducts()),
          ),
        ),
        const SliverToBoxAdapter(child: Gap(12)),
        const _ProductsSliver(),
        const SliverToBoxAdapter(child: Gap(120)),
      ],
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return SliverAppBar(
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: c.bg.withOpacity(0.88),
              border: Border(bottom: BorderSide(color: c.border, width: 0.5)),
            ),
          ),
        ),
      ),
      title: const _BrandTitle(),
      leading: _AppBarIconButton(
        icon: Icons.grid_view_rounded,
        onTap: () => Scaffold.of(context).openDrawer(),
      ),
      actions: [
        BlocBuilder<NotificationsBloc, NotificationsState>(
          buildWhen: (p, n) => p.unreadCount != n.unreadCount,
          builder: (context, state) {
            return _NotifButton(hasUnread: state.unreadCount > 0);
          },
        ),
        const Gap(8),
      ],
    );
  }
}

class _BrandTitle extends StatelessWidget {
  const _BrandTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'ALHELAL ',
                style: TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2,
                ),
              ),
              TextSpan(
                text: 'PRIME',
                style: TextStyle(
                  color: Color(0xFFE8960C),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
        const Gap(4),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Colors.transparent,
                Color(0xFFE8960C),
                Colors.transparent,
              ],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
          child: const SizedBox(height: 1.5, width: 50),
        ),
      ],
    );
  }
}

class _AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _AppBarIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: c.border, width: 0.5),
        ),
        child: Icon(icon, color: c.textPrimary, size: 18),
      ),
    );
  }
}

class _NotifButton extends StatelessWidget {
  final bool hasUnread;
  const _NotifButton({required this.hasUnread});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pushNamed(context, '/notifications');
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: c.border, width: 0.5),
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              color: c.textPrimary,
              size: 18,
            ),
          ),
          if (hasUnread)
            Positioned(
              top: 8,
              right: 4,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: c.gold,
                  shape: BoxShape.circle,
                  border: Border.all(color: c.bg, width: 1),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EliteSlider extends StatefulWidget {
  const _EliteSlider();

  @override
  State<_EliteSlider> createState() => _EliteSliderState();
}

class _EliteSliderState extends State<_EliteSlider> {
  int _current = 0;

  static const _slides = [
    _SlideData(
      'assets/images/slider/1.jpg',
      'IPHONE 15',
      'عالم آيفون المميز',
      'خصومات تصل إلى 50%',
    ),
    _SlideData(
      'assets/images/slider/2.jpg',
      'WATCHES',
      'الأناقة في معصمك',
      'أحدث تشكيلة الساعات',
    ),
    _SlideData(
      'assets/images/slider/3.jpg',
      'AUDIO',
      'تجربة صوتية فائقة',
      'أفضل السماعات العالمية',
    ),
    _SlideData(
      'assets/images/slider/4.jpg',
      '2026',
      'ساعات النخبة 2026',
      'تكنولوجيا لا مثيل لها',
    ),
    _SlideData(
      'assets/images/slider/5.jpg',
      'CAMERAS',
      'وثّق أجمل لحظاتك',
      'احترافية التصوير',
    ),
    _SlideData(
      'assets/images/slider/6.jpg',
      'SAMSUNG',
      'قوة سامسونج',
      'Galaxy S24 Ultra الجديد',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: _slides.length,
          itemBuilder: (_, i, _) => _SlideCard(data: _slides[i]),
          options: CarouselOptions(
            height: 200,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayCurve: Curves.easeInOutCubic,
            viewportFraction: 0.88,
            onPageChanged: (i, _) => setState(() => _current = i),
          ),
        ),
        const Gap(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _slides.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              width: i == _current ? 18 : 5,
              height: 5,
              decoration: BoxDecoration(
                color: i == _current ? c.gold : c.textMuted,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SlideData {
  final String image;
  final String tag;
  final String title;
  final String subtitle;
  const _SlideData(this.image, this.tag, this.title, this.subtitle);
}

class _SlideCard extends StatelessWidget {
  final _SlideData data;
  const _SlideCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(data.image, fit: BoxFit.cover, cacheWidth: 800),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.transparent, Color(0xBF000000)],
                  stops: [0.35, 1.0],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8960C),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      child: Text(
                        data.tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const Gap(6),
                  Text(
                    data.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    data.subtitle,
                    style: const TextStyle(
                      color: Color(0xB3FFFFFF),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: onAction,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: c.gold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                child: Text(
                  actionLabel,
                  style: TextStyle(
                    color: c.gold,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  _CategoriesRow — تحسين الفلترة والأداء
// ══════════════════════════════════════════════════════════
class _CategoriesRow extends StatelessWidget {
  final TextEditingController searchCtrl;
  const _CategoriesRow({required this.searchCtrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: BlocBuilder<HomeBloc, HomeState>(
        // ✅ بناء عندما تتغير الفئة المختارة فقط
        buildWhen: (p, n) {
          if (p is HomeLoaded && n is HomeLoaded) {
            return p.selectedCategory != n.selectedCategory;
          }
          return p.runtimeType != n.runtimeType;
        },
        builder: (context, state) {
          final selected = state is HomeLoaded
              ? state.selectedCategory
              : 'الكل';

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: categoriesData.length,
            itemBuilder: (_, i) => _CategoryItem(
              cat: categoriesData[i],
              isSelected: selected == categoriesData[i].name,
              onTap: () {
                HapticFeedback.selectionClick();
                // ✅ إرسال حدث الفلترة بشكل صحيح
                context.read<HomeBloc>().add(
                  FilterProducts(searchCtrl.text, categoriesData[i].name),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatefulWidget {
  final dynamic cat;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.cat,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<_CategoryItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.92).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final gold = const Color(0xFFE8960C);

    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          margin: const EdgeInsets.only(right: 25), // مساحة جانبية كافية
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: widget.isSelected ? gold.withOpacity(0.12) : c.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.isSelected ? gold : c.border,
                    width: widget.isSelected ? 2 : 0.5,
                  ),
                  boxShadow: widget.isSelected
                      ? [
                          BoxShadow(
                            color: gold.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                padding: const EdgeInsets.all(16),
                child: Image.asset(widget.cat.image, fit: BoxFit.contain),
              ),
              const Gap(8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: widget.isSelected
                      ? FontWeight.w800
                      : FontWeight.w500,
                  color: widget.isSelected ? gold : c.textSecondary,
                ),
                child: Text(widget.cat.name),
              ),
              // ✅ خط ذهبي متحرك تحت الاختيار
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 2.5,
                width: widget.isSelected ? 20 : 0,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: gold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductsSliver extends StatelessWidget {
  const _ProductsSliver();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const SliverToBoxAdapter(child: _ProductsLoader());
        }
        if (state is HomeLoaded && state.products.isNotEmpty) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((_, i) {
                return RepaintBoundary(
                  child: ProductCard(product: state.products[i]),
                );
              }, childCount: state.products.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 272,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
            ),
          );
        }
        if (state is HomeLoaded && state.products.isEmpty) {
          return const SliverToBoxAdapter(child: _EmptyProducts());
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}

class _ProductsLoader extends StatelessWidget {
  const _ProductsLoader();
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Center(
        child: CircularProgressIndicator(color: c.gold, strokeWidth: 2),
      ),
    );
  }
}

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts();
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 52, color: c.textMuted),
          const Gap(12),
          Text(
            'لا توجد نتائج',
            style: TextStyle(color: c.textSecondary, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
