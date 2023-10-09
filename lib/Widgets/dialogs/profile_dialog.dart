import 'package:app_unialfa/models/chat_user.dart';
import 'package:app_unialfa/screens/view_profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: 120,
        height: 300,
        child: Stack(
          children: [
            Positioned(
              top: 60,
              left: -10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  height: 150,
                  width: 300,
                  fit: BoxFit.contain,
                  imageUrl: user.image,
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 5,
              width: 150,
              child: Text(
                user.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Positioned(
                right: 20,
                top: 5,
                child: MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ViewProfileScreen(user: user)));
                    },
                    minWidth: 0,
                    padding: EdgeInsets.all(0),
                    shape: CircleBorder(),
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: 30,
                    )))
          ],
        ),
      ),
    );
  }
}
