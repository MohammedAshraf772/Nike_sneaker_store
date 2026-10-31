import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/core/utils/currency.dart';
import 'package:nike_sneaker_store/features/checkout/data/services/exchange_rate_service.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/cubit/currency_state.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  CurrencyCubit(this._service) : super(CurrencyState.initial());

  final ExchangeRateService _service;

  Future<void> loadRates() async {
    emit(state.copyWith(isLoading: true));

    try {
      final liveRates = await _service.fetchUsdRates();

      final updated =
          state.currencies.map((currency) {
            final rate = liveRates[currency.code];
            return rate == null
                ? currency
                : currency.copyWith(rateFromUsd: rate);
          }).toList();

      final selected = updated.firstWhere(
        (currency) => currency.code == state.selected.code,
        orElse: () => updated.first,
      );

      emit(
        state.copyWith(
          currencies: updated,
          selected: selected,
          isLoading: false,
          isLive: true,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoading: false, isLive: false));
    }
  }

  void select(Currency currency) {
    emit(state.copyWith(selected: currency));
  }
}
