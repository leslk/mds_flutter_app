import 'package:flutter/material.dart';
import 'package:mds_flutter_app/common/button.dart';
import 'package:mds_flutter_app/common/input.dart';
import 'package:mds_flutter_app/common/main_title.dart';
import 'package:mds_flutter_app/models/user.dart';

/// The view for the login page
/// The user can login with his pseudo and password
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController _pseudoController;
  late TextEditingController _passwordController;
  String _loginErrorMesssage = "";

  @override
  void initState() {
    super.initState();
    _pseudoController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _pseudoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Login the user with the given pseudo and password
  Future<void> _login() async {
    try {
      await User.login(_pseudoController.text, _passwordController.text);
    } catch (e) {
      setState(() {
        _loginErrorMesssage = e.toString().split("Exception: ")[1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MainTitle(text: "Connexion"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                Input(
                  controller: _pseudoController,
                  hintText: "Pseudo",
                  isPassword: false,
                ),
                const SizedBox(height: 16),
                Input(
                  controller: _passwordController,
                  hintText: "Mot de passe",
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                Button(
                  text: "Se connecter",
                  onPressed: () async {
                    await _login();
                  },
                ),
                const SizedBox(height: 10),
                _loginErrorMesssage.isNotEmpty ? Text(_loginErrorMesssage, style: const TextStyle(color: Colors.red)) : Container(),
                Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                  Text("Vous n'avez pas de compte ?", style: TextStyle(color: Theme.of(context).primaryColor)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: Text("Sinscrire", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                  ),
                ]),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
