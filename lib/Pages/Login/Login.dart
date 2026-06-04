// ignore_for_file: file_names, deprecated_member_use, sized_box_for_whitespace, avoid_unnecessary_containers, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salespersontracking/Providers/Auth/auth_provider.dart';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:salespersontracking/Footer/Footer.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';
import 'package:salespersontracking/Style/TextFieldStyle.dart';
import 'package:salespersontracking/Validation/TextFieldValidation.dart';
import 'package:salespersontracking/Validation/ToastMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login>
    with SingleTickerProviderStateMixin {
  bool _isObscured = true;
  final TextEditingController Username = TextEditingController();
  final TextEditingController Password = TextEditingController();
  int? User_Id;
  int? Organization_Id;
  String? Terant;

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  Future<void> getSharedPreferencesValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      User_Id = prefs.getInt('User_Id') ?? 0;
      Organization_Id = prefs.getInt('Organization_Id') ?? 0;
      Terant = prefs.getString('Terant') ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    getSharedPreferencesValues().then((_) {});
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _opacityAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.14), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    Username.dispose();
    Password.dispose();
    super.dispose();
  }

  void handleuserlogin() async {
    if (Username.text.isEmpty || Password.text.isEmpty) {
      ErrorToast.showToast(
        context: context,
        title: 'Error',
        description: 'Enter Valid Details',
      );
      return;
    }

    // Call the Riverpod provider
    await ref
        .read(authProvider.notifier)
        .login(Username.text, Password.text, Terant ?? "");
  }

  // Removed old manual logic

  Future<void> storeValuesInSharedPreferencesCustomerTerant() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Terant', "");
    prefs.setBool('TerantBool', false);
  }

  void handleOverviewLogoutTerant(data) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: IntrinsicWidth(
            // Set your desired width here
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.cancel, color: Colors.grey),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Logout",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      child: Text(
                        "Are you sure you want to Logout Terant from this Device ?",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 15, 10, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(70, 40),
                              backgroundColor: Stylecustomer.CrmColor,
                              // side: const BorderSide(
                              //   width: 1.5,
                              //   color:
                              //       Color.fromARGB(255, 96, 192, 237),
                              // ),
                              //background color of button
                              //border width and color
                              shadowColor: const Color.fromARGB(
                                255,
                                180,
                                180,
                                180,
                              ),
                              elevation: 3,
                              //elevation of button
                              shape: RoundedRectangleBorder(
                                //to set border radius to button
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.fromLTRB(
                                6.0,
                                10.0,
                                6.0,
                                10.0,
                              ),
                            ),
                            onPressed: () async {
                              await storeValuesInSharedPreferencesCustomerTerant();
                              Navigator.pop(context);
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         const Tirant(),
                              //   ),
                              // );
                            },
                            child: const Text(
                              'Yes',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(70, 40),
                              backgroundColor: const Color.fromARGB(
                                255,
                                255,
                                255,
                                255,
                              ),
                              side: const BorderSide(
                                width: 1.5,
                                color: Stylecustomer.CrmColor,
                              ),
                              //background color of button
                              //border width and color
                              shadowColor: const Color.fromARGB(
                                255,
                                180,
                                180,
                                180,
                              ),
                              elevation: 3,
                              //elevation of button
                              shape: RoundedRectangleBorder(
                                //to set border radius to button
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.fromLTRB(
                                6.0,
                                10.0,
                                6.0,
                                10.0,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);

                              // Get.to(const EnterNum());
                            },
                            child: const Text(
                              'No',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Stylecustomer.CrmColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      next.when(
        data: (_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(initialIndex: 3),
            ),
          );
        },
        error: (error, stack) {
          ErrorToast.showToast(
            context: context,
            title: 'Error',
            description: error.toString(),
          );
        },
        loading: () {},
      );
    });

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return true;
        } else {
          return false;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false, // ✅ IMPORTANT
        backgroundColor: const Color(0xFFF6FCFF),
        body: Stack(
          children: [
            /// 🌿 Background Image
            Opacity(
              opacity: 0.3,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/salestracking.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            /// Overlay
            Container(color: const Color(0xFFF6FCFF).withOpacity(0.4)),

            /// Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF6FCFF), Color(0xFFEFF8FC)],
                ),
              ),
            ),

            /// Floating circles
            Positioned(
              top: -70,
              left: -60,
              child: Container(
                height: 220,
                width: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF22A6B3).withOpacity(0.14),
                ),
              ),
            ),
            Positioned(
              top: 80,
              right: -50,
              child: Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF11ABB0).withOpacity(0.12),
                ),
              ),
            ),
            Positioned(
              bottom: -90,
              right: -40,
              child: Container(
                height: 220,
                width: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3CC3CF).withOpacity(0.10),
                ),
              ),
            ),

            /// 📱 MAIN CONTENT
            SafeArea(
              child: Column(
                children: [
                  /// 🔝 FORM AREA
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        24,
                        24,
                        24,
                        MediaQuery.of(context).viewInsets.bottom + 20,
                      ),
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            children: [
                              const SizedBox(height: 18),

                              /// LOGO
                              Container(
                                height: 110,
                                width: 110,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(32),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 22,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/CRM_C_LOGO.png',
                                    height: 60,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              Text(
                                'Welcome',
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                'Log in to your account',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),

                              const SizedBox(height: 30),

                              /// FORM CARD
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 30,
                                  horizontal: 18,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 28,
                                      offset: const Offset(0, 18),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    /// USERNAME
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF4FCFF),
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      child: TextField(
                                        controller: Username,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.person,
                                            color: Color(0xFF0F8E99),
                                          ),
                                          hintText: 'Enter Username',
                                          border: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                vertical: 16,
                                              ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    /// PASSWORD
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF4FCFF),
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      child: TextField(
                                        controller: Password,
                                        obscureText: _isObscured,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.lock,
                                            color: Color(0xFF0F8E99),
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _isObscured
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isObscured = !_isObscured;
                                              });
                                            },
                                          ),
                                          hintText: 'Enter Password',
                                          border: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                vertical: 16,
                                              ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 14),

                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          'Forget Password ?',
                                          style: GoogleFonts.poppins(
                                            color: Stylecustomer.CrmColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    /// LOGIN BUTTON
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Stylecustomer.CrmColor,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          handleuserlogin();
                                        },
                                        child: ref.watch(authProvider).isLoading
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                            : Text(
                                                'Log In',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// 🔻 FIXED BOTTOM CARD WITH CENTERED ICON
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(18, 40, 18, 18),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.98),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                'By proceeding you agree to our terms and privacy policy.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.black54,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Secure login for your sales tracking.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -22,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              height: 44,
                              width: 44,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFAAF1E7),
                                    Color(0xFF1DA7B0),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.16),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.shield,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
