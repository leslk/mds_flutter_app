import 'package:flutter/material.dart';
import 'package:mds_flutter_app/common/button.dart';
import 'package:mds_flutter_app/common/main_title.dart';
import 'package:mds_flutter_app/main.dart';
import 'package:mds_flutter_app/models/character.dart';
import 'package:mds_flutter_app/services/http_service.dart';
import 'package:mds_flutter_app/models/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CharacterDetailView extends StatefulWidget {
  const CharacterDetailView({super.key});

  @override
  State<CharacterDetailView> createState() => _CharacterDetailViewState();
}

class _CharacterDetailViewState extends State<CharacterDetailView> {
  Character? _character;
  HttpService httpService = HttpService();
  late int _universeId;
  int? _myId;

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      setState(() => _myId = prefs.getInt("id"));
    });
  }

  Future<Character> _getCharacter(int characterId) async {
    Character character = await Character.getCharacter(characterId);
    return character;
  }

  Widget _displayCharacterPicture() {
    // Display the top part of the screen containing the blue container with character picture
    return Container(
        color: primaryColor,
        width: double.infinity,
        height: 200,
        child: Image.network(
          '${httpService.apiUrl}/image_data/${_character!.image}',
          fit: BoxFit.cover,
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            return const Icon(Icons.image, size: 100, color: Colors.white);
          },
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return const CircularProgressIndicator();
            }
          },
        ));
  }

  Future<Chat> _createChat() async {
    // Create a chat object with the character id
    Chat chat = await Chat.createChat(_character!.id!);
    return chat;
  }

  Widget _displayCharacterInfo(characterId) {
    // Display the second part of the screen containing character info
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                MainTitle(text: _character!.name),
                const SizedBox(height: 16),
                Text(
                  _character!.description,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                Button(
                    onPressed: () async {
                      try {
                        Character updatedCharacter = await Character.updateCharacter(_universeId, {"name": _nameController.text, "id": characterId});
                        setState(() {
                          _character = updatedCharacter;
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Erreur lors de la modification du personnage", style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                    text: "Regénérer la description")
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _displayCharacterDetail(int characterId) {
    // Return the main layout of the screen divided in two parts
    return Column(
      children: <Widget>[
        Expanded(flex: 1, child: _displayCharacterPicture()),
        const SizedBox(height: 16),
        Expanded(flex: 3, child: _displayCharacterInfo(characterId)),
      ],
    );
  }

  Widget _displayCreateChatButton() {
    // Display the chat button in the app bar
    return IconButton(
      icon: const Icon(Icons.chat),
      onPressed: () async {
        try {
          Chat chat = await _createChat();
          Navigator.pushNamed(arguments: chat.id, context, '/conversations/:id');
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Erreur lors de la création de la conversation", style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
            backgroundColor: Colors.red,
          ));
        }
      },
    );
  }

  Future<void> _loadCharacter(int characterId) async {
    // Load the character object that will be displayed on this view
    Character character = await _getCharacter(characterId);
    _nameController.text = character.name;
    setState(() => _character = character);
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context)!.settings.arguments as Map<String, int>;
    final int characterId = args["characterId"];
    _universeId = args["universeId"];
    if (_character == null) {
      _loadCharacter(characterId); // Load character object if still null
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(_character != null ? _character!.name : "Character"),
          actions: [
            _displayCreateChatButton(),
          ],
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: primaryColor,
          iconTheme: const IconThemeData(
            color: primaryColor,
          )),
      body: Center(
        child: _character == null ? const CircularProgressIndicator() : _displayCharacterDetail(characterId),
      ),
    );
  }
}
