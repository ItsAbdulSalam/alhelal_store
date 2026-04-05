import 'package:first_store/models/cart_data.dart';
import 'package:first_store/screens/cartPage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:carousel_slider/carousel_slider.dart'; // تأكد من إضافة المكتبة في pubspec.yaml
import '../models/productModel.dart';
import '../data/productsData.dart';
import '../data/categoriesData.dart';
import 'productsDetails.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1. متغيرات البحث والفلترة
  List<Product> displayedProducts = [];
  String selectedCategory = "الكل";
  final TextEditingController _searchController = TextEditingController();

  // قائمة صور السلايدر (Carousel)
  // روابط صور احترافية من Unsplash (منتجات تقنية، ساعات، لابتوبات)
  final List<String> sliderImages = [
    'https://images.unsplash.com/photo-1510557880182-3d4d3cba3f9e?q=80&w=2070&auto=format&fit=crop', // آيفون فخم
    'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=1999&auto=format&fit=crop', // ساعة ذكية
    'https://images.unsplash.com/photo-1511385348-a52b4a160dc2?q=80&w=2007&auto=format&fit=crop', // لابتوب وماك بوك
    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=2070&auto=format&fit=crop', // سماعات رأسية
  ];

  @override
  void initState() {
    super.initState();
    displayedProducts = productsData; // عرض المنتجات الحقيقية عند البداية
  }

  // 2. محرك الفلترة والبحث السريع
  void _filterProducts(String query, String category) {
    setState(() {
      selectedCategory = category;
      displayedProducts = productsData.where((product) {
        final matchesSearch = product.name.toLowerCase().contains(
          query.toLowerCase(),
        );
        final matchesCategory =
            category == "الكل" ||
            product.name.contains(category) ||
            product.description.contains(category);
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB), // لون خلفية هادئ
      // --- الـ Drawer الاحترافي (الألوان الهادئة والصورة الكبيرة) ---
      drawer: _buildModernDrawer(context),

      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // --- الـ AppBar الفخم ---
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: Colors.white.withOpacity(
              0.95,
            ), // شفافية خفيفة تعطي لمسة عصرية
            elevation: 0,
            centerTitle: true,

            // --- 1. تصميم اسم المتجر بشكل فخم ---
            title: Column(
              children: [
                Text(
                  "ALHELAL",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    letterSpacing: 2.0, // تباعد الأحرف يعطي فخامة فورية
                    fontFamily: 'serif', // أو أي خط فخم قمت بتعريفه
                  ),
                ),
                // خط صغير تحت الاسم يمثل الـ Subtitle (اختياري)
                Container(
                  height: 2,
                  width: 30,
                  color: Colors.orange, // لمسة بسيطة من هويتك البصرية
                  margin: const EdgeInsets.only(top: 2),
                ),
              ],
            ),

            // --- 2. أيقونة المنيو بتصميم أنظف ---
            leading: Builder(
              builder: (context) => IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons
                        .notes_rounded, // أيقونة "Notes" تعطي شكلاً ألطف من المنيو التقليدي
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),

            // --- 3. أيقونة السلة بتصميم متناسق ---
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 5),
                child: _buildCartIcon(context),
              ),
              const Gap(10),
            ],

            // --- 4. إضافة ظل سفلي ناعم جداً ---
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.grey.withOpacity(0.1),
                height: 1.0,
              ),
            ),
          ),

          // --- محتويات الصفحة العلوية (بحث + سلايدر + تصنيفات) ---
          SliverToBoxAdapter(
            child: Column(
              children: [
                const Gap(15),
                _buildModernSearchBar(),
                const Gap(20),

                // --- السلايدر (Carousel) المضاف حديثاً ---
                _buildCarouselSlider(),

                const Gap(25),
                _buildSectionHeader(
                  "التصنيفات",
                  "عرض الكل",
                  () => _filterProducts("", "الكل"),
                ),
                const Gap(15),
                _buildCategoriesSection(),
                const Gap(25),
                _buildSectionHeader("أحدث المنتجات", "تصفية", () {}),
              ],
            ),
          ),

          // --- شبكة المنتجات (Grid) ---
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            sliver: displayedProducts.isEmpty
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text("لا توجد نتائج بحث مطابقة"),
                      ),
                    ),
                  )
                : SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildPremiumProductCard(
                        context,
                        displayedProducts[index],
                      ),
                      childCount: displayedProducts.length,
                    ),
                  ),
          ),
          const SliverToBoxAdapter(child: Gap(50)),
        ],
      ),
    );
  }

  // --- السلايدر الاحترافي (Carousel Slider) ---
  Widget _buildCarouselSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0, // زيادة الطول قليلاً للفخامة
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        viewportFraction: 0.9,
      ),
      items: sliderImages.map((imageUrl) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              // إضافة مؤشر تحميل احترافي
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[100],
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange.withOpacity(0.5),
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              // في حال فشل الرابط أو انقطاع النت
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: const Icon(
                  Icons.broken_image,
                  color: Colors.grey,
                  size: 50,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- بناء الـ Drawer المتطور ---
  Widget _buildModernDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          bottomLeft: Radius.circular(35),
        ),
      ),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(35)),
            ),
            currentAccountPictureSize: const Size(85, 85),
            currentAccountPicture: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset('assets/images/me.jpg', fit: BoxFit.cover),
              ),
            ),
            accountName: const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "عبد السلام",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 19,
                  color: Color(0xFF424242),
                ),
              ),
            ),
            accountEmail: const Text(
              "abdulsalam@gmail.com",
              style: TextStyle(color: Color(0xFF757575), fontSize: 13),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  Icons.home_outlined,
                  "الرئيسية",
                  () => Navigator.pop(context),
                ),
                _buildDrawerItem(Icons.person_outline, "حسابي", () {}),
                _buildDrawerItem(Icons.shopping_bag_outlined, "طلباتي", () {}),
                _buildDrawerItem(Icons.favorite_border, "المفضلة", () {}),
                const Divider(indent: 25, endIndent: 25),
                _buildDrawerItem(Icons.settings_outlined, "الإعدادات", () {}),
                _buildDrawerItem(Icons.help_outline, "مركز المساعدة", () {}),
              ],
            ),
          ),
          _buildLogoutBtn(),
          const Gap(25),
        ],
      ),
    );
  }

  // --- بقية الـ Widgets المساعدة ---
  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 25),
    );
  }

  Widget _buildLogoutBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text(
            "تسجيل الخروج",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          onTap: () {},
        ),
      ),
    );
  }

  Widget _buildCartIcon(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.shopping_bag_outlined,
            color: Colors.black,
            size: 28,
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartScreen()),
          ).then((value) => setState(() {})),
        ),
        if (globalCartList.isNotEmpty)
          Positioned(
            top: 5,
            right: 5,
            child: CircleAvatar(
              radius: 9,
              backgroundColor: Colors.red,
              child: Text(
                "${globalCartList.length}",
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildModernSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) => _filterProducts(val, selectedCategory),
          decoration: const InputDecoration(
            hintText: "ابحث عن منتجك المفضل...",
            prefixIcon: Icon(Icons.search, color: Colors.orange, size: 26),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        itemCount: categoriesData.length,
        itemBuilder: (context, index) {
          final cat = categoriesData[index];
          final isSelected = selectedCategory == cat.name;
          return GestureDetector(
            onTap: () => _filterProducts(_searchController.text, cat.name),
            child: Container(
              width: 85,
              margin: const EdgeInsets.only(right: 15),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.orange : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(cat.image),
                    ),
                  ),
                  const Gap(8),
                  Text(
                    cat.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                      color: isSelected ? Colors.orange : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPremiumProductCard(BuildContext context, Product product) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductsDetailsPage(productdetails: product),
          ),
        ).then((value) => setState(() {}));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Hero(
                        tag: product.image,
                        child: Image.asset(product.image, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 15,
                    child: GestureDetector(
                      onTap: () => setState(
                        () => product.isFavorite = !product.isFavorite,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 20,
                          color: product.isFavorite ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${product.price}",
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    String action,
    VoidCallback onAction,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onAction,
            child: Text(
              action,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
