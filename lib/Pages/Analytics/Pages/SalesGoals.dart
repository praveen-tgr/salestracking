// ignore_for_file: use_build_context_synchronously, deprecated_member_use, avoid_unnecessary_containers, sized_box_for_whitespace, sort_child_properties_last, file_names

import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:salespersontracking/ApiConfig/ApiConfig.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';
import 'package:salespersontracking/Style/TextFieldStyle.dart';

class SalesGoals extends StatefulWidget {
  const SalesGoals({super.key});

  @override
  State<SalesGoals> createState() => _SalesGoalsState();
}

class _SalesData {
  final String category; // Category (Month)
  final double finance; // Finance data
  final double territory; // Territory data

  _SalesData(this.category, this.finance, this.territory);
}

class _SalesGoalsState extends State<SalesGoals> {
  int? User_Id;
  int? Organization_Id;
  String? Terant;
  bool isLoading = true;
  List<String> UserDataList = [];
  List<Map<String, dynamic>> UserDataListfull = [];
  List<Map<String, dynamic>> ActivityData = [];
  List<String> _listFinancial = [];
  List<String> _listTerritory = [];
  String? _selectedFinancial;
  String? _selectedTerritory;
  final TextEditingController From_Date = TextEditingController();
  final TextEditingController To_Date = TextEditingController();
  List<_SalesData> _getChartData() {
    return [
      _SalesData('Jan', 30, 20),
      _SalesData('Feb', 40, 35),
      _SalesData('Mar', 35, 45),
      _SalesData('Apr', 50, 40),
      _SalesData('May', 55, 60),
      _SalesData('Jun', 45, 50),
      _SalesData('Jul', 60, 70),
      _SalesData('Aug', 55, 65),
      _SalesData('Sep', 50, 55),
      _SalesData('Oct', 65, 75),
      _SalesData('Nov', 70, 80),
      _SalesData('Dec', 75, 85),
    ];
  }

  void GetLookUpData() async {
    try {
      String apiUrl = '${ApiConfig.baseUrl}$Terant/user/SalesTargetAdditional/';

      print(" completed gigs $apiUrl");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
      };

      http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      print('Response body: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> responseData = jsonDecode(response.body);
        print('Contact List body:$responseData');
        List<String> contact = responseData
            .where((item) => item['Year'] != null)
            .map((item) => item['Year'].toString())
            .toList();
        List<String> contact1 = responseData
            .where((item) => item['Territery_Name'] != null)
            .map((item) => item['Territery_Name'].toString())
            .toList();

        setState(() {
          _listFinancial = List<String>.from(contact);
          _listTerritory = List<String>.from(contact1);
          UserDataListfull = List<Map<String, dynamic>>.from(responseData);
        });
        print('Contact List :$UserDataList');
      } else {
        print('API call failed with status code: ${jsonDecode(response.body)}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> getSharedPreferencesValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      User_Id = prefs.getInt('User_Id') ?? 0;
      Organization_Id = prefs.getInt('Organization_Id') ?? 0;
      Terant = prefs.getString('Terant') ?? "";
    });
  }

  void GetActivityData() async {
    try {
      String apiUrl = '${ApiConfig.baseUrl}$Terant/user/AnalysticSalesGoals/';

      print(" completed gigs $apiUrl");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
      };
      Map<String, dynamic> payload = {
        "Is_Deleted": false,
        "fromdate": From_Date.text,
        "todate": To_Date.text,
        "userid": "all",
        "selectedTerriteryName": _selectedTerritory,
        "selectedYear": _selectedFinancial
      };
      print('Aactivity payload: ${payload}');

      http.Response response = await http.post(
        body: jsonEncode(payload),
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        setState(() {
          ActivityData = List<Map<String, dynamic>>.from([responseData]);
        });
      } else {
        print('API call failed with status code: ${jsonDecode(response.body)}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getSharedPreferencesValues().then((_) {
      GetLookUpData();

      GetActivityData();
    });
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
                    "Sales Goals",
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
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Choose a Financial",
                                          style: Stylecustomer.Textstyle14black,
                                        ),
                                        Text(
                                          "*",
                                          style: TextStyle(
                                            fontFamily: GoogleFonts.notoSans()
                                                .fontFamily,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromARGB(
                                                255, 186, 4, 4),
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // height: 45,
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    padding: const EdgeInsets.only(left: 10),
                                    child: CustomDropdown<String>(
                                      decoration: CustomDropdownDecoration(
                                          hintStyle:
                                              StyleTextfield.hintTextstyle,
                                          headerStyle: Stylecustomer
                                              .profileTittleTextsub,
                                          closedBorderRadius:
                                              BorderRadius.circular(8),
                                          closedErrorBorderRadius:
                                              BorderRadius.circular(8),
                                          expandedBorderRadius:
                                              BorderRadius.circular(8),
                                          expandedBorder: Border.all(
                                            color: StyleTextfield
                                                .TextfieldborderColor,
                                            width: 0.8,
                                          ),
                                          closedBorder: Border.all(
                                            color: const Color.fromRGBO(
                                                217, 217, 217, 1),
                                            width: 0.8,
                                          ),
                                          closedErrorBorder: Border.all(
                                            color: StyleTextfield
                                                .TextfieldborderColor,
                                            width: 0.8,
                                          ),
                                          closedFillColor:
                                              StyleTextfield.TextfieldColor,
                                          expandedFillColor:
                                              StyleTextfield.TextfieldColor,
                                          listItemStyle: Stylecustomer
                                              .profileTittleTextsubdrop),
                                      hintText: 'Financial Period',
                                      items: _listFinancial,
                                      initialItem: _selectedFinancial,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedFinancial = value;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              padding: const EdgeInsets.only(right: 10),
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Choose a Territory",
                                          style: Stylecustomer.Textstyle14black,
                                        ),
                                        Text(
                                          "*",
                                          style: TextStyle(
                                            fontFamily: GoogleFonts.notoSans()
                                                .fontFamily,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromARGB(
                                                255, 186, 4, 4),
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // height: 45,
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    padding: const EdgeInsets.only(left: 0),
                                    child: CustomDropdown<String>(
                                      decoration: CustomDropdownDecoration(
                                        hintStyle: StyleTextfield.hintTextstyle,
                                        closedBorderRadius:
                                            BorderRadius.circular(8),
                                        closedErrorBorderRadius:
                                            BorderRadius.circular(8),
                                        expandedBorderRadius:
                                            BorderRadius.circular(8),
                                        expandedBorder: Border.all(
                                          color: StyleTextfield
                                              .TextfieldborderColor,
                                          width: 0.8,
                                        ),
                                        closedBorder: Border.all(
                                          color: StyleTextfield
                                              .TextfieldborderColor,
                                          width: 0.8,
                                        ),
                                        closedErrorBorder: Border.all(
                                          color: StyleTextfield
                                              .TextfieldborderColor,
                                          width: 0.8,
                                        ),
                                        closedFillColor:
                                            StyleTextfield.TextfieldColor,
                                        expandedFillColor:
                                            StyleTextfield.TextfieldColor,
                                        listItemStyle: Stylecustomer
                                            .profileTittleTextsubdrop,
                                        headerStyle:
                                            Stylecustomer.profileTittleTextsub,
                                      ),
                                      hintText: 'Territory',
                                      items: _listTerritory,
                                      initialItem: _selectedTerritory,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedTerritory = value;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: double.infinity,
                          height: 410,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: StyleTextfield.TextfieldColor),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 10, bottom: 40),
                                  child: Text(
                                    "Sales Goals",
                                    style: Stylecustomer.profileTittleTextsub,
                                  ),
                                ),
                                SfCartesianChart(
                                  primaryXAxis: const CategoryAxis(
                                    title: AxisTitle(text: 'Month'),
                                  ),
                                  primaryYAxis: const NumericAxis(
                                    title: AxisTitle(text: 'Amount'),
                                  ),
                                  series: <SplineSeries<_SalesData, String>>[
                                    SplineSeries<_SalesData, String>(
                                      dataSource: _getChartData(),
                                      xValueMapper: (_SalesData data, _) =>
                                          data.category, // Months
                                      yValueMapper: (_SalesData data, _) =>
                                          data.finance,
                                      color: Stylecustomer.CrmColor,
                                      name: 'Finance',
                                      markerSettings:
                                          const MarkerSettings(isVisible: true),
                                    ),
                                    SplineSeries<_SalesData, String>(
                                      dataSource: _getChartData(),
                                      xValueMapper: (_SalesData data, _) =>
                                          data.category, // Months
                                      yValueMapper: (_SalesData data, _) =>
                                          data.territory,
                                      color: Colors
                                          .red, // Line color for Territory
                                      name:
                                          'Territory', // Name for the second curve
                                      markerSettings:
                                          const MarkerSettings(isVisible: true),
                                    ),
                                  ],
                                ),
                              ]))
                    ],
                    // ),
                  ),
                ),
              )),
            ])));
  }
}
