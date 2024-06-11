import 'package:flutter/material.dart';
import 'package:mds_flutter_app/views/home_view.dart';
import 'package:mds_flutter_app/views/login_view.dart';
import 'package:mds_flutter_app/services/utils.dart';
import 'dart:async';

class LoginCheckerView extends StatefulWidget {
  const LoginCheckerView({super.key});

  @override
  State<LoginCheckerView> createState() => _LoginCheckerViewState();
}

class _LoginCheckerViewState extends State<LoginCheckerView> {
  late StreamController<bool> _streamController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<bool>();
    _startTokenCheck();
  }

  @override
  void dispose() {
    _streamController.close();
    _timer.cancel();
    super.dispose();
  }

  void _startTokenCheck() async {
    var token = await Token.getToken();
    bool? isLogin = token != null;
    _streamController.add(isLogin);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      token = await Token.getToken();
      bool? isLogin = token != null;
      _streamController.add(isLogin);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _streamController.stream,
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
