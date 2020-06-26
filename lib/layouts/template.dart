import 'package:easytrack/screens/home/calendar.dart';
import 'package:easytrack/screens/home/chat.dart';
import 'package:easytrack/screens/home/shopping.dart';
import 'package:easytrack/services/mainService.dart';
import 'package:flutter/material.dart';
import 'package:bmnav/bmnav.dart' as bmnav;
import '../screens/home/home.dart';
import '../styles/style.dart';

class TemplatePage extends StatefulWidget {
  @override
  _TemplatePageState createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  int currentTab = 0;
  bool connectionLoss;
  List<FormatCommand> recents;

  @override
  void initState() {
    super.initState();
    connectionLoss = true;
    recents = fetchRecentCommands();
  }

  final List<Widget> screens = [
    HomePage(),
    ShoppingPage(),
    CalendarPage(),
    ChatPage()
  ];
  Widget currentScreen = HomePage();

  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: connectionLoss
          ? Stack(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.5),
                  child: ListView(
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 10.0),
                          child: Row(
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
                                child: Icon(
                                  Icons.search,
                                  size: 23.31,
                                  color: Color(0xff000000),
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
                              Icons.list,
                              size: 20.83,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 7.0,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 1.5,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.only(top: 1.0),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 5.8,
                                  child: Card(
                                    elevation: 1.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.horizontal(
                                            right: Radius.circular(10.0))),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              left: BorderSide(
                                                  color: recents[index]
                                                              .command
                                                              .state ==
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
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 30.0,
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: recents[index]
                                                      .products
                                                      .length,
                                                  itemBuilder: (context, ind) {
                                                    return Text(
                                                      '${recents[index].qties[ind]}x ${recents[index].products[ind].name} ',
                                                      style:
                                                          listItemCardProductStyle,
                                                    );
                                                  }),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                recents[index].command.state ==
                                                        0
                                                    ? Text(
                                                        'En cours',
                                                        style:
                                                            listItemCardStateWaitingStyle,
                                                      )
                                                    : recents[index]
                                                                .command
                                                                .state ==
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
                  )),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Color(0xffffffff).withOpacity(.98),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 110.0,
                        height: 110.0,
                        decoration: BoxDecoration(
                            color: orangeColor.withOpacity(.25),
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0))),
                        child: Icon(
                          Icons.signal_wifi_off,
                          size: 56,
                          color: orangeColor,
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        'Connexion perdue',
                        style: alertDialogTitleStyle,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Impossible d\'etablir une connexion avec notre',
                        style: bottomTextStyle,
                      ),
                      Text(
                        'Serveur. Verifier votre acces internet',
                        style: bottomTextStyle,
                      ),
                    ],
                  ),
                ),
              )
            ])
          : PageStorage(child: currentScreen, bucket: bucket),
      bottomNavigationBar: connectionLoss
          ? Container(
              color: Color(0xffffffff),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 56.0),
                child: OutlineButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    onPressed: () {
                      setState(() {
                        connectionLoss = false;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 11.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Actualiser',
                            style: subLogoSubtitleStyle,
                          ),
                          Spacer(),
                          Icon(
                            Icons.refresh,
                            size: 16,
                          )
                        ],
                      ),
                    )),
              ),
            )
          : Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                  color: gradient1.withOpacity(.9),
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: bmnav.BottomNav(
                index: currentTab,
                onTap: (i) {
                  setState(() {
                    currentTab = i;
                    currentScreen = screens[i];
                  });
                },
                iconStyle: bmnav.IconStyle(size: 18.0),
                items: [
                  bmnav.BottomNavItem(Icons.home),
                  bmnav.BottomNavItem(Icons.shopping_cart),
                  bmnav.BottomNavItem(Icons.calendar_today),
                  bmnav.BottomNavItem(Icons.bubble_chart)
                ],
              ),
            ),
    );
  }
}
