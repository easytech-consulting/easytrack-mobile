import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class FilePage extends StatefulWidget {
  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  final _controller = new TextEditingController();
  bool _searchMode = false;

  @override
  Widget build(BuildContext context) {
    Widget _offsetPopup() => PopupMenuButton<int>(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(myHeight(context) / 70.0)),
          onSelected: (int value) {},
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    AmazingIcon.chat_delete_line,
                    color: Color(0xff267FC9),
                    size: myHeight(context) / 40.0,
                  ),
                  SizedBox(width: 16.0),
                  Text(
                    "Selectionner",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: myHeight(context) / 50.0),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 1,
              height: kMinInteractiveDimension / 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    AmazingIcon.chat_off_line,
                    color: Color(0xff267FC9),
                    size: myHeight(context) / 40.0,
                  ),
                  SizedBox(width: 16.0),
                  Text(
                    "Sauvegarde auto.",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: myHeight(context) / 50.0),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    AmazingIcon.delete_bin_6_line,
                    color: redColor,
                    size: myHeight(context) / 40.0,
                  ),
                  SizedBox(width: 16.0),
                  Text(
                    "Supprimer",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: myHeight(context) / 50.0),
                  ),
                ],
              ),
            ),
          ],
          icon: Icon(Icons.more_vert, color: textInverseModeColor),
        );

    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
            child: SafeArea(
              child: Container(
                height: myHeight(context) / 5.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _searchMode
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Hero(
                              tag: 'search',
                              child: Container(
                                height: myHeight(context) / 17.0,
                                child: TextFormField(
                                  onFieldSubmitted: (_) {
                                    setState(() {
                                      _searchMode = false;
                                    });
                                  },
                                  controller: _controller,
                                  textInputAction: TextInputAction.done,
                                  style: TextStyle(
                                      color: textInverseModeColor,
                                      fontWeight: FontWeight.w700),
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          top: 10.0, left: 50.0),
                                      prefixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _searchMode = false;
                                                });
                                              },
                                              icon: Icon(Icons.arrow_back,
                                                  color: textInverseModeColor,
                                                  size: myHeight(context) /
                                                      30.0)),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right:
                                                    myHeight(context) / 50.0),
                                            child: Icon(
                                                AmazingIcon.search_2_line,
                                                color: textInverseModeColor,
                                                size: myHeight(context) / 37.0),
                                          ),
                                        ],
                                      ),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _searchMode = false;
                                            });
                                          },
                                          icon: Icon(AmazingIcon.close_fill,
                                              color: textInverseModeColor,
                                              size: myHeight(context) / 37.0)),
                                      hintText: 'Recherche...',
                                      hintStyle: TextStyle(
                                          color: textInverseModeColor
                                              .withOpacity(.35),
                                          fontSize: 18.0),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      )),
                                ),
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Text(
                                'Mes fichiers',
                                style: TextStyle(
                                    fontSize: myHeight(context) / 40.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              IconButton(
                                  icon: Icon(AmazingIcon.search_2_line),
                                  onPressed: () {
                                    setState(() {
                                      _searchMode = true;
                                    });
                                  }),
                              _offsetPopup()
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
        body: ListView.builder(
            itemCount: datas.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: myHeight(context) / 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          AmazingIcon.file_2_line,
                          size: myHeight(context) / 20.0,
                        ),
                        SizedBox(
                          width: myHeight(context) / 40.0,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              datas[index].title.length <=
                                      myHeight(context) ~/ 20.0
                                  ? datas[index].title
                                  : '${datas[index].title.substring(0, myHeight(context) ~/ 20.0)}...',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            SizedBox(
                              height: myHeight(context) / 200.0,
                            ),
                            RichText(
                                text: TextSpan(
                                    text: datas[index].hour,
                                    style: TextStyle(
                                        color: textInverseModeColor.withOpacity(.54),
                                        fontSize: myHeight(context) / 60),
                                    children: [
                                  TextSpan(
                                      text: datas[index].sender
                                          ? ' - Envoye par moi'
                                          : datas[index].senderName.length <=
                                                  myHeight(context) ~/ 40.0
                                              ? datas[index].senderName
                                              : ' - Envoye par ${datas[index].senderName.substring(0, myHeight(context) ~/ 40.0)}...',
                                      style: TextStyle(
                                          fontSize: myHeight(context) / 70.0))
                                ]))
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            AmazingIcon.delete_bin_6_line,
                            size: myHeight(context) / 30.0,
                            color: redColor,
                          ),
                        )
                      ],
                    ),
                    index < datas.length - 1
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: myHeight(context) / 100.0),
                            child: Divider(
                              thickness: 1.5,
                            ),
                          )
                        : Container(
                            height: 0.0,
                          )
                  ],
                ),
              );
            }));
  }
}

class Data {
  final String title;
  final String hour;
  final bool sender;
  final String senderName;

  Data(this.title, this.hour, {this.senderName, this.sender = false});
}

List<Data> datas = [
  Data('Document de strategie du travail', '7:30', sender: true),
  Data('Organisation bday 25-06-2020', '7:30', sender: true),
  Data('Rapport de finance du 18-06-2020', '7:30', sender: true),
  Data('Mise e place pour la ceremonie de reouverture', '7:30', sender: true),
];
