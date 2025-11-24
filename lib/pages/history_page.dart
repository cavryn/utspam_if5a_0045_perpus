import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import '../models/transaction.dart';
import 'detail_page.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<BorrowTransaction> txs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await LocalStorageService.loadTransactions();
    setState(() {
      txs = list.reversed.toList(); 
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: Text('Riwayat Pinjam')),
      body: txs.isEmpty ? Center(child: Text('Belum ada transaksi')) : ListView.builder(
        itemCount: txs.length,
        itemBuilder: (_, i) {
          final t = txs[i];
          return ListTile(
            leading: Image.asset(t.bookCover, width: 50, fit: BoxFit.cover),
            title: Text(t.bookTitle),
            subtitle: Text('${t.borrowerName} • Rp ${t.totalCost.toStringAsFixed(0)}'),
            trailing: Text(t.status),
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(tx: t)));
              _load(); 
            },
          );
        },
      ),
    );
  }
}
