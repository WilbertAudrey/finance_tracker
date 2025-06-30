class Income {
  final int id;
  final int accountId;
  final double amount;
  final String? category;
  final String? note;

  Income({required this.id, required this.accountId, required this.amount, this.category, this.note});

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id'],
      accountId: json['account_id'],
      amount: json['amount'],
      category: json['category'],
      note: json['note'],
    );
  }
}