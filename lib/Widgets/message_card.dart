// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_unialfa/helper/my_date_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
        onLongPress: () {
          _showBottomSheet(isMe);
        },
        child: isMe ? _greenMessage() : _blueMessage());
  }

  Widget _blueMessage() {
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment
          .start, // Alinhe à esquerda para mensagens do outro remetente
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? 5 : 20),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 211, 245, 255),
              border: Border.all(color: Colors.lightBlue),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => CircularProgressIndicator(
                        strokeWidth: 2,
                      ),

                      // placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
        Text(
          MyDateUtil.getFormattedTime(
            context: context,
            time: widget.message.sent,
          ),
          style: TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment
          .end, // Alinhe à direita para mensagens do usuário atual
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 218, 255, 176),
              border: Border.all(color: Colors.lightGreen),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => CircularProgressIndicator(
                        strokeWidth: 2,
                      ),

                      // placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
        if (widget.message.read.isNotEmpty)
          Icon(
            Icons.done_all_rounded,
            color: Colors.blue,
            size: 20,
          ),
        Text(
          MyDateUtil.getFormattedTime(
            context: context,
            time: widget.message.sent,
          ),
          style: TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }

  void _showBottomSheet(bool isMe) {
    if (!mounted) {
      return; // Verifique se o widget ainda está montado
    }

    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 20, bottom: 30),
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),
              widget.message.type == Type.text
                  ? _OptionItem(
                      icon: Icon(
                        Icons.copy_all_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: 'Copiar Mensagem',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          if (mounted) {
                            Navigator.pop(context);
                            Dialogs.showSnackBar(context, 'Mensagem Copiada');
                          }
                        });
                      })
                  : _OptionItem(
                      icon: Icon(
                        Icons.download_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: 'Salvar Imagem',
                      onTap: () {}),
              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: 20,
                  indent: 20,
                ),
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.blue,
                      size: 26,
                    ),
                    name: 'Editar Mensagem',
                    onTap: () {}),
              if (isMe)
                _OptionItem(
                    icon: Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                      size: 26,
                    ),
                    name: 'Deletar Mensagem',
                    onTap: () async {
                      await APIs.deleteMessage(widget.message).then((value) {
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      });
                    }),
              Divider(
                color: Colors.black54,
                endIndent: 20,
                indent: 20,
              ),
              _OptionItem(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.blue,
                    size: 26,
                  ),
                  name:
                      'Mensagem enviada: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                  onTap: () {}),
              _OptionItem(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.green,
                    size: 26,
                  ),
                  name: widget.message.read.isEmpty
                      ? 'Mensagem Não Visualizada'
                      : 'Mensagem lida: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)} ',
                  onTap: () {})
            ],
          );
        });
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.only(left: 50, top: 15, bottom: 10),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              '    $name',
              style: TextStyle(
                  fontSize: 15, color: Colors.black54, letterSpacing: 0.5),
            ))
          ],
        ),
      ),
    );
  }
}
