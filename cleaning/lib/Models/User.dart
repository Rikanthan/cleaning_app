import 'package:firebase_database/firebase_database.dart';
class User {
  final String name;
  final String phoneNumber;
  final String address;
  final String email;
  final String password;

  User({
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.password
  });

  User.fromSnapshot(DataSnapshot snapshot)
      : 
          name = snapshot.child("name").toString(),
          phoneNumber = snapshot.child("phoneNumber").toString(),
          address = snapshot.child("address").toString(),
          email = snapshot.child("email").toString(),
          password = snapshot.child("password").toString();

  Map<String, dynamic> asMap() => {
        'name': name,
        'phoneNumber': phoneNumber,
        'address': address,
        'email': email,
        'password': password
      };
}
