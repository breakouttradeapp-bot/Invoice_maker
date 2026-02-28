import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

import '../data/models/hive/invoice_model.dart';
import '../data/models/hive/company_model.dart';
import '../core/constants/app_constants.dart';
import 'number_to_words_service.dart';

class PDFGeneratorService {
  static Future<File> generateInvoicePDF({
    required InvoiceModel invoice,
    required CompanyModel company,
    bool showVipBadge = false,
  }) async {
    final pdf = pw.Document();

    // Load logo if available
    pw.MemoryImage? logoImage;
    if (company.logoPath != null && File(company.logoPath!).existsSync()) {
      final bytes = await File(company.logoPath!).readAsBytes();
      logoImage = pw.MemoryImage(bytes);
    }

    // Load signature if available
    pw.MemoryImage? signatureImage;
    if (company.signaturePath != null &&
        File(company.signaturePath!).existsSync()) {
      final bytes = await File(company.signaturePath!).readAsBytes();
      signatureImage = pw.MemoryImage(bytes);
    }

    switch (invoice.templateId) {
      case AppConstants.templateBlueCorporate:
        pdf.addPage(
          _buildBlueCorporatePage(invoice, company, logoImage, signatureImage, showVipBadge),
        );
        break;
      case AppConstants.templateModernMinimal:
        pdf.addPage(
          _buildModernMinimalPage(invoice, company, logoImage, signatureImage),
        );
        break;
      case AppConstants.templateBoldBusiness:
        pdf.addPage(
          _buildBoldBusinessPage(invoice, company, logoImage, signatureImage),
        );
        break;
      case AppConstants.templateCleanCorporate:
        pdf.addPage(
          _buildCleanCorporatePage(invoice, company, logoImage, signatureImage),
        );
        break;
      default:
        pdf.addPage(
          _buildBlueCorporatePage(invoice, company, logoImage, signatureImage, showVipBadge),
        );
    }

    // Save file
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/invoice_${invoice.invoiceNumber}.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  // ─────────────────────────────────────────────────────────────────────
  // TEMPLATE 1: BLUE CORPORATE VIP
  // ─────────────────────────────────────────────────────────────────────
  static pw.Page _buildBlueCorporatePage(
    InvoiceModel invoice,
    CompanyModel company,
    pw.MemoryImage? logo,
    pw.MemoryImage? signature,
    bool showVipBadge,
  ) {
    const primaryBlue = PdfColor.fromInt(0xFF1A237E);
    const headerBlue = PdfColor.fromInt(0xFF0D1B5E);
    const lightGrey = PdfColor.fromInt(0xFFF5F5F5);
    const tableHeaderBlue = PdfColor.fromInt(0xFF283593);
    const altRowColor = PdfColor.fromInt(0xFFF8F9FF);
    const goldColor = PdfColor.fromInt(0xFFFFD700);
    const textDark = PdfColors.black;
    const textMedium = PdfColor.fromInt(0xFF616161);

    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(20),
      build: (pw.Context context) {
        return pw.Container(
          decoration: pw.BoxDecoration(
            color: lightGrey,
            border: pw.Border.all(color: primaryBlue, width: 1.5),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // ── HEADER ──
              _buildBlueCorporateHeader(invoice, company, logo, showVipBadge,
                  headerBlue, goldColor),

              pw.SizedBox(height: 12),

              // ── BILL TO + INVOICE DETAILS ──
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 16),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                        child: _buildBillToSection(invoice, primaryBlue)),
                    pw.SizedBox(width: 16),
                    pw.Expanded(
                        child: _buildInvoiceDetailsSection(invoice, primaryBlue)),
                  ],
                ),
              ),

              pw.SizedBox(height: 12),

              // ── ITEMS TABLE ──
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 16),
                child: _buildItemsTable(invoice, tableHeaderBlue, altRowColor),
              ),

              pw.SizedBox(height: 8),

              // ── TOTALS ──
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 16),
                child: _buildTotalsSection(invoice, primaryBlue, headerBlue),
              ),

              pw.SizedBox(height: 8),

              // ── BANK + SIGNATURE ──
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 16),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(child: _buildBankDetails(company, primaryBlue)),
                    pw.SizedBox(width: 16),
                    pw.Expanded(
                        child: _buildSignatureSection(
                            company, signature, primaryBlue)),
                  ],
                ),
              ),

              pw.SizedBox(height: 8),

              // ── TERMS ──
              if (invoice.termsAndConditions.isNotEmpty)
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 16),
                  child: _buildTermsSection(invoice, primaryBlue),
                ),

              // ── FOOTER ──
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  'This is a computer-generated invoice. | GST Registered | ${company.gstin}',
                  style: pw.TextStyle(fontSize: 7, color: textMedium),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static pw.Widget _buildBlueCorporateHeader(
    InvoiceModel invoice,
    CompanyModel company,
    pw.MemoryImage? logo,
    bool showVipBadge,
    PdfColor headerBlue,
    PdfColor goldColor,
  ) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: headerBlue,
        borderRadius: const pw.BorderRadius.only(
          topLeft: pw.Radius.circular(8),
          topRight: pw.Radius.circular(8),
        ),
      ),
      padding: const pw.EdgeInsets.all(16),
      child: pw.Row(
        children: [
          // Logo + Company Info
          pw.Expanded(
            child: pw.Row(
              children: [
                if (logo != null)
                  pw.Container(
                    width: 50,
                    height: 50,
                    child: pw.Image(logo),
                  ),
                if (logo != null) pw.SizedBox(width: 12),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      company.name,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'GSTIN: ${company.gstin}',
                      style: const pw.TextStyle(fontSize: 8, color: PdfColors.white),
                    ),
                    pw.Text(
                      company.address,
                      style: const pw.TextStyle(fontSize: 8, color: PdfColors.white),
                    ),
                    pw.Text(
                      '${company.city}, ${company.state} - ${company.pincode}',
                      style: const pw.TextStyle(fontSize: 8, color: PdfColors.white),
                    ),
                    pw.Text(
                      '${company.phone}  |  ${company.email}',
                      style: const pw.TextStyle(fontSize: 8, color: PdfColors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // INVOICE title + VIP badge
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'INVOICE',
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                  letterSpacing: 3,
                ),
              ),
              if (invoice.isReverseCharge)
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: pw.BoxDecoration(
                    color: goldColor,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    'REVERSE CHARGE',
                    style: pw.TextStyle(
                      fontSize: 7,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                ),
              if (showVipBadge)
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: pw.BoxDecoration(
                    color: goldColor,
                    borderRadius: pw.BorderRadius.circular(20),
                  ),
                  child: pw.Text(
                    '★ VIP',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildBillToSection(InvoiceModel invoice, PdfColor primary) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: primary, width: 0.5),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('BILL TO',
              style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                  color: primary)),
          pw.Divider(color: primary, thickness: 0.5),
          pw.Text(invoice.customerName,
              style: pw.TextStyle(
                  fontSize: 11, fontWeight: pw.FontWeight.bold)),
          if (invoice.customerGstin.isNotEmpty)
            pw.Text('GSTIN: ${invoice.customerGstin}',
                style: const pw.TextStyle(fontSize: 8)),
          pw.Text(invoice.customerAddress,
              style: const pw.TextStyle(fontSize: 8)),
          pw.Text('State: ${invoice.customerState}',
              style: const pw.TextStyle(fontSize: 8)),
          if (invoice.customerPhone.isNotEmpty)
            pw.Text('Ph: ${invoice.customerPhone}',
                style: const pw.TextStyle(fontSize: 8)),
        ],
      ),
    );
  }

  static pw.Widget _buildInvoiceDetailsSection(
      InvoiceModel invoice, PdfColor primary) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: primary, width: 0.5),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('INVOICE DETAILS',
              style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                  color: primary)),
          pw.Divider(color: primary, thickness: 0.5),
          _detailRow('Invoice No', invoice.invoiceNumber),
          _detailRow('Date',
              '${invoice.invoiceDate.day}/${invoice.invoiceDate.month}/${invoice.invoiceDate.year}'),
          if (invoice.dueDate != null)
            _detailRow('Due Date',
                '${invoice.dueDate!.day}/${invoice.dueDate!.month}/${invoice.dueDate!.year}'),
          _detailRow('Place of Supply', invoice.placeOfSupply),
          _detailRow('Tax Type', invoice.isInterState ? 'IGST' : 'CGST+SGST'),
          _detailRow('Status',
              invoice.paymentStatus.toUpperCase()),
        ],
      ),
    );
  }

  static pw.Widget _detailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
          pw.Text(value,
              style: pw.TextStyle(
                  fontSize: 8, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  static pw.Widget _buildItemsTable(
      InvoiceModel invoice, PdfColor headerColor, PdfColor altRow) {
    final headers = invoice.isInterState
        ? ['#', 'Item / HSN', 'Qty', 'Unit', 'Price', 'Disc%', 'GST%', 'IGST', 'Amount']
        : ['#', 'Item / HSN', 'Qty', 'Unit', 'Price', 'Disc%', 'GST%', 'CGST', 'SGST', 'Amount'];

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: invoice.isInterState
          ? {
              0: const pw.FixedColumnWidth(18),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FixedColumnWidth(28),
              3: const pw.FixedColumnWidth(28),
              4: const pw.FixedColumnWidth(40),
              5: const pw.FixedColumnWidth(28),
              6: const pw.FixedColumnWidth(28),
              7: const pw.FixedColumnWidth(40),
              8: const pw.FixedColumnWidth(45),
            }
          : {
              0: const pw.FixedColumnWidth(18),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FixedColumnWidth(24),
              3: const pw.FixedColumnWidth(24),
              4: const pw.FixedColumnWidth(36),
              5: const pw.FixedColumnWidth(24),
              6: const pw.FixedColumnWidth(24),
              7: const pw.FixedColumnWidth(35),
              8: const pw.FixedColumnWidth(35),
              9: const pw.FixedColumnWidth(40),
            },
      children: [
        // Header Row
        pw.TableRow(
          decoration: pw.BoxDecoration(color: headerColor),
          children: headers
              .map((h) => _tableHeaderCell(h))
              .toList(),
        ),
        // Data Rows
        ...invoice.items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          final bgColor = i.isOdd ? altRow : PdfColors.white;
          final cells = invoice.isInterState
              ? [
                  '${i + 1}',
                  '${item.productName}\n${item.hsnSac.isNotEmpty ? 'HSN: ${item.hsnSac}' : ''}',
                  item.quantity.toStringAsFixed(2),
                  item.unit,
                  item.price.toStringAsFixed(2),
                  '${item.discountPercent.toStringAsFixed(1)}%',
                  '${item.gstRate.toStringAsFixed(0)}%',
                  item.igst.toStringAsFixed(2),
                  item.totalAmount.toStringAsFixed(2),
                ]
              : [
                  '${i + 1}',
                  '${item.productName}\n${item.hsnSac.isNotEmpty ? 'HSN: ${item.hsnSac}' : ''}',
                  item.quantity.toStringAsFixed(2),
                  item.unit,
                  item.price.toStringAsFixed(2),
                  '${item.discountPercent.toStringAsFixed(1)}%',
                  '${item.gstRate.toStringAsFixed(0)}%',
                  item.cgst.toStringAsFixed(2),
                  item.sgst.toStringAsFixed(2),
                  item.totalAmount.toStringAsFixed(2),
                ];
          return pw.TableRow(
            decoration: pw.BoxDecoration(color: bgColor),
            children: cells.asMap().entries.map((e) {
              final isLast = e.key == cells.length - 1;
              return _tableDataCell(e.value, alignRight: isLast || e.key > 4);
            }).toList(),
          );
        }),
      ],
    );
  }

  static pw.Widget _tableHeaderCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 7.5,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _tableDataCell(String text,
      {bool alignRight = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 7.5),
        textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.left,
      ),
    );
  }

  static pw.Widget _buildTotalsSection(
      InvoiceModel invoice, PdfColor primary, PdfColor headerBlue) {
    return pw.Row(
      children: [
        pw.Expanded(child: pw.SizedBox()),
        pw.Container(
          width: 200,
          child: pw.Column(
            children: [
              _totalRow('Sub Total', invoice.subTotal),
              if (invoice.totalDiscount > 0)
                _totalRow('Discount (-)', invoice.totalDiscount,
                    isNegative: true),
              _totalRow('Taxable Amount', invoice.taxableAmount),
              if (!invoice.isInterState) ...[
                _totalRow('CGST', invoice.cgst),
                _totalRow('SGST', invoice.sgst),
              ] else
                _totalRow('IGST', invoice.igst),
              if (invoice.shippingCharges > 0)
                _totalRow('Shipping', invoice.shippingCharges),
              if (invoice.roundOff != 0)
                _totalRow('Round Off', invoice.roundOff),
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  color: headerBlue,
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('TOTAL',
                        style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white)),
                    pw.Text(
                      '₹${invoice.finalTotal.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Container(
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(
                  color: const PdfColor.fromInt(0xFFE8EAF6),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Text(
                  'Amount in Words: ${NumberToWordsService.convert(invoice.finalTotal)} Only',
                  style: pw.TextStyle(
                      fontSize: 7.5, fontStyle: pw.FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _totalRow(String label, double amount,
      {bool isNegative = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
          pw.Text(
            '${isNegative ? '-' : ''}₹${amount.abs().toStringAsFixed(2)}',
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildBankDetails(CompanyModel company, PdfColor primary) {
    if (company.bankName.isEmpty) return pw.SizedBox();
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: primary, width: 0.5),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('BANK DETAILS',
              style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  color: primary)),
          pw.Divider(color: primary, thickness: 0.5),
          _detailRow('Bank Name', company.bankName),
          _detailRow('Account No', company.accountNumber),
          _detailRow('IFSC Code', company.ifscCode),
          _detailRow('Account Holder', company.accountHolder),
          if (company.upiId != null && company.upiId!.isNotEmpty)
            _detailRow('UPI ID', company.upiId!),
        ],
      ),
    );
  }

  static pw.Widget _buildSignatureSection(
      CompanyModel company, pw.MemoryImage? signature, PdfColor primary) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: primary, width: 0.5),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text('For ${company.name}',
              style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  color: primary)),
          pw.SizedBox(height: 24),
          if (signature != null)
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Container(
                width: 80,
                height: 40,
                child: pw.Image(signature),
              ),
            ),
          pw.Container(
            width: 120,
            decoration:
                const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide())),
            padding: const pw.EdgeInsets.only(top: 4),
            child: pw.Text(
              'Authorised Signatory',
              style: const pw.TextStyle(fontSize: 7.5),
              textAlign: pw.TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTermsSection(InvoiceModel invoice, PdfColor primary) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: primary, width: 0.5),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('TERMS & CONDITIONS',
              style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  color: primary)),
          pw.SizedBox(height: 4),
          pw.Text(
            invoice.termsAndConditions,
            style: const pw.TextStyle(fontSize: 7.5),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // TEMPLATE 2: MODERN MINIMAL
  // ─────────────────────────────────────────────────────────────────────
  static pw.Page _buildModernMinimalPage(
    InvoiceModel invoice,
    CompanyModel company,
    pw.MemoryImage? logo,
    pw.MemoryImage? signature,
  ) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            // Header: Company left, INVOICE right
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (logo != null) pw.Image(logo, width: 60),
                    pw.SizedBox(height: 4),
                    pw.Text(company.name,
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.Text('GSTIN: ${company.gstin}',
                        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
                    pw.Text(company.address,
                        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('INVOICE',
                        style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: const PdfColor.fromInt(0xFF1A237E))),
                    pw.Text(invoice.invoiceNumber,
                        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
                    pw.Text(
                        '${invoice.invoiceDate.day}/${invoice.invoiceDate.month}/${invoice.invoiceDate.year}',
                        style: const pw.TextStyle(fontSize: 9)),
                  ],
                ),
              ],
            ),
            pw.Divider(thickness: 2, color: const PdfColor.fromInt(0xFF1A237E)),
            pw.SizedBox(height: 12),
            pw.Row(
              children: [
                pw.Expanded(
                    child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('BILL TO',
                        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
                    pw.SizedBox(height: 4),
                    pw.Text(invoice.customerName,
                        style: pw.TextStyle(
                            fontSize: 11, fontWeight: pw.FontWeight.bold)),
                    pw.Text(invoice.customerAddress,
                        style: const pw.TextStyle(fontSize: 8)),
                    pw.Text('State: ${invoice.customerState}',
                        style: const pw.TextStyle(fontSize: 8)),
                    if (invoice.customerGstin.isNotEmpty)
                      pw.Text('GSTIN: ${invoice.customerGstin}',
                          style: const pw.TextStyle(fontSize: 8)),
                  ],
                )),
                pw.Expanded(child: pw.SizedBox()),
              ],
            ),
            pw.SizedBox(height: 16),
            _buildItemsTable(invoice, const PdfColor.fromInt(0xFF1A237E),
                const PdfColor.fromInt(0xFFF5F5F5)),
            pw.SizedBox(height: 12),
            _buildTotalsSection(
                invoice,
                const PdfColor.fromInt(0xFF1A237E),
                const PdfColor.fromInt(0xFF0D1B5E)),
            pw.Spacer(),
            pw.Divider(),
            _buildBankDetails(company, const PdfColor.fromInt(0xFF1A237E)),
          ],
        );
      },
    );
  }

  // Templates 3 & 4 follow similar patterns (abbreviated for brevity)
  static pw.Page _buildBoldBusinessPage(
      InvoiceModel invoice, CompanyModel company,
      pw.MemoryImage? logo, pw.MemoryImage? signature) {
    // Similar to minimal but with bold typography and accent orange/red
    return _buildModernMinimalPage(invoice, company, logo, signature);
  }

  static pw.Page _buildCleanCorporatePage(
      InvoiceModel invoice, CompanyModel company,
      pw.MemoryImage? logo, pw.MemoryImage? signature) {
    return _buildModernMinimalPage(invoice, company, logo, signature);
  }

  // ── Share / Print Helpers ─────────────────────────────────────────────
  static Future<void> sharePDF(File pdfFile) async {
    await Printing.sharePdf(
      bytes: await pdfFile.readAsBytes(),
      filename: pdfFile.path.split('/').last,
    );
  }

  static Future<void> printPDF(File pdfFile) async {
    await Printing.layoutPdf(
      onLayout: (_) => pdfFile.readAsBytes(),
    );
  }
}
