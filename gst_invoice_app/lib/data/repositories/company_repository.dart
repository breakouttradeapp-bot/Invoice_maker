// company_repository.dart
import 'package:hive/hive.dart';
import '../models/hive/company_model.dart';
import '../../core/constants/app_constants.dart';

class CompanyRepository {
  final Box<CompanyModel> _box = Hive.box<CompanyModel>(AppConstants.companyBox);

  CompanyModel? getCompany() {
    return _box.isEmpty ? null : _box.getAt(0);
  }

  Future<void> saveCompany(CompanyModel company) async {
    if (_box.isEmpty) {
      await _box.add(company);
    } else {
      await _box.putAt(0, company);
    }
  }

  String generateInvoiceNumber() {
    final company = getCompany();
    if (company == null) return 'INV-0001';
    final number = company.invoiceCounter.toString().padLeft(4, '0');
    return '${company.invoicePrefix}-$number';
  }

  Future<void> incrementInvoiceCounter() async {
    final company = getCompany();
    if (company == null) return;
    company.invoiceCounter++;
    await company.save();
  }
}
