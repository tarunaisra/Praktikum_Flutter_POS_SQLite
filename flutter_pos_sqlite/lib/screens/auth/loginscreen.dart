import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../../db/repository.dart';
import '../menu/menu_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _u = TextEditingController();
  final _p = TextEditingController();

  // fungsi untuk hash password
  String _hashPassword(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }

  Future<void> _login() async {
    final username = _u.text.trim();
    final password = _hashPassword(_p.text.trim()); // password di-hash

    final user = await Repo.instance.login(username, password);
    if (user != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MenuScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username atau password salah")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _u,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _p,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('Login')),
          ],
        ),
      ),
    );
  }
}
