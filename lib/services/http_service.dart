import 'dart:async';
import 'dart:convert';
import 'package:mds_flutter_app/services/utils.dart';
import 'package:http/http.dart' as http;
import 'package:mds_flutter_app/models/user.dart';
import 'package:mds_flutter_app/models/universe.dart';
import 'package:mds_flutter_app/models/character.dart';
import 'package:mds_flutter_app/models/chat.dart';
import 'package:mds_flutter_app/models/message.dart';

class HttpService {
  final String apiUrl = "https://mds.sprw.dev";

  // --------------------------------- User ---------------------------------
  Future<void> login(String username, String password) async {
    http.Response res = await http.post(Uri.parse('$apiUrl/auth'),
        body: jsonEncode({
          'username': username,
          'password': password,
        }));
    switch (res.statusCode) {
      case 201:
        var token = jsonDecode(res.body)['token'];
        await Token.getIdFromToken(token);
        await Token.setToken(token);
        break;
      case 401:
        throw Exception('Email ou mot de passe incorrect');
      default:
        throw Exception('Une erreur est survenue');
    }
  }

  Future<void> signup(Map userData) async {
    //remove id from user
    http.Response res = await http.post(Uri.parse('$apiUrl/users'), body: jsonEncode(userData));
    switch (res.statusCode) {
      case 201:
        break;
      case 400:
        throw Exception('Email ou pseudo déjà utilisé');
      default:
        throw Exception('Une erreur est survenue');
    }
  }

  FutureOr<List<User>> getUsers() async {
    String? token = await Token.getToken();
    http.Response res = await http.get(Uri.parse('$apiUrl/users'), headers: {
      'Authorization': 'Bearer $token',
    });
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      // Add user objects to a list and return it
      List<User> users = [];
      for (Map userData in body) {
        users.add(User.fromJson(userData));
      }
      return users;
    } else {
      throw "Can't get users.";
    }
  }

  Future<User> getUser(int id) async {
    String? token = await Token.getToken();
    http.Response res = await http.get(Uri.parse('$apiUrl/users/$id'), headers: {
      'Authorization': 'Bearer $token',
    });
    return User.fromJson(jsonDecode(res.body));
  }

  Future<User> updateUser(int id, Map userData) async {
    String? token = await Token.getToken();
    http.Response res = await http.put(Uri.parse('$apiUrl/users/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(userData));
    switch (res.statusCode) {
      case 200:
        return User.fromJson(jsonDecode(res.body));
      case 400:
        throw Exception('Email ou pseudo déjà utilisé');
      default:
        throw Exception('Une erreur est survenue');
    }
  }

  // --------------------------------- Universes ---------------------------------
  Future<List<Universe>> getUniverses() async {
    String? token = await Token.getToken();
    http.Response res = await http.get(Uri.parse('$apiUrl/universes'), headers: {
      'Authorization': 'Bearer $token',
    });
    switch (res.statusCode) {
      case 200:
        List<dynamic> body = jsonDecode(res.body);

        // Add universe objects to a list and return it
        List<Universe> universes = [];
        for (Map universeData in body) {
          universes.add(Universe.fromJson(universeData));
        }
        return universes;
      default:
        throw Exception('Une erreur est survenue');
    }
  }

  Future<Universe> getUniverse(int id) async {
    String? token = await Token.getToken();
    http.Response res = await http.get(Uri.parse('$apiUrl/universes/$id'), headers: {
      'Authorization': 'Bearer $token',
    });
    switch (res.statusCode) {
      case 200:
        return Universe.fromJson(jsonDecode(res.body));
      default:
        throw Exception('Une erreur est survenue');
    }
  }

  Future<Universe> updateUniverse(int id, Map universeData) async {
    String? token = await Token.getToken();
    http.Response res = await http.put(Uri.parse('$apiUrl/universes/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(universeData));
    switch (res.statusCode) {
      case 200:
        return Universe.fromJson(jsonDecode(res.body));
      default:
        throw Exception('Une erreur est survenue');
    }
  }

  Future<String> deleteUniverse(int id) async {
    String? token = await Token.getToken();
    http.Response res = await http.delete(Uri.parse('$apiUrl/universes/$id'), headers: {
      'Authorization': 'Bearer $token',
    });
    switch (res.statusCode) {
      case 204:
        return "L'univers a bien été supprimé";
      default:
        throw Exception('Une erreur est survenue');
    }
  }

  Future<Universe> createUniverse(Map universeData) async {
    String? token = await Token.getToken();
    http.Response res = await http.post(Uri.parse('$apiUrl/universes'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(universeData));
    switch (res.statusCode) {
      case 201:
        return Universe.fromJson(jsonDecode(res.body));
      default:
        throw Exception('Une erreur est survenue');
    }
  }

  // --------------------------------- Characters ---------------------------------

  FutureOr<List<Character>> getCharacters(int universeId) async {
    String? token = await Token.getToken();
    http.Response res = await http.get(Uri.parse('$apiUrl/universes/$universeId/characters'), headers: {
      'Authorization': 'Bearer $token',
    });
    switch (res.statusCode) {
      case 200:
        List<dynamic> body = jsonDecode(res.body);

        // Add character objects to a list and return it
        List<Character> characters = [];
        for (Map characterData in body) {
          characters.add(Character.fromJson(characterData));
        }
        return characters;
      default:
        throw Exception('Une erreur est survenue');
    }
  }

  Future<Character> getCharacter(int id) async {
    String? token = await Token.getToken();
    http.Response res = await http.get(Uri.parse('$apiUrl/characters/$id'), headers: {
      'Authorization': 'Bearer $token',
    });
    switch (res.statusCode) {
      case 200:
        return Character.fromJson(jsonDecode(res.body));
      default:
        throw Exception('Une erreur est survenue');
    }
  }

  Future<Character> updateCharacter(int universeId, Map characterData) async {
    String? token = await Token.getToken();
    http.Response res = await http.put(Uri.parse('$apiUrl/universes/$universeId/characters/${characterData['id']}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(characterData));
    switch (res.statusCode) {
      case 200:
        return Character.fromJson(jsonDecode(res.body));
      default:
        throw Exception('Une erreur est survenue');
    }
  }

  Future<String> deleteCharacter(int id) async {
    String? token = await Token.getToken();
    http.Response res = await http.delete(Uri.parse('$apiUrl/characters/$id'), headers: {
      'Authorization': 'Bearer $token',
    });
    switch (res.statusCode) {
      case 204:
        return "Le personnage a bien été supprimé";
      default:
        throw Exception('Une erreur est survenue');
    }
  }

  Future<Character> createCharacter(int universeId, Map characterData) async {
    String? token = await Token.getToken();
    http.Response res = await http.post(Uri.parse('$apiUrl/universes/$universeId/characters'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(characterData));
    switch (res.statusCode) {
      case 201:
        return Character.fromJson(jsonDecode(res.body));
      default:
        throw Exception('Une erreur est survenue');
    }
  }

  // --------------------------------- Chats ---------------------------------
  FutureOr<List<Chat>> getChats() async {
    String? token = await Token.getToken();
    http.Response res = await http.get(Uri.parse('$apiUrl/conversations'), headers: {
      'Authorization': 'Bearer $token',
    });
    switch (res.statusCode) {
      case 200:
        List<dynamic> body = jsonDecode(res.body);

        // Add chat objects to a list and return it
        List<Chat> chats = [];
        for (Map chatData in body) {
          chats.add(Chat.fromJson(chatData as Map<String, dynamic>));
        }
        return chats;
      default:
        throw Exception('Une erreur est survenue');
    }
  }

  Future<Chat> createChat(int CharacterId) async {
    String? token = await Token.getToken();
    int? userId = await Token.getId();
    http.Response res = await http.post(Uri.parse('$apiUrl/conversations'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'character_id': CharacterId,
          'user_id': userId,
        }));
    switch (res.statusCode) {
      case 201:
        return Chat.fromJson(jsonDecode(res.body));
      default:
        throw Exception('Une erreur est survenue');
    }
  }

  Future<Chat> getChat(int id) async {
    String? token = await Token.getToken();
    http.Response res = await http.get(Uri.parse('$apiUrl/conversations/$id'), headers: {
      'Authorization': 'Bearer $token',
    });
    switch (res.statusCode) {
      case 200:
        return Chat.fromJson(jsonDecode(res.body));
      default:
        throw Exception('Une erreur est survenue');
    }
  }

  Future<String> deleteChat(int id) async {
    String? token = await Token.getToken();
    http.Response res = await http.delete(Uri.parse('$apiUrl/conversations/$id'), headers: {
      'Authorization': 'Bearer $token',
    });
    switch (res.statusCode) {
      case 200:
        return "La conversation a bien été supprimée";
      default:
        throw Exception('Une erreur est survenue');
    }
  }

  Future<List<Message>> getChatMessages(int chatId) async {
    String? token = await Token.getToken();
    http.Response res = await http.get(Uri.parse("$apiUrl/conversations/$chatId/messages"), headers: {
      'Authorization': 'Bearer $token',
    });

    switch (res.statusCode) {
      case 200:
        List<Message> messages = [];
        for (Map messageData in jsonDecode(res.body)) {
          messages.add(Message.fromJson(messageData));
        }
        return messages;
      default:
        throw Exception("Une erreur est survenue durant la récupération des messages");
    }
  }

  Future<List<Message>> sendMessage(int chatId, String content) async {
    String? token = await Token.getToken();
    http.Response res = await http.post(Uri.parse("$apiUrl/conversations/$chatId/messages"), headers: {'Authorization': 'Bearer $token'}, body: jsonEncode({"content": content}));

    print('body ${res.body}');
    print(res.statusCode);
    switch (res.statusCode) {
      case 201:
        Message message = Message.fromJson(jsonDecode(res.body)["message"]);
        Message answer = Message.fromJson(jsonDecode(res.body)["answer"]);
        return [message, answer];

      default:
        throw Exception("Erreur lors de l'envoi du message");
    }
  }

  Future<Message> regenerateMessage(int chatId) async {
    String? token = await Token.getToken();
    http.Response res = await http.put(Uri.parse("$apiUrl/conversations/$chatId"), headers: {'Authorization': 'Bearer $token'});

    switch (res.statusCode) {
      case 200:
        Message message = Message.fromJson(jsonDecode(res.body));
        return message;

      default:
        throw Exception("Erreur lors de la régénération du message");
    }
  }
}
