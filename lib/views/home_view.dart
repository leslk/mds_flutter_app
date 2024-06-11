import 'package:flutter/material.dart';
import 'package:mds_flutter_app/main.dart';
import 'package:mds_flutter_app/views/users_view.dart';
import 'package:mds_flutter_app/views/universes_view.dart';
import 'package:mds_flutter_app/views/chats_view.dart';
import 'package:mds_flutter_app/services/utils.dart';
import 'package:mds_flutter_app/common/main_title.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  void _logout() async {
    await Token.removeToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MainTitle(
          text: "Accueil",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: primaryColor),
            onPressed: () {
              _logout();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // create square container and i want two per row
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    if (index == 0) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const UsersView()));
                    } else if (index == 1) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UniversesView()));
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatsView()));
                    }
                  },
                  child: Container(
                      margin: const EdgeInsets.all(6),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(color: lightGrey, borderRadius: BorderRadius.circular(10)),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Icon(
                          index == 0
                              ? Icons.person
                              : index == 1
                                  ? Icons.language
                                  : Icons.chat_bubble,
                          size: 50,
                          color: secondaryColor,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          index == 0
                              ? "utilisateurs"
                              : index == 1
                                  ? "univers"
                                  : "conversations",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: secondaryColor),
                        ),
                      ])),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
