import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pdftool/utilities/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPwd = '';

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final userCred = await _authService.signInWithGoogle();
      if (!context.mounted) {
        return;
      }

      if (userCred == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Google Sign In cancelled')));
      }
    } catch (err) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to Sign In')));
    }
  }

  void authenticate() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    try {
      if (_isLogin) {
        await _authService.signInWithEmail(_enteredEmail, _enteredPwd);
      } else {
        await _authService.signUpWithEmail(_enteredEmail, _enteredPwd);
      }
    } on FirebaseAuthException catch (err) {
      if (mounted) {
        String message = 'Authentication failed';

        switch (err.code) {
          case 'invalid-credential':
            message = 'Invalid e-mail or password';
            break;
          case 'user-not-found':
            message = 'No user found with this email address.';
            break;
          case 'wrong-password':
            message = 'Invalid password.';
            break;
          case 'email-already-in-use':
            message = 'This email is already registered.';
            break;
          case 'invalid-email':
            message = 'Please enter a valid email address.';
            break;
          default:
            message = err.message ?? 'Authentication failed';
        }
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter a valid email id';
                        }
                        return null;
                      },
                      onSaved: (value) => _enteredEmail = value!,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      autocorrect: false,
                      obscureText: true,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            value.trim().length < 6) {
                          return 'Password should be of minimum 6 characters';
                        }
                        return null;
                      },
                      onSaved: (value) => _enteredPwd = value!,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 75,
                    child: TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.green),
                            foregroundColor:
                                WidgetStatePropertyAll(Colors.white)),
                        onPressed: () {
                          authenticate();
                        },
                        child: Text(_isLogin ? 'Login' : 'SignUp')),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        _signInWithGoogle(context);
                      },
                      icon: Image.asset(
                        "lib/assets/google_logo.jpeg",
                        width: 20,
                        height: 20,
                      ),
                      label: Text(_isLogin
                          ? 'Login with Google'
                          : 'Sign Up with Google')),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create an account'
                          : 'I already have an account')),
                ],
              )),
        ),
      ),
    );
  }
}
