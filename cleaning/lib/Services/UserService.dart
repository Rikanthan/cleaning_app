import 'package:firebase_database/firebase_database.dart';
import 'package:encrypt/encrypt.dart';

class UserService {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<void> register(String name, String phoneNumber, String address,
      String email, String password) async {
    final key = Key.fromSecureRandom(32);
  final iv = IV.fromSecureRandom(16);
  final encrypter = Encrypter(AES(key));

  final encrypted = encrypter.encrypt(password, iv: iv);
    await ref.set({
      "name": name,
      "phoneNumber": phoneNumber,
      "address": address,
      "email": email,
      "password": encrypted.base16
    });
  }
}
