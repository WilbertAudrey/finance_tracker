import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/account_model.dart';
import '../../data/services/api_service.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final ApiService api;

  AccountCubit(this.api) : super(AccountInitial());

  Future<void> fetchAccounts() async {
    emit(AccountLoading());
    try {
      final accounts = await api.getAccounts();
      emit(AccountLoaded(accounts));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> addAccount(String name, double balance) async {
  try {
    await api.addAccount(name, balance);
    await fetchAccounts(); // refresh data setelah menambahkan akun
  } catch (e) {
    // jangan lempar exception, cukup print dan/atau log
    print("Error saat menambahkan akun: $e");
  }
}

}
