import 'package:easytrack/commons/bottomNavigationBar.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          bottomNavigationBar: CustNavigationBar(index: 3),
      body: Center(child: Text('chat'),),
    );
  }
}
