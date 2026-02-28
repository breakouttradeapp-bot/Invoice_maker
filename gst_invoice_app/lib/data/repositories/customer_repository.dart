// customer_repository.dart
import 'package:hive/hive.dart';
import '../models/hive/customer_model.dart';
import '../../core/constants/app_constants.dart';

class CustomerRepository {
  final Box<CustomerModel> _box = Hive.box<CustomerModel>(AppConstants.customerBox);

  List<CustomerModel> getAllCustomers() {
    return _box.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  CustomerModel? getCustomerById(String id) {
    return _box.values.firstWhere(
      (c) => c.id == id,
      orElse: () => throw Exception('Customer not found'),
    );
  }

  Future<void> addCustomer(CustomerModel customer) async {
    await _box.put(customer.id, customer);
  }

  Future<void> updateCustomer(CustomerModel customer) async {
    await customer.save();
  }

  Future<void> deleteCustomer(String id) async {
    final key = _box.keys.firstWhere(
      (k) => _box.get(k)?.id == id,
      orElse: () => null,
    );
    if (key != null) await _box.delete(key);
  }

  List<CustomerModel> searchCustomers(String query) {
    final q = query.toLowerCase();
    return _box.values
        .where((c) =>
            c.name.toLowerCase().contains(q) ||
            c.phone.contains(q) ||
            c.gstin.toLowerCase().contains(q))
        .toList();
  }
}
