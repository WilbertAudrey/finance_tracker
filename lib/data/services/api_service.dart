import 'package:dio/dio.dart';
import '../models/account_model.dart';
import '../models/income_model.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:5000'));

  // ==== ACCOUNTS ====

  Future<List<Account>> getAccounts() async {
    final res = await _dio.get('/accounts');
    return (res.data as List).map((e) => Account.fromJson(e)).toList();
  }

  Future<void> addAccount(String name, double balance) async {
    try {
      await _dio.post('/accounts', data: {
        'name': name,
        'balance': balance,
      });
    } catch (e) {
      throw Exception("Gagal menambahkan akun: ${e.toString()}");
    }
  }

  // ==== INCOME ====

  Future<List<Income>> getIncomes() async {
    final res = await _dio.get('/income');
    return (res.data as List).map((e) => Income.fromJson(e)).toList();
  }

  Future<void> createIncome({
    required int accountId,
    required double amount,
    String? category,
    String? note,
  }) async {
    try {
      await _dio.post('/income', data: {
        'account_id': accountId,
        'amount': amount,
        'category': category,
        'note': note,
      });
    } catch (e) {
      throw Exception("Gagal menambahkan income: ${e.toString()}");
    }
  }

  Future<void> updateIncome({
    required int id,
    required int accountId,
    required double amount,
    String? category,
    String? note,
  }) async {
    try {
      await _dio.put('/income/$id', data: {
        'account_id': accountId,
        'amount': amount,
        'category': category,
        'note': note,
      });
    } catch (e) {
      throw Exception("Failed to update income: $e");
    }
  }

  Future<void> deleteIncome(int id) async {
    try {
      await _dio.delete('/income/$id');
    } catch (e) {
      throw Exception("Failed to delete income: $e");
    }
  }
}
