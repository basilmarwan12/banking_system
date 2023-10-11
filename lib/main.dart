import 'package:banking_system/database/database_helper.dart';
import 'package:banking_system/views/all_customers_view.dart';
import 'package:banking_system/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = DatabaseHelper();
  await database.initSqlite();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const HomeView(),
      debugShowCheckedModeBanner: false,
      routes: {
        "Customers": (context) => const AllCustomers(),
      },
    );
  }
}
