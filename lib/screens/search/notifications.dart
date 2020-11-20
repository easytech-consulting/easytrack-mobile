import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/commons/gradientIcon.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/notifications/all.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SubSearchNotification extends StatelessWidget {
  final List data;
  SubSearchNotification(this.data);

  _showDetails(context, Map notification) {
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
                        'il y a ${formatDate(DateTime.parse(notification["created_at"]))}',
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
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationsPage())),
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
                            'Acceder aux notifications',
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

  @override
  Widget build(BuildContext context) {
    List _notifications = data;
    return data == null
        ? Center(
            child: Text('Aucune valeur'),
          )
        : data.isEmpty
            ? Center(child: Text('Aucune correspondance'))
            : ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(
                      left: myHeight(context) / 40.0,
                      right: myHeight(context) / 40.0,
                      top: index == 0 ? 0 : myHeight(context) / 70),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GradientIcon(
                              AmazingIcon.message_2_line,
                              myHeight(context) / 25,
                              notificationGradient[index % 5]),
                          SizedBox(
                            width: myWidth(context) / 25.0,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _showDetails(
                                        context, _notifications[index]);
                                  },
                                  child: Text(
                                    _notifications[index]['text'],
                                    style: TextStyle(
                                        fontSize: myHeight(context) / 50,
                                        fontWeight: _notifications[index]
                                                    ['is_active'] ==
                                                0
                                            ? FontWeight.w500
                                            : FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  height: myHeight(context) / 200.0,
                                ),
                                Text(
                                  'Il y a ${formatDate(DateTime.parse(_notifications[index]["created_at"]))}',
                                  style: TextStyle(
                                      fontSize: myHeight(context) / 60,
                                      color: Colors.black54),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: myHeight(context) / 70),
                      Divider(
                        color: Colors.black.withOpacity(.05),
                        thickness: 2,
                      )
                    ],
                  ),
                ),
              );
  }
}
