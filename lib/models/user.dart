import 'dart:convert';

class User {
  String id;
  String fullName;
  String nim;
  String email;
  String address;
  String phone;
  String username;
  String password;

  User({
    required this.id,
    required this.fullName,
    required this.nim,
    required this.email,
    required this.address,
    required this.phone,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'nim': nim,
      'email': email,
      'address': address,
      'phone': phone,
      'username': username,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fullName: map['fullName'],
      nim: map['nim'],
      email: map['email'],
      address: map['address'],
      phone: map['phone'],
      username: map['username'],
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());
  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
