import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/core/cubit/theme_cubit.dart';
import 'package:nike_sneaker_store/routes/app_router.dart';
import 'firebase_options.dart';

import 'package:nike_sneaker_store/features/auth/data/datsource/auth_remote_datasource.dart';
import 'package:nike_sneaker_store/features/auth/data/repository/auth_repository_impl.dart';
import 'package:nike_sneaker_store/features/auth/domain/usecses/login.dart';
import 'package:nike_sneaker_store/features/auth/domain/usecses/logout.dart';
import 'package:nike_sneaker_store/features/auth/domain/usecses/register.dart';

import 'package:nike_sneaker_store/features/auth/presentation/cubit/auth_cubit.dart';

import 'package:nike_sneaker_store/features/cart/cubit/cart_cubit.dart';

import 'package:nike_sneaker_store/features/favourates/cubit/favorites_cubit.dart';

import 'package:nike_sneaker_store/features/profile/presentation/cubit/profile_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authRemote = AuthRemoteDataSource(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );

  final authRepository = AuthRepositoryImpl(authRemote);

  final loginUseCase = Login(authRepository);
  final registerUseCase = Register(authRepository);
  final logoutUseCase = Logout(authRepository);

  runApp(
    MyApp(
      login: loginUseCase,
      register: registerUseCase,
      logout: logoutUseCase,
    ),
  );
}

class MyApp extends StatelessWidget {
  final Login login;
  final Register register;
  final Logout logout;

  const MyApp({
    super.key,
    required this.login,
    required this.register,
    required this.logout,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(login, register, logout)),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => FavoritesCubit()),
        BlocProvider(create: (_) => ProfileCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

            // ثيم وضع النهار (الأبيض النظيف مع اللمسات الزرقاء)
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor:
                  AppColors.lightBackground, // اللون الفاتح المريح
              primaryColor: AppColors.primary,
              cardColor: AppColors.lightCard,
              colorScheme: ColorScheme.light(
                primary: AppColors.primary,
                surface: AppColors.lightSurface,
                background: AppColors.lightBackground,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.lightBackground,
                elevation: 0,
                iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
                titleTextStyle: TextStyle(
                  color: AppColors.lightTextPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: AppColors.lightTextPrimary),
                bodyMedium: TextStyle(color: AppColors.lightTextSecondary),
              ),
            ),

            // ثيم وضع الليل (الأسود الغامق الحالي)
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: AppColors.background,
              primaryColor: AppColors.primary,
              cardColor: AppColors.card,
              colorScheme: ColorScheme.dark(
                primary: AppColors.primary,
                surface: AppColors.surface,
                background: AppColors.background,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.background,
                elevation: 0,
                iconTheme: IconThemeData(color: AppColors.textPrimary),
                titleTextStyle: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: AppColors.textPrimary),
                bodyMedium: TextStyle(color: AppColors.textSecondary),
              ),
            ),

            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
