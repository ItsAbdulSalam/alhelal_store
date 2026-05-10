import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_store/bloc/address_bloc.dart';
import 'package:first_store/bloc/address_event.dart';
import 'package:first_store/bloc/notifications/notifications_bloc.dart';
import 'package:first_store/bloc/profile/profile_bloc.dart';
import 'package:first_store/bloc/Auth/auth_bloc.dart';
import 'package:first_store/services/firebase_options.dart';
import 'package:first_store/shared/app_theme.dart';
import 'package:first_store/shared/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// استيراد الـ Blocs والصفحات
import 'bloc/home_bloc.dart';
import 'bloc/cart_bloc.dart';
import 'bloc/favorites_bloc.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth/auth_welcome_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main_wrapper.dart';
import 'screens/notifications_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // إعدادات شريط الحالة (Status Bar) للحصول على مظهر عصري
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc()),
          BlocProvider(create: (_) => HomeBloc()..add(LoadProducts())),
          BlocProvider(create: (_) => CartBloc()),
          BlocProvider(create: (_) => FavoritesBloc()),
          BlocProvider(create: (_) => AddressBloc()..add(LoadAddresses())),
          BlocProvider(create: (_) => ProfileBloc()..add(LoadProfile())),
          BlocProvider(
            create: (_) => NotificationsBloc()..add(LoadNotifications()),
          ),
        ],
        child: const AlhelalPrimeApp(),
      ),
    ),
  );
}

class AlhelalPrimeApp extends StatelessWidget {
  const AlhelalPrimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ALHELAL PRIME',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.mode,

      // دعم العربية والاتجاه من اليمين لليسار
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),

      // ── الحل الجذري للبطء عند تسجيل الخروج ──────────────────────────
      home: BlocListener<AuthBloc, AuthState>(
        // ✅ الـ Listener هنا هو المسؤول عن القفز الفوري لصفحة الترحيب عند الخروج
        listener: (context, state) {
          if (state is Unauthenticated) {
            // مسح سجل التنقل والذهاب لصفحة الترحيب فوراً
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/welcome', (route) => false);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            // 1. إذا كانت الحالة "تم تسجيل الدخول"
            if (state is Authenticated) {
              return const MainWrapper();
            }

            // 2. إذا كانت الحالة "خروج" (ستتم معالجتها أيضاً في الـ Listener بالأعلى)
            if (state is Unauthenticated) {
              return const OnboardingScreen();
            }

            // 3. فحص الجلسة عند فتح التطبيق لأول مرة (Cold Start)
            return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const _GlobalLoader();
                }
                if (snapshot.hasData && snapshot.data != null) {
                  return const MainWrapper();
                }
                return const OnboardingScreen();
              },
            );
          },
        ),
      ),

      // ── المسارات (Routes) ──────────────────────────────────────────
      routes: {
        '/welcome': (_) => const AuthWelcomeScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/main': (_) => const MainWrapper(),
        '/notifications': (_) => const NotificationsScreen(),
      },
    );
  }
}

class _GlobalLoader extends StatelessWidget {
  const _GlobalLoader();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF080808),
      body: Center(child: CircularProgressIndicator(color: Color(0xFFE8960C))),
    );
  }
}
