/// GST Calculation Engine - India Compliant
/// Handles CGST/SGST (intrastate) and IGST (interstate) calculations

class GSTCalculationResult {
  final double baseAmount;
  final double discountAmount;
  final double taxableAmount;
  final double cgst;
  final double sgst;
  final double igst;
  final double totalTax;
  final double totalAmount;
  final bool isInterState;
  final double gstRate;
  final bool isInclusive;

  const GSTCalculationResult({
    required this.baseAmount,
    required this.discountAmount,
    required this.taxableAmount,
    required this.cgst,
    required this.sgst,
    required this.igst,
    required this.totalTax,
    required this.totalAmount,
    required this.isInterState,
    required this.gstRate,
    required this.isInclusive,
  });

  Map<String, dynamic> toJson() => {
        'baseAmount': baseAmount,
        'discountAmount': discountAmount,
        'taxableAmount': taxableAmount,
        'cgst': cgst,
        'sgst': sgst,
        'igst': igst,
        'totalTax': totalTax,
        'totalAmount': totalAmount,
        'isInterState': isInterState,
        'gstRate': gstRate,
        'isInclusive': isInclusive,
      };
}

class InvoiceTaxSummary {
  final double subTotal;
  final double totalDiscount;
  final double taxableAmount;
  final double cgst;
  final double sgst;
  final double igst;
  final double totalTax;
  final double shippingCharges;
  final double grandTotal;
  final double roundOff;
  final double finalTotal;
  final bool isInterState;
  final Map<double, TaxRateBreakdown> taxBreakdown;

  const InvoiceTaxSummary({
    required this.subTotal,
    required this.totalDiscount,
    required this.taxableAmount,
    required this.cgst,
    required this.sgst,
    required this.igst,
    required this.totalTax,
    required this.shippingCharges,
    required this.grandTotal,
    required this.roundOff,
    required this.finalTotal,
    required this.isInterState,
    required this.taxBreakdown,
  });
}

class TaxRateBreakdown {
  final double gstRate;
  final double taxableAmount;
  final double cgst;
  final double sgst;
  final double igst;

  const TaxRateBreakdown({
    required this.gstRate,
    required this.taxableAmount,
    required this.cgst,
    required this.sgst,
    required this.igst,
  });
}

class LineItemCalculation {
  final double quantity;
  final double price;
  final double discountPercent;
  final double gstRate;
  final bool isInclusive;
  final bool isInterState;

  const LineItemCalculation({
    required this.quantity,
    required this.price,
    required this.discountPercent,
    required this.gstRate,
    required this.isInclusive,
    required this.isInterState,
  });
}

class GSTCalculatorService {
  /// Calculate GST for a single line item
  static GSTCalculationResult calculateLineItem(LineItemCalculation params) {
    final double baseAmount = params.quantity * params.price;
    final double discountAmount = baseAmount * (params.discountPercent / 100);
    double taxableAmount = baseAmount - discountAmount;

    double cgst = 0.0;
    double sgst = 0.0;
    double igst = 0.0;

    if (params.isInclusive && params.gstRate > 0) {
      // Extract tax from inclusive price
      taxableAmount = taxableAmount / (1 + params.gstRate / 100);
    }

    final double taxAmount = taxableAmount * (params.gstRate / 100);

    if (params.isInterState) {
      igst = taxAmount;
    } else {
      cgst = taxAmount / 2;
      sgst = taxAmount / 2;
    }

    final double totalTax = cgst + sgst + igst;
    final double totalAmount = taxableAmount + totalTax;

    return GSTCalculationResult(
      baseAmount: _round(baseAmount),
      discountAmount: _round(discountAmount),
      taxableAmount: _round(taxableAmount),
      cgst: _round(cgst),
      sgst: _round(sgst),
      igst: _round(igst),
      totalTax: _round(totalTax),
      totalAmount: _round(totalAmount),
      isInterState: params.isInterState,
      gstRate: params.gstRate,
      isInclusive: params.isInclusive,
    );
  }

  /// Calculate full invoice tax summary
  static InvoiceTaxSummary calculateInvoice({
    required List<Map<String, dynamic>> items,
    // each item: {quantity, price, discountPercent, gstRate, isInclusive}
    required String sellerState,
    required String buyerState,
    required double shippingCharges,
    required bool isReverseCharge,
  }) {
    final bool isInterState = sellerState.toLowerCase() != buyerState.toLowerCase();

    double subTotal = 0.0;
    double totalDiscount = 0.0;
    double totalTaxable = 0.0;
    double totalCGST = 0.0;
    double totalSGST = 0.0;
    double totalIGST = 0.0;

    // Tax breakdown by GST rate
    final Map<double, Map<String, double>> rateMap = {};

    for (final item in items) {
      final calc = calculateLineItem(LineItemCalculation(
        quantity: (item['quantity'] as num).toDouble(),
        price: (item['price'] as num).toDouble(),
        discountPercent: (item['discountPercent'] as num?)?.toDouble() ?? 0.0,
        gstRate: (item['gstRate'] as num).toDouble(),
        isInclusive: item['isInclusive'] as bool? ?? false,
        isInterState: isInterState,
      ));

      subTotal += calc.baseAmount;
      totalDiscount += calc.discountAmount;
      totalTaxable += calc.taxableAmount;

      if (isReverseCharge) {
        // Under reverse charge, no tax collected from buyer
        // Just track taxable amount
      } else {
        totalCGST += calc.cgst;
        totalSGST += calc.sgst;
        totalIGST += calc.igst;
      }

      // Group by tax rate
      final rate = calc.gstRate;
      if (!rateMap.containsKey(rate)) {
        rateMap[rate] = {
          'taxable': 0.0,
          'cgst': 0.0,
          'sgst': 0.0,
          'igst': 0.0,
        };
      }
      rateMap[rate]!['taxable'] = rateMap[rate]!['taxable']! + calc.taxableAmount;
      rateMap[rate]!['cgst'] = rateMap[rate]!['cgst']! + calc.cgst;
      rateMap[rate]!['sgst'] = rateMap[rate]!['sgst']! + calc.sgst;
      rateMap[rate]!['igst'] = rateMap[rate]!['igst']! + calc.igst;
    }

    final double totalTax = totalCGST + totalSGST + totalIGST;
    final double grandTotal = totalTaxable + totalTax + shippingCharges;
    final double roundOff = _calculateRoundOff(grandTotal);
    final double finalTotal = grandTotal + roundOff;

    // Build tax breakdown
    final Map<double, TaxRateBreakdown> taxBreakdown = {};
    rateMap.forEach((rate, values) {
      taxBreakdown[rate] = TaxRateBreakdown(
        gstRate: rate,
        taxableAmount: _round(values['taxable']!),
        cgst: _round(values['cgst']!),
        sgst: _round(values['sgst']!),
        igst: _round(values['igst']!),
      );
    });

    return InvoiceTaxSummary(
      subTotal: _round(subTotal),
      totalDiscount: _round(totalDiscount),
      taxableAmount: _round(totalTaxable),
      cgst: _round(totalCGST),
      sgst: _round(totalSGST),
      igst: _round(totalIGST),
      totalTax: _round(totalTax),
      shippingCharges: _round(shippingCharges),
      grandTotal: _round(grandTotal),
      roundOff: _round(roundOff),
      finalTotal: _round(finalTotal),
      isInterState: isInterState,
      taxBreakdown: taxBreakdown,
    );
  }

  /// Determines if intrastate or interstate based on state match
  static bool isInterState(String sellerState, String buyerState) {
    return sellerState.trim().toLowerCase() != buyerState.trim().toLowerCase();
  }

  static double _calculateRoundOff(double amount) {
    final double rounded = amount.roundToDouble();
    return _round(rounded - amount);
  }

  static double _round(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  /// Format currency in Indian format (₹)
  static String formatCurrency(double amount) {
    final String formatted = amount.toStringAsFixed(2);
    final parts = formatted.split('.');
    final whole = parts[0];
    final decimal = parts[1];

    // Indian number formatting
    if (whole.length <= 3) return '₹$whole.$decimal';

    final last3 = whole.substring(whole.length - 3);
    final remaining = whole.substring(0, whole.length - 3);
    final groups = <String>[];
    String temp = remaining;
    while (temp.length > 2) {
      groups.insert(0, temp.substring(temp.length - 2));
      temp = temp.substring(0, temp.length - 2);
    }
    if (temp.isNotEmpty) groups.insert(0, temp);

    return '₹${groups.join(',')},${last3}.${decimal}';
  }
}
