import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/chat/file.dart';
import 'package:easytrack/styles/style.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ShowDiscussion extends StatefulWidget {
  final Map user;

  const ShowDiscussion({Key key, this.user}) : super(key: key);

  @override
  _ShowDiscussionState createState() => _ShowDiscussionState();
}

class _ShowDiscussionState extends State<ShowDiscussion> {
  Map _peer;
  bool _searchMode;
  String groupChatId;
  TextEditingController _controller;
  FocusNode _node;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _peer = widget.user;
    initChatRoom();
    registerNotification();
    configLocalNotification();
    _node = FocusNode();
    _searchMode = false;
    _fieldChattingWithField();
    _controller = TextEditingController();
    _scrollController = ScrollController();
  }

  initChatRoom() {
    if (user.id.toString().hashCode <= _peer['id'].toString().hashCode) {
      groupChatId =
          '${user.id.toString().hashCode}-${_peer['id'].toString().hashCode}';
    } else {
      groupChatId =
          '${_peer['id'].toString().hashCode}-${user.id.toString().hashCode}';
    }
  }

  checkUser({String id}) async {
    QueryDocumentSnapshot result;
    result = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: id)
        .get()
        .then((value) => value.docs.first);

    return result;
  }

  _fieldChattingWithField() async {
    QueryDocumentSnapshot currentUser = await checkUser(id: user.id.toString());

    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.id)
        .update({'chattingWith': _peer['id']});
  }

  void registerNotification() async {
    QueryDocumentSnapshot currentUser = await checkUser(id: user.id.toString());

    FirebaseMessaging _messaging = FirebaseMessaging();
    _messaging.requestNotificationPermissions();

    _messaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    _messaging.getToken().then((token) {
      print(token);
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.id)
          .update({'pushToken': token});
    }).catchError((err) {
      throw Exception('Exception occured when register message $err');
    });
  }

  void showNotification(message) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.flutterchatdemo'
          : 'com.duytq.flutterchatdemo',
      'Easytrack chat module',
      'Discussion between users of same site and/or snack',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  void configLocalNotification() {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  buildMessage(QueryDocumentSnapshot messageQuery, int index, datas) {
    Map message = messageQuery.data();
    return Padding(
      padding: index < datas.length - 1 &&
              DateTime.parse(datas[index + 1].data()['date'])
                      .difference(DateTime.parse(datas[index].data()['date'])) <
                  Duration(minutes: 1)
          ? EdgeInsets.zero
          : EdgeInsets.only(bottom: myHeight(context) / 100.0),
      child: Row(
        mainAxisAlignment:
            message['idTo'] == user.id.toString() || message['idTo'] == user.id
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: message['idTo'] == user.id.toString() ||
                    message['idTo'] == user.id
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(myHeight(context) / 100.0),
                      topRight: Radius.circular(myHeight(context) / 100.0),
                      bottomRight: message['idTo'] == user.id.toString() ||
                              message['idTo'] == user.id
                          ? Radius.circular(0.0)
                          : Radius.circular(myHeight(context) / 100.0),
                      bottomLeft: message['idTo'] != user.id.toString() ||
                              message['idTo'] != user.id
                          ? Radius.circular(0.0)
                          : Radius.circular(myHeight(context) / 100.0)),
                  color: message['idTo'] != user.id.toString() &&
                          message['idTo'] != user.id
                      ? Color(0xff267FC9)
                      : Color(0xff3E4859),
                ),
                width: myWidth(context) / 1.7,
                child: Padding(
                  padding: EdgeInsets.all(myHeight(context) / 100.0),
                  child: Text(
                    message['content'],
                    style: TextStyle(
                        color: textSameModeColor,
                        fontSize: myHeight(context) / 50.0),
                  ),
                ),
              ),
              SizedBox(
                height: myHeight(context) / 500,
              ),
              index > 0 &&
                      DateTime.parse(datas[index].data()['date']).difference(
                              DateTime.parse(datas[index - 1].data()['date'])) <
                          Duration(minutes: 1)
                  ? Text(
                      formatHour(DateTime.parse(message['date'])),
                      style: TextStyle(
                          color: textInverseModeColor.withOpacity(.38),
                          fontWeight: FontWeight.bold,
                          fontSize: myHeight(context) / 70),
                    )
                  : SizedBox(
                      height: 0.0,
                    )
            ],
          ),
        ],
      ),
    );
  }

  void onSendMessage(String content) {
    if (content.trim() != '') {
      _controller.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': user.id.toString(),
            'idTo': _peer['id'],
            'date': DateTime.now().toString(),
            'content': content
          },
        );
      });
      _scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  Widget _offsetPopup() => PopupMenuButton<int>(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(myHeight(context) / 70.0)),
        onSelected: (int value) {
          if (value == 0) {
            setState(() {
              _searchMode = true;
            });
          } else if (value == 1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => FilePage()));
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Icon(
                  AmazingIcon.search_2_line,
                  color: Color(0xff267FC9),
                  size: myHeight(context) / 40.0,
                ),
                SizedBox(width: 16.0),
                Text(
                  "Recherche",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: myHeight(context) / 50.0),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 1,
            height: kMinInteractiveDimension / 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Icon(
                  AmazingIcon.folder_line,
                  color: Color(0xff267FC9),
                  size: myHeight(context) / 40.0,
                ),
                SizedBox(width: 16.0),
                Text(
                  "Fichiers",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: myHeight(context) / 50.0),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Icon(
                  AmazingIcon.chat_delete_line,
                  color: Color(0xff267FC9),
                  size: myHeight(context) / 40.0,
                ),
                SizedBox(width: 16.0),
                Text(
                  "Effacer les messages",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: myHeight(context) / 50.0),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 3,
            height: kMinInteractiveDimension / 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Icon(
                  AmazingIcon.chat_off_line,
                  color: Color(0xff267FC9),
                  size: myHeight(context) / 40.0,
                ),
                SizedBox(width: 16.0),
                Text(
                  "Bloquer notification",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: myHeight(context) / 50.0),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Icon(
                  AmazingIcon.delete_bin_6_line,
                  color: redColor,
                  size: myHeight(context) / 40.0,
                ),
                SizedBox(width: 16.0),
                Text(
                  "Supprimer",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: myHeight(context) / 50.0),
                ),
              ],
            ),
          ),
        ],
        icon: Icon(Icons.more_vert, color: textInverseModeColor),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
          child: SafeArea(
            child: Container(
              height: myHeight(context) / 5.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _searchMode
                      ? Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Hero(
                            tag: 'search',
                            child: Container(
                              height: myHeight(context) / 17.0,
                              child: TextFormField(
                                onFieldSubmitted: (_) {
                                  setState(() {
                                    _searchMode = false;
                                  });
                                },
                                controller: _controller,
                                textInputAction: TextInputAction.done,
                                style: TextStyle(
                                    color: textInverseModeColor,
                                    fontWeight: FontWeight.w700),
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        top: 10.0, left: 50.0),
                                    prefixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _searchMode = false;
                                              });
                                            },
                                            icon: Icon(Icons.arrow_back,
                                                color: textInverseModeColor,
                                                size:
                                                    myHeight(context) / 30.0)),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: myHeight(context) / 50.0),
                                          child: Icon(AmazingIcon.search_2_line,
                                              color: textInverseModeColor,
                                              size: myHeight(context) / 37.0),
                                        ),
                                      ],
                                    ),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _searchMode = false;
                                          });
                                        },
                                        icon: Icon(AmazingIcon.close_fill,
                                            color: textInverseModeColor,
                                            size: myHeight(context) / 37.0)),
                                    hintText: 'Recherche...',
                                    hintStyle: TextStyle(
                                        color: textInverseModeColor
                                            .withOpacity(.35),
                                        fontSize: 18.0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    )),
                              ),
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () => Navigator.pop(context),
                            ),
                            Container(
                              width: myHeight(context) / 25.0,
                              height: myHeight(context) / 25.0,
                              alignment: Alignment.center,
                              child: _peer['photo'] == null ||
                                      _peer['photo'] == 'null' ||
                                      _peer['photo'] == ''
                                  ? Padding(
                                      padding: EdgeInsets.all(
                                          myHeight(context) / 200),
                                      child: Text(
                                        _peer['name']
                                            .substring(0, 2)
                                            .toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: textSameModeColor,
                                            fontSize: myHeight(context) / 60),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 0.0,
                                    ),
                              decoration: _peer['photo'] == null ||
                                      _peer['photo'] == 'null' ||
                                      _peer['photo'] == ''
                                  ? BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xff3E4859))
                                  : BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'img/persons/${_peer['photo']}'),
                                          fit: BoxFit.cover)),
                            ),
                            SizedBox(
                              width: myHeight(context) / 50.0,
                            ),
                            Text(
                              _peer['name'],
                              style: TextStyle(
                                  fontSize: myHeight(context) / 40.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            _offsetPopup()
                          ],
                        ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: myWidth(context) / 20.0),
                    child: Divider(
                      thickness: 1.5,
                    ),
                  )
                ],
              ),
            ),
          ),
          preferredSize: Size.fromHeight(myHeight(context) / 10.0)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: myWidth(context) / 50.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .doc(groupChatId)
                    .collection(groupChatId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Text('Chargement de la discussion'),
                    );
                  }
                  return Container(
                    height: myHeight(context) * .77,
                    child: ListView.builder(
                        controller: _scrollController,
                        reverse: false,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return buildMessage(snapshot.data.docs[index], index,
                              snapshot.data.docs);
                        }),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: textSameModeColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(
                      thickness: 1.5,
                    ),
                    TextFormField(
                      controller: _controller,
                      focusNode: _node,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0.0),
                          hintStyle: TextStyle(
                              color: textInverseModeColor.withOpacity(.12)),
                          hintText: 'Ecrire un message',
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                AmazingIcon.attachment_line,
                                color: textInverseModeColor,
                              ),
                              SizedBox(
                                width: myWidth(context) / 30,
                              ),
                              GestureDetector(
                                onTap: () => onSendMessage(_controller.text),
                                child: Icon(
                                  AmazingIcon.send_plane_fill,
                                  color: textInverseModeColor,
                                ),
                              )
                            ],
                          ),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
