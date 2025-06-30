class Expense {
  final int id;
  final int accountId;
  final double amount;
  final String? category;
  final String? note;

  Expense({required this.id, required this.accountId, required this.amount, this.category, this.note});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      accountId: json['account_id'],
      amount: json['amount'],
      category: json['category'],
      note: json['note'],
    );
  }
}