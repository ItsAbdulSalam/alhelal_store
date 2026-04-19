import 'package:first_store/bloc/address_bloc.dart';
import 'package:first_store/bloc/address_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- استيراد الـ Blocs (تأكد من صحة المسارات في مجلد bloc) ---
import 'bloc/home_bloc.dart';
import 'bloc/cart_bloc.dart';
import 'bloc/favorites_bloc.dart';

// استيراد الشاشات
import 'screens/onboarding_screen.dart';
import 'screens/auth/auth_welcome_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main_wrapper.dart'; // هذا الملف هو الأساس لظهور البار

void main() {
  // التأكد من تهيئة أدوات فلاتر قبل التشغيل
  WidgetsFlutterBinding.ensureInitialized();

  // ضبط شفافية شريط الحالة العلوي وتناسق الأيقونات
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    // MultiBlocProvider: العقل المركزي للتطبيق
    // نضعه هنا لكي تعمل السلة والمفضلة في كل صفحات التطبيق دون استثناء
    MultiBlocProvider(
      providers: [
        // تحميل المنتجات فور تشغيل التطبيق
        BlocProvider(create: (context) => HomeBloc()..add(LoadProducts())),
        // تهيئة بلوك السلة
        BlocProvider(create: (context) => CartBloc()),
        // تهيئة بلوك المفضلة
        BlocProvider(create: (context) => FavoritesBloc()),
        BlocProvider<AddressBloc>(
          create: (context) => AddressBloc()..add(LoadAddresses()),
        ),
      ],
      child: const AlhelalPrimeApp(),
    ),
  );
}

class AlhelalPrimeApp extends StatelessWidget {
  const AlhelalPrimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ALHELAL PRIME',

      // إعدادات الثيم (Theme) - الهوية البصرية لمتجر الهلال
      theme: ThemeData(
        fontFamily: 'Cairo', // الخط العربي الأنيق
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          primary: Colors.orange,
          secondary: const Color(
            0xFF1A1A1A,
          ), // الأسود الملكي الذي استخدمته في البار
        ),
        // تحسين مظهر الـ AppBar بشكل عام
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),

      // إجبار التطبيق على اتجاه اليمين لليسار (RTL) لدعم اللغة العربية
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },

      // نقطة البداية
      // ملاحظة: بمجرد انتهاء Onboarding، يجب أن ينقلك التطبيق إلى /main لكي يظهر البار
      home: const OnboardingScreen(),

      // تعريف المسارات (Routes)
      routes: {
        '/welcome': (context) => const AuthWelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        // المسار الأساسي الذي يحتوي على البار السفلي والتبديل بين الصفحات
        '/main': (context) => const MainWrapper(),
      },
    );
  }
}
