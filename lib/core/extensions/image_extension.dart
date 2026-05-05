/// Created this extension as it is much easier and quicker for implementation
/// Code credits => Kluivert
library;

import 'package:intl/intl.dart';

extension ImageFormat on String {
  String get png {
    return 'assets/images/$this.png';
  }

  String get svg {
    return 'assets/icons/$this.svg';
  }

  String get json {
    return 'assets/json/$this.json';
  }

  /// Converts an ISO 8601 date string to the format "d, MMM yyyy".
  String toFormattedDate() {
    try {
      final parsedDate = DateTime.parse(this);
      return DateFormat('d, MMM yyyy').format(parsedDate);
    } catch (e) {
      return this;
    }
  }

  String toFormattedChatDate() {
    try {
      final parsedDate = DateTime.parse(this);
      final now = DateTime.now();
      final difference = now.difference(parsedDate);

      if (difference.inMinutes < 1) {
        return 'just now';
      } else if (difference.inMinutes < 30) {
        return '${difference.inMinutes} min ago';
      } else if (parsedDate.day == now.day && parsedDate.month == now.month && parsedDate.year == now.year) {
        return DateFormat('hh:mm a').format(parsedDate);
      } else {
        return DateFormat('d, MMM yyyy').format(parsedDate);
      }
    } catch (e) {
      return this;
    }
  }
}
