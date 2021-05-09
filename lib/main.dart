import 'package:flutter/material.dart';
import 'package:real_chat_flutter/chat_list_screen.dart';
import './ChatPage.dart';
import 'login_screen.dart';

void main() => runApp(MyMaterial());

class MyMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        ChatList.id: (context) => ChatList(),
        ChatPage.id: (context) => ChatPage(),
      },
    );
  }
}
