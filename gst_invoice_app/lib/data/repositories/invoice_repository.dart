import 'package:hive/hive.dart';
import '../models/hive/invoice_model.dart';
import '../../core/constants/app_constants.dart';

class InvoiceRepository {
  final Box<InvoiceModel> _box = Hive.box<InvoiceModel>(AppConstants.invoiceBox);

  List<InvoiceModel> getAllInvoices() {
    return _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  InvoiceModel? getInvoiceById(String id) {
    return _box.values.firstWhere(
      (i) => i.id == id,
      orElse: () => throw Exception('Invoice not found'),
    );
  }

  Future<void> addInvoice(InvoiceModel invoice) async {
    await _box.put(invoice.id, invoice);
  }

  Future<void> updateInvoice(InvoiceModel invoice) async {
    await invoice.save();
  }

  Future<void> deleteInvoice(String id) async {
    final key = _box.keys.firstWhere(
      (k) => _box.get(k)?.id == id,
      orElse: () => null,
    );
    if (key != null) await _box.delete(key);
  }

  List<InvoiceModel> getInvoicesByCustomer(String customerId) {
    return _box.values
        .where((i) => i.customerId == customerId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Dashboard statistics
  double getTotalSales() {
    return _box.values.fold(0.0, (sum, i) => sum + i.finalTotal);
  }

  double getTotalGSTCollected() {
    return _box.values.fold(0.0, (sum, i) => sum + i.totalTax);
  }

  double getTotalPending() {
    return _box.values
        .where((i) => i.paymentStatus != 'paid')
        .fold(0.0, (sum, i) => sum + i.balanceDue);
  }

  int getInvoiceCount() => _box.length;

  Map<String, double> getMonthlySales() {
    final Map<String, double> monthly = {};
    for (final invoice in _box.values) {
      final key =
          '${invoice.invoiceDate.year}-${invoice.invoiceDate.month.toString().padLeft(2, '0')}';
      monthly[key] = (monthly[key] ?? 0.0) + invoice.finalTotal;
    }
    return monthly;
  }

  List<InvoiceModel> getRecentInvoices({int limit = 5}) {
    final sorted = getAllInvoices();
    return sorted.take(limit).toList();
  }
}
