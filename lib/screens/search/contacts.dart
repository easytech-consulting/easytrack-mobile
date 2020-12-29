import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/screens/chat/show.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SubSearchContact extends StatelessWidget {
  final List data;
  SubSearchContact(this.data);

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

  colorsSendOnFirebase(bool isText, int index) {
    List colors;
    if (isText) {
      colors = ["2680C9", "26B0C3", "23B0C3", "61B820", "324CDE", "9A1CDD"];
    } else {
      colors = ['C9DFF2', 'C8EBF0', 'C9F6FB', 'D7EDC7', 'CBD2F7', 'E6C6F7'];
    }

    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    List contacts = data;
    return data == null
        ? Center(
            child: Text('Aucune valeur'),
          )
        : data.isEmpty
            ? Center(child: Text('Vide'))
            : ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowDiscussion(
                                textColor: colorsSendOnFirebase(true, index),
                                bgcolor: colorsSendOnFirebase(false, index),
                                user: contacts[index]))),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.black12))),
                      height: myHeight(context) / 8,
                      margin: EdgeInsets.symmetric(horizontal: 30.0),
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
                              contacts[index]['name']
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: myWidth(context) / 2,
                                  child: Text(
                                    contacts[index]['name'],
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
                });
  }
}
