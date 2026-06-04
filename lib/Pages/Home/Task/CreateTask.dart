// ignore_for_file: use_build_context_synchronously, deprecated_member_use, avoid_unnecessary_containers, sized_box_for_whitespace, sort_child_properties_last, file_names


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salespersontracking/Pages/Home/Task/TaskList.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';
import 'package:salespersontracking/Style/TextFieldStyle.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  TextEditingController dateInput = TextEditingController();
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
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
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
                    "Create Task",
                    style: Stylecustomer.HeaderTittleText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  padding: const EdgeInsets.fromLTRB(0, 5, 20, 35),
                  icon: const Icon(Icons.save),
                  iconSize: 30,
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TaskList(),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.23,
                                    child: Text(
                                      "Task Name",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                    child: Text(
                                      ":",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.69,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: StyleTextfield.TextfieldColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 5, 10, 0),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: "Enter Task Name *",
                                        hintStyle: StyleTextfield.hintTextstyle,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                            color: StyleTextfield
                                                .TextfieldborderColor,
                                            width: 0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                            color: StyleTextfield
                                                .TextfieldborderColor,
                                            width: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.23,
                                    child: Text(
                                      "Project Name",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                    child: Text(
                                      ":",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.69,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: StyleTextfield.TextfieldColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 5, 10, 0),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: "Enter Project Name *",
                                        hintStyle: StyleTextfield.hintTextstyle,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                            color: StyleTextfield
                                                .TextfieldborderColor,
                                            width: 0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                            color: StyleTextfield
                                                .TextfieldborderColor,
                                            width: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.23,
                                    child: Text(
                                      "Priority",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                    child: Text(
                                      ":",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.69,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: StyleTextfield.TextfieldColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 5, 10, 0),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: "Enter Priority *",
                                        hintStyle: StyleTextfield.hintTextstyle,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                            color: StyleTextfield
                                                .TextfieldborderColor,
                                            width: 0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                            color: StyleTextfield
                                                .TextfieldborderColor,
                                            width: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.23,
                                    child: Text(
                                      "Start Date",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                    child: Text(
                                      ":",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.69,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: StyleTextfield.TextfieldColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 5, 10, 0),
                                    child: TextField(
                                      controller: dateInput,
                                      decoration: InputDecoration(
                                        hintText: "Select Start date *",
                                        hintStyle: StyleTextfield.hintTextstyle,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                            color: StyleTextfield
                                                .TextfieldborderColor,
                                            width: 0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                            color: StyleTextfield
                                                .TextfieldborderColor,
                                            width: 0,
                                          ),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: const Icon(
                                            CupertinoIcons.calendar,
                                            color:
                                                Color.fromARGB(255, 80, 79, 79),
                                            size: 20,
                                          ),
                                          onPressed: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now().add(
                                                  const Duration(
                                                      days:
                                                          1)), // Tomorrow's date
                                              firstDate: DateTime.now()
                                                  .add(const Duration(days: 1)),
                                              lastDate: DateTime(2100),
                                              builder: (BuildContext context,
                                                  Widget? child) {
                                                return Theme(
                                                  data: ThemeData.light()
                                                      .copyWith(
                                                    colorScheme:
                                                        const ColorScheme.light(
                                                      primary: Color.fromRGBO(
                                                          174,
                                                          205,
                                                          249,
                                                          1), // Header background color
                                                      onPrimary: Colors
                                                          .white, // Header text color
                                                      surface: Colors
                                                          .white, // Selected date background color
                                                      onSurface: Colors
                                                          .black, // Selected date text color
                                                    ),
                                                    // dialogBackgroundColor: Colors
                                                    //     .white, // Background color of the date picker dialog
                                                  ),
                                                  child: child!,
                                                );
                                              },
                                            );

                                            if (pickedDate != null) {
                                              String formattedDate =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(pickedDate);
                                              setState(() {
                                                dateInput.text = formattedDate;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now().add(
                                              const Duration(
                                                  days: 1)), // Tomorrow's date
                                          firstDate: DateTime.now()
                                              .add(const Duration(days: 1)),
                                          lastDate: DateTime(2100),
                                          selectableDayPredicate:
                                              (DateTime date) {
                                            // Disable Sundays
                                            if (date.weekday ==
                                                DateTime.sunday) {
                                              return false;
                                            }
                                            return true;
                                          },
                                        );

                                        if (pickedDate != null) {
                                          String formattedDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate);
                                          setState(() {
                                            dateInput.text = formattedDate;
                                          });
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.23,
                                    child: Text(
                                      "End Date",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                    child: Text(
                                      ":",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.69,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: StyleTextfield.TextfieldColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 5, 10, 0),
                                    child: TextField(
                                      controller: dateInput,
                                      decoration: InputDecoration(
                                        hintText: "Select End date *",
                                        hintStyle: StyleTextfield.hintTextstyle,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                            color: StyleTextfield
                                                .TextfieldborderColor,
                                            width: 0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                            color: StyleTextfield
                                                .TextfieldborderColor,
                                            width: 0,
                                          ),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: const Icon(
                                            CupertinoIcons.calendar,
                                            color:
                                                Color.fromARGB(255, 80, 79, 79),
                                            size: 20,
                                          ),
                                          onPressed: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now().add(
                                                  const Duration(
                                                      days:
                                                          1)), // Tomorrow's date
                                              firstDate: DateTime.now()
                                                  .add(const Duration(days: 1)),
                                              lastDate: DateTime(2100),
                                              builder: (BuildContext context,
                                                  Widget? child) {
                                                return Theme(
                                                  data: ThemeData.light()
                                                      .copyWith(
                                                    colorScheme:
                                                        const ColorScheme.light(
                                                      primary: Color.fromRGBO(
                                                          174,
                                                          205,
                                                          249,
                                                          1), // Header background color
                                                      onPrimary: Colors
                                                          .white, // Header text color
                                                      surface: Colors
                                                          .white, // Selected date background color
                                                      onSurface: Colors
                                                          .black, // Selected date text color
                                                    ),
                                                    // dialogBackgroundColor: Colors
                                                    //     .white, // Background color of the date picker dialog
                                                  ),
                                                  child: child!,
                                                );
                                              },
                                            );

                                            if (pickedDate != null) {
                                              String formattedDate =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(pickedDate);
                                              setState(() {
                                                dateInput.text = formattedDate;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now().add(
                                              const Duration(
                                                  days: 1)), // Tomorrow's date
                                          firstDate: DateTime.now()
                                              .add(const Duration(days: 1)),
                                          lastDate: DateTime(2100),
                                          selectableDayPredicate:
                                              (DateTime date) {
                                            // Disable Sundays
                                            if (date.weekday ==
                                                DateTime.sunday) {
                                              return false;
                                            }
                                            return true;
                                          },
                                        );

                                        if (pickedDate != null) {
                                          String formattedDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate);
                                          setState(() {
                                            dateInput.text = formattedDate;
                                          });
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.23,
                                    child: Text(
                                      "Owner",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                    child: Text(
                                      ":",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.69,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: StyleTextfield.TextfieldColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 5, 10, 0),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: "Enter Owner *",
                                        hintStyle: StyleTextfield.hintTextstyle,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                            color: StyleTextfield
                                                .TextfieldborderColor,
                                            width: 0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                            color: StyleTextfield
                                                .TextfieldborderColor,
                                            width: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    // ),
                  ),
                ),
              )),
            ])));
  }
}
