import 'package:chat/component/rounded_button.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
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
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                    hintText: 'Enter your Email',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blueAccent, width: 1),
                      borderRadius: BorderRadius.circular(32),
                    )),
              ),
              const SizedBox(height: 15),
              TextField(
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                    hintText: 'Enter your Password',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blueAccent, width: 1),
                      borderRadius: BorderRadius.circular(32),
                    )),
              ),
              const SizedBox(height: 30),
              RoundedButton(
                title: 'Login',
                color: Colors.lightBlueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true; // Show spinner when login starts
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
                          content:
                              const Text("Email and Password cannot be empty."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Try signing in the user with Firebase if data is valid
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );

                      if (user != null) {
                        Navigator.pushNamed(
                            context,
                            ChatScreen
                                .id); // Navigate to chat screen if login is successful
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                      // Optionally, show a dialog if login fails
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Login Failed"),
                            content: const Text(
                                "Please check your credentials and try again."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
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
        if (showSpinner)
          const Center(
            child: CircularProgressIndicator(), // Display spinner in the center
          ),
      ]),
    );
  }
}
