import 'package:chat/component/rounded_button.dart';
import 'package:chat/constants.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  static const String id = 'registration';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200,
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your Email'),
                ),
                const SizedBox(height: 20),
                TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your Password'),
                ),
                const SizedBox(height: 30),
                RoundedButton(
                  title: 'Register',
                  color: Colors.lightBlueAccent,
                  onPressed: () async {
                    setState(() {
                      showSpinner =
                          true; // Show spinner when registration starts
                    });

                    // Simulate a loading time
                    await Future.delayed(const Duration(seconds: 2));

                    if (email.isEmpty || password.isEmpty) {
                      // Show a dialog box if any field is empty
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Input Error"),
                            content: const Text(
                                "Email and Password cannot be empty."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // Try registering the user with Firebase if data is valid
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);

                        if (newUser != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                      } catch (e) {
                        debugPrint(e.toString());
                        // Optionally, you can show another dialog if the registration fails
                      }
                    }

                    setState(() {
                      showSpinner = false; // Hide the spinner after processing
                    });
                  },
                ),
              ],
            ),
          ),
          // Show CircularProgressIndicator while showSpinner is true
          if (showSpinner)
            Center(
              child:
                  CircularProgressIndicator(), // Display spinner in the center
            ),
        ],
      ),
    );
  }
}
