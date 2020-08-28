import 'dart:convert';

import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/services/messageService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'file.dart';
import 'package:flutter/material.dart';

class ShowDiscussion extends StatefulWidget {
  final Map user;

  const ShowDiscussion({Key key, this.user}) : super(key: key);

  @override
  _ShowDiscussionState createState() => _ShowDiscussionState();
}

class _ShowDiscussionState extends State<ShowDiscussion> {
  final _controller = new TextEditingController();
  final _messageController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _searchMode = false;
  Future _messages;
  List _socketMessages;
  SocketIO _socketIO;

  @override
  void initState() {
    super.initState();
    _messages = fetchMessages(widget.user['id']);
    initSocket();
  }

  void initSocket() {
    _socketIO = SocketIOManager().createSocketIO(
        'https://easytrackchatserver.herokuapp.com', '/',
        query: 'chatID=${user.id}');
    _socketIO.init();

    _socketIO.subscribe('receive_message', (jsonData) {
      _socketMessages.add(json.decode(jsonData));
    });

    _socketIO.connect();
  }

  void sendMessage(params) {
    _socketMessages.add(params);
    _socketIO.sendMessage('send_message', json.encode(params));
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
                  AmazingIcon.calendar_line,
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
                  AmazingIcon.chat_1_line,
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
                  AmazingIcon.repeat_2_line,
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
        icon: Icon(Icons.more_vert, color: Colors.black),
      );

  saveMessage() async {
    Map<String, dynamic> params = Map<String, dynamic>();
    params['status'] = '1';
    params['sender'] = user.id.toString();
    params['receiver'] = widget.user['id'].toString();
    params['message'] = _messageController.text;
    params['created_at'] = DateTime.now().toString();
    sendMessage(params);
    setState(() {
      _messageController.text = '';
    });

    await storeMessages(params).then((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                      color: Color(0xff000000),
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
                                                  color: Colors.black,
                                                  size: myHeight(context) /
                                                      30.0)),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right:
                                                    myHeight(context) / 50.0),
                                            child: Icon(
                                                AmazingIcon.search_2_line,
                                                color: Color(0xff000000),
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
                                              color: Color(0xff000000),
                                              size: myHeight(context) / 37.0)),
                                      hintText: 'Recherche...',
                                      hintStyle: TextStyle(
                                          color: Color(0xff000000)
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
                                child: widget.user['photo'] == null
                                    ? Padding(
                                        padding: EdgeInsets.all(
                                            myHeight(context) / 200),
                                        child: Text(
                                          widget.user['name']
                                              .substring(0, 2)
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: myHeight(context) / 60),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 0.0,
                                      ),
                                decoration: widget.user['photo'] == null
                                    ? BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xff3E4859))
                                    : BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'img/persons/${widget.user['photo']}'),
                                            fit: BoxFit.cover)),
                              ),
                              SizedBox(
                                width: myHeight(context) / 50.0,
                              ),
                              Text(
                                widget.user['name'],
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
          padding: EdgeInsets.symmetric(horizontal: myWidth(context) / 20.0),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              FutureBuilder(
                future: _messages,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    if (_socketMessages == null) {
                      _socketMessages = snapshot.data;
                    }
                    return Container(
                        height: myHeight(context) * .78,
                        width: double.infinity,
                        child: _socketMessages == null ||
                                _socketMessages.length == 0
                            ? Align(
                                child: Text(
                                    "Demarrer une discussion avec ${widget.user['name']}"),
                              )
                            : ListView.builder(
                                itemCount: _socketMessages.length,
                                itemBuilder: (context, index) {
                                  int nextIndex = index + 1;
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: nextIndex >=
                                                _socketMessages.length
                                            ? myHeight(context) / 100.0
                                            : _socketMessages[nextIndex]
                                                            ['sender'] ==
                                                        _socketMessages[index]
                                                            ['sender'] &&
                                                    _socketMessages[nextIndex]
                                                            ['created_at'] ==
                                                        _socketMessages[index]
                                                            ['created_at']
                                                ? 0.0
                                                : myHeight(context) / 100.0),
                                    child: Row(
                                      mainAxisAlignment: _socketMessages[index]
                                                      ['sender'] ==
                                                  user.id ||
                                              _socketMessages[index]
                                                      ['sender'] ==
                                                  user.id.toString()
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              _socketMessages[index]
                                                              ['sender'] ==
                                                          user.id ||
                                                      _socketMessages[index]
                                                              ['sender'] ==
                                                          user.id.toString()
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                        myHeight(context) /
                                                            100.0),
                                                    topRight: Radius.circular(
                                                        myHeight(context) /
                                                            100.0),
                                                    bottomRight: _socketMessages[index]['sender'] == user.id || _socketMessages[index]['sender'] == user.id.toString()
                                                        ? Radius.circular(0.0)
                                                        : Radius.circular(
                                                            myHeight(context) /
                                                                100.0),
                                                    bottomLeft: _socketMessages[index]
                                                                ['sender'] !=
                                                            user.id
                                                        ? Radius.circular(0.0)
                                                        : Radius.circular(myHeight(context) / 100.0)),
                                                color: _socketMessages[index]
                                                            ['sender'] ==
                                                        user.id||
                                                      _socketMessages[index]
                                                              ['sender'] ==
                                                          user.id.toString()
                                                    ? Color(0xff267FC9)
                                                    : Color(0xff3E4859),
                                              ),
                                              width: myWidth(context) / 1.7,
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    myHeight(context) / 100.0),
                                                child: Text(
                                                  _socketMessages[index]
                                                      ['message'],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          myHeight(context) /
                                                              50.0),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: myHeight(context) / 500,
                                            ),
                                            nextIndex >= _socketMessages.length
                                                ? Text(
                                                    formatHour(DateTime.parse(
                                                        _socketMessages[index]
                                                            ['created_at'])),
                                                    style: TextStyle(
                                                        color: Colors.black38,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            myHeight(context) /
                                                                70),
                                                  )
                                                : _socketMessages[nextIndex]
                                                                ['sender'] ==
                                                            _socketMessages[
                                                                    index]
                                                                ['sender'] &&
                                                        _socketMessages[index][
                                                                'created_at'] ==
                                                            _socketMessages[
                                                                    index]
                                                                ['created_at']
                                                    ? SizedBox(
                                                        height: 0.0,
                                                      )
                                                    : Text(
                                                        formatHour(DateTime
                                                            .parse(snapshot
                                                                    .data[index]
                                                                [
                                                                'created_at'])),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black38,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: myHeight(
                                                                    context) /
                                                                70),
                                                      )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }));
                  }
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: myHeight(context) / 7.0,
                      alignment: Alignment.topCenter,
                      child: Text('Chargement de la discussion...'),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(
                        thickness: 1.5,
                      ),
                      TextFormField(
                        controller: _messageController,
                        focusNode: _focusNode,
                        onFieldSubmitted: (value) {
                          _focusNode.unfocus();
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0.0),
                            hintStyle: TextStyle(color: Colors.black12),
                            hintText: 'Ecrire un message',
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.attach_file,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: myWidth(context) / 30,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_messageController.text.isNotEmpty) {
                                      saveMessage();
                                    }
                                  },
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
