// ignore_for_file: use_build_context_synchronously, deprecated_member_use, avoid_unnecessary_containers, sized_box_for_whitespace, sort_child_properties_last, file_names

import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:salespersontracking/ApiConfig/ApiConfig.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';
import 'package:salespersontracking/Style/TextFieldStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ActivityOverview extends StatefulWidget {
  const ActivityOverview({super.key});

  @override
  State<ActivityOverview> createState() => _ActivityOverviewState();
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}

class SalesData1 {
  SalesData1(this.year, this.sales);
  final String year; // Use String instead of DateTime
  final double sales;
}

class _ActivityOverviewState extends State<ActivityOverview> {
  final List<String> _list = [
    'This Year',
    'This Month',
    'Last 3 Months',
    'Last 6 Months',
    'This Week',
    'Current Day',
  ];
  String? _selectedValue;
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  List<SalesData1>? chartData1;
  String? _selectedUser;
  String formattedDate =
      DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSZ").format(DateTime.now());
  int? User_Id;
  int? Organization_Id;
  String? Terant;
  bool isLoading = true;
  List<String> UserDataList = [];
  List<Map<String, dynamic>> UserDataListfull = [];
  List<Map<String, dynamic>> ActivityData = [];
  int User_ID = 0;
  int? Total_Sales;
  int? Average_Sales;
  final TextEditingController From_Date = TextEditingController();
  final TextEditingController To_Date = TextEditingController();

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
        });
        print('Contact List :$UserDataList');
        setState(() {
          _selectedUser = "All";
        });
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

  void GetActivityData(from, to) async {
    try {
      String apiUrl =
          '${ApiConfig.baseUrl}$Terant/user/AnalysticActivityOverview/';

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
        setState(() {
          chartData1 = ActivityData[0]["date_call_duration_data"]
              .map<SalesData1>((item) => SalesData1(
                  DateFormat('MMM dd')
                      .format(DateFormat('yyyy-MM-dd')
                          .parse(item["Date"].toString()))
                      .toString(),
                  (item["Total_Call_Duration"] as num).toDouble()))
              .toList();
          data = ActivityData[0]["Current_Total_Call_Duration"]
              .map<_ChartData>((item) => _ChartData(
                  item["Company_Name"].toString(),
                  (item["total_call_duration"] as num).toDouble()))
              .toList();
          Total_Sales = ActivityData[0]['invoice_count'];
          Average_Sales = (ActivityData[0]['Avg_sales'] as num).toInt();
          isLoading = false;
        });
        print('ApartmentCRUD List body:$responseData');
        print('chartData1:$chartData1');
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
    data = [_ChartData("", 0)];
    getSharedPreferencesValues().then((_) {
      GetLookUpData();
      setState(() {
        From_Date.text =
            "${DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year, 1, 1))}";
        To_Date.text = "${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
        _selectedValue = "This Year";
      });
      GetActivityData(From_Date.text, To_Date.text);

      _tooltip = TooltipBehavior(enable: true);
    });
  }

  Future<void> HandleFromandTodate(Value) async {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat('yyyy-MM-dd');

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
                    "Activity Overview",
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
                                        GetActivityData(
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
                                          GetActivityData(
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
                                          GetActivityData(
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
                                            print(
                                                "Booking_Date ${From_Date.text}");
                                            GetActivityData(
                                                From_Date.text, To_Date.text);
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
                                            print(
                                                "Booking_Date ${From_Date.text}");
                                            GetActivityData(
                                                From_Date.text, To_Date.text);
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
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.46,
                              height: 130,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: StyleTextfield.TextfieldColor),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 10),
                                      child: Text(
                                        "Sales Closed",
                                        style:
                                            Stylecustomer.profileTittleTextsub,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 0),
                                      child: Container(
                                        height: 70,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.47,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (isLoading == false &&
                                                    Total_Sales != 0 ||
                                                Total_Sales != null)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0,
                                                    left: 0,
                                                    right: 0,
                                                    bottom: 0),
                                                child: TweenAnimationBuilder<
                                                    double>(
                                                  tween: Tween<double>(
                                                      begin: 0,
                                                      end: (Total_Sales ?? 0)
                                                          .toDouble()),
                                                  duration: const Duration(
                                                      seconds: 3),
                                                  builder:
                                                      (context, value, child) {
                                                    return Text(
                                                      value.toStringAsFixed(0),
                                                      style: Stylecustomer
                                                          .Textstyle23graphblue,
                                                    );
                                                  },
                                                ),
                                              ),
                                            if (isLoading == true ||
                                                Total_Sales == 0 &&
                                                    Total_Sales == null)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10,
                                                    left: 0,
                                                    right: 0,
                                                    bottom: 0),
                                                child: Text(
                                                  "-----",
                                                  style: Stylecustomer
                                                      .Textstyle23graphblue,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ]),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.46,
                              height: 130,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: StyleTextfield.TextfieldColor),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 10),
                                      child: Text(
                                        "Average Sales",
                                        style:
                                            Stylecustomer.profileTittleTextsub,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 0),
                                      child: Container(
                                        height: 70,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.47,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (isLoading == false &&
                                                    Average_Sales != 0 ||
                                                Average_Sales != null)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0,
                                                    left: 0,
                                                    right: 0,
                                                    bottom: 0),
                                                child: TweenAnimationBuilder<
                                                    double>(
                                                  tween: Tween<double>(
                                                      begin: 0,
                                                      end: (Average_Sales ?? 0)
                                                          .toDouble()),
                                                  duration: const Duration(
                                                      seconds: 3),
                                                  builder:
                                                      (context, value, child) {
                                                    return Text(
                                                      value.toStringAsFixed(0),
                                                      style: Stylecustomer
                                                          .Textstyle23graphblue,
                                                    );
                                                  },
                                                ),
                                              ),
                                            if (isLoading == true ||
                                                Average_Sales == 0 &&
                                                    Average_Sales == null)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10,
                                                    left: 0,
                                                    right: 0,
                                                    bottom: 0),
                                                child: Text(
                                                  "-----",
                                                  style: Stylecustomer
                                                      .Textstyle23graphblue,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    )
                                    // Padding(
                                    //   padding: const EdgeInsets.only(
                                    //       top: 10, right: 3, left: 3),
                                    //   child: Container(
                                    //     height: 70,
                                    //     width:
                                    //         MediaQuery.of(context).size.width *
                                    //             0.45,
                                    //     child: SfSparkAreaChart(
                                    //       data: const <double>[
                                    //         35,
                                    //         28,
                                    //         34,
                                    //         32,
                                    //         10,
                                    //         50,
                                    //         45
                                    //       ], // Sample data
                                    //       color: Stylecustomer.CrmColor
                                    //           .withOpacity(
                                    //               0.5), // Fill color for the area
                                    //       borderColor: Stylecustomer.CrmColor,
                                    //       borderWidth:
                                    //           2, // Thickness of the line
                                    //       labelDisplayMode:
                                    //           SparkChartLabelDisplayMode.none,
                                    //     ),
                                    //   ),
                                    // ),
                                  ]),
                            )
                          ],
                        ),
                      ),
                      Container(
                          width: double.infinity,
                          height: 240,
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
                                      top: 10, left: 10, bottom: 10),
                                  child: Text(
                                    "Call Activities",
                                    style: Stylecustomer.profileTittleTextsub,
                                  ),
                                ),
                                Container(
                                  height:
                                      190, // Define height for the chart itself
                                  child: SfCartesianChart(
                                      primaryXAxis: CategoryAxis(
                                        interval: 1,
                                      ),
                                      primaryYAxis: const NumericAxis(
                                        minimum: 0,
                                        // maximum: 60,
                                        // interval: 10
                                      ),
                                      tooltipBehavior: _tooltip,
                                      series: <CartesianSeries<_ChartData,
                                          String>>[
                                        ColumnSeries<_ChartData, String>(
                                            dataSource: data,
                                            xValueMapper:
                                                (_ChartData data, _) =>
                                                    data.x.length > 6
                                                        ? data.x.substring(0, 6)
                                                        : data.x,
                                            yValueMapper:
                                                (_ChartData data, _) => data.y,
                                            name: '',
                                            color: Stylecustomer.CrmColor)
                                      ]),
                                )
                              ])),
                      Container(
                          width: double.infinity,
                          height: 240,
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
                                      top: 10, left: 10, bottom: 10),
                                  child: Text(
                                    "Outbond Calls Per Weekday",
                                    style: Stylecustomer.profileTittleTextsub,
                                  ),
                                ),
                                Container(
                                    height:
                                        190, // Define height for the chart itself
                                    child: SfCartesianChart(
                                      primaryXAxis:
                                          const CategoryAxis(), // Use CategoryAxis for string data
                                      series: <CartesianSeries>[
                                        // Renders line chart
                                        LineSeries<SalesData1, String>(
                                          dataSource: chartData1,
                                          xValueMapper: (SalesData1 sales, _) =>
                                              sales.year, // x is a String
                                          yValueMapper: (SalesData1 sales, _) =>
                                              sales.sales,
                                        ),
                                      ],
                                    ))
                              ])),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                    // ),
                  ),
                ),
              )),
            ])));
  }
}
