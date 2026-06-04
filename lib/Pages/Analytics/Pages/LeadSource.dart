// ignore_for_file: use_build_context_synchronously, deprecated_member_use, avoid_unnecessary_containers, sized_box_for_whitespace, sort_child_properties_last, file_names

import 'dart:convert';
import 'dart:math';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:salespersontracking/ApiConfig/ApiConfig.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';
import 'package:salespersontracking/Style/TextFieldStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LeadSource extends StatefulWidget {
  const LeadSource({super.key});

  @override
  State<LeadSource> createState() => _LeadSourceState();
}

class _ChartData {
  final String category;
  final double value;
  final double height; // Height property
  final Color color;

  _ChartData(this.category, this.value, this.height, this.color);
}

class _LeadSourceState extends State<LeadSource> {
  final List<String> _list = [
    'This Year',
    'This Month',
    'This Week',
    'Last Week',
    'Last Month',
    'Last 3 Months',
    'Last 6 Months',
    'Custom Date',
  ];

  String? _selectedValue;
  String? _selectedUser;
  String formattedDate =
      DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSZ").format(DateTime.now());
  int? User_Id;
  int? Organization_Id;
  String? Terant;
  bool isLoading = true;
  List<String> UserDataList = [];
  List<Map<String, dynamic>> UserDataListfull = [];
  List<Map<String, dynamic>> SalesCustomerData = [];
  int User_ID = 0;
  int? Total_Sales;
  final TextEditingController From_Date = TextEditingController();
  final TextEditingController To_Date = TextEditingController();

  List<_ChartData> getChartData() {
    if (SalesCustomerData.isEmpty) {
      return [
        _ChartData('Category A', 35, 40, Stylecustomer.CrmColor),
      ];
    } else {
      Random random = Random();

      return SalesCustomerData[0]["lead_sources_within_period"]
          .map<_ChartData>((item) {
        Color randomColor =
            Colors.primaries[random.nextInt(Colors.primaries.length)];
        return _ChartData(
            item["source"],
            (item["total"] as num).toDouble(),
            (item["total"] as num).toDouble(),
            randomColor // Assign random color
            );
      }).toList();
    }
  }

  void GetLookUpData() async {
    try {
      String apiUrl = '${ApiConfig.baseUrl}$Terant/useradmin/UsersList/';

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
            .where((item) => item['username'] != null)
            .map((item) => item['username'].toString())
            .toList();
        contact.insert(0, "All");

        setState(() {
          UserDataList = contact;
          UserDataListfull = List<Map<String, dynamic>>.from(responseData);
          _selectedUser = "All";
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

  void GetSalesCustomerData(from, to) async {
    try {
      String apiUrl = '${ApiConfig.baseUrl}$Terant/user/AnalysticLeadSource/';

      print(" completed gigs $apiUrl");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
      };
      Map<String, dynamic> payload = {
        "Is_Deleted": false,
        "fromdate": from,
        "todate": to,
        "userid": User_ID == 0 || User_ID == null ? "all" : User_ID
      };
      print("payload gigs $payload");

      http.Response response = await http.post(
        body: jsonEncode(payload),
        Uri.parse(apiUrl),
        headers: headers,
      );

      print('ApartmentCRUD body: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        // int sum = 0;
        // int Total = responseData["lead_sources_within_period"]
        //     .map((item) => sum + item["total"])
        //     .toint();
        // print("Total_Sales $Total");

        setState(() {
          SalesCustomerData = List<Map<String, dynamic>>.from([responseData]);
          // Total_Sales = Total;
        });
        print('ApartmentCRUD List body:$SalesCustomerData');
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
      setState(() {
        From_Date.text =
            "${DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year, 1, 1))}";
        To_Date.text = "${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
        _selectedValue = "This Year";
      });

      GetSalesCustomerData(From_Date.text, To_Date.text);
    });
  }

  Future<void> HandleFromandTodate(Value) async {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat('yyyy-MM-dd'); // Change format to YYYY-MM-DD

    late DateTime fromDate;
    DateTime toDate = now;

    switch (Value) {
      case 'This Year':
        fromDate = DateTime(now.year, 1, 1);
        break;
      case 'This Month':
        fromDate = DateTime(now.year, now.month, 1);
        break;
      case 'This Week':
        fromDate = now
            .subtract(Duration(days: now.weekday - 1)); // Monday of this week
        break;
      case 'Last Week':
        DateTime lastWeek = now.subtract(Duration(days: 7 + now.weekday - 1));
        fromDate = lastWeek;
        toDate = lastWeek.add(Duration(days: 6)); // Sunday of last week
        break;
      case 'Last Month':
        DateTime lastMonth = DateTime(now.year, now.month - 1, 1);
        fromDate = lastMonth;
        toDate = DateTime(now.year, now.month, 0); // Last day of last month
        break;
      case 'Last 3 Months':
        fromDate = DateTime(now.year, now.month - 3, 1);
        break;
      case 'Last 6 Months':
        fromDate = DateTime(now.year, now.month - 6, 1);
        break;
      default:
        fromDate = now;
    }

    setState(() {
      From_Date.text = format.format(fromDate); // Convert to "YYYY-MM-DD"
      To_Date.text = format.format(toDate); // Convert to "YYYY-MM-DD"
    });

    print("From_Date ${From_Date.text}");
    print("To_Date ${To_Date.text}");
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
                    "Lead Source",
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
                                          "Choose a Period",
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
                                      ),
                                      hintText: 'Time Period',
                                      items: _list,
                                      initialItem: _selectedValue,
                                      onChanged: (value) async {
                                        await HandleFromandTodate(value);
                                        setState(() {
                                          _selectedValue = value;
                                        });
                                        GetSalesCustomerData(
                                            From_Date.text, To_Date.text);
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
                                          "Choose a Person",
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
                                      ),
                                      hintText: 'Sales Person',
                                      items: UserDataList,
                                      initialItem: _selectedUser,
                                      onChanged: (value) {
                                        if (value == "All") {
                                          setState(() {
                                            User_ID = 0;
                                            _selectedUser = value;
                                          });
                                          GetSalesCustomerData(
                                              From_Date.text, To_Date.text);
                                        } else {
                                          setState(() {
                                            _selectedUser = value;
                                            for (var item in UserDataListfull) {
                                              if (item['username'] == value) {
                                                User_ID = item['id'];
                                                break;
                                              }
                                            }
                                          });
                                          GetSalesCustomerData(
                                              From_Date.text, To_Date.text);
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if (_selectedValue == "Custom Date")
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
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      child: Row(
                                        children: [
                                          Text(
                                            "From Date",
                                            style:
                                                Stylecustomer.Textstyle14black,
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
                                      child: GestureDetector(
                                        onTap: () async {
                                          // Open the date picker dialog
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime.now(),
                                          );

                                          if (pickedDate != null) {
                                            setState(() {
                                              From_Date.text =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(pickedDate);
                                            });
                                            GetSalesCustomerData(
                                                From_Date.text, To_Date.text);
                                            print(
                                                "Booking_Date ${From_Date.text}");
                                          }
                                        },
                                        child: AbsorbPointer(
                                          child: TextField(
                                            controller: From_Date,
                                            decoration: InputDecoration(
                                              hintText: "From Date *",
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
                                              suffixIcon: const Icon(
                                                  Icons.calendar_today,
                                                  color: Colors
                                                      .grey), // Calendar icon
                                            ),
                                            readOnly:
                                                true, // Make the TextField non-editable
                                          ),
                                        ),
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
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 5, 10, 5),
                                      child: Row(
                                        children: [
                                          Text(
                                            "To Date",
                                            style:
                                                Stylecustomer.Textstyle14black,
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
                                      child: GestureDetector(
                                        onTap: () async {
                                          // Open the date picker dialog
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime
                                                .now(), // Default to current date
                                            firstDate:
                                                DateTime(2000), // Minimum date
                                            lastDate:
                                                DateTime(2100), // Maximum date
                                          );

                                          if (pickedDate != null) {
                                            // Format the picked date and update the TextField controller
                                            setState(() {
                                              To_Date.text =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(pickedDate);
                                            });
                                            GetSalesCustomerData(
                                                From_Date.text, To_Date.text);
                                            print(
                                                "Booking_Date ${From_Date.text}");
                                          }
                                        },
                                        child: AbsorbPointer(
                                          child: TextField(
                                            controller: To_Date,
                                            decoration: InputDecoration(
                                              hintText: "To Date *",
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
                                              suffixIcon: const Icon(
                                                  Icons.calendar_today,
                                                  color: Colors
                                                      .grey), // Calendar icon
                                            ),
                                            readOnly:
                                                true, // Make the TextField non-editable
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
                      if (_selectedValue == "Custom Date")
                        const SizedBox(
                          height: 15,
                        ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            // Circular Chart inside a fixed-height Container
                            Container(
                                height: 250, // Adjust height as needed
                                child: SfCircularChart(
                                  legend: const Legend(isVisible: true),
                                  series: <CircularSeries<_ChartData, String>>[
                                    DoughnutSeries<_ChartData, String>(
                                      dataSource: getChartData(),
                                      xValueMapper: (_ChartData data, _) =>
                                          data.category,
                                      yValueMapper: (_ChartData data, _) =>
                                          data.value,
                                      pointColorMapper: (_ChartData data, _) =>
                                          data.color,
                                      // Labels display height
                                      dataLabelMapper: (_ChartData data, _) =>
                                          '${data.height}',
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                        alignment: ChartAlignment.center,
                                        labelAlignment:
                                            ChartDataLabelAlignment.bottom,
                                        isVisible: true,
                                        labelPosition:
                                            ChartDataLabelPosition.inside,
                                      ),
                                      explode: true,
                                      explodeOffset: '10%',
                                      startAngle: 240,
                                      endAngle: 600,
                                      innerRadius: '40%',
                                    )
                                  ],
                                ))
                          ]))
                    ],
                    // ),
                  ),
                ),
              )),
            ])));
  }
}
