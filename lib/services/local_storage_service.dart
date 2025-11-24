import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/book.dart';
import '../models/transaction.dart';

class LocalStorageService {
  static const _usersKey = 'users';
  static const _booksKey = 'books';
  static const _transactionsKey = 'transactions';
  static const _sessionKey = 'current_session_user_id';

  static Future<List<User>> loadUsers() async {
    final p = await SharedPreferences.getInstance();
    final s = p.getStringList(_usersKey) ?? [];
    return s.map((e) => User.fromJson(e)).toList();
  }

  static Future<void> saveUser(User user) async {
    final p = await SharedPreferences.getInstance();
    final list = p.getStringList(_usersKey) ?? [];
    final idx = list.indexWhere((e) => User.fromJson(e).id == user.id);
    if (idx >= 0) {
      list[idx] = user.toJson();
    } else {
      list.add(user.toJson());
    }
    await p.setStringList(_usersKey, list);
  }

  static Future<void> saveUsersList(List<User> users) async {
    final p = await SharedPreferences.getInstance();
    await p.setStringList(_usersKey, users.map((u) => u.toJson()).toList());
  }

  static Future<List<Book>> loadBooks() async {
    final p = await SharedPreferences.getInstance();
    final s = p.getStringList(_booksKey);
    if (s == null || s.isEmpty) {
      final defaultBooks = [
        Book(
          id: 'b1',
          title: 'Flutter and Dart Cookbook',
          genre: 'Teknologi',
          pricePerDay: 5000,
          cover: 'assets/images/cover1.jpg',
          synopsis: 'Panduan dasar hingga mahir Flutter.',
        ),
        Book(
          id: 'b2',
          title: 'Teknologi Untuk Masa Depan',
          genre: 'Teknologi',
          pricePerDay: 7000,
          cover: 'assets/images/cover2.jpg',
          synopsis: 'Buku yang menunjukkan potensi perkembangan teknologi di masa depan.',
        ),
        Book(
          id: 'b3',
          title: 'Trio Detektif',
          genre: 'Fiksi',
          pricePerDay: 4000,
          cover: 'assets/images/cover3.jpg',
          synopsis: 'Kisah petualangan seru.',
        ),
      ];
      await p.setStringList(_booksKey, defaultBooks.map((b) => b.toJson()).toList());
      return defaultBooks;
    } else {
      return s.map((e) => Book.fromJson(e)).toList();
    }
  }

  static Future<void> saveBooks(List<Book> books) async {
    final p = await SharedPreferences.getInstance();
    await p.setStringList(_booksKey, books.map((b) => b.toJson()).toList());
  }

  static Future<List<BorrowTransaction>> loadTransactions() async {
    final p = await SharedPreferences.getInstance();
    final s = p.getStringList(_transactionsKey) ?? [];
    return s.map((e) => BorrowTransaction.fromJson(e)).toList();
  }

  static Future<void> saveTransactions(List<BorrowTransaction> txs) async {
    final p = await SharedPreferences.getInstance();
    await p.setStringList(_transactionsKey, txs.map((t) => t.toJson()).toList());
  }

  static Future<void> addTransaction(BorrowTransaction tx) async {
    final list = await loadTransactions();
    list.add(tx);
    await saveTransactions(list);
  }

  static Future<void> updateTransaction(BorrowTransaction tx) async {
    final list = await loadTransactions();
    final idx = list.indexWhere((t) => t.id == tx.id);
    if (idx >= 0) {
      list[idx] = tx;
      await saveTransactions(list);
    }
  }

  static Future<void> setCurrentSession(String userId) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_sessionKey, userId);
  }

  static Future<void> clearSession() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_sessionKey);
  }

  static Future<User?> getCurrentUser() async {
    final p = await SharedPreferences.getInstance();
    final id = p.getString(_sessionKey);
    if (id == null) return null;
    final users = await loadUsers();
    return users.firstWhere((u) => u.id == id, orElse: () => null as User);
  }
}
