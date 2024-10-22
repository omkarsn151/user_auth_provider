import 'package:flutter/material.dart';
import 'package:login_pro/screens/signup_screen.dart';
import 'package:provider/provider.dart';
import '../auth_service/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  bool _obscureText = true;
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    bool isLoading = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LogIN',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: _emailError,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (_) {
                  setState(() {
                    _emailError = null; // Remove error on input
                  });
                },
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: _passwordError,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                        onPressed: () {
                          _togglePasswordVisibility();
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: Colors.blue.shade200,
                        ))),
                onChanged: (_) {
                  setState(() {
                    _passwordError = null; // Remove error on input
                  });
                },
              ),
              const SizedBox(height: 18),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _emailError = _passwordError = null;
                        });

                        if (_emailController.text.isEmpty) {
                          setState(() {
                            _emailError = 'Email cannot be empty';
                          });
                        }
                        if (_passwordController.text.isEmpty) {
                          setState(() {
                            _passwordError = 'Password cannot be empty';
                          });
                        }
                        if (_emailError == null && _passwordError == null) {
                          setState(() {
                            isLoading = true;
                          });
                          final error = await authService.signIn(
                            _emailController.text,
                            _passwordController.text,
                          );
                          setState(() {
                            isLoading = false;
                          });
                          if (error != null) {
                            setState(() {
                              _emailError = _passwordError =
                                  'Incorrect email or password!';
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        'LogIN',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('New user?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()),
                      );
                    },
                    child: const Text(
                      'Create an account',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
