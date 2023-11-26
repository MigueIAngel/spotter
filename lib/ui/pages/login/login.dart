import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:validatorless/validatorless.dart';
import '../../controllers/authentication_controller.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final AuthenticationController authenticationController = Get.find();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String err = "";
  void signIn() async {
    await googleSignIn.signIn();
  }

  void showSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.greenAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          titleTextStyle: const TextStyle(
            color: Colors.green, // Color del texto del título
            fontSize: 22.0, // Tamaño del texto del título
            fontWeight: FontWeight.bold, // Peso del texto del título
          ),
          contentTextStyle: const TextStyle(
            color: Colors.black, // Color del texto del contenido
            fontSize: 18.0, // Tamaño del texto del contenido
          ),
          title: const Text('Éxito!'),
          content: const Text(
            '¡User Registered!',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.green, // Color del texto del botón
                  fontWeight: FontWeight.bold, // Peso del texto del botón
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showInvalidCredentialsDialog(BuildContext context, String e) {
    String msg = "";
    switch (e) {
      case "User not found":
        msg = "User Credentials Error.";
        break;
      case "":
        msg = "Please enter a valid email and password.";
        break;
      case "You have been blocked temporaly by too many requests":
        msg = "You have been blocked temporaly by too many requests";
        break;
      case "The email is taken":
        print("qqad");
        msg = "The email already exits";
        break;
      case "The password is too weak":
        msg = "The password is too weak.";
        break;
      case "Invalid Credentials":
        msg = "User Credentials are invalid";
        break;
      default:
        msg = "Unexpected error. ";
        break;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          titleTextStyle: const TextStyle(
            color: Colors.blue, // Color del texto del título
            fontSize: 22.0, // Tamaño del texto del título
            fontWeight: FontWeight.bold, // Peso del texto del título
          ),
          contentTextStyle: const TextStyle(
            color: Colors.black, // Color del texto del contenido
            fontSize: 18.0, // Tamaño del texto del contenido
          ),
          title: const Text('Oops!'),
          content: Text(
            msg,
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.blue, // Color del texto del botón
                  fontWeight: FontWeight.bold, // Peso del texto del botón
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              const Image(
                image: AssetImage('assets/logoG2.png'),
                width: 200,
                height: 200,
              ),
              // Form
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: Validatorless.multiple([
                          Validatorless.required('Email is required'),
                          Validatorless.email('Invalid email'),
                        ]),
                        controller: emailController,
                        key: const Key('mailField'),
                        decoration: const InputDecoration(
                            labelText: 'Email', prefixIcon: Icon(Icons.email)),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        validator:
                            Validatorless.required("Password is required"),
                        controller: passwordController,
                        key: const Key('passwordField'),
                        decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock)),
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color.fromARGB(255, 77, 77, 160),
                            ),
                            onPressed: () async {
                              try {
                                if (emailController.text.isEmail &&
                                    passwordController.text.isNotEmpty) {
                                  await authenticationController.login(
                                      emailController.text,
                                      passwordController.text);
                                } else {
                                  showInvalidCredentialsDialog(context, err);
                                }
                              } catch (error) {
                                authenticationController.errorMessage.value =
                                    error.toString();
                                if (authenticationController
                                    .errorMessage.value.isNotEmpty) {
                                  // ignore: use_build_context_synchronously
                                  showInvalidCredentialsDialog(
                                      context,
                                      authenticationController
                                          .errorMessage.value);
                                }
                              }
                            },
                            child: const Text('Login'),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                if (emailController.text.isEmail &&
                                    passwordController.text.isNotEmpty) {
                                  await authenticationController.signup(
                                      emailController.text,
                                      passwordController.text);
                                } else {
                                  showInvalidCredentialsDialog(context, err);
                                }
                              } catch (error) {
                                authenticationController.errorSign.value =
                                    error.toString();
                                if (authenticationController
                                    .errorSign.value.isNotEmpty) {
                                  // ignore: use_build_context_synchronously
                                  showInvalidCredentialsDialog(context,
                                      authenticationController.errorSign.value);
                                } else {
                                  // ignore: use_build_context_synchronously
                                  showSuccess(context);
                                }
                              }
                            },
                            child: const Text("Register"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
