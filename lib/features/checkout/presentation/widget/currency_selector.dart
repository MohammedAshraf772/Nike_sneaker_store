import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/core/utils/currency.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/cubit/currency_state.dart';

class CurrencySelector extends StatelessWidget {
  final CurrencyState state;
  final ValueChanged<Currency> onChanged;

  const CurrencySelector({
    super.key,
    required this.state,
    required this.onChanged,
  });

  String get _statusMessage {
    if (state.isLoading) return 'Fetching live exchange rates...';
    if (state.isLive) {
      return 'Live rates, updated daily · Rates By Exchange Rate API';
    }
    return 'Live rates unavailable — showing approximate rates';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Currency',
          style: TextStyle(
            color: AppColors.getTextPrimary(context),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.getCard(context),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Currency>(
              value: state.selected,
              isExpanded: true,
              dropdownColor: AppColors.getCard(context),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.getTextSecondary(context),
              ),
              items:
                  state.currencies.map((currency) {
                    return DropdownMenuItem(
                      value: currency,
                      child: Text(
                        '${currency.symbol} ${currency.code} — ${currency.name}',
                        style: TextStyle(
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: (currency) {
                if (currency != null) onChanged(currency);
              },
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _statusMessage,
          style: TextStyle(
            color: AppColors.getTextSecondary(context),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
