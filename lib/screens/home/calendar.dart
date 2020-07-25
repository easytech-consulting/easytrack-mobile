import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: screenSize(context).height / 20,
          ),
          Text('A G E N D A',
              style: TextStyle(
                  color: Colors.black38,
                  fontSize: screenSize(context).height / 44,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: screenSize(context).height / 60,
          ),
          Text(
            'Equipe de serveur',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: screenSize(context).height / 35),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0),
            child: Container(
              height: screenSize(context).height / 2,
              child: Stack(
                children: <Widget>[
                  SfCalendar(
                    cellBorderColor: Colors.black,
                    firstDayOfWeek: 7,
                    minDate: DateTime.now().subtract(Duration(days: 7)),
                    headerHeight: screenSize(context).height / 10,
                    headerStyle: CalendarHeaderStyle(
                        textStyle: TextStyle(
                            fontFamily: 'Ubuntu',
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                    view: CalendarView.month,
                    dataSource: MeetingDataSource(_getDataSource()),
                    monthViewSettings: MonthViewSettings(
                        appointmentDisplayMode:
                            MonthAppointmentDisplayMode.appointment),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: screenSize(context).height / 45),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Align(
                            alignment: Alignment.topRight,
                            child: Container(
                                width: screenSize(context).height / 15,
                                height: screenSize(context).height / 18,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: screenSize(context).height / 50,
                                ))),
                        Align(
                            alignment: Alignment.topRight,
                            child: Container(
                                width: screenSize(context).height / 15,
                                height: screenSize(context).height / 18,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: screenSize(context).height / 50,
                                ))),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

List<Meeting> _getDataSource() {
  List<Meeting> meetings = <Meeting>[];
  final DateTime today = DateTime.now();
  meetings.add(Meeting(
      'Reunion du personnel',
      DateTime(today.year, today.month, today.day, 9, 0, 0),
      DateTime(today.year, today.month, today.day, 9, 0, 0)
          .add(Duration(days: 2)),
      gradient1,
      false));
  meetings.add(Meeting(
      'Depot',
      DateTime(today.year, today.month, today.day).add(Duration(days: 11)),
      DateTime(today.year, today.month, today.day).add(Duration(days: 12)),
      gradient2,
      false));
  meetings.add(Meeting(
      'Bilan hebdomadaire',
      DateTime(today.year, today.month, today.day).add(Duration(days: 20)),
      DateTime(today.year, today.month, today.day).add(Duration(days: 21)),
      lightBlueColor,
      false));
  meetings.add(Meeting(
      'Recrutement',
      DateTime(today.year, today.month, today.day).add(Duration(days: 13)),
      DateTime(today.year, today.month, today.day).add(Duration(days: 16)),
      greenColor,
      false));
  meetings.add(Meeting(
      'Ajout',
      DateTime(today.year, today.month, today.day).add(Duration(days: 29)),
      DateTime(today.year, today.month, today.day).add(Duration(days: 33)),
      orangeColor,
      false));
  meetings.add(Meeting(
      'Rendez-vous avec le directeur',
      DateTime(today.year, today.month, today.day).subtract(Duration(days: 4)),
      DateTime(today.year, today.month, today.day).subtract(Duration(days: 2)),
      redColor,
      false));

  return meetings;
}
