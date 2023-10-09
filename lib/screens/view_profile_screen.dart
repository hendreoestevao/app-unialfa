import 'dart:convert';
import 'dart:io';

import 'package:app_unialfa/Widgets/chat_user_card.dart';
import 'package:app_unialfa/api/apis.dart';
import 'package:app_unialfa/helper/dialogs.dart';
import 'package:app_unialfa/helper/my_date_util.dart';
import 'package:app_unialfa/models/chat_user.dart';
import 'package:app_unialfa/screens/auth/login_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(widget.user.name),
          ),
    floatingActionButton:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Criado em: ',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      Text(MyDateUtil.getLastMessageTime(context: context, time: widget.user.createdAt, showYear: true),
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 16)),
                    ],
                  ),


          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      height: 300,
                      width: 3000,
                      fit: BoxFit.contain,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                    height: 20,
                  ),
                  Text(widget.user.email,
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 16)),
                  SizedBox(
                    width: 10,
                    height: 20,
                  ),
                  SizedBox(
                    width: 10,
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'status: ',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      Text(widget.user.about,
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
