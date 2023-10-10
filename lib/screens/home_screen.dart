import 'dart:convert';

import 'package:app_unialfa/Widgets/chat_user_card.dart';
import 'package:app_unialfa/api/apis.dart';
import 'package:app_unialfa/helper/dialogs.dart';
import 'package:app_unialfa/models/chat_user.dart';
import 'package:app_unialfa/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    // APIs.updateActiveStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }

        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: Icon(CupertinoIcons.home),
              title: _isSearching
                  ? TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nome,  Email, ...'),
                      autofocus: true,
                      style: TextStyle(fontSize: 17, letterSpacing: 0.5),
                      onChanged: (val) {
                        _searchList.clear();

                        for (var i in _list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            _searchList.add(i);
                          }
                          setState(() {
                            _searchList;
                          });
                        }
                      },
                    )
                  : Text('UniAlfa'),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon: Icon(
                        _isSearching ? CupertinoIcons.clear : Icons.search)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                    user: APIs.me,
                                  )));
                    },
                    icon: Icon(Icons.more_vert))
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FloatingActionButton(
                onPressed: () {
                  _addChatUserDialog();
                },
                child: Icon(Icons.add_comment_rounded),
              ),
            ),
            body: StreamBuilder(
                stream: APIs.getMyUsersId(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(child: CircularProgressIndicator());

                    case ConnectionState.active:
                    case ConnectionState.done:



                      return StreamBuilder(
                          stream: APIs.getAllUsers(
                              snapshot.data?.docs.map((e) => e.id).toList() ??
                                  []),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                              case ConnectionState.none:
                                return const Center(
                                    child: CircularProgressIndicator());

                              case ConnectionState.active:
                              case ConnectionState.done:
                                if (snapshot.hasData) {
                                  final data = snapshot.data?.docs;
                                  _list = data
                                          ?.map((e) =>
                                              ChatUser.fromJson(e.data()))
                                          .toList() ??
                                      [];
                                }

                                if (_list.isNotEmpty) {
                                  return ListView.builder(
                                      itemCount: _isSearching
                                          ? _searchList.length
                                          : _list.length,
                                      padding: EdgeInsets.only(top: 5),
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return ChatUserCard(
                                          user: _isSearching
                                              ? _searchList[index]
                                              : _list[index],
                                        );
                                        // return Text('Name: ${list[index]}');
                                      });
                                } else {
                                  return Center(
                                      child: Text(
                                    'Nenhum Usuario Encontrado',
                                    style: TextStyle(fontSize: 20),
                                  ));
                                }
                            }
                          });
                  }
;
                })),
      ),
    );
  }

  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding:
                  EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text(' Adicionar Usuario')
                ],
              ),
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.blue,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    if (email.isNotEmpty)
                      await APIs.addChatUser(email).then((value) {
                        if (!value) {
                          Dialogs.showSnackBar(context, 'Usuario não existe');
                        }
                      });
                  },
                  child: Text(
                    'Adicionar',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                )
              ],
            ));
  }
}
