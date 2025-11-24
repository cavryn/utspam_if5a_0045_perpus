import 'dart:convert';

class Book {
  String id;
  String title;
  String genre;
  double pricePerDay;
  String cover;
  String synopsis;

  Book({
    required this.id,
    required this.title,
    required this.genre,
    required this.pricePerDay,
    required this.cover,
    required this.synopsis,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'genre': genre,
    'pricePerDay': pricePerDay,
    'cover': cover,
    'synopsis': synopsis,
  };

  factory Book.fromMap(Map<String, dynamic> m) => Book(
    id: m['id'],
    title: m['title'],
    genre: m['genre'],
    pricePerDay: (m['pricePerDay'] as num).toDouble(),
    cover: m['cover'],
    synopsis: m['synopsis'],
  );

  String toJson() => json.encode(toMap());
  factory Book.fromJson(String s) => Book.fromMap(json.decode(s));
}
