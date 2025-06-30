import 'package:dio/dio.dart';
import '../models/account_model.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:5000'));

  Future<List<Account>> getAccounts() async {
    final res = await _dio.get('/accounts');
    return (res.data as List).map((e) => Account.fromJson(e)).toList();
  }
}