import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/core/utils/currency.dart';

class CurrencySelector extends StatelessWidget {
  final Currency selected;
  final ValueChanged<Currency> onChanged;

  const CurrencySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

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
              value: selected,
              isExpanded: true,
              dropdownColor: AppColors.getCard(context),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.getTextSecondary(context),
              ),
              items:
                  Currency.all.map((currency) {
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
          'Approximate rate for demo purposes — not a live exchange rate',
          style: TextStyle(
            color: AppColors.getTextSecondary(context),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
