import 'package:first_store/bloc/favorites_bloc.dart';
import 'package:first_store/bloc/favorites_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

// استيراد الصفحات والـ Bloc (تأكد من صحة المسارات في مشروعك)
import 'home.dart';
import 'cartPage.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  // ترتيب الصفحات
  final List<Widget> _pages = [
    const HomeScreen(),
    const FavoritesScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // IndexedStack يحافظ على حالة الصفحات ولا يعيد تحميلها
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.orange, // لون الهوية الخاص بك
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Colors.orange.withOpacity(0.1),
            color: Colors.black,
            tabs: [
              const GButton(
                icon: Icons.home_rounded, // أيقونة فلاتر الأصلية
                text: 'الرئيسية',
              ),
              GButton(
                icon: Icons.favorite_border_rounded,
                text: 'المفضلة',
                leading: // داخل قائمة الـ items في BottomNavigationBar أو الـ Custom Bar الذي صنعته
                BlocBuilder<FavoritesBloc, FavoritesState>(
                  builder: (context, state) {
                    // نحسب عدد العناصر في المفضلة حالياً
                    int favoritesCount = 0;
                    if (state is FavoritesUpdated) {
                      favoritesCount = state.favoritesList.length;
                    }

                    return Badge(
                      isLabelVisible:
                          favoritesCount > 0, // يظهر فقط إذا كان هناك منتجات
                      label: Text(favoritesCount.toString()),
                      backgroundColor: Colors.orange,
                      child: Icon(
                        favoritesCount > 0
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: favoritesCount > 0 ? Colors.red : Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              GButton(
                icon: Icons.shopping_bag_outlined,
                text: 'السلة',
                leading: BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    int cartCount = 0;
                    if (state is CartUpdated) {
                      cartCount = state.cartItems.length;
                    }
                    return Badge(
                      label: Text('$cartCount'),
                      isLabelVisible: cartCount > 0,
                      backgroundColor: Colors.orange,
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: _selectedIndex == 2
                            ? Colors.orange
                            : Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
              const GButton(icon: Icons.person_outline_rounded, text: 'حسابي'),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
