import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../cubit/account/account_cubit.dart';
import '../../data/services/api_service.dart';
import 'account_page.dart';
import 'add_account_dialog.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isExpanded = false;

  void _toggleFab() {
    setState(() => _isExpanded = !_isExpanded);
  }

  void _onAddIncome() {
    print("Add Income");
  }

  void _onAddExpense() {
    print("Add Expense");
  }

  void _onAddAccount() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AddAccountDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Finance Dashboard'), backgroundColor: const Color.fromARGB(255, 210, 210, 211),),
      body: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          if (state is AccountLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AccountLoaded) {
            final showMoreButton = state.accounts.length > 4;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.grey[50],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'My Accounts',
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (showMoreButton)
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AccountPage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.more_horiz, size: 16),
                              label: const Text("More"),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.accounts.length > 4 ? 4 : state.accounts.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 5.8,
                        ),
                        itemBuilder: (context, index) {
                          final acc = state.accounts[index];
                          final color = Colors.primaries[index % Colors.primaries.length].shade100;
                          final iconBg = Colors.primaries[index % Colors.primaries.length].shade400;

                          return Container(
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 2,
                                  offset: const Offset(1, 1),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: iconBg,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.account_balance_wallet_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        acc.name,
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        currencyFormatter.format(acc.balance),
                                        style: GoogleFonts.poppins(
                                          fontSize: 9,
                                          color: Colors.green[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is AccountError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isExpanded) ...[
            FloatingActionButton.small(
              heroTag: 'add-income',
              onPressed: _onAddIncome,
              backgroundColor: Colors.green,
              child: const Icon(Icons.add_circle),
              tooltip: 'Add Income',
            ),
            const SizedBox(height: 10),
            FloatingActionButton.small(
              heroTag: 'add-expense',
              onPressed: _onAddExpense,
              backgroundColor: Colors.red,
              child: const Icon(Icons.remove_circle),
              tooltip: 'Add Expense',
            ),
            const SizedBox(height: 10),
            FloatingActionButton.small(
              heroTag: 'add-account',
              onPressed: _onAddAccount,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.account_balance),
              tooltip: 'Add Account',
            ),
            const SizedBox(height: 10),
          ],
          FloatingActionButton(
            onPressed: _toggleFab,
            backgroundColor: Colors.black87,
            child: Icon(_isExpanded ? Icons.close : Icons.menu),
            tooltip: 'Menu',
          ),
        ],
      ),
    );
  }
}