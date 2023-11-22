import 'package:f_firebase_202210/ui/controllers/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  final databaseRef = FirebaseDatabase.instance.ref();
  var errorMessage = RxString('');
  var errorSign = RxString('');
  Future<void> login(email, password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Limpiar el mensaje de error si el inicio de sesión es exitoso
      errorMessage.value = '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage.value = 'User not found';
        throw errorMessage.value; // Lanzar la excepción
      } else if (e.code == 'wrong-password') {
        errorMessage.value = 'Wrong password';
        throw errorMessage.value; // Lanzar la excepción
      } else if (e.code == 'invalid-credential') {
        errorMessage.value = "Invalid Credentials";
        throw errorMessage.value;
      } else if (e.code == "too-many-requests") {
        errorMessage.value =
            "You have been blocked temporaly by too many requests";
      } else {
        print(e.code);
      }
    }
  }

  Future<void> signup(email, password) async {
    try {
      UserCredential uc = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      UserController userController = Get.find();
      await userController.createUser(email, uc.user!.uid);
      errorSign.value = "";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorSign.value = "The password is too weak";
        throw errorSign.value;
      } else if (e.code == 'email-already-in-use') {
        errorSign.value = "The email is taken";

        throw errorSign.value;
      } else {
        print(e.code);
      }
    }
  }

  logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      return Future.error("Logout error");
    }
  }

  String userEmail() {
    String email = FirebaseAuth.instance.currentUser!.email ?? "a@a.com";
    email = email.split('@')[0];
    return email;
  }

  String getUid() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return uid;
  }
}
