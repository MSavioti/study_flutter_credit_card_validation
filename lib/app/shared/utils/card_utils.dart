import 'package:study_flutter_credit_card_validation/app/shared/extensions/date_time_extension.dart';

class CardUtils {
  static String? validateMonthYearDate(String? value) {
    final _extractedDate = extractMonthYearFromDate(value);

    if (_extractedDate.isEmpty) {
      return 'Invalid date format.';
    }

    int month = _extractedDate.first;
    int year = _extractedDate.last;

    final DateTime _currentDate = DateTime.now();
    final int _twoDigitCurrentYear = _currentDate.yearWithTwoDigits;

    if (year < _twoDigitCurrentYear) {
      return 'Card has expired.';
    }

    if ((year == _twoDigitCurrentYear) && (month < _currentDate.month)) {
      return 'Card has expired.';
    }

    return null;
  }

  static List<int> extractMonthYearFromDate(String? value) {
    if (value == null ||
        value.isEmpty ||
        value.length < 5 ||
        !value.contains('/')) {
      return [];
    }

    final _splitValue = value.split('/');

    if (_splitValue.length != 2 ||
        _splitValue.first.length != 2 ||
        _splitValue.last.length != 2) {
      return [];
    }

    int month = int.tryParse(_splitValue.first) ?? -1;
    int year = int.tryParse(_splitValue.last) ?? -1;

    if (year < 0 || month < 0 || month > 12) {
      return [];
    }

    return <int>[month, year];
  }

  static String normalizeCardNumber(String text) {
    RegExp regExp = RegExp(r"[^0-9]");
    return text.replaceAll(regExp, '');
  }

  static String? validateCardNumber(String? input) {
    if (input == null || input.isEmpty) {
      return 'Required field';
    }

    input = normalizeCardNumber(input);

    if (input.length < 8 || input.length > 19) {
      return 'Not a valid card number.';
    }

    int _sum = 0;

    for (var i = 0; i < input.length; i++) {
      int _currentDigit = int.parse(input[input.length - i - 1]);

      if (i % 2 == 1) {
        _currentDigit *= 2;
      }

      _sum += _currentDigit > 9 ? (_currentDigit - 9) : _currentDigit;
    }

    if (_sum % 10 > 0) {
      return 'Not a valid card number.';
    }

    return null;
  }
}
