import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/chat/file.dart';
import 'package:easytrack/screens/home/home.dart';
import 'package:easytrack/styles/style.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ShowDiscussion extends StatefulWidget {
  final Map user;
  final String bgcolor, textColor;
  const ShowDiscussion(
      {Key key, this.user, @required this.bgcolor, @required this.textColor})
      : super(key: key);

  @override
  _ShowDiscussionState createState() => _ShowDiscussionState();
}

class _ShowDiscussionState extends State<ShowDiscussion> {
  Map _peer;
  bool _searchMode, _messageIsSelected;
  int _messageIndex;
  String newLastMessage = '';

  String groupChatId, _messageCode;
  TextEditingController _controller;
  FocusNode _node;
  String bgcolor, textColor;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _messageIsSelected = false;
    _peer = widget.user;
    logPeerOnFireCloud(_peer);
    initChatRoom();
    bgcolor = widget.bgcolor;
    textColor = widget.textColor;
    registerNotification();
    configLocalNotification();
    _node = FocusNode();
    _searchMode = false;
    _fieldChattingWithField();
    _controller = TextEditingController();
    _scrollController = ScrollController();
  }

  logPeerOnFireCloud(_peer) async {
    await logPeerOnFirebase(_peer);
  }

  initChatRoom() {
    if (int.parse(user.id.toString()) <= int.parse(_peer['id'].toString())) {
      groupChatId = '${user.id}-${_peer['id']}';
    } else {
      groupChatId = '${_peer['id']}-${user.id}';
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

  _selectedMessage(String code, int index, String last) {
    setState(() {
      _messageIsSelected = true;
      _messageIndex = index;
      _messageCode = code;
      newLastMessage = last;
    });
  }

  _deleteMessage(String code) {
    setState(() {
      _messageIsSelected = false;
    });
    print(newLastMessage);
    FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(code)
        .update({'delete': 1});

    FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .update({'lastmessage': newLastMessage});
  }

  buildMessage(QueryDocumentSnapshot messageQuery, int index, datas) {
    Map message = messageQuery.data();
    return Row(
      mainAxisAlignment:
          message['idTo'] == user.id.toString() || message['idTo'] == user.id
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(myHeight(context) / 100.0),
                topRight: Radius.circular(myHeight(context) / 100.0),
                bottomRight: message['idTo'] == user.id.toString() ||
                        message['idTo'] == user.id
                    ? Radius.circular(myHeight(context) / 100.0)
                    : Radius.circular(0.0),
                bottomLeft: message['idTo'] == user.id.toString() ||
                        message['idTo'] == user.id
                    ? Radius.circular(0.0)
                    : Radius.circular(myHeight(context) / 100.0)),
            color: message['idTo'] != user.id.toString() &&
                    message['idTo'] != user.id
                ? Color(0xFFF5F5F5)
                : Color(0xFF3E4859).withOpacity(.5),
          ),
          width: myWidth(context) / 1.7,
          child: Padding(
            padding: EdgeInsets.all(myHeight(context) / 100.0),
            child: Text(
              message['content'],
              style: TextStyle(
                  color: message['idTo'] != user.id.toString() &&
                          message['idTo'] != user.id
                      ? Colors.black
                      : Colors.white,
                  fontSize: myHeight(context) / 50.0),
            ),
          ),
        ),
      ],
    );
  }

  void onSendMessage(String content) {
    if (content.trim() != '') {
      _controller.clear();
      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc();
      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': user.id,
            'idTo': _peer['id'].runtimeType.toString() == 'int'
                ? _peer['id']
                : int.parse(_peer['id']),
            'date': Timestamp.now().microsecondsSinceEpoch,
            'content': content,
            'delete': 0
          },
        );
      });
      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          FirebaseFirestore.instance.collection('messages').doc(groupChatId),
          {
            'date': Timestamp.now().microsecondsSinceEpoch,
            'users': [
              user.id,
              _peer['id'].runtimeType.toString() == 'int'
                  ? _peer['id']
                  : int.parse(_peer['id']),
            ],
            'delete': 0,
            'colors': [
              bgcolor,
              textColor,
            ],
            'lastmessage': content
          },
        );
      });
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
          } else {
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
        ],
        icon: Icon(Icons.more_vert, color: Colors.white),
      );

  searchMethod(toSearch) {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainPage(
                    index: 3,
                  ))),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: PreferredSize(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [gradient1, gradient2])),
                padding:
                    EdgeInsets.symmetric(vertical: myHeight(context) / 100.0),
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainPage(
                                      index: 3,
                                    )))),
                    Expanded(
                      child: _searchMode
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: myWidth(context) / 50),
                              child: TextFormField(
                                  autofocus: true,
                                  onFieldSubmitted: (value) =>
                                      searchMethod(value),
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          AmazingIcon.close_line,
                                          color: Colors.white,
                                        ),
                                        onPressed: () =>
                                            setState(() => _searchMode = false),
                                      ),
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      hintStyle: TextStyle(color: Colors.white),
                                      hintText: 'Recherche')),
                            )
                          : Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white24),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          myHeight(context) / 75),
                                      child: Text(
                                        _peer['name']
                                            .substring(0, 2)
                                            .toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: myHeight(context) / 60),
                                      ),
                                    )),
                                SizedBox(
                                  width: myWidth(context) / 30.0,
                                ),
                                Container(
                                  width: myWidth(context) / 2.5,
                                  child: Text(
                                    capitalize(_peer['name']),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: myHeight(context) / 40.0,
                                        color: Colors.white),
                                  ),
                                ),
                                Spacer(),
                                _messageIsSelected
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              AmazingIcon.file_shred_line,
                                              color: Colors.redAccent[300],
                                            ),
                                            onPressed: () =>
                                                _deleteMessage(_messageCode),
                                          )
                                        ],
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                              icon: Icon(
                                                AmazingIcon.search_2_line,
                                                color: Colors.white,
                                              ),
                                              onPressed: () => setState(
                                                  () => _searchMode = true)),
                                          _offsetPopup()
                                        ],
                                      )
                              ],
                            ),
                    )
                  ],
                ),
              ),
              preferredSize: Size.fromHeight(myHeight(context) / 10.0)),
          body: Padding(
            padding: EdgeInsets.only(top: myWidth(context) / 30.0),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('messages')
                        .doc(groupChatId)
                        .collection(groupChatId)
                        .orderBy('date')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Text('Chargement de la discussion'),
                        );
                      }
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                            _scrollController.offset + myHeight(context),
                            duration: Duration(microseconds: 300),
                            curve: Curves.easeOut);
                      }
                      return Container(
                        height: myHeight(context) * .77,
                        child: ListView.builder(
                            controller: _scrollController,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return snapshot.data.docs[index]
                                          .data()['delete'] !=
                                      0
                                  ? Container()
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: snapshot
                                                      .data.docs[index]
                                                      .data()['idTo'] ==
                                                  user.id.toString() ||
                                              snapshot.data.docs[index]
                                                      .data()['idTo'] ==
                                                  user.id
                                          ? CrossAxisAlignment.start
                                          : CrossAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () => _messageIsSelected &&
                                                  index != _messageIndex
                                              ? _selectedMessage(
                                                  snapshot.data.docs[index].id,
                                                  index,
                                                  snapshot.data.docs.length < 2
                                                      ? 'Lancer la discussion'
                                                      : snapshot
                                                          .data.docs[index - 1]
                                                          .data()['message'])
                                              : setState(() =>
                                                  _messageIsSelected = false),
                                          onLongPress: () => _messageIsSelected
                                              ? null
                                              : _selectedMessage(
                                                  snapshot.data.docs[index].id,
                                                  index,
                                                  snapshot.data.docs.length < 2
                                                      ? 'Commencer la discussion'
                                                      : snapshot
                                                          .data.docs[index - 1]
                                                          .data()['message']),
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    myWidth(context) / 30.0,
                                              ),
                                              color: index == _messageIndex &&
                                                      _messageIsSelected
                                                  ? Colors.blue.withOpacity(.1)
                                                  : Colors.transparent,
                                              child: buildMessage(
                                                  snapshot.data.docs[index],
                                                  index,
                                                  snapshot.data.docs)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: myWidth(context) / 30.0,
                                          ),
                                          child: Text(
                                            formatHour(DateTime
                                                .fromMicrosecondsSinceEpoch(
                                                    snapshot.data.docs[index]
                                                        .data()['date'])),
                                            style: TextStyle(
                                                color: textInverseModeColor
                                                    .withOpacity(.38),
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    myHeight(context) / 70),
                                          ),
                                        ),
                                        SizedBox(
                                          height: myHeight(context) / 100,
                                        ),
                                      ],
                                    );
                            }),
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
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
                        maxLines: null,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0.0),
                            hintStyle: TextStyle(
                                color: textInverseModeColor.withOpacity(.12)),
                            hintText: 'Ecrire un message',
                            suffixIcon: GestureDetector(
                              onTap: () => onSendMessage(_controller.text),
                              child: Icon(
                                AmazingIcon.send_plane_fill,
                                color: textInverseModeColor,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
