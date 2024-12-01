import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notion_test/presentation/auth/screen/sign_in.dart';
import 'package:notion_test/presentation/home/screen/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Smth went wrong'),
            );
          } else {
            if (snapshot.data == null) {
              return const SignInScreen();
            } else {
              return const HomeScreen();
            }
          }
        },
      ),
    );
  }
}
