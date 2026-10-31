import 'package:equatable/equatable.dart';
import 'package:nike_sneaker_store/core/utils/currency.dart';

class CurrencyState extends Equatable {
  final List<Currency> currencies;
  final Currency selected;
  final bool isLoading;
  final bool isLive;

  const CurrencyState({
    required this.currencies,
    required this.selected,
    this.isLoading = false,
    this.isLive = false,
  });

  factory CurrencyState.initial() {
    return CurrencyState(
      currencies: Currency.all,
      selected: Currency.all.first,
      isLoading: true,
    );
  }

  CurrencyState copyWith({
    List<Currency>? currencies,
    Currency? selected,
    bool? isLoading,
    bool? isLive,
  }) {
    return CurrencyState(
      currencies: currencies ?? this.currencies,
      selected: selected ?? this.selected,
      isLoading: isLoading ?? this.isLoading,
      isLive: isLive ?? this.isLive,
    );
  }

  @override
  List<Object?> get props => [
    currencies.map((c) => '${c.code}:${c.rateFromUsd}').toList(),
    selected.code,
    selected.rateFromUsd,
    isLoading,
    isLive,
  ];
}
