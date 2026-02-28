import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/hive/invoice_model.dart';
import '../../../data/repositories/company_repository.dart';
import '../../../data/repositories/invoice_repository.dart';
import '../../../services/pdf_generator_service.dart';

/// No ads on invoice preview or PDF view screen (AdMob policy compliant)
class InvoicePreviewScreen extends StatefulWidget {
  final InvoiceModel invoice;
  const InvoicePreviewScreen({super.key, required this.invoice});

  @override
  State<InvoicePreviewScreen> createState() => _InvoicePreviewScreenState();
}

class _InvoicePreviewScreenState extends State<InvoicePreviewScreen> {
  final _companyRepo = CompanyRepository();
  final _invoiceRepo = InvoiceRepository();
  bool _generating = false;
  File? _pdfFile;

  @override
  Widget build(BuildContext context) {
    final company = _companyRepo.getCompany()!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: Text('Invoice #${widget.invoice.invoiceNumber}'),
        actions: [
          if (_generating)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                ),
              ),
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'Download PDF',
              onPressed: _generateAndDownload,
            ),
            IconButton(
              icon: const Icon(Icons.share),
              tooltip: 'Share',
              onPressed: _shareInvoice,
            ),
            IconButton(
              icon: const Icon(Icons.print),
              tooltip: 'Print',
              onPressed: _printInvoice,
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Invoice Preview Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: _InvoicePreviewCard(
                  invoice: widget.invoice, companyName: company.name),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _generateAndDownload,
                    icon: const Icon(Icons.download),
                    label: const Text('Download PDF'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _shareInvoice,
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Payment status update
            if (widget.invoice.paymentStatus != 'paid')
              ElevatedButton.icon(
                onPressed: _markAsPaid,
                icon: const Icon(Icons.check_circle),
                label: const Text('Mark as Paid'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size.fromHeight(45)),
              ),
          ],
        ),
      ),
    );
  }

  Future<File?> _getOrGeneratePDF() async {
    if (_pdfFile != null) return _pdfFile;
    setState(() => _generating = true);
    try {
      final company = _companyRepo.getCompany()!;
      final file = await PDFGeneratorService.generateInvoicePDF(
        invoice: widget.invoice,
        company: company,
      );
      setState(() {
        _pdfFile = file;
        _generating = false;
      });

      // Save PDF path
      widget.invoice.pdfPath = file.path;
      await _invoiceRepo.updateInvoice(widget.invoice);

      return file;
    } catch (e) {
      setState(() => _generating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('PDF generation failed: $e')));
      }
      return null;
    }
  }

  Future<void> _generateAndDownload() async {
    final file = await _getOrGeneratePDF();
    if (file != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF saved: ${file.path}'),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () => PDFGeneratorService.printPDF(file),
          ),
        ),
      );
    }
  }

  Future<void> _shareInvoice() async {
    final file = await _getOrGeneratePDF();
    if (file != null) {
      await PDFGeneratorService.sharePDF(file);
    }
  }

  Future<void> _printInvoice() async {
    final file = await _getOrGeneratePDF();
    if (file != null) {
      await PDFGeneratorService.printPDF(file);
    }
  }

  Future<void> _markAsPaid() async {
    widget.invoice.paymentStatus = 'paid';
    widget.invoice.amountPaid = widget.invoice.finalTotal;
    await _invoiceRepo.updateInvoice(widget.invoice);
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invoice marked as paid')));
    }
  }
}

// ── Invoice Preview Card (visual representation) ──────────────────────
class _InvoicePreviewCard extends StatelessWidget {
  final InvoiceModel invoice;
  final String companyName;

  const _InvoicePreviewCard({
    required this.invoice,
    required this.companyName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryBlue, width: 1.5),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppTheme.headerBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(companyName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const Text('INVOICE',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3)),
              ],
            ),
          ),

          // Invoice details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bill to
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('BILL TO',
                            style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.textMedium,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(invoice.customerName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(invoice.customerState,
                            style: const TextStyle(
                                fontSize: 12, color: AppTheme.textMedium)),
                      ],
                    ),
                    // Invoice number
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(invoice.invoiceNumber,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryBlue)),
                        Text(
                            '${invoice.invoiceDate.day}/${invoice.invoiceDate.month}/${invoice.invoiceDate.year}',
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textMedium)),
                      ],
                    ),
                  ],
                ),

                const Divider(height: 20),

                // Items
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1.5),
                  },
                  children: [
                    const TableRow(
                      decoration:
                          BoxDecoration(color: AppTheme.primaryBlue),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(6),
                          child: Text('Item',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(6),
                          child: Text('Qty',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 11),
                              textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: EdgeInsets.all(6),
                          child: Text('Amount',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 11),
                              textAlign: TextAlign.right),
                        ),
                      ],
                    ),
                    ...invoice.items.asMap().entries.map((e) {
                      final item = e.value;
                      final bg = e.key.isOdd
                          ? const Color(0xFFF8F9FF)
                          : Colors.white;
                      return TableRow(
                        decoration: BoxDecoration(color: bg),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(item.productName,
                                style: const TextStyle(fontSize: 11)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                                item.quantity.toStringAsFixed(2),
                                style: const TextStyle(fontSize: 11),
                                textAlign: TextAlign.center),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                                '₹${item.totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.right),
                          ),
                        ],
                      );
                    }),
                  ],
                ),

                const SizedBox(height: 12),

                // Totals
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 200,
                    child: Column(
                      children: [
                        _totalRow('Taxable', invoice.taxableAmount),
                        if (!invoice.isInterState) ...[
                          _totalRow('CGST', invoice.cgst),
                          _totalRow('SGST', invoice.sgst),
                        ] else
                          _totalRow('IGST', invoice.igst),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: AppTheme.headerBlue,
                              borderRadius: BorderRadius.circular(6)),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('TOTAL',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  '₹${invoice.finalTotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Payment Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: invoice.paymentStatus == 'paid'
                            ? Colors.green
                            : invoice.paymentStatus == 'partial'
                                ? Colors.orange
                                : Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        invoice.paymentStatus.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          Text('₹${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
