// ============================================================
// invoice_list_screen.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/hive/invoice_model.dart';
import '../../../data/repositories/invoice_repository.dart';
import 'invoice_preview_screen.dart';
import 'create_invoice_screen.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  final InvoiceRepository _repo = InvoiceRepository();

  String _searchQuery = '';
  String _statusFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final all = _repo.getAllInvoices();

    final filtered = all.where((inv) {
      final matchSearch = _searchQuery.isEmpty ||
          inv.customerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          inv.invoiceNumber.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchStatus =
          _statusFilter == 'all' || inv.paymentStatus == _statusFilter;

      return matchSearch && matchStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Invoices')),
      body: Column(
        children: [
          // 🔍 Search & Filter Section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search invoices...',
                    prefixIcon: Icon(Icons.search),
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['all', 'paid', 'unpaid', 'partial'].map((s) {
                      final selected = _statusFilter == s;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(s.toUpperCase()),
                          selected: selected,
                          onSelected: (_) =>
                              setState(() => _statusFilter = s),
                          selectedColor:
                              AppTheme.primaryBlue.withOpacity(0.2),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // 📄 Invoice List
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No invoices found',
                      style: TextStyle(color: AppTheme.textMedium),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _InvoiceTile(
                      invoice: filtered[i],
                      onRefresh: () => setState(() {}),
                    ),
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateInvoiceScreen(),
            ),
          );
          setState(() {});
        },
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _InvoiceTile extends StatelessWidget {
  final InvoiceModel invoice;
  final VoidCallback onRefresh;

  const _InvoiceTile({
    required this.invoice,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = invoice.paymentStatus == 'paid'
        ? Colors.green
        : invoice.paymentStatus == 'partial'
            ? Colors.orange
            : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => InvoicePreviewScreen(invoice: invoice),
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
          child: const Icon(
            Icons.description,
            color: AppTheme.primaryBlue,
          ),
        ),
        title: Text(
          invoice.customerName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${invoice.invoiceNumber} • ${DateFormat('dd MMM yyyy').format(invoice.invoiceDate)}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${invoice.finalTotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                invoice.paymentStatus.toUpperCase(),
                style: TextStyle(
                  fontSize: 9,
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
