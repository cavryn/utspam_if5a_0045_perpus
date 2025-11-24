import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../services/local_storage_service.dart';

class EditBorrowPage extends StatefulWidget {
  final BorrowTransaction tx;
  EditBorrowPage({required this.tx});

  @override
  _EditBorrowPageState createState() => _EditBorrowPageState();
}

class _EditBorrowPageState extends State<EditBorrowPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _daysCtl;
  late DateTime _startDate;
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    _daysCtl = TextEditingController(text: widget.tx.days.toString());
    _startDate = DateFormat('yyyy-MM-dd').parse(widget.tx.startDate);
    _calculate();
    _daysCtl.addListener(_calculate);
  }

  void _calculate([_]) {
    final days = int.tryParse(_daysCtl.text) ?? 0;
    setState(() {
      double pricePerDay = widget.tx.totalCost / (widget.tx.days == 0 ? 1 : widget.tx.days);
      total = days * pricePerDay;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final newTx = BorrowTransaction(
      id: widget.tx.id,
      bookId: widget.tx.bookId,
      bookTitle: widget.tx.bookTitle,
      bookCover: widget.tx.bookCover,
      borrowerName: widget.tx.borrowerName,
      days: int.parse(_daysCtl.text),
      startDate: DateFormat('yyyy-MM-dd').format(_startDate),
      totalCost: total,
      status: widget.tx.status,
    );
    await LocalStorageService.updateTransaction(newTx);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Peminjaman')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(widget.tx.bookTitle, style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _daysCtl,
                decoration: InputDecoration(labelText: 'Lama Pinjam (hari)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v==null || v.isEmpty) return 'Wajib diisi';
                  final n = int.tryParse(v);
                  if (n == null || n <= 0) return 'Masukkan angka positif';
                  return null;
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Tanggal Mulai: ${DateFormat('yyyy-MM-dd').format(_startDate)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final dt = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (dt != null) setState(() => _startDate = dt);
                },
              ),
              SizedBox(height: 12),
              Text('Total: Rp ${total.toStringAsFixed(0)}'),
              SizedBox(height: 12),
              ElevatedButton(onPressed: _save, child: Text('Simpan Perubahan')),
            ],
          ),
        ),
      ),
    );
  }
}
