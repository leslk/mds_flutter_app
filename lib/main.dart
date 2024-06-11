import 'package:flutter/material.dart';
import 'package:mds_flutter_app/views/character_detail_view.dart';
import 'package:mds_flutter_app/views/login_view.dart';
import 'package:mds_flutter_app/views/signup_view.dart';
import 'package:mds_flutter_app/views/splash_screen_view.dart';
import 'package:mds_flutter_app/views/universes_view.dart';
import 'package:mds_flutter_app/views/universes_detail_view.dart';
import 'package:mds_flutter_app/views/users_view.dart';
import 'package:mds_flutter_app/views/chats_view.dart';
import 'package:mds_flutter_app/views/user_detail_view.dart';
import 'package:mds_flutter_app/views/characters_view.dart';
import 'package:mds_flutter_app/views/chat_detail_view.dart';

const Color primaryColor = Color(0xFF4B5F94);
const Color secondaryColor = Color(0xFF758ABE);
const Color lightGrey = Color(0xFFF4F4F4);
const Color darkerGrey = Color.fromARGB(255, 181, 181, 181);

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        primaryColor: primaryColor,
        secondaryHeaderColor: secondaryColor,
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
            backgroundColor: const WidgetStatePropertyAll<Color>(primaryColor),
            padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(70),
              ),
            ),
            minimumSize: const WidgetStatePropertyAll<Size>(Size(double.infinity, 0)),
          ),
        ),
      ),
      routes: {
        '/login': (context) => const LoginView(),
        '/signup': (context) => const SignupView(),
        '/users': (context) => const UsersView(),
        '/users/:id': (context) => const UserDetailView(),
        '/universes': (context) => const UniversesView(),
        '/universes/:id': (context) => const UniverseDetailView(),
        '/universes/:universeId/characters': (context) => const CharactersView(),
        '/universes/:universeId/characters/:id': (context) => const CharacterDetailView(),
        '/universes/:universeId/users/:userId': (context) => const UserDetailView(),
        '/conversations': (context) => const ChatsView(),
        '/conversations/:id': (context) => const ChatDetailView(),
      },
      home: const Scaffold(
        body: Center(child: SplashScreenView()),
      ),
    );
  }
}
