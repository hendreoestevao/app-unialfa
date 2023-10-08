class Message {
  final String toId;
  final String msg;
  final String read;
  final Type type;
  final String fromId;
  final String sent;

  Message({
    required this.toId,
    required this.msg,
    required this.read,
    required this.type,
    required this.fromId,
    required this.sent,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      toId: json['toId'].toString(),
      msg: json['msg'].toString(),
      read: json['read'].toString(),
      type: json['type'].toString() == Type.image.name ? Type.image : Type.text,
      fromId: json['fromId'].toString(),
      sent: json['sent'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'toId': toId,
      'msg': msg,
      'read': read,
      'type': type.name,
      'fromId': fromId,
      'sent': sent,
    };
  }
}

enum Type { text, image }
