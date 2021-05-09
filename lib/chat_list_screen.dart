import 'package:flutter/material.dart';
import 'package:real_chat_flutter/model.dart';

import 'ChatPage.dart';

class ChatList extends StatefulWidget {
  static const id = 'chat_list';
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    print(id);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            id == '1'
                ? Container()
                : FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        ChatPage.id,
                        arguments: ScreenAgrs(userId: int.parse(id), chatId: 1),
                      );
                    },
                    child: Text('Id 1'),
                  ),
            id == '2'
                ? Container()
                : FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        ChatPage.id,
                        arguments: ScreenAgrs(userId: int.parse(id), chatId: 2),
                      );
                    },
                    child: Text('Id 2'),
                  ),
            id == '3'
                ? Container()
                : FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        ChatPage.id,
                        arguments: ScreenAgrs(userId: int.parse(id), chatId: 3),
                      );
                    },
                    child: Text('Id 3'),
                  ),
            id == '4'
                ? Container()
                : FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        ChatPage.id,
                        arguments: ScreenAgrs(userId: int.parse(id), chatId: 4),
                      );
                    },
                    child: Text('Id 4'),
                  ),
          ],
        ),
      ),
    );
  }
}
