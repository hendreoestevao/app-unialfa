import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/chat_user.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _nameState();
}

class _nameState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        //color: Colors.blue.shade100,
        elevation: 0.5,
        child: InkWell(
          onTap: () {},
          child: ListTile(
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
                widget.user.about,
                maxLines: 1,
              ),
              trailing: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.lightGreenAccent.shade400,
                  borderRadius: BorderRadius.circular(10)
                ),
              )
              // trailing: Text(
              //   '12:00 PM',
              //   style: TextStyle(color: Colors.black54),
              // ),
              ),
        ));
  }
}
