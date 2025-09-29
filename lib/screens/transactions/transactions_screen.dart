import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../db/repository.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Map<String, dynamic>> _dailyTotals = [];

  @override
  void initState() {
    super.initState();
    _loadDailyTotals();
  }

  Future<void> _loadDailyTotals() async {
    final totals = await Repo.instance.getDailyTotals();
    setState(() {
      _dailyTotals = totals;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi')),
      body: ListView.builder(
        itemCount: _dailyTotals.length,
        itemBuilder: (context, index) {
          final item = _dailyTotals[index];
          final date = DateTime.parse(item['date']);
          final formattedDate = DateFormat('dd MMM yyyy').format(date);
          return ListTile(
            title: Text(formattedDate),
            trailing: Text('Total: Rp ${item['daily_total']}'),
          );
        },
      ),
    );
  }
}