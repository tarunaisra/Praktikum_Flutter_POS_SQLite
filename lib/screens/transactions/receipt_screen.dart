import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../db/repository.dart';
import '../../models/txn.dart';  // Asumsi model Txn dan TxnItem ada

class ReceiptScreen extends StatelessWidget {
  final int txnId;

  const ReceiptScreen({super.key, required this.txnId});

  Future<pw.Document> _generatePdf() async {
    final pdf = pw.Document();
    // Ambil data transaksi dari DB
    final txn = await Repo.instance.getTxnById(txnId);  // Asumsi fungsi ini ada di repo
    final items = await Repo.instance.getTxnItems(txnId);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Struk Transaksi ID: ${txn.id}'),
            pw.Text('Tanggal: ${txn.createdAt}'),
            pw.Text('Total: Rp ${txn.total}'),
            pw.SizedBox(height: 20),
            pw.Text('Detail Item:'),
            pw.Table.fromTextArray(
              data: <List<String>>[
                <String>['Nama', 'Qty', 'Harga'],
                ...items.map((item) => [item.name, item.qty.toString(), 'Rp ${item.price}']),
              ],
            ),
          ],
        ),
      ),
    );
    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Struk Transaksi')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final pdf = await _generatePdf();
            await Printing.sharePdf(bytes: await pdf.save(), filename: 'struk_$txnId.pdf');
          },
          child: const Text('Ekspor ke PDF'),
        ),
      ),
    );
  }
}