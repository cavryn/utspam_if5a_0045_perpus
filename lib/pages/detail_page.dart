import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/local_storage_service.dart';
import 'edit_borrow_page.dart';

class DetailPage extends StatefulWidget {
  final BorrowTransaction tx;
  DetailPage({required this.tx});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late BorrowTransaction tx;

  @override
  void initState() {
    super.initState();
    tx = widget.tx;
  }

  Future<void> _cancel() async {
    tx = BorrowTransaction(
      id: tx.id,
      bookId: tx.bookId,
      bookTitle: tx.bookTitle,
      bookCover: tx.bookCover,
      borrowerName: tx.borrowerName,
      days: tx.days,
      startDate: tx.startDate,
      totalCost: tx.totalCost,
      status: 'cancelled',
    );
    await LocalStorageService.updateTransaction(tx);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transaksi dibatalkan')));
  }

  Future<void> _edit() async {
    final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => EditBorrowPage(tx: tx)));
    if (res == true) {
      final fresh = (await LocalStorageService.loadTransactions()).firstWhere((e) => e.id == tx.id);
      setState(() => tx = fresh);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Peminjaman')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Image.asset(tx.bookCover, width: 120, height: 160, fit: BoxFit.cover),
            SizedBox(height: 8),
            Text(tx.bookTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Peminjam: ${tx.borrowerName}'),
            Text('Lama: ${tx.days} hari'),
            Text('Mulai: ${tx.startDate}'),
            Text('Total: Rp ${tx.totalCost.toStringAsFixed(0)}'),
            Text('Status: ${tx.status}'),
            SizedBox(height: 12),
            if (tx.status == 'active') Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _edit, child: Text('Edit')),
                SizedBox(width: 12),
                ElevatedButton(onPressed: _cancel, child: Text('Batalkan'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
