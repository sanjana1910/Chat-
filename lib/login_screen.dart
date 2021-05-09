import 'package:flutter/material.dart';
import 'chat_list_screen.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController id = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text('Enter the ID'),
              TextField(
                controller: id,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, ChatList.id, arguments: id.text);
                },
                child: Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
