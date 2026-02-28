import 'package:hive/hive.dart';
import 'invoice_item_model.dart';

part 'invoice_model.g.dart';

@HiveType(typeId: 4)
class InvoiceModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String invoiceNumber;

  @HiveField(2)
  DateTime invoiceDate;

  @HiveField(3)
  DateTime? dueDate;

  // Customer Details
  @HiveField(4)
  String customerId;

  @HiveField(5)
  String customerName;

  @HiveField(6)
  String customerGstin;

  @HiveField(7)
  String customerAddress;

  @HiveField(8)
  String customerState;

  @HiveField(9)
  String customerPhone;

  @HiveField(10)
  String customerEmail;

  // GST Info
  @HiveField(11)
  String sellerState;

  @HiveField(12)
  bool isInterState;

  @HiveField(13)
  bool isReverseCharge;

  @HiveField(14)
  String placeOfSupply;

  // Line Items
  @HiveField(15)
  List<InvoiceItemModel> items;

  // Amounts
  @HiveField(16)
  double subTotal;

  @HiveField(17)
  double totalDiscount;

  @HiveField(18)
  double taxableAmount;

  @HiveField(19)
  double cgst;

  @HiveField(20)
  double sgst;

  @HiveField(21)
  double igst;

  @HiveField(22)
  double totalTax;

  @HiveField(23)
  double shippingCharges;

  @HiveField(24)
  double grandTotal;

  @HiveField(25)
  double roundOff;

  @HiveField(26)
  double finalTotal;

  // Status
  @HiveField(27)
  String paymentStatus; // 'paid', 'unpaid', 'partial'

  @HiveField(28)
  double amountPaid;

  // Notes
  @HiveField(29)
  String notes;

  @HiveField(30)
  String termsAndConditions;

  // Template
  @HiveField(31)
  int templateId;

  @HiveField(32)
  DateTime createdAt;

  @HiveField(33)
  String? pdfPath;

  InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.invoiceDate,
    this.dueDate,
    required this.customerId,
    required this.customerName,
    this.customerGstin = '',
    required this.customerAddress,
    required this.customerState,
    this.customerPhone = '',
    this.customerEmail = '',
    required this.sellerState,
    required this.isInterState,
    this.isReverseCharge = false,
    required this.placeOfSupply,
    required this.items,
    required this.subTotal,
    this.totalDiscount = 0,
    required this.taxableAmount,
    this.cgst = 0,
    this.sgst = 0,
    this.igst = 0,
    required this.totalTax,
    this.shippingCharges = 0,
    required this.grandTotal,
    this.roundOff = 0,
    required this.finalTotal,
    this.paymentStatus = 'unpaid',
    this.amountPaid = 0,
    this.notes = '',
    this.termsAndConditions = '',
    this.templateId = 1,
    required this.createdAt,
    this.pdfPath,
  });

  double get balanceDue => finalTotal - amountPaid;
}
