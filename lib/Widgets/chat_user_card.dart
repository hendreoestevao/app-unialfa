import 'package:app_unialfa/api/apis.dart';
import 'package:app_unialfa/helper/my_date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _nameState();
}

class _nameState extends State<ChatUserCard> {
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        //color: Colors.blue.shade100,
        elevation: 0.5,
        child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChatScreen(
                            user: widget.user,
                          )));
            },
            child: StreamBuilder(
              stream: APIs.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                if (list.isNotEmpty) {
                  _message = list[0];
                }
                return ListTile(
                  // leading: const CircleAvatar(
                  // child: Icon(CupertinoIcons.person),
                  //),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: CachedNetworkImage(
                      imageUrl: widget.user.image,
                      // placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                  title: Text(widget.user.name),
                  subtitle: Text(
                    _message != null ? _message!.msg : widget.user.about,
                    maxLines: 1,
                  ),
                  trailing: _message == null
                      ? null
                      : _message!.read.isEmpty &&
                              _message!.fromId != APIs.user.uid
                          ? Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                  color: Colors.lightGreenAccent.shade400,
                                  borderRadius: BorderRadius.circular(10)),
                            )
                          : Text(
                              MyDateUtil.getLastMessageTime(context: context, time: _message!.sent,),
                              style: TextStyle(color: Colors.black54),
                            ),
                  // trailing: Text(
                  //   '12:00 PM',
                  //   style: TextStyle(color: Colors.black54),
                  // ),
                );
              },
            )));
  }
}
