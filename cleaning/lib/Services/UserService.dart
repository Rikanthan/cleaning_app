import 'package:cleaning/Models/User.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:encrypt/encrypt.dart';
import 'package:mongo_dart/mongo_dart.dart';

class UserService {
  DatabaseReference ref = FirebaseDatabase.instance.ref('users');

  Future<void> register(String name, String phoneNumber, String address,
      String email, String password) async {
    final key = Key.fromUtf8('3aed2d6e3a9afdabae9e5b3ce431c23a');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(password, iv: iv);
    //final decrypted = encrypter.decrypt(encrypted, iv: iv);
    await ref.child(Uuid().v1()).set({
      "name": name,
      "phoneNumber": phoneNumber,
      "address": address,
      "email": email,
      "password": encrypted.base64
    });
  }

  Future<void> login(String email, String password) async {
    final snapshot = await ref.get();
   if(snapshot.exists){
    print(snapshot.children);
   }
  }
}
