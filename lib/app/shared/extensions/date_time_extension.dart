extension DateTimeExtension on DateTime {
  int get yearWithTwoDigits {
    if (year < 1000) {
      return 0;
    }

    final _stringfiedYear = '$year';
    final _lastTwoDigits =
        _stringfiedYear.substring(_stringfiedYear.length - 2);
    return int.parse(_lastTwoDigits);
  }
}
