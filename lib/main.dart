// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously

import 'dart:io';

// import 'package:crm_main_app/Footer/Footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:salespersontracking/Controller/Network/ApiService.dart';
import 'package:salespersontracking/Controller/Network/NetworkController.dart';
import 'package:salespersontracking/Footer/Footer.dart';
import 'package:salespersontracking/Pages/Login/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// void initializeCometChat() {
//   final appID = dotenv.env['APP_ID'] ?? '';
//   final region = dotenv.env['REGION'] ?? '';
//   final authKey = dotenv.env['AUTH_KEY'] ?? '';

//   if (appID.isNotEmpty && region.isNotEmpty && authKey.isNotEmpty) {
//     CometChat.init(appID, CometChatInitOptions(region: region)).then((value) {
//       print("CometChat Initialized Successfully");
//     }).catchError((error) {
//       print("CometChat Initialization Failed: ${error.message}");
//     });
//   } else {
//     print("Missing CometChat configuration in .env");
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await dotenv.load(fileName: ".env");
  final apiService = await ApiService.create();

  runApp(
    ProviderScope(
      child: MultiProvider(
        providers: [
          Provider(create: (_) => apiService),
          ChangeNotifierProvider(create: (_) => ConnectivityService()),
          // ChangeNotifierProvider(create: (_) => PiPModeNotifier()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRMFARM',
      theme: ThemeData(),
      home: UpgradeAlert(child: const MyHomePage(title: '')),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> storeValuesInSharedPreferencesCustomer1(terant) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Terant', terant);
    prefs.setBool('TerantBool', true);
  }

  void CheckTirant() async {
    storeValuesInSharedPreferencesCustomer1("salestracking");
    // storeValuesInSharedPreferencesCustomer1("reluxcrm");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? Terant = "salestracking";
    // String? Terant = "relux";
    bool? TerantBool = true;
    // bool? TerantBool = prefs.getBool("TerantBool");
    if (TerantBool == true && Terant != null) {
      CheckLogin();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  Future<void> storeValuesInSharedPreferencesCustomer(
    User_Id,
    Organization_Id,
    username,
    fullname,
    email,
    Designation,
    PhoneNo,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('LoginBool', true);
    prefs.setInt('User_Id', User_Id);
    prefs.setInt('Organization_Id', Organization_Id);
    prefs.setString('username', username);
    prefs.setString('fullname', fullname);
    prefs.setString('email', email);
    prefs.setString('Designation', Designation);
    prefs.setString('PhoneNo', PhoneNo);
  }

  void CheckLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? User_Id = prefs.getInt("User_Id");
    bool? LoginBool = prefs.getBool("LoginBool");
    if (LoginBool == true && User_Id != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(initialIndex: 2)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        WidgetAnimator(
                          incomingEffect:
                              WidgetTransitionEffects.incomingScaleUp(
                                duration: const Duration(seconds: 1),
                              ),
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Image.asset(
                              'assets/images/CRM_C_LOGO.png',
                              height: 100,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextAnimator(
                                'CRM',
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w400,
                                ),
                                incomingEffect:
                                    WidgetTransitionEffects.outgoingOffsetThenScale(),
                                initialDelay: const Duration(seconds: 1),
                                characterDelay: const Duration(
                                  milliseconds: 200,
                                ),
                              ),
                              const SizedBox(width: 1),
                              TextAnimator(
                                'FARM',
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                                incomingEffect:
                                    WidgetTransitionEffects.incomingOffsetThenScale(),
                                initialDelay: const Duration(seconds: 2),
                                characterDelay: const Duration(
                                  milliseconds: 200,
                                ),
                                onIncomingAnimationComplete: (p0) {
                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    () {
                                      CheckTirant();
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
