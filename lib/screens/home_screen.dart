import 'package:flutter/material.dart';
import 'package:login_pro/auth_service/auth_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<Map<String, dynamic>?>(
                future: authService.getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    final userData = snapshot.data!;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Welcome ${userData['name']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue
                          ),
                        ),
                        const Text('Profile info',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text('Name: ${userData['name']}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text('Email: ${userData['email']}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text('Phone: ${userData['phone']}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  }
                  return const Text('No user data available');
                }),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: () => _confirmSignOut(context, authService),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('LogOut', style: TextStyle(color: Colors.white),),
                          Icon(Icons.login_rounded, color: Colors.white,)
                        ],
                      )
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: () => _confirmDeleteAccount(context, authService),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Delete Account', style: TextStyle(color: Colors.white),),
                          Icon(Icons.delete_outline_rounded, color: Colors.red,)
                        ],
                      )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(
      BuildContext context, AuthService authService) async {
    final bool shouldSignOut = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Confirm SignOut!'),
              content: const Text('Are you sure you want to signout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('SignOUt'))
              ],
            ));
    if (shouldSignOut) {
      await authService.signOut();
    }
  }



  Future<void> _confirmDeleteAccount(
      BuildContext context, AuthService authService) async {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    final bool shouldDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Account Deletion'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please confirm your credentials to delete your account.'),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false, // Prevents dismissing dialog while loading
        builder: (context) => const Dialog(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Deleting Account..."),
              ],
            ),
          ),
        ),
      );

      final String? error = await authService.deleteAccount(
        emailController.text,
        passwordController.text,
      );

      // Dismiss the loading dialog
      Navigator.of(context).pop();

      // Show a SnackBar with the result
      if (error != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account successfully deleted.')),
        );
      }
    }
  }

}
