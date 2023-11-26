import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../../data/model/message.dart';
import '../controllers/authentication_controller.dart';
import '../controllers/chat_controller.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  ChatController chatController = Get.find();
  AuthenticationController authenticationController = Get.find();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    chatController.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    chatController.stop();
    super.dispose();
  }

  Widget _item(Message element, int posicion, String uid) {
    logInfo('Current user? -> ${uid == element.user} msg -> ${element.text}');
    return Container(
      alignment:
          uid == element.user ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: 250), // Incrementamos ancho máximo
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Border radius más grande
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8, // Márgenes verticales más grandes
          ),
          color: uid == element.user
              ? const Color.fromARGB(255, 70, 70, 160)
              : const Color(0xFF76A4D3),
          elevation: 1,
          child: Padding(
              padding: const EdgeInsets.all(16), // Padding interno mayor
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    element.text.split('\n')[0],
                    style: TextStyle(
                      fontSize: 18,
                      color: uid == element.user ? Colors.amber : Colors.white,
                    ),
                    textAlign:
                        uid == element.user ? TextAlign.right : TextAlign.left,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    element.text.split('\n')[1],
                    style: TextStyle(
                      color: uid == element.user ? Colors.white : Colors.black,
                      fontSize: 16, // Texto más grande
                    ),
                    textAlign:
                        uid == element.user ? TextAlign.right : TextAlign.left,
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _list() {
    String uid = authenticationController.getUid();
    logInfo('Current user $uid');
    return GetX<ChatController>(builder: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
      return ListView.builder(
        itemCount: chatController.messages.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          var element = chatController.messages[index];
          return _item(element, index, uid);
        },
      );
    });
  }

  Future<void> _sendMsg(String text) async {
    //FocusScope.of(context).requestFocus(FocusNode());
    logInfo("Calling _sendMsg with $text");
    await chatController.sendMsg(text);
  }

  Widget _textInput() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.only(left: 5.0, top: 5.0),
            child: TextField(
              key: const Key('MsgTextField'),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your message',
              ),
              onSubmitted: (value) {
                if (_controller.text.isNotEmpty) {
                  _sendMsg(_controller.text);
                  _controller.clear();
                } else {
                  logInfo('Empty message');
                }
              },
              controller: _controller,
            ),
          ),
        ),
        TextButton(
            key: const Key('sendButton'),
            child: const Text('Send'),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                _sendMsg(_controller.text);
                _controller.clear();
              } else {
                logInfo('Empty message');
              }
            })
      ],
    );
  }

  _scrollToEnd() async {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    return Padding(
      padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 25.0),
      child: Column(
        children: [Expanded(flex: 4, child: _list()), _textInput()],
      ),
    );
  }
}
