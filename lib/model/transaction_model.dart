enum TransactionType { income, expense, refund }

enum TransactionStatus { completed, pending, failed }

class TransactionModel {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final TransactionStatus status;

  TransactionModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
    required this.status,
  });
}
