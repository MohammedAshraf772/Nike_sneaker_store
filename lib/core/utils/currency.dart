class Currency {
  final String code;
  final String symbol;
  final String name;
  final double rateFromUsd;

  const Currency({
    required this.code,
    required this.symbol,
    required this.name,
    required this.rateFromUsd,
  });

  double convertFromUsd(double usdAmount) => usdAmount * rateFromUsd;

  static const List<Currency> all = [
    Currency(code: 'USD', symbol: '\$', name: 'US Dollar', rateFromUsd: 1),
    Currency(code: 'EUR', symbol: '€', name: 'Euro', rateFromUsd: 0.92),
    Currency(
      code: 'GBP',
      symbol: '£',
      name: 'British Pound',
      rateFromUsd: 0.78,
    ),
    Currency(
      code: 'EGP',
      symbol: 'E£',
      name: 'Egyptian Pound',
      rateFromUsd: 48.5,
    ),
    Currency(code: 'SAR', symbol: 'SR', name: 'Saudi Riyal', rateFromUsd: 3.75),
    Currency(code: 'AED', symbol: 'AED', name: 'UAE Dirham', rateFromUsd: 3.67),
    Currency(
      code: 'JPY',
      symbol: '¥',
      name: 'Japanese Yen',
      rateFromUsd: 149.5,
    ),
  ];
}
