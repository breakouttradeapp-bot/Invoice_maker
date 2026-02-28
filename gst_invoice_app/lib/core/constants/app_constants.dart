class AppConstants {
  AppConstants._();

  static const String appName = 'GST Invoice Maker';
  static const String appVersion = '1.0.0';

  // Hive Boxes
  static const String companyBox = 'company_box';
  static const String customerBox = 'customer_box';
  static const String productBox = 'product_box';
  static const String invoiceBox = 'invoice_box';
  static const String settingsBox = 'settings_box';

  // Settings Keys
  static const String themeColorKey = 'theme_color';
  static const String invoicePrefixKey = 'invoice_prefix';
  static const String invoiceCounterKey = 'invoice_counter';
  static const String selectedTemplateKey = 'selected_template';

  // GST Rates
  static const List<double> gstRates = [0.0, 5.0, 12.0, 18.0, 28.0];

  // Indian States (for GST)
  static const List<String> indianStates = [
    'Andaman and Nicobar Islands',
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chandigarh',
    'Chhattisgarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Delhi',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jammu and Kashmir',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Ladakh',
    'Lakshadweep',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Puducherry',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  // AdMob Test IDs
  static const String testBannerAdId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitialAdId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String testNativeAdId =
      'ca-app-pub-3940256099942544/2247696110';

  // Production Ad IDs (replace with actual IDs before release)
  static const String prodBannerAdId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String prodInterstitialAdId =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String prodNativeAdId =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';

  // Use test IDs in debug, production in release
  static bool get isDebug {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  static String get bannerAdId =>
      isDebug ? testBannerAdId : prodBannerAdId;
  static String get interstitialAdId =>
      isDebug ? testInterstitialAdId : prodInterstitialAdId;
  static String get nativeAdId =>
      isDebug ? testNativeAdId : prodNativeAdId;

  // Invoice Templates
  static const int templateBlueCorporate = 1;
  static const int templateModernMinimal = 2;
  static const int templateBoldBusiness = 3;
  static const int templateCleanCorporate = 4;

  static const List<Map<String, dynamic>> templates = [
    {
      'id': templateBlueCorporate,
      'name': 'Blue Corporate VIP',
      'description': 'Professional dark blue design with VIP badge',
      'preview': 'template1_preview.png',
    },
    {
      'id': templateModernMinimal,
      'name': 'Modern Minimal',
      'description': 'Clean, minimalist design for modern businesses',
      'preview': 'template2_preview.png',
    },
    {
      'id': templateBoldBusiness,
      'name': 'Bold Business',
      'description': 'Bold typography with strong visual hierarchy',
      'preview': 'template3_preview.png',
    },
    {
      'id': templateCleanCorporate,
      'name': 'Clean Corporate',
      'description': 'Professional clean layout with subtle accents',
      'preview': 'template4_preview.png',
    },
  ];
}
