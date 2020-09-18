import 'package:easytrack/commons/globals.dart';
import 'package:flutter/material.dart';

class ShowDiscussion extends StatefulWidget {
  final Map user;

  const ShowDiscussion({Key key, this.user}) : super(key: key);

  @override
  _ShowDiscussionState createState() => _ShowDiscussionState();
}

class _ShowDiscussionState extends State<ShowDiscussion> {
  
  showNotification(message) {}

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
                    Row(
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
                                  padding:
                                      EdgeInsets.all(myHeight(context) / 200),
                                  child: Text(
                                    widget.user['name']
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
            children: [],
          ),
        ));
  }
}
