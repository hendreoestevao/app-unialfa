import 'package:app_unialfa/Widgets/chat_user_card.dart';
import 'package:app_unialfa/api/apis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(CupertinoIcons.home),
        title: Text('UniAlfa'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () async {
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
          },
          child: Icon(Icons.add_comment_rounded),
        ),
      ),
      body: ListView.builder(
          itemCount: 16,
          padding: EdgeInsets.only(top: 5),
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return ChatUserCard();
          }),
    );
  }
}
