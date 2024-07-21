import 'package:flutter/material.dart';
import 'package:todo/screens/authform.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Authentication"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: const Authform(),
    );
  }
}
