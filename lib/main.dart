import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_tracker_app/cubit/account/account_cubit.dart';
import 'package:finance_tracker_app/cubit/income/income_cubit.dart';
import 'package:finance_tracker_app/data/services/api_service.dart';
import 'package:finance_tracker_app/presentation/pages/dashboard_page.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AccountCubit(ApiService())..fetchAccounts()),
        BlocProvider(create: (_) => IncomeCubit(ApiService())..fetchRecentIncome()), // pastikan method ini ada
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        cardTheme: const CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
      ),
      home: const DashboardPage(),
    );
  }
}
