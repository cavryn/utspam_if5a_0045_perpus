import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../services/local_storage_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameCtl = TextEditingController();
  final _nikCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _addressCtl = TextEditingController();
  final _phoneCtl = TextEditingController();
  final _usernameCtl = TextEditingController();
  final _passwordCtl = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final users = await LocalStorageService.loadUsers();
    final emailExists = users.any((u) => u.email == _emailCtl.text.trim());
    final usernameExists = users.any((u) => u.username == _usernameCtl.text.trim());
    if (emailExists || usernameExists) {
      setState(() => _isSubmitting = false);
      final msg = emailExists ? 'Email sudah terdaftar' : 'Username sudah terdaftar';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      return;
    }

    final user = User(
      id: Uuid().v4(),
      fullName: _fullNameCtl.text.trim(),
      nim: _nikCtl.text.trim(),
      email: _emailCtl.text.trim(),
      address: _addressCtl.text.trim(),
      phone: _phoneCtl.text.trim(),
      username: _usernameCtl.text.trim(),
      password: _passwordCtl.text.trim(),
    );

    await LocalStorageService.saveUser(user);

    setState(() => _isSubmitting = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registrasi berhasil')));
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrasi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _fullNameCtl,
                decoration: InputDecoration(labelText: 'Nama Lengkap'),
                validator: (v) => v==null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _nikCtl,
                decoration: InputDecoration(labelText: 'nim'),
                validator: (v) => v==null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _emailCtl,
                decoration: InputDecoration(labelText: 'Email (@gmail.com)'),
                validator: (v) {
                  if (v==null || v.isEmpty) return 'Wajib diisi';
                  final email = v.trim();
                  if (!email.endsWith('@gmail.com')) return 'Gunakan format @gmail.com';
                  return null;
                },
              ),
              TextFormField(
                controller: _addressCtl,
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (v) => v==null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _phoneCtl,
                decoration: InputDecoration(labelText: 'Nomor Telepon'),
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v==null || v.isEmpty) return 'Wajib diisi';
                  if (!RegExp(r'^[0-9]+$').hasMatch(v)) return 'Hanya angka';
                  return null;
                },
              ),
              TextFormField(
                controller: _usernameCtl,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (v) => v==null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _passwordCtl,
                decoration: InputDecoration(labelText: 'Password (min 6)'),
                obscureText: true,
                validator: (v) {
                  if (v==null || v.isEmpty) return 'Wajib diisi';
                  if (v.length < 6) return 'Minimal 6 karakter';
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _register,
                child: _isSubmitting ? CircularProgressIndicator(color: Colors.white) : Text('Register'),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: Text('Sudah punya akun? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
