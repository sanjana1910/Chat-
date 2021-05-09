import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:real_chat_flutter/Constants.dart';
import 'package:real_chat_flutter/message.dart';
import 'ImagePreview.dart';
import 'model.dart';

Message tempMessage;

class ChatPage extends StatefulWidget {
  static const id = 'chat_page';
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  File pickedFile;

  SocketIO socketIO;
  List<Message> messages = [];

  double height, width;
  int userId = 2;
  TextEditingController textController;
  ScrollController scrollController;
  ScreenAgrs screenArgs;

  Future<File> _createFileFromString(Message message) async {
    Uint8List bytes = base64Decode(message.data);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".jpg");
    await file.writeAsBytes(bytes);
    return file;
  }

  listenSocket() async {
    socketIO = SocketIOManager().createSocketIO(
      'https://safe-mountain-92086.herokuapp.com',
      '/',
    );
    // 'https://real-chat-1234.herokuapp.com',
    //Call init before doing anything with socket
    socketIO.init();
    //Subscribe to an event to listen to
    socketIO.subscribe('receive_message', (json) async {


      final jsonData = jsonDecode(json);

      print(jsonData["type"]);

      if (jsonData["type"] == "image") {
        tempMessage = Message.fromJson(jsonData);
        tempMessage.file = await _createFileFromString(tempMessage);
      }

      if (jsonData["type"] == "text") {
        tempMessage = Message.fromJson(jsonData);
      }

      setState(() {
        messages.add(tempMessage);
      });

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    });
    //Connect to the socket
    socketIO.connect();
  }

  //
  // saveMessageLocallyOrOnDatabase()async{
  //   final messagesArray = [];
  //
  //   final data = {
  //     "data": messagesArray
  //   };
  //
  //   messages.forEach((element) {
  //     messagesArray.add(jsonEncode(element.toJson()));
  //   });
  //
  //   final res = await http.post("mogo:db:;lakjsdla??api+/upload/messages",body: data);
  // }

  @override
  void initState() {
    super.initState();
    //Initializing the message list
    //Initializing the TextEditingController and ScrollController
    textController = TextEditingController();
    scrollController = ScrollController();
    //Creating the socket
    listenSocket();
    super.initState();
  }

  Message message;

  _getFromGallery(ScreenAgrs screenArgs) async {
    // ignore: deprecated_member_use
    pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    final bytes = pickedFile.readAsBytesSync();
    String img64 = base64Encode(bytes);

    message = Message(
        type: "image",
        data: img64,
        file: pickedFile,
        senderId: screenArgs.chatId,
        me: screenArgs.userId);
    socketIO.sendMessage('send_message', json.encode(message.toJson()));
    print(message);
    //Add the message to the list
    this.setState(() => messages.add(message));
    textController.text = '';
    //Scroll down the list to show the latest message
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 600),
      curve: Curves.ease,
    );
  }

  _getFromCamera(screenArgs) async {
    pickedFile = await ImagePicker.pickImage(source: ImageSource.camera);
    final bytes = pickedFile.readAsBytesSync();
    String img64 = base64Encode(bytes);

    message = Message(
        type: "image",
        data: img64,
        file: pickedFile,
        senderId: screenArgs.chatId,
        me: screenArgs.userId);

    socketIO.sendMessage(
      'send_message',
      json.encode(
        message.toJson(),
      ),
    );
    print(message);
    //Add the message to the list
    this.setState(() => messages.add(message));
    textController.text = '';
    //Scroll down the list to show the latest message
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 600),
      curve: Curves.ease,
    );
  }

  String dataToBeSent;

  sendData() async {
    if (textController.text.isNotEmpty) {
      message = Message(
          type: "text",
          data: textController.text,
          senderId: screenArgs.chatId,
          me: screenArgs.userId);
      //Send the message as JSON data to send_message event
      socketIO.sendMessage('send_message', json.encode(message.toJson()));
      print(message);
      //Add the message to the list
      this.setState(() => messages.add(message));
      textController.text = '';
      //Scroll down the list to show the latest message
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    width = MediaQuery.of(context).size.width;
    screenArgs = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(title: Text('User ${screenArgs.chatId}')),
            Container(
              height: height - 140,
              width: width,
              child: ListView.builder(
                controller: scrollController,
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final message = messages[index];
                  return MessageBubble(
                    message: message,
                    userId: screenArgs.userId,
                  );
                },
              ),
            ),
            Container(
              height: height * 0.1,
              width: width,
              child: Row(
                children: <Widget>[
                  Container(
                    width: width * 0.7,
                    child: TextField(
                      onChanged: (data) {
                        dataToBeSent = data;
                      },
                      decoration: InputDecoration.collapsed(
                        hintText: 'Send a message...',
                      ),
                      controller: textController,
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.attach_file),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                children: [
                                  Center(
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          GestureDetector(
                                            child: Text("Gallery"),
                                            onTap: () async {
                                              await _getFromGallery(screenArgs);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          Padding(padding: EdgeInsets.all(8.0)),
                                          GestureDetector(
                                            child: Text("Camera"),
                                            onTap: () async {
                                              await _getFromCamera(screenArgs);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              );
                            });
                      }),
                  FloatingActionButton(
                    backgroundColor: Colors.deepPurple,
                    onPressed: () {
                      sendData();
                    },
                    child: Icon(
                      Icons.send,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MessageBubble extends StatelessWidget {
  MessageBubble({this.message, this.userId});
  int userId;
  Message message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: message.me == userId
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: message.me == userId
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(0.0),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
            elevation: 5.0,
            color: message.me == userId ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: provideWidgets(context,message),
            ),
          )
        ],
      ),
    );
  }



  provideWidgets(context,Message message) {
    if (message.type == "text") {
      return Text(
        message.data,
        style: TextStyle(
            color: message.me == userId ? Colors.white : Colors.black,
            fontSize: 15.0),
      );
    }
    if (message.type == "image") {
      return GestureDetector(
          onTap: (){
            navPush(context, ImageP());
          },
          child: Image.file(message.file));



    }
  }
}
