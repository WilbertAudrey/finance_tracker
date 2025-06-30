import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit() : super(ExpenseInitial());
}
