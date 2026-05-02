import 'package:firebase_auth/firebase_auth.dart'; // أضفنا هذا الاستيراد
import 'package:firebase_core/firebase_core.dart';
import 'package:first_store/bloc/address_bloc.dart';
import 'package:first_store/bloc/address_event.dart';
import 'package:first_store/bloc/notifications/notifications_bloc.dart';
import 'package:first_store/bloc/profile/profile_bloc.dart';
import 'package:first_store/bloc/Auth/auth_bloc.dart';
import 'package:first_store/firebase_options.dart';
import 'package:first_store/services/notification_service.dart';
import 'package:first_store/screens/notifications_screen.dart';
import 'package:first_store/shared/app_theme.dart';
import 'package:first_store/shared/theme_provider.dart';
import 'package:first_store/screens/auth/auth_widgets.dart'; // لتلوين الـ Loading
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'bloc/home_bloc.dart';
import 'bloc/cart_bloc.dart';
import 'bloc/favorites_bloc.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth/auth_welcome_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
          BlocProvider(create: (_) => NotificationsBloc()),
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
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),

      // التعديل السحري هنا في خاصية home
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // حالة الانتظار عند فحص السحاب
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Color(0xFF080808), // AuthColors.bg
              body: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFE8960C),
                ), // AuthColors.gold
              ),
            );
          }

          // إذا وجد مستخدم مسجل مسبقاً، نتوجه فوراً للمتجر
          if (snapshot.hasData && snapshot.data != null) {
            return const MainWrapper();
          }

          // إذا لم يجد مستخدم، نبدأ من البداية
          return const OnboardingScreen();
        },
      ),

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
