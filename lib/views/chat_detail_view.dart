import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mds_flutter_app/models/chat.dart';
import 'package:mds_flutter_app/models/character.dart';
import 'package:mds_flutter_app/main.dart';
import 'package:mds_flutter_app/services/http_service.dart';
import 'package:mds_flutter_app/models/message.dart';
import 'package:mds_flutter_app/common/input.dart';

/// Displays the chat detail view
/// It allows to access the conversation with a specific character
/// It allows to send messages to the character
class ChatDetailView extends StatefulWidget {
  const ChatDetailView({super.key});

  @override
  State<ChatDetailView> createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends State<ChatDetailView> {
  Chat? _chat;
  Character? _character;
  dynamic messages;
  bool _isLoading = true;
  final HttpService httpService = HttpService();
  late final ScrollController _scrollController;
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isWriting = false;
  bool _firstBuild = true;

  /// At the initialization set the scroll controller and the focus node
  @override
  void initState() {
    _scrollController = ScrollController();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _isWriting = true;
        });
      } else {
        setState(() {
          _isWriting = false;
        });
      }
    });
    super.initState();
  }

  /// When the widget is disposed, dispose the scroll controller and the focus node
  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Load the chat with the given id
  Future<Chat> _loadChat(int chatId) async {
    Chat chat = await Chat.getChat(chatId);
    await chat.loadMessages();
    return chat;
  }

  /// Load the character with the given id
  Future<Character> _loadCharacter(int characterId) async {
    return await Character.getCharacter(characterId);
  }

  /// Load the chat and the character with the given id
  Future<void> _loadData(int chatId) async {
    Chat chat = await _loadChat(chatId);
    Character character = await _loadCharacter(chat.characterId!);

    setState(() {
      _chat = chat;
      _character = character;
      _isLoading = false;
    });
  }

  /// Send a message to the character
  Future<void> _sendMessage(String content) async {
    try {
      List<Message> messages = await _chat!.sendMessage(content);
      _messageController.clear();
      setState(() {
        _chat!.messages.add(messages[0]);
        _chat!.messages.add(messages[1]);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Erreur lors de l'envoi du message",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ));
      rethrow;
    }
  }

  /// Regenerate the last message sent by the IA
  Future<void> _regenerateMessage() async {
    try {
      Message message = await Chat.regenerateMessage(_chat!.id!);
      // avoid adding an empty message
      if (message.content.isEmpty) {
        message = await Chat.regenerateMessage(_chat!.id!);
      } else {
        // remove the last message and add the new one
        setState(() {
          _chat!.messages.removeAt(_chat!.messages.length - 1);
          _chat!.messages.add(message);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Erreur lors de la régénération du message",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  Widget _displayCharacterPicture(Character character) {
    // Display the top part of the screen containing the blue container with character picture
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                CircleAvatar(
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
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(character.name, style: const TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// Display the bottom part of the screen containing the input field to send messages
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Input(
                focusNode: _focusNode,
                controller: _messageController,
                hintText: 'Ecrire un message...',
                isPassword: false,
              ),
            ),
          ),
          IconButton(
            style: ButtonStyle(
              backgroundColor: !_isWriting ? WidgetStateProperty.all<Color>(primaryColor) : WidgetStateProperty.all<Color>(Colors.grey),
              iconColor: WidgetStateProperty.all<Color>(Colors.white),
            ),
            icon: const Icon(Icons.arrow_upward),
            onPressed: !_isWriting && _messageController.text.isNotEmpty
                ? () async {
                    await _sendMessage(_messageController.text);
                    // Scroll down after adding those messages to the list view
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }

  /// Display the conversation with the character
  Widget _displayConversation() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _chat!.messages.length,
            itemBuilder: (BuildContext context, int index) {
              if (_firstBuild) {
                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                });
                _firstBuild = false;
              }

              return Container(
                padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: (!_chat!.messages[index].isSentByHuman ? Alignment.topLeft : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (!_chat!.messages[index].isSentByHuman ? Colors.grey.shade200 : secondaryColor),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _chat!.messages[index].content,
                          style: TextStyle(
                            fontSize: 15,
                            color: !_chat!.messages[index].isSentByHuman ? Colors.black : Colors.white,
                          ),
                        ),
                        if (index == _chat!.messages.length - 1)
                          IconButton(
                            icon: const Icon(Icons.refresh, color: primaryColor),
                            onPressed: () async {
                              try {
                                await _regenerateMessage();
                                // Scroll down after adding those messages to the list view
                                SchedulerBinding.instance.addPostFrameCallback((_) {
                                  _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text(
                                    "Erreur lors de la régénération du message",
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  backgroundColor: Colors.red,
                                ));
                              }
                            },
                          )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        _buildMessageInput(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final int chatId = ModalRoute.of(context)!.settings.arguments as int;
    if (_chat == null) {
      _loadData(chatId);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          // Delete conversation button
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              try {
                await Chat.deleteChat(chatId);
                Navigator.of(context).pop("deleted");
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    "Erreur lors de la suppression de la conversation",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.red,
                ));
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[_displayCharacterPicture(_character!), Expanded(child: _displayConversation())],
            ),
    );
  }
}
