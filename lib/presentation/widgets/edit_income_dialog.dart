import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_tracker_app/data/models/income_model.dart';
import 'package:finance_tracker_app/cubit/account/account_cubit.dart';
import 'package:finance_tracker_app/cubit/income/income_cubit.dart';

class EditIncomeDialog extends StatefulWidget {
  final Income income;

  const EditIncomeDialog({super.key, required this.income});

  @override
  State<EditIncomeDialog> createState() => _EditIncomeDialogState();
}

class _EditIncomeDialogState extends State<EditIncomeDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _categoryController;
  late TextEditingController _noteController;
  int? _selectedAccountId;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.income.amount.toStringAsFixed(0));
    _categoryController = TextEditingController(text: widget.income.category ?? '');
    _noteController = TextEditingController(text: widget.income.note ?? '');
    _selectedAccountId = widget.income.accountId;

    context.read<AccountCubit>().fetchAccounts();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _categoryController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Edit Income", style: TextStyle(fontWeight: FontWeight.bold)),
      content: Form(
        key: _formKey,
        child: BlocBuilder<AccountCubit, AccountState>(
          builder: (context, state) {
            if (state is AccountLoading) {
              return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
            }

            if (state is AccountLoaded) {
              final accounts = state.accounts;

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<int>(
                      value: _selectedAccountId,
                      decoration: const InputDecoration(
                        labelText: "Account",
                        prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                      ),
                      items: accounts.map((acc) {
                        return DropdownMenuItem<int>(
                          value: acc.id,
                          child: Text(acc.name),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedAccountId = val),
                      validator: (val) => val == null ? 'Pilih akun' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: "Amount",
                        prefixText: "Rp ",
                        prefixIcon: Icon(Icons.money),
                      ),
                      validator: (val) => (val == null || val.isEmpty) ? "Masukkan jumlah" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        labelText: "Category",
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        labelText: "Note",
                        prefixIcon: Icon(Icons.note_alt_outlined),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Text("Gagal memuat akun");
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final amount = double.tryParse(_amountController.text) ?? 0;
              final cubit = context.read<IncomeCubit>();

              await cubit.updateIncome(
                id: widget.income.id,
                accountId: _selectedAccountId!,
                amount: amount,
                category: _categoryController.text,
                note: _noteController.text,
              );

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Income berhasil diperbarui"),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            }
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}
