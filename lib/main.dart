import 'package:finance_tracker_app/cubit/account/account_cubit.dart';
import 'package:finance_tracker_app/data/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/pages/dashboard_page.dart';
import 'presentation/pages/account_page.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => AccountCubit(ApiService())..fetchAccounts(),
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