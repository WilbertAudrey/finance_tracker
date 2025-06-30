import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'income_state.dart';

class IncomeCubit extends Cubit<IncomeState> {
  IncomeCubit() : super(IncomeInitial());
}
