import 'auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fintrack/app_routes.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.welcome,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                SizedBox(height: 32.0),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.email,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.email_required;
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return AppLocalizations.of(context)!.email_invalid;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.password,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.password_required;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      String email = emailController.text;
                      String password = passwordController.text;
                      try {
                        User? user = await _authService
                            .signInWithEmailAndPassword(email, password);
                        if (user != null) {
                          // ignore: use_build_context_synchronously
                          context.go(AppRoutes.dashboard);
                        }
                      } catch (e) {
                        scaffoldMessenger.showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 5,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.login,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    context.go(AppRoutes.register);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.register,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
