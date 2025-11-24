import 'dart:convert';

class BorrowTransaction {
  String id;
  String bookId;
  String bookTitle;
  String bookCover;
  String borrowerName;
  int days;
  String startDate;
  double totalCost;
  String status;

  BorrowTransaction({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.bookCover,
    required this.borrowerName,
    required this.days,
    required this.startDate,
    required this.totalCost,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'bookId': bookId,
    'bookTitle': bookTitle,
    'bookCover': bookCover,
    'borrowerName': borrowerName,
    'days': days,
    'startDate': startDate,
    'totalCost': totalCost,
    'status': status,
  };

  factory BorrowTransaction.fromMap(Map<String, dynamic> m) => BorrowTransaction(
    id: m['id'],
    bookId: m['bookId'],
    bookTitle: m['bookTitle'],
    bookCover: m['bookCover'],
    borrowerName: m['borrowerName'],
    days: m['days'],
    startDate: m['startDate'],
    totalCost: (m['totalCost'] as num).toDouble(),
    status: m['status'],
  );

  String toJson() => json.encode(toMap());
  factory BorrowTransaction.fromJson(String s) => BorrowTransaction.fromMap(json.decode(s));
}
