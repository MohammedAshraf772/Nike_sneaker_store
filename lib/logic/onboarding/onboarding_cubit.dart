import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingState extends Equatable {
  final int currentPage;
  final bool isLastPage;

  const OnboardingState({required this.currentPage, required this.isLastPage});

  factory OnboardingState.initial() =>
      const OnboardingState(currentPage: 0, isLastPage: false);

  OnboardingState copyWith({int? currentPage, bool? isLastPage}) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }

  @override
  List<Object> get props => [currentPage, isLastPage];
}

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({required int totalPages})
    : _totalPages = totalPages,
      super(OnboardingState.initial());

  final int _totalPages;

  void changePage(int index) {
    emit(
      state.copyWith(currentPage: index, isLastPage: index == _totalPages - 1),
    );
  }

  void nextPage() {
    if (state.currentPage < _totalPages - 1) {
      final next = state.currentPage + 1;
      emit(
        state.copyWith(currentPage: next, isLastPage: next == _totalPages - 1),
      );
    }
  }
}
