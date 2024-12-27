import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {}, child: const Text("SignUp/Login ")),
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password",
                      style: TextStyle(color: Colors.white),
                    )),
                const SizedBox(height: 20),
              ],
            ),
            ElevatedButton.icon(
                onPressed: () {},
                label: const Text("SignUp/Login with Google")),
          ],
        ),
      ),
    );
  }
}
