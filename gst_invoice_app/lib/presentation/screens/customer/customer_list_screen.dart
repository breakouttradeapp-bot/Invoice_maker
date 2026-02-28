import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/hive/customer_model.dart';
import '../../../data/repositories/customer_repository.dart';

class CustomerListScreen extends StatefulWidget {
  final bool selectMode;
  const CustomerListScreen({super.key, this.selectMode = false});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final _repo = CustomerRepository();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final customers = _searchQuery.isEmpty
        ? _repo.getAllCustomers()
        : _repo.searchCustomers(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectMode ? 'Select Customer' : 'Customers'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                  hintText: 'Search customers...', prefixIcon: Icon(Icons.search)),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          Expanded(
            child: customers.isEmpty
                ? const Center(child: Text('No customers found'))
                : ListView.builder(
                    itemCount: customers.length,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (_, i) {
                      final c = customers[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          onTap: widget.selectMode
                              ? () => Navigator.pop(context, c)
                              : null,
                          leading: CircleAvatar(
                            backgroundColor:
                                Colors.teal.withOpacity(0.1),
                            child: Text(c.name[0].toUpperCase(),
                                style: TextStyle(
                                    color: Colors.teal.shade700,
                                    fontWeight: FontWeight.bold)),
                          ),
                          title: Text(c.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                          subtitle: Text(
                              '${c.phone} | ${c.state}',
                              style: const TextStyle(fontSize: 12)),
                          trailing: widget.selectMode
                              ? const Icon(Icons.chevron_right)
                              : PopupMenuButton(
                                  itemBuilder: (_) => [
                                    const PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Edit')),
                                    const PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete',
                                            style: TextStyle(
                                                color: Colors.red))),
                                  ],
                                  onSelected: (v) async {
                                    if (v == 'edit') {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  AddEditCustomerScreen(
                                                      customer: c)));
                                      setState(() {});
                                    } else if (v == 'delete') {
                                      await _repo.deleteCustomer(c.id);
                                      setState(() {});
                                    }
                                  },
                                ),
                        ),
                      );
                    }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const AddEditCustomerScreen()));
          setState(() {});
        },
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AddEditCustomerScreen extends StatefulWidget {
  final CustomerModel? customer;
  const AddEditCustomerScreen({super.key, this.customer});

  @override
  State<AddEditCustomerScreen> createState() =>
      _AddEditCustomerScreenState();
}

class _AddEditCustomerScreenState extends State<AddEditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repo = CustomerRepository();

  late TextEditingController _name;
  late TextEditingController _gstin;
  late TextEditingController _address;
  late TextEditingController _city;
  late TextEditingController _pincode;
  late TextEditingController _phone;
  late TextEditingController _email;
  String _state = AppConstants.indianStates.first;

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    _name = TextEditingController(text: c?.name ?? '');
    _gstin = TextEditingController(text: c?.gstin ?? '');
    _address = TextEditingController(text: c?.address ?? '');
    _city = TextEditingController(text: c?.city ?? '');
    _pincode = TextEditingController(text: c?.pincode ?? '');
    _phone = TextEditingController(text: c?.phone ?? '');
    _email = TextEditingController(text: c?.email ?? '');
    _state = c?.state ?? AppConstants.indianStates.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              widget.customer == null ? 'Add Customer' : 'Edit Customer')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Customer Name *'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              decoration: const InputDecoration(labelText: 'Phone *'),
              keyboardType: TextInputType.phone,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _gstin,
              decoration:
                  const InputDecoration(labelText: 'GSTIN (Optional)'),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _address,
              decoration:
                  const InputDecoration(labelText: 'Address *'),
              maxLines: 2,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: _city,
                  decoration: const InputDecoration(labelText: 'City'),
                )),
                const SizedBox(width: 12),
                Expanded(
                    child: TextFormField(
                  controller: _pincode,
                  decoration: const InputDecoration(labelText: 'Pincode'),
                  keyboardType: TextInputType.number,
                )),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _state,
              decoration: const InputDecoration(labelText: 'State *'),
              items: AppConstants.indianStates
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _state = v!),
              validator: (v) => v == null ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(45)),
              child: const Text('Save Customer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final customer = CustomerModel(
      id: widget.customer?.id ?? const Uuid().v4(),
      name: _name.text.trim(),
      gstin: _gstin.text.trim(),
      address: _address.text.trim(),
      city: _city.text.trim(),
      state: _state,
      pincode: _pincode.text.trim(),
      phone: _phone.text.trim(),
      email: _email.text.trim(),
      createdAt: widget.customer?.createdAt ?? DateTime.now(),
    );
    await _repo.addCustomer(customer);
    if (mounted) Navigator.pop(context, customer);
  }
}
