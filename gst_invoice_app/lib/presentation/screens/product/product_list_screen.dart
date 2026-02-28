import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/hive/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _repo = ProductRepository();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final products = _searchQuery.isEmpty
        ? _repo.getAllProducts()
        : _repo.searchProducts(_searchQuery);

    return Scaffold(
      appBar: AppBar(title: const Text('Products & Services')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                  hintText: 'Search products/services...',
                  prefixIcon: Icon(Icons.search)),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? const Center(child: Text('No products found'))
                : ListView.builder(
                    itemCount: products.length,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (_, i) {
                      final p = products[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                Colors.purple.withOpacity(0.1),
                            child: Icon(Icons.inventory_2,
                                color: Colors.purple.shade700, size: 20),
                          ),
                          title: Text(p.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                          subtitle: Text(
                              'HSN: ${p.hsnSac.isEmpty ? 'N/A' : p.hsnSac} | GST: ${p.gstRate.toStringAsFixed(0)}%',
                              style: const TextStyle(fontSize: 12)),
                          trailing: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('₹${p.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryBlue)),
                              Text(p.unit,
                                  style: const TextStyle(fontSize: 11)),
                            ],
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
                  builder: (_) => const AddEditProductScreen()));
          setState(() {});
        },
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AddEditProductScreen extends StatefulWidget {
  final ProductModel? product;
  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() =>
      _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repo = ProductRepository();

  late TextEditingController _name;
  late TextEditingController _hsn;
  late TextEditingController _price;
  late TextEditingController _desc;
  double _gstRate = 18;
  String _unit = 'Nos';
  bool _trackStock = false;
  final _stockCtrl = TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _name = TextEditingController(text: p?.name ?? '');
    _hsn = TextEditingController(text: p?.hsnSac ?? '');
    _price = TextEditingController(
        text: p != null ? p.price.toStringAsFixed(2) : '');
    _desc = TextEditingController(text: p?.description ?? '');
    _gstRate = p?.gstRate ?? 18;
    _unit = p?.unit ?? 'Nos';
    _trackStock = p?.trackStock ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.product == null
              ? 'Add Product/Service'
              : 'Edit Product')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration:
                  const InputDecoration(labelText: 'Product/Service Name *'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _price,
                    decoration: const InputDecoration(
                        labelText: 'Price (₹) *'),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        (double.tryParse(v ?? '') ?? 0) <= 0
                            ? 'Required'
                            : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _unit,
                    decoration: const InputDecoration(labelText: 'Unit'),
                    items: [
                      'Nos', 'Kg', 'Ltr', 'Mtr', 'Pcs',
                      'Box', 'Set', 'Hr', 'Day', 'Month'
                    ]
                        .map((u) =>
                            DropdownMenuItem(value: u, child: Text(u)))
                        .toList(),
                    onChanged: (v) => setState(() => _unit = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _hsn,
                    decoration: const InputDecoration(
                        labelText: 'HSN/SAC Code'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<double>(
                    value: _gstRate,
                    decoration: const InputDecoration(labelText: 'GST %'),
                    items: AppConstants.gstRates
                        .map((r) => DropdownMenuItem(
                            value: r,
                            child: Text('${r.toStringAsFixed(0)}%')))
                        .toList(),
                    onChanged: (v) => setState(() => _gstRate = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _desc,
              decoration:
                  const InputDecoration(labelText: 'Description (Optional)'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _trackStock,
              onChanged: (v) => setState(() => _trackStock = v),
              title: const Text('Track Stock'),
              contentPadding: EdgeInsets.zero,
            ),
            if (_trackStock)
              TextFormField(
                controller: _stockCtrl,
                decoration:
                    const InputDecoration(labelText: 'Opening Stock'),
                keyboardType: TextInputType.number,
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(45)),
              child: const Text('Save Product'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final product = ProductModel(
      id: widget.product?.id ?? const Uuid().v4(),
      name: _name.text.trim(),
      hsnSac: _hsn.text.trim(),
      gstRate: _gstRate,
      price: double.parse(_price.text.trim()),
      unit: _unit,
      description: _desc.text.trim(),
      trackStock: _trackStock,
      stockQuantity: double.tryParse(_stockCtrl.text) ?? 0,
    );
    await _repo.addProduct(product);
    if (mounted) Navigator.pop(context);
  }
}
