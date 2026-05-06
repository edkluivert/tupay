import 'dart:convert';
import 'package:tupay/features/wallet/data/models/transaction_model.dart';

class IsolateParser {
  /// Simulates parsing and filtering a 5MB JSON payload in a background isolate.
  static Future<List<TransactionModel>> parseLargeTransactionData() async {

    final buffer = StringBuffer()
    ..write('[');
    for (var i = 0; i < 50000; i++) {
      buffer.write(r'''
      {
        "id": "tx_$i",
        "title": "Mock Transaction $i",
        "subtitle": "Isolate processed",
        "amount": "${(i % 1000) + 10.50}",
        "currencySymbol": "$",
        "type": "${i % 2 == 0 ? 'credit' : 'debit'}",
        "status": "success",
        "category": "purchase",
        "timestamp": "2023-10-24T14:45:00.000Z"
      }
      ''');
      if (i < 49999) buffer.write(',');
    }
    buffer.write(']');

    final jsonString = buffer.toString();
    final decoded = jsonDecode(jsonString);

    if (decoded is! List) {
      throw const FormatException('Expected a JSON list');
    }

    final decodedList = decoded.cast<Map<String, dynamic>>();
    

    final transactions = decodedList.map((json) {
      return TransactionModel(
        id: json['id'] as String,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String,
        amount: json['amount'] as String,
        currencySymbol: json['currencySymbol'] as String,
        type: json['type'] == 'credit' ? TransactionType.credit : TransactionType.debit,
        status: TransactionStatus.success,
        category: TransactionCategory.purchase,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
    }).toList();
    

    final filteredTransactions = transactions.where((tx) {
      final amount = double.tryParse(tx.amount) ?? 0.0;
      return amount > 500.0;
    }).toList();
    

    return filteredTransactions.take(10).toList();
  }
}
