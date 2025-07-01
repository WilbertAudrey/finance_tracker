import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/api_service.dart';
import '../../data/models/income_model.dart';
import 'income_state.dart';

class IncomeCubit extends Cubit<IncomeState> {
  final ApiService apiService;

  IncomeCubit(this.apiService) : super(IncomeInitial());

  /// Fetch all incomes
  Future<void> fetchIncomes() async {
    emit(IncomeLoading());
    try {
      final incomes = await apiService.getIncomes();
      incomes.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // sort by date desc
      emit(IncomeLoaded(incomes));
    } catch (e) {
      emit(IncomeError("Failed to fetch income: $e"));
    }
  }

  /// Fetch recent (latest) incomes (e.g. top 10)
  Future<void> fetchRecentIncome({int limit = 10}) async {
    emit(IncomeLoading());
    try {
      final incomes = await apiService.getIncomes();
      incomes.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // newest first
      final recent = incomes.take(limit).toList();
      emit(IncomeLoaded(recent));
    } catch (e) {
      emit(IncomeError("Failed to fetch recent income: $e"));
    }
  }

  /// Add new income
  Future<void> addIncome({
    required int accountId,
    required double amount,
    String? category,
    String? note,
  }) async {
    try {
      await apiService.createIncome(
        accountId: accountId,
        amount: amount,
        category: category,
        note: note,
      );
      await fetchIncomes(); // refresh list after successful add
    } catch (e) {
      emit(IncomeError("Failed to add income: $e"));
    }
  }
}
