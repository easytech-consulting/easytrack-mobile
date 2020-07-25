import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/home/searchResult.dart';
import 'package:easytrack/services/mainService.dart';
import 'package:flutter/material.dart';

import '../../styles/style.dart';

class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  List<FormatCommand> recents;
  bool searchMode;

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchMode = false;
    recents = fetchRecentCommands();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.5),
        child: ListView(
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                child: searchMode
                    ? Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              height: 36.0,
                              decoration: textFormFieldBoxDecoration,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                              height: 36.0,
                              child: TextFormField(
                                onFieldSubmitted: (_) {
                                  setState(() {
                                    searchMode = false;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SearchResult(index: 1)));
                                },
                                controller: _controller,
                                textInputAction: TextInputAction.done,
                                style: TextStyle(color: Color(0xff000000)),
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 50.0),
                                    prefixIcon: Icon(
                                        /* AmazingIcon.user_icon, */ AmazingIcon
                                            .search_2_line,
                                        color: Color(0xff000000),
                                        size: 20.0),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            searchMode = false;
                                          });
                                        },
                                        /* AmazingIcon.user_icon, */ icon: Icon(
                                            AmazingIcon.close_fill,
                                            color: Color(0xff000000),
                                            size: 20.0)),
                                    hintText: 'Recherche...',
                                    hintStyle: TextStyle(
                                        color:
                                            Color(0xff000000).withOpacity(.35),
                                        fontSize: 18.0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 145.08,
                            height: 36.0,
                            child: Image.asset(
                              'img/logos/LogoWithText.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Spacer(),
                          Container(
                            height: 46.0,
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  searchMode = true;
                                });
                              },
                              child: Icon(
                                AmazingIcon.search_2_line,
                                size: 23.31,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Container(
                            width: 40.0,
                            height: 40.0,
                            child: ClipOval(
                                child: Image.asset(
                              'img/persons/person1.jpg',
                              fit: BoxFit.cover,
                            )),
                          )
                        ],
                      ),
              ),
            ),
            Divider(
              color: Colors.black.withOpacity(.2),
            ),
            SizedBox(
              height: 13.0,
            ),
            Row(
              children: <Widget>[
                Text(
                  'Mes commandes',
                  style: shoppingMainPartTitleStyle,
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    AmazingIcon.list_settings_fill,
                    size: 20.83,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 7.0,
            ),
            Container(
              height: screenSize(context).height / 1.5,
              width: screenSize(context).width,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(top: 1.0),
                      child: Container(
                        height: screenSize(context).height / 5.8,
                        child: Card(
                          elevation: 1.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(10.0))),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                        color: recents[index].command.state == 0
                                            ? Colors.deepOrangeAccent
                                            : recents[index].command.state == 1
                                                ? greenColor
                                                : redColor))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.5, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '${recents[index].command.title}',
                                        style: listCardItemTitleStyle,
                                      ),
                                      Spacer(),
                                      Icon(
                                        AmazingIcon.more_2_fill,
                                        size: 24.0,
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  Container(
                                    width: screenSize(context).width,
                                    height: 30.0,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            recents[index].products.length,
                                        itemBuilder: (context, ind) {
                                          return Text(
                                            '${recents[index].qties[ind]}x ${recents[index].products[ind].name} ',
                                            style: listItemCardProductStyle,
                                          );
                                        }),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      recents[index].command.state == 0
                                          ? Text(
                                              'En cours',
                                              style:
                                                  listItemCardStateWaitingStyle,
                                            )
                                          : recents[index].command.state == 1
                                              ? Text('Commande',
                                                  style:
                                                      listItemCardStateOrderedStyle)
                                              : Text(
                                                  'Annule',
                                                  style:
                                                      listItemCardStateCanceledStyle,
                                                ),
                                      Spacer(),
                                      Text(
                                        'Il y\'a ${recents[index].command.date}',
                                        style: listItemCardDateStyle,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: recents.length,
              ),
            )
          ],
        ),
      )),
    );
  }
}
