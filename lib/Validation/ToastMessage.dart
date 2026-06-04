
import 'package:flutter/material.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';
import 'package:toastification/toastification.dart';

class SuccessToast {
  static void showToast({
    required BuildContext context,
    required String title,
    required String description,
    ToastificationType type = ToastificationType.success,
    Color primaryColor = Stylecustomer.CrmColor,
    Duration autoCloseDuration = const Duration(seconds: 5),
    EdgeInsets margin = const EdgeInsets.only(right: 15, left: 15, top: 40),
  }) {
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: autoCloseDuration,
      title: Text(title),
      description: Text(description),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      margin: margin,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(Icons.check),
      showIcon: true,
      primaryColor: primaryColor,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.always,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) {
          print('Toast ${toastItem.id} close button tapped');
          toastification.dismiss(toastItem);
        },
        onAutoCompleteCompleted: (toastItem) =>
            print('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
      ),
    );
  }
}

class ErrorToast {
  static void showToast({
    required BuildContext context,
    required String title,
    required String description,
    ToastificationType type = ToastificationType.error,
    Color primaryColor = const Color.fromARGB(255, 232, 22, 22),
    Duration autoCloseDuration = const Duration(seconds: 5),
    EdgeInsets margin = const EdgeInsets.only(right: 15, left: 15, top: 40),
  }) {
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: autoCloseDuration,
      title: Text(title),
      description: Text(description),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      margin: margin,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(Icons.error),
      showIcon: true,
      primaryColor: primaryColor,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.always,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) {
          print('Toast ${toastItem.id} close button tapped');
          toastification.dismiss(toastItem);
        },
        onAutoCompleteCompleted: (toastItem) =>
            print('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
      ),
    );
  }
}
