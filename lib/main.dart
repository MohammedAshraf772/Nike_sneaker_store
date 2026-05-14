import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

import 'package:nike_sneaker_store/logic/theme/theme_cubit.dart';

import 'package:nike_sneaker_store/features/spash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authRemote = AuthRemoteDataSource(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );

  final authRepo = AuthRepositoryImpl(authRemote);

  final loginUseCase = Login(authRepo);
  final registerUseCase = Register(authRepo);
  final logoutUseCase = Logout(authRepo);

  runApp(
    MyApp(
      loginUseCase: loginUseCase,
      registerUseCase: registerUseCase,
      logoutUseCase: logoutUseCase,
    ),
  );
}

class MyApp extends StatelessWidget {
  final Login loginUseCase;
  final Register registerUseCase;
  final Logout logoutUseCase;

  const MyApp({
    super.key,
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => AuthCubit(loginUseCase, registerUseCase, logoutUseCase),
        ),

        BlocProvider(create: (_) => CartCubit()),

        BlocProvider(create: (_) => FavoritesCubit()),

        BlocProvider(create: (_) => ProfileCubit()),

        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            themeMode: mode,

            theme: ThemeData.light(),

            darkTheme: ThemeData.dark(),

            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
