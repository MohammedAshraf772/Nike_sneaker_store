class AppStrings {
  AppStrings._();

  static const String appName = 'Nike Store';

  static const List<Map<String, String>> onboardingData = [
    {
      'tag': 'NEW ARRIVAL',
      'title': 'Nike Air\nMax 270',
      'subtitle': 'Experience the future\nof comfort and style.',
      'image': 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png',
    },
    {
      'tag': 'BEST SELLER',
      'title': 'Nike React\nInfinity',
      'subtitle': 'Built for the long run.\nBuilt for you.',
      'image': 'https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_t.png',
    },
    {
      'tag': 'LIMITED EDITION',
      'title': 'Nike Dunk\nLow Retro',
      'subtitle': 'Classic style meets\nmodern performance.',
      'image': 'https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_t.png',
    },
  ];
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String homeRoute = '/home';
  static const String detailRoute = '/detail';
  static const String cartRoute = '/cart';
}
