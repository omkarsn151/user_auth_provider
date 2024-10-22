import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_pro/auth_service/auth_service.dart';
import 'package:login_pro/screens/home_screen.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emailcontrolleer = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmPasswordError;

  bool _validateFields() {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    bool isValid = true;

    if(_namecontroller.text.isEmpty){
      _nameError = 'Name cannot be empty';
      isValid = false;
    }

    if(_emailcontrolleer.text.isEmpty){
      _emailError = 'Email cannot be empty';
      isValid = false;
    }
    else if(!_emailcontrolleer.text.contains('@')){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid email!')));
      _emailError = 'Invalid email';
      isValid = false;
    }

    if(_phoneController.text.isEmpty){
      _phoneError = 'Phone number cannot be empty';
      isValid = false;
    } else if(_phoneController.text.length != 10){
      _phoneError = 'Please enter a valid phone number';
      isValid = false;
    }

    if(_passwordController.text.isEmpty){
      _passwordError = 'Please set a password';
      isValid = false;
    } else if(_passwordController.text.length < 6 ){
      _passwordError = 'Password must be minimum of 6 characters';
      isValid = false;
    } else if(_passwordController.text.length >= 12 ){
      _passwordError = 'Password must be maximum of 12 characters';
      isValid = false;
    }

    if(_confirmpasswordController.text.isEmpty){
      _confirmPasswordError = 'Re-enter the password to confirm';
      isValid = false;
    } else if(_confirmpasswordController.text != _passwordController.text){
      _confirmPasswordError = 'Passwords donot match';
      isValid = false;
    }
    return isValid;
  }

  bool _obscureText = true;
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SignUP',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: _namecontroller,
                  decoration: InputDecoration(
                      labelText: 'Name',
                    border: const OutlineInputBorder(),
                    errorText: _nameError,
                  ),
                  onChanged: (_){
                    setState(() {
                      _nameError = null;
                    });
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: _emailcontrolleer,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      border: const OutlineInputBorder(),
                    errorText: _emailError,
                  ),
                  onChanged: (_){
                    setState(() {
                      _emailError = null;
                    });
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: _phoneController,
        
                  decoration: InputDecoration(
                      labelText: 'Phone',
                      border: const OutlineInputBorder(),
                    errorText: _phoneError
                  ),
                  onChanged: (_){
                    setState(() {
                      _phoneError = null;
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
                      border: const OutlineInputBorder(),
                      errorText: _passwordError,
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
                  onChanged: (_){
                    setState(() {
                      _phoneError = null;
                    });
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: _confirmpasswordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                      labelText: 'Confirm password',
                      border: const OutlineInputBorder(),
                      errorText: _confirmPasswordError,
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
                  onChanged: (_){
                    setState(() {
                      _confirmPasswordError = null;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
        
                ElevatedButton(
                  onPressed: () async {
                    if(_validateFields()){
                      final error = await authService.signUp(
                          _emailcontrolleer.text,
                          _passwordController.text,
                          _namecontroller.text,
                          _phoneController.text);
                      // Navigator.pop(context);
                      if (error != null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(error)));
                      } else{
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => const HomeScreen())
                        // );
                      }
                      Navigator.pop(context);
                    }
        
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text(
                    'Create account',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Go back to Login',
                          style: TextStyle(color: Colors.blue),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
