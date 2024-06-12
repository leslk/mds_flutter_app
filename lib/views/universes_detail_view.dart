import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mds_flutter_app/common/button.dart';
import 'package:mds_flutter_app/common/main_title.dart';
import 'package:mds_flutter_app/main.dart';
import 'package:mds_flutter_app/models/universe.dart';
import 'package:mds_flutter_app/services/http_service.dart';
import 'package:mds_flutter_app/common/text_input_modal.dart';

/// View that displays the details of a universe
/// It allows to edit the universe name
class UniverseDetailView extends StatefulWidget {
  const UniverseDetailView({super.key});

  @override
  State<UniverseDetailView> createState() => _UniverseDetailViewState();
}

class _UniverseDetailViewState extends State<UniverseDetailView> {
  Universe? _universe;
  HttpService httpService = HttpService();

  /// Get the universe with the given id
  Future<Universe> _getUniverse(int universeId) async {
    Universe universe = await Universe.getUniverse(universeId);
    return universe;
  }

  /// Update the universe with the given data
  Future<void> _updateUniverse(int universeId, Map<String, dynamic> data) async {
    try {
      Universe universe = await Universe.updateUniverse(universeId, data);
      setState(() {
        _universe = universe;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Univers modifié avec succès", style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Erreur lors de la modification de l'univers", style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
        backgroundColor: Colors.red,
      ));
      rethrow;
    }
  }

  Widget _displayUniversePicture() {
    // Display the top part of the screen containing the blue container with universe picture
    return Container(
        color: primaryColor,
        width: double.infinity,
        height: 200,
        child: Image.network(
          '${httpService.apiUrl}/image_data/${_universe!.image}',
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

  Widget _displayProfileEditionDialog() {
    // Return the content of the bottom sheet modal when editing the universe name
    return TextInputModal(
        buttonText: "Modifier le nom de l'univers",
        hintText: "Nouveau nom",
        value: _universe!.name,
        onConfirm: (String value) async {
          await _updateUniverse(_universe!.id!, {"name": value});
        });
  }

  Widget _displayEditInfoButton() {
    // Return the pen button that allows the universe to be edited
    return IconButton(
      icon: const Icon(Icons.edit, color: Colors.white),
      onPressed: () async {
        // show dialod with full width in the bottom of the screen
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return _displayProfileEditionDialog();
          },
        );
      },
    );
  }

  Widget _displayUniverseInfo(universeId) {
    // Display the second part of the screen containing universe info
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(
                      text: "Voir les personnages",
                      onPressed: () {
                        Navigator.pushNamed(arguments: universeId, context, '/universes/:universeId/characters');
                      }),
                  const SizedBox(height: 32),
                  MainTitle(text: _universe!.name),
                  const SizedBox(height: 16),
                  Text(
                    _universe!.description,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
              )),
          const SizedBox(height: 75)
        ],
      ),
    );
  }

  Widget _displayUniverseDetail(int universeId) {
    // Return the main layout of the screen divided in two parts
    return Column(
      children: <Widget>[
        Expanded(flex: 1, child: _displayUniversePicture()),
        const SizedBox(height: 16),
        Expanded(flex: 3, child: _displayUniverseInfo(universeId)),
      ],
    );
  }

  Future<void> _loadUniverse(int universeId) async {
    // Load the universe object that will be displayed on this view
    Universe universe = await _getUniverse(universeId);
    setState(() => _universe = universe);
  }

  @override
  Widget build(BuildContext context) {
    final int universeId = ModalRoute.of(context)!.settings.arguments as int;
    if (_universe == null) {
      _loadUniverse(universeId); // Load universe object if still null
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_universe != null ? _universe!.name : "", style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [_displayEditInfoButton()],
        centerTitle: true,
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _universe == null ? const CircularProgressIndicator() : _displayUniverseDetail(universeId),
      ),
    );
  }
}
