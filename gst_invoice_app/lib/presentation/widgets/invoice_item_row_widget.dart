import 'package:flutter/material.dart';
import '../screens/invoice/create_invoice_screen.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class InvoiceItemRowWidget extends StatefulWidget {
  final InvoiceItemEntry item;
  final int index;
  final VoidCallback? onDelete;
  final Function(InvoiceItemEntry) onChanged;
  const InvoiceItemRowWidget({
    super.key,
    required this.item,
    required this.index,
    required this.onChanged,
    this.onDelete,
  });

  @override
  State<InvoiceItemRowWidget> createState() => _InvoiceItemRowWidgetState();
}

class _InvoiceItemRowWidgetState extends State<InvoiceItemRowWidget> {
  late TextEditingController _nameCtrl;
  late TextEditingController _hsnCtrl;
  late TextEditingController _qtyCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _discCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.item.productName);
    _hsnCtrl = TextEditingController(text: widget.item.hsnSac);
    _qtyCtrl = TextEditingController(
        text: widget.item.quantity.toStringAsFixed(2));
    _priceCtrl = TextEditingController(
        text: widget.item.price > 0 ? widget.item.price.toStringAsFixed(2) : '');
    _discCtrl = TextEditingController(
        text: widget.item.discountPercent > 0
            ? widget.item.discountPercent.toStringAsFixed(1)
            : '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _hsnCtrl.dispose();
    _qtyCtrl.dispose();
    _priceCtrl.dispose();
    _discCtrl.dispose();
    super.dispose();
  }

  void _notify() => widget.onChanged(widget.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                child: Text('${widget.index + 1}',
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              const Text('Item Details',
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600)),
              const Spacer(),
              if (widget.onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Colors.red, size: 20),
                  onPressed: widget.onDelete,
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
                labelText: 'Product / Service Name *',
                isDense: true),
            validator: (v) => v!.isEmpty ? 'Required' : null,
            onChanged: (v) {
              widget.item.productName = v;
              _notify();
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _hsnCtrl,
                  decoration: const InputDecoration(
                      labelText: 'HSN/SAC', isDense: true),
                  onChanged: (v) {
                    widget.item.hsnSac = v;
                    _notify();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: widget.item.unit,
                  isDense: true,
                  decoration:
                      const InputDecoration(labelText: 'Unit', isDense: true),
                  items: ['Nos', 'Kg', 'Ltr', 'Mtr', 'Pcs', 'Box', 'Set', 'Hr']
                      .map((u) =>
                          DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  onChanged: (v) {
                    widget.item.unit = v!;
                    _notify();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _qtyCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Qty', isDense: true),
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    widget.item.quantity = double.tryParse(v) ?? 1;
                    _notify();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _priceCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Unit Price (₹) *', isDense: true),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      (double.tryParse(v ?? '') ?? 0) <= 0
                          ? 'Required'
                          : null,
                  onChanged: (v) {
                    widget.item.price = double.tryParse(v) ?? 0;
                    _notify();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _discCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Disc %', isDense: true),
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    widget.item.discountPercent = double.tryParse(v) ?? 0;
                    _notify();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<double>(
                  value: widget.item.gstRate,
                  isDense: true,
                  decoration: const InputDecoration(
                      labelText: 'GST %', isDense: true),
                  items: AppConstants.gstRates
                      .map((r) => DropdownMenuItem(
                          value: r,
                          child: Text('${r.toStringAsFixed(0)}%')))
                      .toList(),
                  onChanged: (v) {
                    widget.item.gstRate = v!;
                    _notify();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  const Text('Incl.', style: TextStyle(fontSize: 11)),
                  Switch(
                    value: widget.item.isInclusive,
                    onChanged: (v) {
                      setState(() => widget.item.isInclusive = v);
                      _notify();
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
