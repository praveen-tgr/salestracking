// ignore_for_file: file_names, deprecated_member_use, sized_box_for_whitespace, avoid_unnecessary_containers


import 'package:flutter/material.dart';
import 'package:salespersontracking/Pages/Analytics/Pages/ActivityOverview.dart';
import 'package:salespersontracking/Pages/Analytics/Pages/CallDuration.dart';
import 'package:salespersontracking/Pages/Analytics/Pages/LeadSource.dart';
import 'package:salespersontracking/Pages/Analytics/Pages/SalesDashboard.dart';
import 'package:salespersontracking/Pages/Analytics/Pages/SalesGoals.dart';
import 'package:salespersontracking/Pages/Analytics/Pages/Salesbycustomer.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            appBar: AppBar(
              backgroundColor: Colors.white,
              toolbarHeight: MediaQuery.of(context).size.height * 0.10,
              flexibleSpace: Container(
                height: MediaQuery.of(context).size.height * 0.11,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromRGBO(7, 182, 182, 1),
                      ]),
                ),
                child: Center(
                  child: Text(
                    "Analytics",
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
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.21,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SalesbyCustomer(),
                                      ));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      decoration: BoxDecoration(
                                          color: Stylecustomer.CrmColor,
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15)),
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                      child: Image.asset(
                                        'assets/images/Icons/SalesbyCustomer_analytics.png',
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Container(
                                        child: Text(
                                      "Sales by Customer",
                                      style: Stylecustomer.cardText,
                                      textAlign: TextAlign.center,
                                    ))
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.21,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ActivityOverview(),
                                      ));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      decoration: BoxDecoration(
                                          color: Stylecustomer.CrmColor,
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15)),
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                      child: Image.asset(
                                        'assets/images/Icons/ActivityOverview_analytics.png',
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Container(
                                        child: Text(
                                      "Activity Overview",
                                      style: Stylecustomer.cardText,
                                      textAlign: TextAlign.center,
                                    ))
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.21,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SalesGoals(),
                                      ));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      decoration: BoxDecoration(
                                          color: Stylecustomer.CrmColor,
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15)),
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                      child: Image.asset(
                                        'assets/images/Icons/SalesGoals_analytics.png',
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Container(
                                        child: Text(
                                      "Sales Goals",
                                      style: Stylecustomer.cardText,
                                      textAlign: TextAlign.center,
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.21,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LeadSource(),
                                      ));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      decoration: BoxDecoration(
                                          color: Stylecustomer.CrmColor,
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15)),
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                      child: Image.asset(
                                        'assets/images/Icons/LeadSource_analytics.png',
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Container(
                                        child: Text(
                                      "Lead Source",
                                      style: Stylecustomer.cardText,
                                      textAlign: TextAlign.center,
                                    ))
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.21,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CallDuration(),
                                      ));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      decoration: BoxDecoration(
                                          color: Stylecustomer.CrmColor,
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15)),
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                      child: Image.asset(
                                        'assets/images/Icons/CallDuration_analytics.png',
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Container(
                                        child: Text(
                                      "Call Duration",
                                      style: Stylecustomer.cardText,
                                      textAlign: TextAlign.center,
                                    ))
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.21,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SalesDashboard(),
                                      ));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      decoration: BoxDecoration(
                                          color: Stylecustomer.CrmColor,
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15)),
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                      child: Image.asset(
                                        'assets/images/Icons/SalesDashboard_analytics.png',
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Container(
                                        child: Text(
                                      "Sales Dashboard",
                                      style: Stylecustomer.cardText,
                                      textAlign: TextAlign.center,
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ))
            ])));
  }
}
