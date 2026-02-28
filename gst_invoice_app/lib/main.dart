import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'data/models/hive/company_model.dart';
import 'data/models/hive/customer_model.dart';
import 'data/models/hive/product_model.dart';
import 'data/models/hive/invoice_model.dart';
import 'data/models/hive/invoice_item_model.dart';
import 'presentation/screens/dashboard/dashboard_screen.dart';
import 'presentation/screens/company/company_setup_screen.dart';
import 'data/repositories/company_repository.dart';
import 'services/admob_service.dart';
import 'services/consent_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive Adapters
  Hive.registerAdapter(CompanyModelAdapter());
  Hive.registerAdapter(CustomerModelAdapter());
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(InvoiceModelAdapter());
  Hive.registerAdapter(InvoiceItemModelAdapter());

  // Open Hive Boxes
  await Hive.openBox<CompanyModel>(AppConstants.companyBox);
  await Hive.openBox<CustomerModel>(AppConstants.customerBox);
  await Hive.openBox<ProductModel>(AppConstants.productBox);
  await Hive.openBox<InvoiceModel>(AppConstants.invoiceBox);
  await Hive.openBox(AppConstants.settingsBox);

  // Initialize AdMob with UMP consent
  await ConsentManager.initialize();

  runApp(const GSTInvoiceApp());
}

class GSTInvoiceApp extends StatefulWidget {
  const GSTInvoiceApp({super.key});

  @override
  State<GSTInvoiceApp> createState() => _GSTInvoiceAppState();
}

class _GSTInvoiceAppState extends State<GSTInvoiceApp> {
  @override
  void initState() {
    super.initState();
    _initAdMob();
  }

  Future<void> _initAdMob() async {
    final canLoad = await ConsentManager.canRequestAds();
    if (canLoad) {
      await MobileAds.instance.initialize();
      AdMobService.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _getStartScreen(),
    );
  }

  Widget _getStartScreen() {
    final companyRepo = CompanyRepository();
    final company = companyRepo.getCompany();
    if (company == null) {
      return const CompanySetupScreen(isFirstTime: true);
    }
    return const DashboardScreen();
  }
}
