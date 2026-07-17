import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/features/home/data/repo/product_repository.dart';
import 'package:nike_sneaker_store/features/search/presentation/cubit/search_cubite.dart';
import 'package:nike_sneaker_store/features/search/presentation/cubit/search_state.dart';
import 'package:nike_sneaker_store/features/search/presentation/widget/search_bar_widget.dart';
import 'package:nike_sneaker_store/features/search/presentation/widget/search_error_widget.dart';
import 'package:nike_sneaker_store/features/search/presentation/widget/search_initial_widget.dart';
import 'package:nike_sneaker_store/features/search/presentation/widget/search_loading_widget.dart';
import 'package:nike_sneaker_store/features/search/presentation/widget/search_results_widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(ProductRepository()),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(BuildContext context, String value) {
    context.read<SearchCubit>().search(value);
  }

  void _onSearchCleared(BuildContext context) {
    _controller.clear();
    context.read<SearchCubit>().clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            SearchBarWidget(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: (value) => _onSearchChanged(context, value),
              onClear: () => _onSearchCleared(context),
            ),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return const SearchInitialWidget();
                  }
                  if (state is SearchLoading) {
                    return const SearchLoadingWidget();
                  }
                  if (state is SearchLoaded) {
                    return SearchResultsWidget(
                      results: state.results,
                      query: state.query,
                    );
                  }
                  if (state is SearchError) {
                    return SearchErrorWidget(message: state.message);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
