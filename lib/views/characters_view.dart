import 'package:flutter/material.dart';
import 'package:mds_flutter_app/common/input.dart';
import 'package:mds_flutter_app/common/main_title.dart';
import 'package:mds_flutter_app/main.dart';
import 'package:mds_flutter_app/services/http_service.dart';
import 'package:mds_flutter_app/models/character.dart';

class CharactersView extends StatefulWidget {
  const CharactersView({super.key});
  @override
  State<CharactersView> createState() => _CharactersViewState();
}

class _CharactersViewState extends State<CharactersView> {
  final HttpService httpService = HttpService();
  bool _isLoading = false;

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

  Card _displayCharacterCard(Character character, int universeId) {
    return Card(
      color: lightGrey,
      elevation: 0,
      child: ListTile(
        leading: _displayCharacterImage(character),
        title: Text(character.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        onTap: () {
          Navigator.pushNamed(arguments: {"universeId": universeId, "characterId": character.id!}, context, '/universes/:universeId/characters/:id');
        },
      ),
    );
  }

  Dialog _displayCreateCharacterDialog(int universeId) {
    final TextEditingController nameController = TextEditingController();

    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Input(controller: nameController, hintText: "Nom du personnage", isPassword: false),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() {
                  _isLoading = true;
                });
                try {
                  await Character.createCharacter(universeId, {"name": nameController.text});
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Erreur lors de la création du personnage"),
                  ));
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              child: const Text("Créer le personnage"),
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder _displayCharacterList(universeId) {
    return FutureBuilder<List<Character>>(
      future: Character.getCharacters(universeId),
      builder: (BuildContext context, AsyncSnapshot<List<Character>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If an error occured while fetching universes:
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Erreur lors du chargement des personnages",
                textAlign: TextAlign.center,
              ),
            );
          }

          // There is some data to show:
          if (snapshot.hasData) {
            List<Character> characters = snapshot.data!;

            // character list is empty:
            if (characters.isEmpty) {
              return const Center(
                child: Text("Aucun personnage"),
              );
            }

            // character list is not empty:
            return ListView.builder(
              itemCount: characters.length,
              itemBuilder: (BuildContext context, int index) {
                return _displayCharacterCard(characters[index], universeId);
              },
            );
          }
        }

        // Still no data to show, waiting for getCharacters() function to end:
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int universeId = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: const MainTitle(text: "Personnages"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: primaryColor,
            onPressed: () async {
              await showDialog(context: context, builder: (BuildContext context) => _displayCreateCharacterDialog(universeId));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: _isLoading ? const Center(child: Text("personnage en cours de creation", style: TextStyle(color: secondaryColor, fontSize: 16, fontWeight: FontWeight.bold))) : _displayCharacterList(universeId)),
          ],
        ),
      ),
    );
  }
}
