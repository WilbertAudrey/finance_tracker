import 'package:equatable/equatable.dart';
import '../../data/models/income_model.dart';

abstract class IncomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class IncomeInitial extends IncomeState {}

class IncomeLoading extends IncomeState {}

class IncomeLoaded extends IncomeState {
  final List<Income> incomes;

  IncomeLoaded(this.incomes);

  @override
  List<Object?> get props => [incomes];
}

class IncomeError extends IncomeState {
  final String message;

  IncomeError(this.message);

  @override
  List<Object?> get props => [message];
}
