import 'package:flutter/material.dart';
import 'package:mds_flutter_app/views/home_view.dart';
import 'package:mds_flutter_app/views/login_view.dart';
import 'package:mds_flutter_app/services/utils.dart';
import 'dart:async';

class LoginCheckerView extends StatelessWidget {
  const LoginCheckerView({super.key});

  /// This stream allows us to check if the token is in shared preferences, expired or still valid.
  Stream<bool> _checkTokenStream() async* {
    while (true) {
      String? token = await Token.getToken();
      if (token == null) {
        yield false;
      } else if (Token.isExpired(token)) {
        Token.removeToken();
        yield false;
      } else {
        yield true;
      }
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  /// In the build method, we are using the StreamBuilder to check if the user is logged in or not.
  /// If the user is logged in, we will show the HomeView, otherwise we will show the LoginView.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _checkTokenStream(),
        builder: (BuildContext context, AsyncSnapshot<bool> isLogged) {
          if (isLogged.hasData) {
            if (isLogged.data! && isLogged.data == true) {
              return const HomeView();
            }
            return const LoginView();
          }
          return const Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        });
  }
}
