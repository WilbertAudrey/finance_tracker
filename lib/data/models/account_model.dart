import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final int id;
  final String name;
  final double balance;

  const Account({required this.id, required this.name, required this.balance});

factory Account.fromJson(Map<String, dynamic> json) => Account(
  id: json['id'],
  name: json['name'],
balance: double.tryParse(json['balance'].toString()) ?? 0.0,

);


  @override
  List<Object?> get props => [id, name, balance];
}
