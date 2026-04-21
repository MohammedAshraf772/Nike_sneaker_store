import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/core/cubit/auth_cubit.dart';
import 'features/cart/cubit/cart_cubit.dart';
import 'core/theme/theme_cubit.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: const NikeApp(),
    ),
  );
}
