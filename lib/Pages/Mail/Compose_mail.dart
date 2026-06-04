// ignore_for_file: use_build_context_synchronously, deprecated_member_use, avoid_unnecessary_containers, sized_box_for_whitespace, sort_child_properties_last, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';
import 'package:salespersontracking/Style/TextFieldStyle.dart';
import 'package:salespersontracking/Validation/ToastMessage.dart';

class Compose extends StatefulWidget {
  const Compose({super.key});

  @override
  State<Compose> createState() => _ComposeState();
}

class _ComposeState extends State<Compose> {
  bool isLoading = false;
  bool isSuccess = false;

  void _onSwipe() async {
    setState(() {
      isLoading = true;
    });

    // Simulate a delay for the loading
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
      isSuccess = true;
    });

    SuccessToast.showToast(
      context: context, 
      title: 'Success', 
      description: 'Mail Sent Successfully!'
    );
  }

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
                    "Compose",
                    style: Stylecustomer.HeaderTittleText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
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
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color:
                                    const Color.fromARGB(255, 225, 225, 225))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                              child: Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Text(
                                      "To",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.001,
                                    child: Text(
                                      ":",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.66,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: StyleTextfield.TextfieldColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 0, 5, 0),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: "Enter E-mail Id *",
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
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Text(
                                      "Cc",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.001,
                                    child: Text(
                                      ":",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.66,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: StyleTextfield.TextfieldColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 0, 5, 0),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: "Enter E-mail Id",
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
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Text(
                                      "Subject",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.001,
                                    child: Text(
                                      ":",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.66,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: StyleTextfield.TextfieldColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 0, 5, 0),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: "Enter Subject",
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Text(
                                      "",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.001,
                                    child: Text(
                                      "",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.66,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        color: StyleTextfield.TextfieldColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 0, 5, 0),
                                    child: TextField(
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                        hintText: "",
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
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Text(
                                      "",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.001,
                                    child: Text(
                                      "",
                                      style: Stylecustomer.Textstyle13black1,
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 10, 0, 5),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text(
                                            "Regards",
                                            style:
                                                Stylecustomer.Textstyle13black1,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.001,
                                          child: Text(
                                            ":",
                                            style:
                                                Stylecustomer.Textstyle13black1,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.43,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color:
                                                  StyleTextfield.TextfieldColor,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          margin: const EdgeInsets.fromLTRB(
                                              10, 0, 0, 0),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              hintText: "Enter Name",
                                              hintStyle:
                                                  StyleTextfield.hintTextstyle,
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
                        ),
                      ),
                    ],
                    // ),
                  ),
                ),
              )),
              Align(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.25,
                    0,
                    MediaQuery.of(context).size.width * 0.25,
                    10,
                  ),
                  child: isSuccess
                      ? Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(30)),
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Successful ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        )
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            SwipeButton(
                              thumbPadding: const EdgeInsets.all(3),
                              activeThumbColor: Colors.white,
                              thumb: const Icon(
                                Icons.double_arrow,
                                color: Stylecustomer.CrmColor,
                              ),
                              elevationThumb: 2,
                              elevationTrack: 2,
                              activeTrackColor: Stylecustomer.CrmColor,
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    )
                                  : const Text(
                                      "Send",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                              onSwipe: _onSwipe,
                            ),
                          ],
                        ),
                ),
              ),
            ])));
  }
}
