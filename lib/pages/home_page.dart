import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import '../models/user.dart';
import 'books_page.dart';
import 'history_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? currentUser;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await LocalStorageService.getCurrentUser();
    setState(() {
      currentUser = user;
      loading = false;
    });
  }

  void _logout() async {
    await LocalStorageService.clearSession();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(
        title: Text('Halo, ${currentUser?.fullName ?? 'User'}'),
        actions: [
          IconButton(onPressed: _logout, icon: Icon(Icons.logout)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 3/2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _menuCard(Icons.book, 'Daftar Buku', () => Navigator.push(context, MaterialPageRoute(builder: (_) => BooksPage()))),
            _menuCard(Icons.add_shopping_cart, 'Tambah Pinjam', () => Navigator.push(context, MaterialPageRoute(builder: (_) => BooksPage(openBorrowDirect: true)))),
            _menuCard(Icons.history, 'Riwayat', () => Navigator.push(context, MaterialPageRoute(builder: (_) => HistoryPage()))),
            _menuCard(Icons.person, 'Profil', () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()))),
          ],
        ),
      ),
    );
  }

  Widget _menuCard(IconData icon, String title, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40),
              SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
