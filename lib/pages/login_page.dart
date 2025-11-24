import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import '../models/user.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idCtl = TextEditingController();
  final _pwdCtl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final users = await LocalStorageService.loadUsers();
    final input = _idCtl.text.trim();
    final pwd = _pwdCtl.text.trim();
    final user = users.firstWhere(
      (u) => (u.email == input || u.nim == input) && u.password == pwd,
      orElse: () => null as User,
    );
    if (user == null) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email/nim atau password salah')));
      return;
    }
    await LocalStorageService.setCurrentSession(user.id);
    setState(() => _loading = false);
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
         key: _formKey,
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             TextFormField(
               controller: _idCtl,
               decoration: InputDecoration(labelText: 'Email atau nim'),
               validator: (v) => v==null || v.isEmpty ? 'Wajib diisi' : null,
             ),
             TextFormField(
               controller: _pwdCtl,
               decoration: InputDecoration(labelText: 'Password'),
               obscureText: true,
               validator: (v) => v==null || v.isEmpty ? 'Wajib diisi' : null,
             ),
             SizedBox(height: 20),
             ElevatedButton(
               onPressed: _loading ? null : _login,
               child: _loading ? CircularProgressIndicator(color: Colors.white) : Text('Login'),
             ),
             TextButton(
               onPressed: () => Navigator.pushNamed(context, '/register'),
               child: Text('Belum punya akun? Registrasi'),
             )
           ],
         ),
        ),
      ),
    );
  }
}
