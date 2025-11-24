import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/book.dart';
import '../models/transaction.dart';
import '../services/local_storage_service.dart';
import '../models/user.dart';

class BorrowFormPage extends StatefulWidget {
  final Book book;
  BorrowFormPage({required this.book});

  @override
  _BorrowFormPageState createState() => _BorrowFormPageState();
}

class _BorrowFormPageState extends State<BorrowFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _daysCtl = TextEditingController(text: '1');
  DateTime _startDate = DateTime.now();
  double total = 0.0;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    _calculate();
    _loadUser();
    _daysCtl.addListener(_calculate);
  }

  void _loadUser() async {
    currentUser = await LocalStorageService.getCurrentUser();
    setState(() {});
  }

  void _calculate([_]) {
    final days = int.tryParse(_daysCtl.text) ?? 0;
    setState(() {
      total = days * widget.book.pricePerDay;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User belum terdeteksi')));
      return;
    }
    final tx = BorrowTransaction(
      id: Uuid().v4(),
      bookId: widget.book.id,
      bookTitle: widget.book.title,
      bookCover: widget.book.cover,
      borrowerName: currentUser!.fullName,
      days: int.parse(_daysCtl.text),
      startDate: DateFormat('yyyy-MM-dd').format(_startDate),
      totalCost: total,
      status: 'active',
    );
    await LocalStorageService.addTransaction(tx);
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    Navigator.pushNamed(context, '/home');
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => FutureBuilder(
      future: Future.delayed(Duration(milliseconds: 100)),
      builder: (_, __) => Container(),
    )));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Peminjaman berhasil disimpan')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form Peminjaman')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ListTile(
                leading: Image.asset(widget.book.cover, width: 60, fit: BoxFit.cover),
                title: Text(widget.book.title),
                subtitle: Text(widget.book.genre),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nama Peminjam'),
                initialValue: currentUser?.fullName ?? '',
                readOnly: true,
              ),
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
                  if (dt != null) {
                    setState(() => _startDate = dt);
                  }
                },
              ),
              SizedBox(height: 12),
              Text('Total biaya: Rp ${total.toStringAsFixed(0)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Konfirmasi Pinjam'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
