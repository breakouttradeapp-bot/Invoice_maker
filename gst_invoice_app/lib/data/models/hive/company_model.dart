// ============================================================
// company_model.dart
// ============================================================
import 'package:hive/hive.dart';

part 'company_model.g.dart';

@HiveType(typeId: 0)
class CompanyModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String gstin;

  @HiveField(2)
  String pan;

  @HiveField(3)
  String address;

  @HiveField(4)
  String city;

  @HiveField(5)
  String state;

  @HiveField(6)
  String pincode;

  @HiveField(7)
  String phone;

  @HiveField(8)
  String email;

  @HiveField(9)
  String website;

  @HiveField(10)
  String? logoPath;

  @HiveField(11)
  String bankName;

  @HiveField(12)
  String accountNumber;

  @HiveField(13)
  String ifscCode;

  @HiveField(14)
  String accountHolder;

  @HiveField(15)
  String? upiId;

  @HiveField(16)
  String? upiQrPath;

  @HiveField(17)
  String? signaturePath;

  @HiveField(18)
  String invoicePrefix;

  @HiveField(19)
  int invoiceCounter;

  @HiveField(20)
  String termsAndConditions;

  CompanyModel({
    required this.name,
    required this.gstin,
    required this.pan,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.phone,
    required this.email,
    this.website = '',
    this.logoPath,
    this.bankName = '',
    this.accountNumber = '',
    this.ifscCode = '',
    this.accountHolder = '',
    this.upiId,
    this.upiQrPath,
    this.signaturePath,
    this.invoicePrefix = 'INV',
    this.invoiceCounter = 1,
    this.termsAndConditions =
        '1. Payment due within 30 days of invoice date.\n2. Goods once sold will not be taken back.\n3. Subject to local jurisdiction.',
  });
}
