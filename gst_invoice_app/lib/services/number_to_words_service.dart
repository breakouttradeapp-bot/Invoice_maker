/// Converts a double amount to Indian English words (Rupees and Paise)
class NumberToWordsService {
  static const List<String> _ones = [
    '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight',
    'Nine', 'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen',
    'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'
  ];

  static const List<String> _tens = [
    '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty',
    'Sixty', 'Seventy', 'Eighty', 'Ninety'
  ];

  static String convert(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final rupees = int.parse(parts[0]);
    final paise = int.parse(parts[1]);

    String result = '';

    if (rupees > 0) {
      result = '${_convertToWords(rupees)} Rupees';
    } else {
      result = 'Zero Rupees';
    }

    if (paise > 0) {
      result += ' and ${_convertToWords(paise)} Paise';
    }

    return result;
  }

  static String _convertToWords(int number) {
    if (number == 0) return 'Zero';
    if (number < 20) return _ones[number];
    if (number < 100) {
      return '${_tens[number ~/ 10]}${number % 10 != 0 ? ' ${_ones[number % 10]}' : ''}';
    }
    if (number < 1000) {
      return '${_ones[number ~/ 100]} Hundred${number % 100 != 0 ? ' ${_convertToWords(number % 100)}' : ''}';
    }
    if (number < 100000) {
      return '${_convertToWords(number ~/ 1000)} Thousand${number % 1000 != 0 ? ' ${_convertToWords(number % 1000)}' : ''}';
    }
    if (number < 10000000) {
      return '${_convertToWords(number ~/ 100000)} Lakh${number % 100000 != 0 ? ' ${_convertToWords(number % 100000)}' : ''}';
    }
    return '${_convertToWords(number ~/ 10000000)} Crore${number % 10000000 != 0 ? ' ${_convertToWords(number % 10000000)}' : ''}';
  }
}
