import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/commons/header.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/chat/show.dart';
import 'package:easytrack/services/contactService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class CurrentDiscussion extends StatefulWidget {
  @override
  _CurrentDiscussionState createState() => _CurrentDiscussionState();
}

class _CurrentDiscussionState extends State<CurrentDiscussion> {
  TextEditingController _controller;
  FocusNode _node;
  List dataToShow, allData;
  bool _searchMode = false;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController();
    _node = FocusNode();
    initialization();

  }

  initialization() async {
    await logUserOnFirebase();
  }

  loadData(contacts) {
    dataToShow = contacts;
    allData = contacts;
  }

  searchMethod(List items, filter) {
    List result = [];
    for (var item in items) {
      if (item['name'].toLowerCase().contains(filter.toLowerCase())) {
        if (!result.contains(item)) {
          result.add(item);
        }
      }
    }
    return filter == '' ? items : result;
  }

  generateBackgroundColor(int index) {
    List colors = [
      Color(0xFFC9DFF2),
      Color(0xFFC8EBF0),
      Color(0xFFC9F6FB),
      Color(0xFFD7EDC7),
      Color(0xFFCBD2F7),
      Color(0xFFE6C6F7)
    ];

    return colors[index % colors.length];
  }

  generateTextColor(int index) {
    List colors = [
      Color(0xFF2680C9),
      Color(0xFF26B0C3),
      Color(0xFF23B0C3),
      Color(0xFF61B820),
      Color(0xFF324CDE),
      Color(0xFF9A1CDD)
    ];

    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: FutureBuilder(
          future: fetchContacts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (allData == null) {
                loadData(snapshot.data);
              }
              return Scaffold(
                backgroundColor: backgroundColor,
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      header2(context, 'Chat', () {}),
                      Expanded(
                        child: ListView.builder(
                            itemCount: dataToShow.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShowDiscussion(
                                            user: dataToShow[index]))),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.black12))),
                                  height: myHeight(context) / 8,
                                  padding: EdgeInsets.symmetric(
                                    vertical: myHeight(context) / 30.0,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: myHeight(context) / 15.0,
                                        height: myHeight(context) / 15.0,
                                        alignment: Alignment.center,
                                        child: Text(
                                          dataToShow[index]['name']
                                              .substring(0, 2)
                                              .toUpperCase(),
                                          style: TextStyle(
                                              color: generateTextColor(index),
                                              fontWeight: FontWeight.bold,
                                              fontSize: myHeight(context) / 55),
                                        ),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                generateBackgroundColor(index)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                myHeight(context) / 50.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: myWidth(context) / 2,
                                              child: Text(
                                                dataToShow[index]['name'],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize:
                                                        myHeight(context) /
                                                            45.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                                width: myWidth(context) / 2,
                                                child: Text(
                                                  'Demarrer la conversation',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Text('10:30')
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              );
            }

            return Scaffold(
              backgroundColor: backgroundColor,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    header2(context, 'Chat', () {}),
                    Expanded(
                        child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(gradient1),
                      ),
                    ))
                  ],
                ),
              ),
            );
          },
        ));
  }
}
