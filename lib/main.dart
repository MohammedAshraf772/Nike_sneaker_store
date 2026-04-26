import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/features/favourates/cubit/favorites_cubit.dart';

import 'firebase_options.dart';

import 'package:nike_sneaker_store/features/auth/core/cubit/auth_cubit.dart';
import 'package:nike_sneaker_store/features/auth/core/screens/login_screen.dart';

import 'package:nike_sneaker_store/features/cart/cubit/cart_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),

        BlocProvider(create: (_) => CartCubit()),

        BlocProvider(create: (_) => FavoritesCubit()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}
