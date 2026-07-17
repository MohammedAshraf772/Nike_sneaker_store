import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/core/widgets/side_menu.dart';

import 'package:nike_sneaker_store/features/home/data/repo/product_repository.dart';
import 'package:nike_sneaker_store/features/home/presentation/cubit/home_cubit.dart';
import 'package:nike_sneaker_store/features/home/presentation/widget/home_content.dart';
import 'package:nike_sneaker_store/features/home/presentation/widget/home_error_widget.dart';
import 'package:nike_sneaker_store/features/home/presentation/widget/home_loading_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(ProductRepository())..getProducts(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const HomeLoadingGrid();
            }

            if (state is HomeError) {
              return HomeErrorWidget(message: state.message);
            }

            if (state is HomeSuccess) {
              return HomeContent(state: state);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
