import 'dart:ui';
import 'package:first_store/screens/professionalSearchBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../bloc/home_bloc.dart';
import '../bloc/cart_bloc.dart';
import '../widgets/product_grid_view.dart';
import '../data/categoriesData.dart';
import '../models/productModel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF3E0), Color(0xFFFBFBFB), Colors.white],
          stops: [0.0, 0.4, 1.0],
        ),
      ),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: HomeBody(),
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final TextEditingController searchController = TextEditingController();
  int _currentSlide = 0;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(
          child: Column(
            children: [
              const ProfessionalSearchBar(),
              const Gap(10),
              _buildEliteSlider(),
              const Gap(25),
              _buildSectionHeader("التصنيفات", "عرض الكل", () {
                context.read<HomeBloc>().add(LoadProducts());
              }),
              _buildModernCategories(),
              const Gap(20),
              _buildSectionHeader("أحدث المنتجات", "الأفضل", () {
                context.read<HomeBloc>().add(LoadProducts());
              }),
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(50.0),
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  } else if (state is HomeLoaded) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ProductGridView(
                        products: state.products.cast<Product>(),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              const Gap(150),
            ],
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════
  //  AppBar الجديد
  // ════════════════════════════════════════════
  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.88),
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.06),
                  width: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
      // ── Brand Title ──
      title: Column(
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
          Container(
            height: 1.5,
            width: 50,
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
          ),
        ],
      ),
      // ── Leading: Menu ──
      leading: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: GestureDetector(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black.withOpacity(0.08),
                width: 0.5,
              ),
            ),
            child: const Icon(
              Icons.grid_view_rounded,
              color: Color(0xFF1A1A1A),
              size: 18,
            ),
          ),
        ),
      ),
      // ── Actions: Notifications ──
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/notifications'),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.08),
                    width: 0.5,
                  ),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF1A1A1A),
                  size: 18,
                ),
              ),
            ),
            // نقطة الإشعار
            Positioned(
              top: 9,
              right: 9,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8960C),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),
            ),
          ],
        ),
        const Gap(6),
      ],
    );
  }

  // ════════════════════════════════════════════
  //  باقي الكود بدون تغيير
  // ════════════════════════════════════════════

  Widget _buildEliteSlider() {
    final List<Map<String, String>> sliderData = [
      {
        "image": "assets/images/slider/1.jpg",
        "title": "عالم آيفون المميز",
        "sub": "خصومات تصل إلى 50% على آيفون 15 برو",
      },
      {
        "image": "assets/images/slider/2.jpg",
        "title": "الأناقة في معصمك",
        "sub": "أحدث تشكيلة من الساعات الكلاسيكية والذكية",
      },
      {
        "image": "assets/images/slider/3.jpg",
        "title": "تجربة صوتية فائقة",
        "sub": "استمتع بنقاء الصوت مع أفضل السماعات العالمية",
      },
      {
        "image": "assets/images/slider/4.jpg",
        "title": "ساعات النخبة 2026",
        "sub": "تكنولوجيا متقدمة وتصميم عصري لا مثيل له",
      },
      {
        "image": "assets/images/slider/5.jpg",
        "title": "وثّق أجمل لحظاتك",
        "sub": "احترافية التصوير مع أحدث الكاميرات الرقمية",
      },
      {
        "image": "assets/images/slider/6.jpg",
        "title": "قوة سامسونج بين يديك",
        "sub": "اكتشف ذكاء Galaxy S24 Ultra الجديد كلياً",
      },
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 210,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        viewportFraction: 0.88,
        enlargeStrategy: CenterPageEnlargeStrategy.height,
        onPageChanged: (index, _) => setState(() => _currentSlide = index),
      ),
      items: sliderData.map((data) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  data['image']!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 40,
                          ),
                          Gap(5),
                          Text(
                            "الصورة غير موجودة",
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          data['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Gap(8),
                      Text(
                        data['sub']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(blurRadius: 10, color: Colors.black),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildModernCategories() {
    return SizedBox(
      height: 140,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          String selectedCat = state is HomeLoaded
              ? state.selectedCategory
              : "الكل";
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: categoriesData.length,
            itemBuilder: (context, index) {
              final cat = categoriesData[index];
              final bool isSelected = selectedCat == cat.name;
              return GestureDetector(
                onTap: () {
                  context.read<HomeBloc>().add(
                    FilterProducts(searchController.text, cat.name),
                  );
                },
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: isSelected ? 85 : 75,
                      width: isSelected ? 85 : 75,
                      margin: const EdgeInsets.only(right: 20),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? Colors.orange
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? Colors.orange.withOpacity(0.3)
                                : Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Image.asset(cat.image, fit: BoxFit.contain),
                    ),
                    const Gap(8),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        cat.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w900
                              : FontWeight.w600,
                          color: isSelected ? Colors.orange : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    String actionText,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                actionText,
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
