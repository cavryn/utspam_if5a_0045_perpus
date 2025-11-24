import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/local_storage_service.dart';
import 'borrow_form_page.dart';

class BooksPage extends StatefulWidget {
  final bool openBorrowDirect;
  BooksPage({this.openBorrowDirect = false});

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  List<Book> books = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final b = await LocalStorageService.loadBooks();
    setState(() {
      books = b;
      loading = false;
    });
    if (widget.openBorrowDirect && books.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => BorrowFormPage(book: books[0])));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Buku')),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: books.length,
        itemBuilder: (_, i) {
          final book = books[i];
          return Card(
            child: ListTile(
              leading: SizedBox(width: 50, child: Image.asset(book.cover, fit: BoxFit.cover)),
              title: Text(book.title),
              subtitle: Text('${book.genre} • Rp ${book.pricePerDay.toStringAsFixed(0)}/hari'),
              trailing: ElevatedButton(
                child: Text('Pinjam'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => BorrowFormPage(book: book)));
                },
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => BorrowFormPage(book: book)));
              },
            ),
          );
        },
      ),
    );
  }
}
