import 'package:flutter/material.dart';
import 'package:mds_flutter_app/common/main_title.dart';
import 'package:mds_flutter_app/models/universe.dart';
import 'package:mds_flutter_app/common/input.dart';
import 'package:mds_flutter_app/main.dart';
import 'package:mds_flutter_app/services/http_service.dart';
import 'package:mds_flutter_app/common/button.dart';

/// View that displays the list of universes
/// It allows to create a universe and to search for a universe
class UniversesView extends StatefulWidget {
  const UniversesView({super.key});
  @override
  State<UniversesView> createState() => _UniversesViewState();
}

class _UniversesViewState extends State<UniversesView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  final HttpService httpService = HttpService();

  /// At the initialization set the listener to the search controller
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  /// When the widget is disposed, dispose the search controller
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Create a universe with the given name
  Future<Universe> _createUniverse(String name) async {
    try {
      setState(() {
        _isLoading = true;
      });
      Universe universe = await Universe.createUniverse({"name": name});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Univers créé avec succès", style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
        backgroundColor: Colors.green,
      ));
      return universe;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Erreur lors de la création de l'univers", style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
        backgroundColor: Colors.red,
      ));
      rethrow;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Return a list of universes filtered by search query and sorted by name
  List<Universe> _getFilteredUniverses(List<Universe> universes) {
    String query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      return universes.toList()..sort((a, b) => a.name.compareTo(b.name));
    } else {
      return universes.where((universe) {
        return universe.name.toLowerCase().contains(query);
      }).toList()
        ..sort((a, b) => a.name.compareTo(b.name));
      // sort universes by name
    }
  }

  /// Display the image of the universe
  Widget _displayUniverseImage(Universe universe) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: universe.image.isNotEmpty
          ? CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.network(
                  '${httpService.apiUrl}/image_data/${universe.image}',
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

  /// Display the card of the universe
  Card _displayUniverseCard(Universe universe) {
    return Card(
      color: lightGrey,
      elevation: 0,
      child: ListTile(
        leading: _displayUniverseImage(universe),
        title: Text(universe.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        onTap: () {
          Navigator.pushNamed(arguments: universe.id, context, '/universes/:id');
        },
      ),
    );
  }

  /// Display the dialog to create a universe
  Dialog _displayCreateUniverseDialog() {
    final TextEditingController nameController = TextEditingController();
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Input(controller: nameController, hintText: "Nom de l'univers", isPassword: false),
            const SizedBox(height: 16),
            Button(
              text: "Créer l'univers",
              onPressed: () async {
                Navigator.pop(context);
                await _createUniverse(nameController.text);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Display the list of universes
  FutureBuilder _displayUniverseList() {
    return FutureBuilder<List<Universe>>(
      future: Universe.getUniverses(),
      builder: (BuildContext context, AsyncSnapshot<List<Universe>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If an error occured while fetching universes:
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Erreur lors de la récupération des universes",
                textAlign: TextAlign.center,
              ),
            );
          }

          // There is some data to show:
          if (snapshot.hasData) {
            List<Universe> filteredUniverses = _getFilteredUniverses(snapshot.data!);

            // Universes list is empty:
            if (filteredUniverses.isEmpty) {
              return const Center(
                child: Text("Aucun univers"),
              );
            }

            // Universes list is not empty:
            return ListView.builder(
              itemCount: filteredUniverses.length,
              itemBuilder: (BuildContext context, int index) {
                return _displayUniverseCard(filteredUniverses[index]);
              },
            );
          }
        }

        // Still no data to show, waiting for getUniverses function to end:
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
        title: const MainTitle(text: "Univers"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: primaryColor),
            onPressed: () async {
              await showDialog(context: context, builder: (BuildContext context) => _displayCreateUniverseDialog());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Input(controller: _searchController, hintText: "search", isPassword: false),
          const SizedBox(height: 16),
          Expanded(child: _isLoading ? const Center(child: Text("univers en cours de creation", style: TextStyle(color: secondaryColor, fontSize: 16, fontWeight: FontWeight.bold))) : _displayUniverseList()),
        ]),
      ),
    );
  }
}
