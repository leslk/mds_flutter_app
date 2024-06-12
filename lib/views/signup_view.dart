import 'package:flutter/material.dart';
import 'package:mds_flutter_app/common/button.dart';
import 'package:mds_flutter_app/common/input.dart';
import 'package:mds_flutter_app/common/main_title.dart';
import 'package:mds_flutter_app/models/user.dart';
import 'package:mds_flutter_app/views/login_checker_view.dart';

/// The view for the signup page
/// The user can signup with his pseudo, name, firstname, email and password
class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  late TextEditingController _pseudoController;
  late TextEditingController _nameController;
  late TextEditingController _firstNameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _emailController;
  String _signupErrorMesssage = "";

  @override
  void initState() {
    super.initState();
    _pseudoController = TextEditingController();
    _nameController = TextEditingController();
    _firstNameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _pseudoController.dispose();
    _nameController.dispose();
    _firstNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    try {
      await User.signup(
        _pseudoController.text,
        _nameController.text,
        _firstNameController.text,
        _emailController.text,
        _passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Inscription réussie", style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
        backgroundColor: Colors.green,
      ));
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginCheckerView()));
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
