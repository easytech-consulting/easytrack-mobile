import 'package:easytrack/commons/layouts.dart';
import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/chat/show.dart';
import 'package:easytrack/services/contactService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class DiscussionPage extends StatefulWidget {
  @override
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  Future _contacts;

  @override
  void initState() {
    super.initState();
    _contacts = fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              height: myHeight(context) * .89,
              child: FutureBuilder(
                future: _contacts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          title: otherHeader(context),
                          floating: true,
                          primary: true,
                          pinned: true,
                          automaticallyImplyLeading: false,
                          bottom: PreferredSize(
                            preferredSize: Size.fromHeight(
                              myHeight(context) / 10.0,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(myHeight(context) / 33.0),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Chats',
                                      style: TextStyle(
                                          fontSize: myHeight(context) / 30.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(AmazingIcon.list_settings_fill)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          expandedHeight: myHeight(context) / 5.5,
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ShowDiscussion(user: snapshot.data[index]))),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: myHeight(context) / 100.0,
                                    horizontal: 20.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: myHeight(context) / 15.0,
                                      height: myHeight(context) / 15.0,
                                      alignment: Alignment.center,
                                      child: snapshot.data[index]['photo'] ==
                                              null
                                          ? Text(
                                              snapshot.data[index]['name']
                                                  .substring(0, 2)
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      myHeight(context) / 45),
                                            )
                                          : SizedBox(
                                              height: 0.0,
                                            ),
                                      decoration: snapshot.data[index]
                                                  ['photo'] ==
                                              null
                                          ? BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: generateColor())
                                          : BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'img/persons/${snapshot.data[index]['photo']}'),
                                                  fit: BoxFit.cover)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: myHeight(context) / 50.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: myWidth(context) / 1.5,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data[index]['name'],
                                                  style: TextStyle(
                                                      fontSize:
                                                          myHeight(context) /
                                                              45.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                snapshot.data[index]
                                                            ['last_message'] ==
                                                        null
                                                    ? Text('')
                                                    : Text(
                                                        formatDate(DateTime.parse(snapshot
                                                                    .data[index]
                                                                ['last_message']
                                                            ['created_at'])),
                                                        style: TextStyle(
                                                            fontSize: myHeight(
                                                                    context) /
                                                                80),
                                                      )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: myHeight(context) / 150.0,
                                          ),
                                          Container(
                                            child: snapshot.data[index]
                                                        ['last_message'] ==
                                                    null
                                                ? Text('Demarrer la conversation')
                                                : Text(
                                                    snapshot
                                                                .data[index][
                                                                    'last_message']
                                                                    ['message']
                                                                .length <=
                                                            myHeight(context) ~/
                                                                20.0
                                                        ? snapshot.data[index]
                                                                ['last_message']
                                                            ['message']
                                                        : "${snapshot.data[index]['last_message']['message'].substring(0, myHeight(context) ~/ 20.0)}...",
                                                    style: TextStyle(
                                                        fontSize:
                                                            myHeight(context) /
                                                                50.0),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            childCount: snapshot.data.length,
                          ),
                        )
                      ],
                    );
                  }
                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        title: otherHeader(context),
                        floating: true,
                        primary: true,
                        pinned: true,
                        automaticallyImplyLeading: false,
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(
                            myHeight(context) / 10.0,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(myHeight(context) / 33.0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Chats',
                                    style: TextStyle(
                                        fontSize: myHeight(context) / 30.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(AmazingIcon.list_settings_fill)
                                ],
                              ),
                            ),
                          ),
                        ),
                        expandedHeight: myHeight(context) / 5.5,
                      ),
                      SliverList(
                          delegate: SliverChildListDelegate.fixed([
                        Container(
                          height: myHeight(context) / 2,
                          child: Center(
                              child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(gradient1),
                          )),
                        )
                      ]))
                    ],
                  );
                },
              ))),
    );
  }
}
/* 
class Data {
  final int index;
  final String image;
  final String username;
  final String content;
  final DateTime date;
  Data(this.index, this.username, this.content, this.date, {this.image});
}

List<Data> datas = [
  Data(
    0,
    'Carel Essama',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    DateTime.parse('2020-02-13'),
    image: 'person1.jpg',
  ),
  Data(
    1,
    'Paul Kamegni',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    DateTime.now().subtract(Duration(hours: 2)),
    image: 'person2.jpg',
  ),
  Data(
    2,
    'Serge Nono',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    DateTime.now().subtract(Duration(hours: 20)),
    image: 'person3.jpg',
  ),
  Data(
    3,
    'Lewis Tchinda',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    DateTime.parse('2020-02-13'),
  ),
  Data(
    4,
    'Alima Soso',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    DateTime.parse('2020-01-30'),
    image: 'person5.jpg',
  ),
  Data(
    5,
    'Belinga Estelle',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    DateTime.parse('2020-08-15'),
    image: 'person6.jpg',
  ),
  Data(
    6,
    'Ebenye Vanessa',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    DateTime.parse('2020-03-13'),
    image: 'person7.jpg',
  ),
  Data(
    7,
    'Carel Essama',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    DateTime.parse('2020-02-13'),
    image: 'person8.jpg',
  ),
  Data(
    8,
    'Carel Essama',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    DateTime.parse('2020-02-13'),
  ),
  Data(
    9,
    'Alger Diana',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    DateTime.parse('2020-02-13'),
    image: 'person10.jpg',
  ),
  Data(
    10,
    'Rodrigue Ange',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    DateTime.parse('2020-02-13'),
    image: 'person11.jpg',
  ),
  Data(
    11,
    'Ange Didier',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    DateTime.parse('2020-02-13'),
  ),
  Data(
      12,
      'Carel Essama',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      DateTime.parse('2020-02-13'),
      image: 'person13.jpg'),
  Data(
      13,
      'WiltekTbs',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      DateTime.parse('2020-02-13'),
      image: 'person13.jpg'),
  Data(
    14,
    'Stephane',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    DateTime.parse('2020-02-13'),
  )
];
 */
