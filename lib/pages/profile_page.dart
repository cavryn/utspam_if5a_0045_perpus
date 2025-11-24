import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import '../models/user.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    user = await LocalStorageService.getCurrentUser();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: Text('Profil')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${user?.fullName ?? ""}'),
            Text('nim: ${user?.nim ?? ""}'),
            Text('Email: ${user?.email ?? ""}'),
            Text('Alamat: ${user?.address ?? ""}'),
            Text('Telp: ${user?.phone ?? ""}'),
            Text('Username: ${user?.username ?? ""}'),
          ],
        ),
      ),
    );
  }
}