class StringUtils {
  static String? validateString(String? value) {
    return value == null || value.isEmpty ? 'Invalid value.' : null;
  }
}
