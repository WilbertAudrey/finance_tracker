class Income {
  final int id;
  final int accountId;
  final double amount;
  final String? category;
  final String? note;
  final String accountName;
  final DateTime createdAt;

  Income({
    required this.id,
    required this.accountId,
    required this.amount,
    this.category,
    this.note,
    required this.accountName,
    required this.createdAt,
  });

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id'],
      accountId: json['account_id'],
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      category: json['category'],
      note: json['note'],
      accountName: json['account_name'] ?? 'Unknown Account',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
