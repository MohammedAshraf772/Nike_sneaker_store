import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/core/cubit/theme_cubit.dart';

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

import 'package:nike_sneaker_store/features/spash/splash_screen.dart';

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

      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        themeMode: ThemeMode.dark,

        darkTheme: ThemeData.dark(),

        home: const SplashScreen(),
      ),
    );
  }
}
