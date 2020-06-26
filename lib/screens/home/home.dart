import 'package:easytrack/screens/home/searchResult.dart';
import 'package:easytrack/services/mainService.dart';
import 'package:flutter/material.dart';
import '../../styles/style.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FormatCommand> recents;
  bool searchMode;

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    recents = fetchRecentCommands();
    searchMode = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [gradient1, gradient2],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.5),
            child: ListView(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
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
                                                  SearchResult(index: 0)));
                                    },
                                    controller: _controller,
                                    textInputAction: TextInputAction.done,
                                    style: TextStyle(color: Color(0xffffffff)),
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 50.0),
                                        prefixIcon: Icon(
                                            /* AmazingIcon.user_icon, */ Icons
                                                .search,
                                            color: Color(0xffffffff),
                                            size: 20.0),
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                searchMode = false;
                                              });
                                            },
                                            /* AmazingIcon.user_icon, */ icon:
                                                Icon(Icons.close,
                                                    color: Color(0xffffffff),
                                                    size: 20.0)),
                                        hintText: 'Recherche...',
                                        hintStyle: TextStyle(
                                            color: Color(0xffffffff)
                                                .withOpacity(.35),
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
                                  'img/logos/LogoWhiteWithText.png',
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
                                    Icons.search,
                                    size: 23.31,
                                    color: Color(0xffffffff),
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
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 4.25,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 19.5, vertical: 15.25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('VENTES', style: topCardTitleStyle),
                              Spacer(),
                              Text(
                                '7 derniers jours',
                                style: topCardTitleStyle,
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 16.0,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            '75%',
                            style: topCardPercentStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Taux de conversion',
                                style: topCardDescriptionStyle,
                              ),
                              Spacer(),
                              Icon(
                                Icons.insert_chart,
                                size: 20.3,
                                color: gradient1,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Container(
                            height: 5.0,
                            child: LinearProgressIndicator(
                              value: .8,
                              backgroundColor:
                                  Color(0xff000000).withOpacity(.2),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(gradient1),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 13.0,
                ),
                Text(
                  'Vos commandes recentes',
                  style: mainPartTitleStyle,
                ),
                SizedBox(
                  height: 7.0,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2.25,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 5.8,
                            child: Card(
                              elevation: 1.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(10.0))),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                            color:
                                                recents[index].command.state ==
                                                        0
                                                    ? Colors.deepOrangeAccent
                                                    : recents[index]
                                                                .command
                                                                .state ==
                                                            1
                                                        ? greenColor
                                                        : redColor))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.5, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '${recents[index].command.title}',
                                            style: listCardItemTitleStyle,
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.more_vert,
                                            size: 24.0,
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                              : recents[index].command.state ==
                                                      1
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
          )
        ],
      )),
    );
  }
}
