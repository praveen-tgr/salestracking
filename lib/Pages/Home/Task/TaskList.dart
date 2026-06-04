// ignore_for_file: use_build_context_synchronously, deprecated_member_use, avoid_unnecessary_containers, sized_box_for_whitespace, sort_child_properties_last, file_names, non_constant_identifier_names, avoid_print


import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salespersontracking/Pages/Home/Task/CreateTask.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  String Presentdate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  bool Monthview = true;
  bool Weekview = false;
  bool Dayview = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          return false;
        },
        child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 100,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                  child: const Icon(
                    CupertinoIcons.arrow_left,
                    color: Color.fromARGB(255, 0, 0, 0),
                    size: 25,
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              toolbarHeight: MediaQuery.of(context).size.height * 0.10,
              flexibleSpace: Container(
                height: MediaQuery.of(context).size.height * 0.11,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromRGBO(7, 182, 182, 1),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    "Task",
                    style: Stylecustomer.HeaderTittleText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 40),
                  icon: const Icon(Icons.add),
                  iconSize: 30,
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateTask(),
                        ));
                  },
                ),
              ],
              automaticallyImplyLeading: false,
            ),
            body: Column(children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    Monthview = true;
                                    Weekview = false;
                                    Dayview = false;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Monthview == true
                                          ? Stylecustomer.CrmColor
                                          : Colors.white,
                                      border: Border.all(
                                          width: 1,
                                          color: Monthview == true
                                              ? Colors.white
                                              : Stylecustomer.CrmColor),
                                      borderRadius: BorderRadius.circular(5)),
                                  height: 45,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Center(
                                    child: Text(
                                      'Month',
                                      style: TextStyle(
                                        fontFamily: Stylecustomer.FontFamily,
                                        fontWeight: FontWeight.w500,
                                        color: Monthview == true
                                            ? Colors.white
                                            : Stylecustomer.CrmColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    Monthview = false;
                                    Weekview = true;
                                    Dayview = false;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Weekview == true
                                          ? Stylecustomer.CrmColor
                                          : Colors.white,
                                      border: Border.all(
                                          width: 1,
                                          color: Weekview == true
                                              ? Colors.white
                                              : Stylecustomer.CrmColor),
                                      borderRadius: BorderRadius.circular(5)),
                                  height: 45,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Center(
                                    child: Text(
                                      'Week',
                                      style: TextStyle(
                                        fontFamily: Stylecustomer.FontFamily,
                                        fontWeight: FontWeight.w500,
                                        color: Weekview == true
                                            ? Colors.white
                                            : Stylecustomer.CrmColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    Monthview = false;
                                    Weekview = false;
                                    Dayview = true;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Dayview == true
                                          ? Stylecustomer.CrmColor
                                          : Colors.white,
                                      border: Border.all(
                                          width: 1,
                                          color: Dayview == true
                                              ? Colors.white
                                              : Stylecustomer.CrmColor),
                                      borderRadius: BorderRadius.circular(5)),
                                  height: 45,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Center(
                                    child: Text(
                                      'Day',
                                      style: TextStyle(
                                        fontFamily: Stylecustomer.FontFamily,
                                        fontWeight: FontWeight.w500,
                                        color: Dayview == true
                                            ? Colors.white
                                            : Stylecustomer.CrmColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      if (Monthview == true)
                        Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.75,
                            child: MonthView(
                              controller: EventController(),
                              minMonth: DateTime(1990),
                              maxMonth: DateTime(2050),
                              initialMonth: DateTime.now(),
                              cellAspectRatio: 1,
                              onPageChange: (date, pageIndex) =>
                                  print("$date, $pageIndex"),
                              onCellTap: (events, date) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CreateTask(),
                                    ));
                              },
                              startDay: WeekDays.monday,
                              onEventTap: (event, date) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CreateTask(),
                                    ));
                              },
                              onEventDoubleTap: (events, date) => print(events),
                              onEventLongTap: (event, date) => print(event),
                              onDateLongPress: (date) => print(date),
                              headerStringBuilder: (date, {secondaryDate}) {
                                return DateFormat('MMMM - yyyy').format(date);
                              },
                              headerStyle: HeaderStyle(
                                  headerTextStyle:
                                      Stylecustomer.profileTittleText,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(7, 182, 182, 1)
                                        .withOpacity(0.2),
                                  )),
                              showWeekTileBorder: false,
                              hideDaysNotInMonth: true,
                              borderSize: 0.5,
                              showBorder: true,
                            )),
                      if (Weekview == true)
                        Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.75,
                            padding: const EdgeInsets.only(bottom: 60),
                            child: WeekView(
                              controller: EventController(),
                              eventTileBuilder:
                                  (date, events, boundry, start, end) {
                                return Container();
                              },
                              fullDayEventBuilder: (events, date) {
                                return Container();
                              },
                              showLiveTimeLineInAllDays: true,
                              minDay: DateTime(1990),
                              maxDay: DateTime(2050),
                              initialDay: DateTime.now(),
                              heightPerMinute: 1,
                              eventArranger: const SideEventArranger(),
                              onEventTap: (events, date) => print(events),
                              onEventDoubleTap: (events, date) => print(events),
                              onDateLongPress: (date) => print(date),
                              startDay: WeekDays.monday,
                              startHour: 0,
                              endHour: 24,
                              showVerticalLines: false,
                              // fullDayHeaderTitle: 'All day',
                              showWeekDayAtBottom: false,
                              weekTitleHeight: 60,
                              fullDayHeaderTextConfig:
                                  const FullDayHeaderTextConfig(
                                textAlign: TextAlign.center,
                                textOverflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              headerStringBuilder: (date, {secondaryDate}) {
                                // Get the current date (today)
                                DateTime today = date;

                                // Calculate the start of the week (Sunday)
                                DateTime startOfWeek = today.subtract(
                                    Duration(days: today.weekday - 1));

                                // Calculate the end of the week (Saturday)
                                DateTime endOfWeek =
                                    startOfWeek.add(const Duration(days: 6));

                                // Format the start and end of the week
                                String startFormatted = DateFormat('MMM dd')
                                    .format(startOfWeek); // Example: Dec 03
                                String endFormatted = DateFormat('MMM dd')
                                    .format(endOfWeek); // Example: Dec 08

                                // Get the current year
                                String year = DateFormat('yyyy')
                                    .format(today); // Example: 2024

                                // Return the formatted week header
                                return "$startFormatted to $endFormatted ($year)";
                              },
                              headerStyle: HeaderStyle(
                                  headerTextStyle:
                                      Stylecustomer.profileTittleText,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(7, 182, 182, 1)
                                        .withOpacity(0.2),
                                  )),
                              keepScrollOffset: true,
                            )),
                      if (Dayview == true)
                        Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.75,
                            padding: const EdgeInsets.only(bottom: 60),
                            child: DayView(
                              controller: EventController(),
                              eventTileBuilder:
                                  (date, events, boundry, start, end) {
                                // Return your widget to display as event tile.
                                return Container();
                              },
                              fullDayEventBuilder: (events, date) {
                                // Return your widget to display full day event view.
                                return Container();
                              },
                              showVerticalLine:
                                  true, // To display live time line in day view.
                              showLiveTimeLineInAllDays:
                                  true, // To display live time line in all pages in day view.
                              minDay: DateTime(1990),
                              maxDay: DateTime(2050),
                              initialDay: DateTime.now(),
                              heightPerMinute:
                                  1, // height occupied by 1 minute time span.
                              eventArranger:
                                  const SideEventArranger(), // To define how simultaneous events will be arranged.
                              onEventTap: (events, date) => print(events),
                              onEventDoubleTap: (events, date) => print(events),
                              onEventLongTap: (events, date) => print(events),
                              onDateLongPress: (date) => print(date),
                              startHour: 0,
                              endHour: 24,
                              // hourLinePainter: () {
                              //     return //Your custom painter.
                              // },

                              headerStyle: HeaderStyle(
                                  headerTextStyle:
                                      Stylecustomer.profileTittleText,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(7, 182, 182, 1)
                                        .withOpacity(0.2),
                                  )),
                              keepScrollOffset: true,
                            ))
                    ],
                    // ),
                  ),
                ),
              )),
            ])));
  }
}
