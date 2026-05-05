class StringUtils {
  static bool isPhoneNumber(String value) {
    try {
      if (value.startsWith('0')) return true;
      int.parse(value);
      return true;
    } on FormatException {
      return false;
    }
  }

  static String escapeSpecial(String query) {
    return query.replaceAllMapped(RegExp(r'[.*+?^${}()|[\]\\]'), (x) {
      return '\\${x[0]}';
    });
  }
}
