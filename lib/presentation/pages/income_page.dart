import 'package:finance_tracker_app/presentation/widgets/add_income_dialog.dart';
import 'package:finance_tracker_app/presentation/widgets/edit_income_dialog.dart';
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
      appBar: AppBar(
        title: const Text('Income List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Tambah Income',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const AddIncomeDialog(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<IncomeCubit, IncomeState>(
        builder: (context, state) {
          final rootContext = context; // Untuk snackbar

          if (state is IncomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is IncomeLoaded) {
            final incomes = [...state.incomes]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

            if (incomes.isEmpty) {
              return const Center(child: Text('Belum ada data income.'));
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: incomes.length,
              separatorBuilder: (_, __) => const Divider(thickness: 1),
              itemBuilder: (context, index) {
                final income = incomes[index];
                final dateFormatted = DateFormat('dd MMM yyyy').format(income.createdAt);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}.',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              income.accountName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              dateFormatted,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Text("Kategori: ",
                                    style: TextStyle(fontWeight: FontWeight.w500)),
                                Flexible(
                                  child: Text(income.category ?? '-',
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Catatan: ",
                                    style: TextStyle(fontWeight: FontWeight.w500)),
                                Flexible(
                                  child: Text(income.note ?? '-',
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            currencyFormatter.format(income.amount),
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => EditIncomeDialog(income: income),
                                  );
                                },
                                icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                                tooltip: 'Edit',
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text("Konfirmasi Hapus"),
                                      content: const Text("Apakah Anda yakin ingin menghapus income ini?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(ctx).pop(),
                                          child: const Text("Batal"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.of(ctx).pop();
                                            await rootContext.read<IncomeCubit>().deleteIncome(income.id);
                                            if (rootContext.mounted) {
                                              ScaffoldMessenger.of(rootContext).showSnackBar(
                                                const SnackBar(
                                                  content: Text("Income berhasil dihapus"),
                                                  behavior: SnackBarBehavior.floating,
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                tooltip: 'Hapus',
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          } else if (state is IncomeError) {
            return Center(
              child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.red)),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
