import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/api_service.dart';
import '../../data/models/income_model.dart';
import 'income_state.dart';

class IncomeCubit extends Cubit<IncomeState> {
  final ApiService apiService;

  IncomeCubit(this.apiService) : super(IncomeInitial());

  /// Ambil semua data income
  Future<void> fetchIncomes() async {
    emit(IncomeLoading());
    try {
      final incomes = await apiService.getIncomes();
      incomes.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // sort terbaru dulu
      emit(IncomeLoaded(incomes));
    } catch (e) {
      emit(IncomeError("Failed to fetch income: $e"));
    }
  }

  /// Tambah income baru
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
      await fetchIncomes(); // refresh list setelah tambah
    } catch (e) {
      emit(IncomeError("Failed to add income: $e"));
    }
  }

  /// Update income
  Future<void> updateIncome({
    required int id,
    required int accountId,
    required double amount,
    String? category,
    String? note,
  }) async {
    try {
      await apiService.updateIncome(
        id: id,
        accountId: accountId,
        amount: amount,
        category: category,
        note: note,
      );
      await fetchIncomes(); // refresh list setelah update
    } catch (e) {
      emit(IncomeError("Failed to update income: $e"));
    }
  }

  /// Hapus income
  Future<void> deleteIncome(int id) async {
  try {
    await apiService.deleteIncome(id);
    await fetchIncomes(); // refresh list setelah delete
  } catch (e) {
    emit(IncomeError("Failed to delete income: $e"));
  }
}
}
