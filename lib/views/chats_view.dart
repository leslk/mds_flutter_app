import 'package:flutter/material.dart';
import 'package:mds_flutter_app/common/main_title.dart';
import 'package:mds_flutter_app/main.dart';
import 'package:mds_flutter_app/services/http_service.dart';
import 'package:mds_flutter_app/models/character.dart';
import 'package:mds_flutter_app/models/chat.dart';

/// Displays the list of chats
/// It allows to access the conversations
class ChatsView extends StatefulWidget {
  const ChatsView({super.key});
  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  final HttpService httpService = HttpService();

  Future<List<Map<String, dynamic>>> _fetchChatsAndCharacters() async {
    List<Chat> chats = await Chat.getChats();
    List<Future<Map<String, dynamic>>> futures = chats.map((chat) async {
      Character character = await Character.getCharacter(chat.characterId!);
      return {'chat': chat, 'character': character};
    }).toList();

    return Future.wait(futures);
  }

  Widget _displayCharacterImage(Character character) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: character.image.isNotEmpty
          ? CircleAvatar(
              backgroundColor: Colors.white,
              radius: 40,
              child: ClipOval(
                child: Image.network(
                  '${httpService.apiUrl}/image_data/${character.image}',
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return const Icon(Icons.image, size: 20, color: primaryColor);
                  },
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            )
          : const Icon(Icons.image, size: 20, color: primaryColor),
    );
  }

  Card _displayChatCard(Character character, Chat chat) {
    return Card(
      color: lightGrey,
      elevation: 0,
      child: ListTile(
        leading: _displayCharacterImage(character),
        title: Text(character.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        onTap: () async {
          await Navigator.pushNamed(context, '/conversations/:id', arguments: chat.id!);
          setState(() {});
        },
      ),
    );
  }

  FutureBuilder _displayChatList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchChatsAndCharacters(),
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Erreur lors du chargement des conversations",
                textAlign: TextAlign.center,
              ),
            );
          }

          if (snapshot.hasData) {
            List<Map<String, dynamic>> chatDataList = snapshot.data!;

            if (chatDataList.isEmpty) {
              return const Center(
                child: Text("Aucune conversation"),
              );
            }

            return ListView.builder(
              itemCount: chatDataList.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> chatData = chatDataList[index];
                Character character = chatData['character'];
                Chat chat = chatData['chat'];
                return _displayChatCard(character, chat);
              },
            );
          }
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MainTitle(text: "Conversations"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Expanded(child: _displayChatList()),
        ]),
      ),
    );
  }
}
