import 'dart:io';

class Message {
  String data;
  String type;
  int senderId;
  File file;
  int me;

  Message({this.data, this.senderId, this.me, this.type,this.file});

  Message.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    senderId = json['sender-id'];
    type = json['type'];
    me = json['me'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['sender-id'] = this.senderId;
    data['type'] = this.type;
    data['me'] = this.me;
    return data;
  }

}

