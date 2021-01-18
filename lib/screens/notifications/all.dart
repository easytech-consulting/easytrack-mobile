import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/commons/gradientIcon.dart';
import 'package:easytrack/data.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/home/home.dart';
import 'package:easytrack/services/notificationService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationsPage> {
  bool loading = false;
  int index = 1;

  var notificationGradient = [
    LinearGradient(
      colors: <Color>[Color(0xFF267EC9), Color(0xFF26B1C3)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    LinearGradient(
      colors: <Color>[Color(0xFFC92626), Color(0xFFFF5CEC)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    LinearGradient(
      colors: <Color>[Color(0xFFFFA412), Color(0xFFEDE51E)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    LinearGradient(
      colors: <Color>[Color(0xFF267EC9), Color(0xFF26B1C3)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    LinearGradient(
      colors: <Color>[Color(0xFF267EC9), Color(0xFF26B1C3)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  ];

  _attemptUpdate(id) async {
    setState(() {
      loading = true;
    });
    await closeNotifications(id).then((value) {
      setState(() {
        loading = false;
      });
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => NotificationsPage()));
    });
  }

  _showDetails(Map notification) {
    showDialog(
        context: context,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: myHeight(context) / 30,
                horizontal: myHeight(context) / 25),
            height: myHeight(context) * .5,
            width: myWidth(context) * .8,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: myWidth(context) / 2,
                      child: Text(
                        '${formatDate(DateTime.parse(notification["created_at"]))}',
                        style: TextStyle(
                            fontSize: myHeight(context) / 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(),
                    InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(AmazingIcon.close_line))
                  ],
                ),
                SizedBox(
                  height: myHeight(context) / 20.0,
                ),
                Container(
                  width: myWidth(context) / 1.5,
                  height: myHeight(context) / 5,
                  child: Text(
                    notification['text'],
                    style: TextStyle(
                        fontSize: myHeight(context) / 40,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _attemptUpdate(notification['id']);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [gradient1, gradient2]),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: Text(
                            'Marquer comme lu',
                            style: TextStyle(
                                color: textSameModeColor, fontSize: 18),
                          ),
                        ),
                      )),
                )
              ],
            ),
          ),
        ));
  }

  loadData(List datas, int multiplicator) {
    List result = [];
    if (datas.length <= 5 * multiplicator) {
      return datas;
    }
    for (var i = 0; i < 5 * multiplicator; i++) {
      result.add(datas[i]);
    }
    return result;
  }

  List dataShow, allData;
  Future futureNotifications;

  initData(datas) {
    allData = datas;
    dataShow = loadData(allData, index);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0xFFF8F8F8),
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF8F8F8),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(myWidth(context) / 20,
                    myHeight(context) / 80, myWidth(context) / 20, 0.0),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notifications',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: myWidth(context) / 17),
                      ),
                      IconButton(
                        icon: Icon(
                          AmazingIcon.close_fill,
                          size: myWidth(context) / 13,
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainPage())),
                      )
                    ],
                  ),
                  Expanded(
                      child: FutureBuilder(
                          future: fetchNotifications(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              globalNotifications = snapshot.data;
                              initData(snapshot.data);
                              return dataShow == null || dataShow.length == 0
                                  ? Center(
                                      child: Text('Aucune notification'),
                                    )
                                  : ListView.builder(
                                      itemCount: dataShow.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              top: index == 0
                                                  ? myHeight(context) / 30
                                                  : myHeight(context) / 50),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  GradientIcon(
                                                      AmazingIcon
                                                          .message_2_line,
                                                      myHeight(context) / 22,
                                                      notificationGradient[
                                                          index % 5]),
                                                  SizedBox(
                                                    width:
                                                        myWidth(context) / 25.0,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            _showDetails(
                                                                dataShow[
                                                                    index]);
                                                          },
                                                          child: Text(
                                                            dataShow[index]
                                                                ['text'],
                                                            style: TextStyle(
                                                                fontSize: myHeight(
                                                                        context) /
                                                                    40,
                                                                fontWeight: dataShow[index]
                                                                            [
                                                                            'is_active'] ==
                                                                        0
                                                                    ? FontWeight
                                                                        .w500
                                                                    : FontWeight
                                                                        .w600),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: myHeight(
                                                                  context) /
                                                              200.0,
                                                        ),
                                                        Text(
                                                          '${formatDate(DateTime.parse(dataShow[index]["created_at"]))}',
                                                          style: TextStyle(
                                                              fontSize: myHeight(
                                                                      context) /
                                                                  50,
                                                              color: Colors
                                                                  .black54),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                  height:
                                                      myHeight(context) / 50),
                                              Divider(
                                                color: Colors.black
                                                    .withOpacity(.05),
                                                thickness: 2,
                                              )
                                            ],
                                          ),
                                        );
                                      });
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  gradient1,
                                ),
                              ),
                            );
                          })),
                  dataShow == null || dataShow.length >= allData.length
                      ? Container(
                          height: 0.0,
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: myHeight(context) / 50),
                          child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  dataShow = loadData(allData, ++index);
                                });
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      myHeight(context) / 10.0)),
                              color: Color(0xFF267FC9).withOpacity(.08),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: myHeight(context) / 70),
                                child: Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Voir plus',
                                    style: TextStyle(
                                        color: Color(0xFF267FC9),
                                        fontWeight: FontWeight.w500,
                                        fontSize: myHeight(context) / 45),
                                  ),
                                ),
                              )),
                        )
                ]),
              ),
              !loading
                  ? Container(height: 0.0)
                  : Container(
                      color: Colors.white.withOpacity(.9),
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(gradient1),
                      ),
                    )
            ],
          ),
        ));
  }
}
