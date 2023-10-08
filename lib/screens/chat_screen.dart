import 'dart:convert';

import 'package:app_unialfa/Widgets/message_card.dart';
import 'package:app_unialfa/models/message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../models/chat_user.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Color.fromARGB(255, 234, 248, 255),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: APIs.getAllMessages(widget.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const SizedBox();

                      case ConnectionState.active:
                      case ConnectionState.done:
                        // if (snapshot.hasData) {
                        final data = snapshot.data?.docs;
                        // print('Hendreooooo:  ${jsonEncode(data![0].data())}');
                        _list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                            reverse:
                                false, // Exibir as mensagens mais recentes no topo
                            itemCount: _list.length,
                            padding: EdgeInsets.only(bottom: 5),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return MessageCard(
                                message: _list[index],
                              );
                            },
                          );
                        } else {
                          return Center(
                              child: Text(
                            'Diz olá',
                            style: TextStyle(fontSize: 20),
                          ));
                        }
                    }
                  }),
            ),
            _chatInput()
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black54,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: CachedNetworkImage(
              width: 40,
              height: 40,
              imageUrl: widget.user.image,
              // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => const CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                'Visto pela última vez não disponível',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                      size: 25,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'digite algo...',
                          hintStyle: TextStyle(color: Colors.blueAccent),
                          border: InputBorder.none,
                        )),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  )
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text);
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: CircleBorder(),
            color: Colors.green,
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 28,
            ),
          )
        ],
      ),
    );
  }
}
