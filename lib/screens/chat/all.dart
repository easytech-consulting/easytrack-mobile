import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/data.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/chat/show.dart';
import 'package:easytrack/screens/search/search.dart';
import 'package:flutter/material.dart';

class AllContacts extends StatefulWidget {
  @override
  _AllContactsState createState() => _AllContactsState();
}

class _AllContactsState extends State<AllContacts> {
  List dataToShow, allData;

  @override
  void initState() {
    super.initState();
    loadData(globalContacts);
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

  colorsSendOnFirebase(bool isText, int index) {
    List colors;
    if (isText) {
      colors = ["2680C9", "26B0C3", "23B0C3", "61B820", "324CDE", "9A1CDD"];
    } else {
      colors = ['C9DFF2', 'C8EBF0', 'C9F6FB', 'D7EDC7', 'CBD2F7', 'E6C6F7'];
    }

    return colors[index % colors.length];
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
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.arrow_back),
                      ),
                      SizedBox(
                        width: myWidth(context) / 50,
                      ),
                      Container(
                          width: myWidth(context) / 3,
                          child: Text(
                            'Contacts',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                            style:
                                TextStyle(fontSize: myHeight(context) / 30.0),
                          )),
                      Spacer(),
                      Hero(
                        tag: 'search',
                        child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Search(index: 5,),
                              )),
                          child: Icon(
                            AmazingIcon.search_2_line,
                            size: myHeight(context) / 35.0,
                            color: textInverseModeColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFFE4E4E4),
                                  shape: BoxShape.circle),
                              child: Padding(
                                padding:
                                    EdgeInsets.all(myHeight(context) / 50.0),
                                child: Text(
                                  '${user.name.substring(0, 2).toUpperCase()}',
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w600,
                                      fontSize: myHeight(context) / 60.0),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0.0,
                              right: 0.0,
                              child: Container(
                                width: myHeight(context) / 55.0,
                                height: myHeight(context) / 55.0,
                                decoration: BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: dataToShow.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowDiscussion(
                                    textColor:
                                        colorsSendOnFirebase(true, index),
                                    bgcolor: colorsSendOnFirebase(false, index),
                                    user: dataToShow[index]))),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.black12))),
                          height: myHeight(context) / 8,
                          padding: EdgeInsets.symmetric(
                            vertical: myHeight(context) / 30.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    color: generateBackgroundColor(index)),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: myHeight(context) / 50.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: myWidth(context) / 2,
                                      child: Text(
                                        dataToShow[index]['name'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: myHeight(context) / 45.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                        width: myWidth(context) / 2,
                                        child: Text(
                                          'Demarrer la conversation',
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
