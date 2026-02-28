import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/hive/invoice_model.dart';
import '../../../data/models/hive/invoice_item_model.dart';
import '../../../data/models/hive/customer_model.dart';
import '../../../data/repositories/invoice_repository.dart';
import '../../../data/repositories/company_repository.dart';
import '../../../services/gst_calculator_service.dart';
import '../../../services/admob_service.dart';
import '../../widgets/invoice_item_row_widget.dart';
import '../customer/customer_list_screen.dart';
import 'invoice_preview_screen.dart';

class CreateInvoiceScreen extends StatefulWidget {
  final InvoiceModel? existingInvoice;
  const CreateInvoiceScreen({super.key, this.existingInvoice});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyRepo = CompanyRepository();
  final _invoiceRepo = InvoiceRepository();

  CustomerModel? _selectedCustomer;

  late TextEditingController _invoiceNumberCtrl;
  late DateTime _invoiceDate;
  DateTime? _dueDate;
  bool _isReverseCharge = false;
  String _paymentStatus = 'unpaid';
  final _notesCtrl = TextEditingController();
  late TextEditingController _termsCtrl;

  // ✅ FIXED HERE (Removed _)
  final List<InvoiceItemEntry> _items = [];

  double _shippingCharges = 0;
  int _selectedTemplate = 1;

  InvoiceTaxSummary? _taxSummary;

  @override
  void initState() {
    super.initState();
    final company = _companyRepo.getCompany();
    _invoiceNumberCtrl =
        TextEditingController(text: _companyRepo.generateInvoiceNumber());
    _invoiceDate = DateTime.now();
    _termsCtrl =
        TextEditingController(text: company?.termsAndConditions ?? '');
    _items.add(InvoiceItemEntry());
    _selectedTemplate = AppConstants.templateBlueCorporate;
  }

  @override
  void dispose() {
    _invoiceNumberCtrl.dispose();
    _notesCtrl.dispose();
    _termsCtrl.dispose();
    super.dispose();
  }

  void _recalculate() {
    final company = _companyRepo.getCompany();
    if (company == null || _selectedCustomer == null) {
      setState(() => _taxSummary = null);
      return;
    }

    final items = _items
        .where((item) => item.productName.isNotEmpty && item.price > 0)
        .map((item) => {
              'quantity': item.quantity,
              'price': item.price,
              'discountPercent': item.discountPercent,
              'gstRate': item.gstRate,
              'isInclusive': item.isInclusive,
            })
        .toList();

    if (items.isEmpty) {
      setState(() => _taxSummary = null);
      return;
    }

    final summary = GSTCalculatorService.calculateInvoice(
      items: items,
      sellerState: company.state,
      buyerState: _selectedCustomer!.state,
      shippingCharges: _shippingCharges,
      isReverseCharge: _isReverseCharge,
    );

    setState(() => _taxSummary = summary);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: Text(widget.existingInvoice == null
            ? 'Create Invoice'
            : 'Edit Invoice'),
      ),
      body: const Center(
        child: Text("UI remains same - shortened here for clarity"),
      ),
    );
  }
}

/// ✅ FIXED: Public class (NO UNDERSCORE)
class InvoiceItemEntry {
  String productName = '';
  String hsnSac = '';
  double quantity = 1;
  String unit = 'Nos';
  double price = 0;
  double discountPercent = 0;
  double gstRate = 18;
  bool isInclusive = false;
}
