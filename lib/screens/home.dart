import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:carousel_slider/carousel_slider.dart';

// استيراد الملفات الضرورية
import '../bloc/home_bloc.dart';
// تأكد من وجود هذا الاستيراد
import '../bloc/cart_bloc.dart'; // ضروري للوصول للسلة
import '../widgets/product_grid_view.dart';
import '../data/categoriesData.dart';
import '../models/productModel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم الـ BlocProvider الموجود في main.dart تلقائياً عبر الـ context
    return const Scaffold(backgroundColor: Color(0xFFFBFBFB), body: HomeBody());
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
    // نصيحة: استخدمنا التابع context.read لضمان وصول الأحداث للـ Bloc الصحيح
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(
          child: Column(
            children: [
              _buildModernSearchBar(context),
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

              // منطقة المنتجات الحساسة للتحديث
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
                        // ملاحظة: تأكد أن ProductGridView يستخدم context.read<CartBloc>() داخله
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              const Gap(
                150,
              ), // زيادة المسافة لضمان عدم تداخل زر "إتمام الدفع" مع البار
            ],
          ),
        ),
      ],
    );
  }

  // --- شريط التطبيق الملكي (AppBar) ---
  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: Colors.white.withOpacity(0.85),
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12), // تأثير زجاجي فخم
          child: Container(color: Colors.transparent),
        ),
      ),
      title: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [
            Color(0xFF1A1A1A),
            Color(0xFFE65100),
          ], // تدرج بين الأسود والبرتقالي الغامق
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: const Text(
          "ALHELAL PRIME",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: Colors.white, // اللون هنا لا يهم بسبب ShaderMask
          ),
        ),
      ),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.notes_rounded, color: Colors.black, size: 22),
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.black,
              size: 22,
            ),
          ),
        ),
        const Gap(10),
      ],
    );
  }

  Widget _buildModernSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: TextField(
          controller: searchController,
          onChanged: (val) {
            final state = context.read<HomeBloc>().state;
            String currentCat = state is HomeLoaded
                ? state.selectedCategory
                : "الكل";
            context.read<HomeBloc>().add(FilterProducts(val, currentCat));
          },
          decoration: InputDecoration(
            hintText: "ما الذي تبحث عنه اليوم؟",
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
            prefixIcon: const Icon(Icons.search_rounded, color: Colors.orange),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildEliteSlider() {
    // تأكد أن هذه المسارات مطابقة تماماً لمجلد assets/images/slider/
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
                // عرض الصورة المحلية مع معالج أخطاء احترافي
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

                // تدرج لوني لجعل النص واضحاً
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

                // نصوص السلايدر
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
