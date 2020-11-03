import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/search/search.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

Widget header(BuildContext context, Function _onClick) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: myHeight(context) / 30.0),
    child: Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Hi, ', style: TextStyle(fontSize: myHeight(context) / 30.0)),
            Container(
                width: myWidth(context) / 3,
                child: Text(
                  '${user.name}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: myHeight(context) / 30.0),
                )),
            Spacer(),
            Hero(
              tag: 'search',
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Search(),
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
              onTap: () => _onClick(),
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFE4E4E4), shape: BoxShape.circle),
                    child: Padding(
                      padding: EdgeInsets.all(myHeight(context) / 50.0),
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
  );
}

Widget header2(BuildContext context, String title, onclick,
    {bool search = true}) {
  return Container(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              width: myWidth(context) / 3,
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(fontSize: myHeight(context) / 30.0),
              )),
          Spacer(),
          !search
              ? Container(
                  height: 0.0,
                )
              : Hero(
                  tag: 'search',
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Search(),
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
            onTap: onclick,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFE4E4E4), shape: BoxShape.circle),
                  child: Padding(
                    padding: EdgeInsets.all(myHeight(context) / 50.0),
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
  );
}

Widget sliverHeader(BuildContext context, String title, String subtitle,
    {@required bool canAdd,
    @required Function onClick,
    bool canSearch = true}) {
  return SliverAppBar(
    pinned: true,
    primary: true,
    backgroundColor: gradient1,
    flexibleSpace: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [gradient1, gradient2],
              begin: Alignment.center,
              end: Alignment.bottomRight)),
    ),
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            size: myHeight(context) / 35.0,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: myHeight(context) / 50.0,
        ),
        Text(
          title,
          style: TextStyle(
              color: Colors.white, fontSize: myHeight(context) / 40.0),
        )
      ],
    ),
    bottom: PreferredSize(
      child: Padding(
        padding: EdgeInsets.fromLTRB(myHeight(context) / 36.0, 0.0,
            myHeight(context) / 36.0, myHeight(context) / 50.0),
        child: Row(
          children: [
            Text(
              subtitle,
              style: TextStyle(
                  color: Colors.white, fontSize: myHeight(context) / 28.0),
            ),
            Spacer(),
            !canSearch
                ? Container(
                    height: 0.0,
                  )
                : GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Search())),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(
                        AmazingIcon.search_2_line,
                        color: Colors.white,
                      ),
                    ),
                  ),
            !canAdd
                ? Container(
                    height: 0.0,
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: myWidth(context) / 50.0,
                      ),
                      GestureDetector(
                          onTap: onClick,
                          child: Icon(
                            Icons.add,
                            size: myHeight(context) / 24.0,
                            color: Colors.white,
                          )),
                    ],
                  )
          ],
        ),
      ),
      preferredSize: Size.fromHeight(myHeight(context) / 20.0),
    ),
  );
}

Widget sliverHeader2(
  BuildContext context,
  String title,
  String subtitle,
) {
  return SliverAppBar(
    pinned: true,
    primary: true,
    backgroundColor: Colors.white,
    flexibleSpace: Container(
      color: Colors.transparent,
    ),
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            size: myHeight(context) / 35.0,
            color: Colors.black,
          ),
        ),
        SizedBox(
          width: myHeight(context) / 50.0,
        ),
        Text(
          title,
          style: TextStyle(
              color: Colors.black, fontSize: myHeight(context) / 40.0),
        )
      ],
    ),
    bottom: PreferredSize(
      child: Padding(
        padding: EdgeInsets.fromLTRB(myHeight(context) / 36.0, 0.0,
            myHeight(context) / 36.0, myHeight(context) / 50.0),
        child: Row(
          children: [
            Text(
              subtitle,
              style: TextStyle(
                  color: Colors.black, fontSize: myHeight(context) / 28.0),
            ),
            Spacer(),
            GestureDetector(
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search())),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Icon(
                  AmazingIcon.search_2_line,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      preferredSize: Size.fromHeight(myHeight(context) / 20.0),
    ),
  );
}
