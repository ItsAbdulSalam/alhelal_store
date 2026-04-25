import 'package:first_store/bloc/address_bloc.dart';
import 'package:first_store/bloc/address_event.dart';
import 'package:first_store/bloc/notifications/notifications_bloc.dart';
import 'package:first_store/bloc/profile/profile_bloc.dart';
import 'package:first_store/services/notification_service.dart';
import 'package:first_store/screens/notifications_screen.dart';
import 'package:first_store/shared/app_theme.dart';
import 'package:first_store/shared/theme_provider.dart';
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

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await NotificationService.instance.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => HomeBloc()..add(LoadProducts())),
          BlocProvider(create: (_) => CartBloc()),
          BlocProvider(create: (_) => FavoritesBloc()),
          BlocProvider(create: (_) => AddressBloc()..add(LoadAddresses())),
          BlocProvider(create: (_) => ProfileBloc()..add(LoadProfile())),
          BlocProvider(create: (_) => NotificationsBloc()),
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
      home: const OnboardingScreen(),
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
