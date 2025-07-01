import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../cubit/income/income_cubit.dart';
import '../../cubit/income/income_state.dart';

class IncomePage extends StatelessWidget {
  const IncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Income List')),
      body: BlocBuilder<IncomeCubit, IncomeState>(
        builder: (context, state) {
          if (state is IncomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is IncomeLoaded) {
            final incomes = [...state.incomes];

            if (incomes.isEmpty) {
              return const Center(child: Text('Belum ada data income.'));
            }

            // Sort berdasarkan createdAt descending
            incomes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: incomes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final income = incomes[index];
                final dateFormatted = DateFormat('dd MMM yyyy').format(income.createdAt);

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.attach_money, color: Colors.green),
                    title: Text(
                      income.accountName ?? 'Unknown Account',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kategori: ${income.category ?? "-"}'),
                        Text('Catatan: ${income.note ?? "-"}'),
                        Text(
                          dateFormatted,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Text(
                      currencyFormatter.format(income.amount),
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is IncomeError) {
            return Center(
              child: Text('Error: ${state.message}',
                  style: const TextStyle(color: Colors.red)),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
