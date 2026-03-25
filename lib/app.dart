import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/core/contants/theme/app_theme.dart';
import 'package:nike_sneaker_store/routes/app_router.dart';

class NikeApp extends StatelessWidget {
  const NikeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nike Store',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
