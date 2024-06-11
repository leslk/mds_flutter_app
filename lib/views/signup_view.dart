import 'package:flutter/material.dart';
import 'package:mds_flutter_app/common/button.dart';
import 'package:mds_flutter_app/common/input.dart';
import 'package:mds_flutter_app/common/main_title.dart';
import 'package:mds_flutter_app/models/user.dart';

/// The view for the signup page
/// The user can signup with his pseudo, name, firstname, email and password
class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController _pseudoController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _signupErrorMesssage = "";

  Future<void> _signup() async {
    try {
      await User.signup(
        _pseudoController.text,
        _nameController.text,
        _firstNameController.text,
        _emailController.text,
        _passwordController.text,
      );
    } catch (e) {
      setState(() {
        _signupErrorMesssage = e.toString().split("Exception: ")[1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MainTitle(text: "Inscription"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  Input(
                    controller: _pseudoController,
                    hintText: "Pseudo",
                    isPassword: false,
                  ),
                  const SizedBox(height: 16),
                  Input(
                    controller: _nameController,
                    hintText: "Nom",
                    isPassword: false,
                  ),
                  const SizedBox(height: 16),
                  Input(
                    controller: _firstNameController,
                    hintText: "Prénom",
                    isPassword: false,
                  ),
                  const SizedBox(height: 16),
                  Input(
                    controller: _emailController,
                    hintText: "Email",
                    isPassword: false,
                  ),
                  const SizedBox(height: 16),
                  Input(
                    controller: _passwordController,
                    hintText: "Mot de passe",
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),
                  Input(
                    controller: _confirmPasswordController,
                    hintText: "Confirmer le mot de passe",
                    isPassword: true,
                    onChanged: (String value) {
                      if (_passwordController.text != value) {
                        setState(() {
                          _signupErrorMesssage = "Les mots de passe ne correspondent pas";
                        });
                      } else {
                        setState(() {
                          _signupErrorMesssage = "";
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Button(
                    text: "S'inscrire",
                    onPressed: () async {
                      await _signup();
                    },
                  ),
                  const SizedBox(height: 10),
                  _signupErrorMesssage.isNotEmpty ? Text(_signupErrorMesssage, style: const TextStyle(color: Colors.red)) : Container(),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text("Se Connecter", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
