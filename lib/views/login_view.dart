import 'package:flutter/material.dart';
import 'package:mds_flutter_app/common/button.dart';
import 'package:mds_flutter_app/common/input.dart';
import 'package:mds_flutter_app/common/main_title.dart';
import 'package:mds_flutter_app/models/user.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _pseudoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _loginErrorMesssage = "";
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
                    try {
                      await User.login(_pseudoController.text, _passwordController.text);
                    } on Exception catch (e) {
                      setState(() {
                        _loginErrorMesssage = e.toString();
                      });
                    }
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
