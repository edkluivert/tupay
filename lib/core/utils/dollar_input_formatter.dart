import 'package:flutter/services.dart';

class DollarSignInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // If text is empty, just return empty
    if (newValue.text.isEmpty) {
      return const TextEditingValue(
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Remove any existing dollar signs
    var text = newValue.text.replaceAll(r'$', '');

    // If text is empty after removing $, return empty
    if (text.isEmpty) {
      return const TextEditingValue(
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Add $ at start
    text = '\$$text';

    final selectionIndex = text.length;

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}