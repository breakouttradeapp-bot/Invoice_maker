import 'package:hive/hive.dart';

part 'invoice_item_model.g.dart';

@HiveType(typeId: 3)
class InvoiceItemModel extends HiveObject {
  @HiveField(0)
  String productName;

  @HiveField(1)
  String hsnSac;

  @HiveField(2)
  double quantity;

  @HiveField(3)
  String unit;

  @HiveField(4)
  double price;

  @HiveField(5)
  double discountPercent;

  @HiveField(6)
  double gstRate;

  @HiveField(7)
  bool isInclusive;

  @HiveField(8)
  double taxableAmount;

  @HiveField(9)
  double cgst;

  @HiveField(10)
  double sgst;

  @HiveField(11)
  double igst;

  @HiveField(12)
  double totalAmount;

  InvoiceItemModel({
    required this.productName,
    this.hsnSac = '',
    required this.quantity,
    this.unit = 'Nos',
    required this.price,
    this.discountPercent = 0,
    required this.gstRate,
    this.isInclusive = false,
    required this.taxableAmount,
    this.cgst = 0,
    this.sgst = 0,
    this.igst = 0,
    required this.totalAmount,
  });
}
