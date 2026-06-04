// ignore_for_file: deprecated_member_use, file_names

import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:salespersontracking/ApiConfig/ApiConfig.dart';
import 'package:salespersontracking/Pages/Mail/Compose_mail.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Mail extends StatefulWidget {
  const Mail({super.key});

  @override
  State<Mail> createState() => _MailState();
}

class _MailState extends State<Mail> {
  bool isLoading = true;
  int? User_Id;
  int? Organization_Id;
  String? Terant;
  String? Roll_Name;
  List<Map<String, dynamic>> MailData = [];

  void GetMailData() async {
    try {
      String apiUrl = '${ApiConfig.baseUrl}$Terant/user/Welcomemailsent/';

      print("Welcomemail gigs $apiUrl");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
      };

      Map<String, dynamic> payload = {
        "period": ["2024-12-31", "2025-12-31"]
        // "period": [sevenDaysBeforeDate, Presentdate]
      };

      http.Response response = await http.post(
        body: jsonEncode(payload),
        Uri.parse(apiUrl),
        headers: headers,
      );

      print('Response body: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          isLoading = false;
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

  Future<void> getSharedPreferencesValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      User_Id = prefs.getInt('User_Id') ?? 0;
      Organization_Id = prefs.getInt('Organization_Id') ?? 0;
      Terant = prefs.getString('Terant') ?? "";
      Roll_Name = prefs.getString('Roll_Name') ?? "";
    });
  }

  @override
  void initState() {
    super.initState();

    getSharedPreferencesValues().then((_) async {
      GetMailData();
    });
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
                colors: [
                  Color.fromARGB(255, 255, 255, 255),
                  Color.fromRGBO(7, 182, 182, 1),
                ],
              ),
            ),
            child: Center(
              child: Text(
                "Inbox",
                style: Stylecustomer.HeaderTittleText,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          automaticallyImplyLeading: false,
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
                      builder: (context) => const Compose(),
                    ));
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Skeletonizer(
                enabled: isLoading,
                child: ListView.builder(
                  itemCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      margin: const EdgeInsets.fromLTRB(10, 8, 10, 5),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 246, 246, 246),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Container(
                          margin: const EdgeInsets.all(4),
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: 25,
                          color: Colors.grey[300],
                        ),
                        subtitle: Container(
                          margin: const EdgeInsets.all(4),
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: 25,
                          color: Colors.grey[300],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
