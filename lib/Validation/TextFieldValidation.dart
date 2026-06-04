import 'package:flutter/services.dart';

class EmailIdValidation extends TextInputFormatter {
  final int maxLength;

  // Constructor to set maximum length
  EmailIdValidation(
      {this.maxLength = 10}); // Default length of 10, can be customized

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Filter to allow only letters, numbers, @, and .
    String filteredValue =
        newValue.text.replaceAll(RegExp(r'[^a-zA-Z0-9@.]'), '');

    // Ensure the first character is lowercase if it's a letter
    if (filteredValue.isNotEmpty &&
        filteredValue[0].contains(RegExp(r'[a-zA-Z]'))) {
      filteredValue =
          filteredValue[0].toLowerCase() + filteredValue.substring(1);
    }

    // Enforce the maximum length
    if (filteredValue.length > maxLength) {
      filteredValue = filteredValue.substring(0, maxLength);
    }

    // Calculate the new cursor position after formatting
    int cursorPosition =
        newValue.selection.baseOffset.clamp(0, filteredValue.length);

    // Return the filtered text with the cursor at the adjusted position
    return TextEditingValue(
      text: filteredValue,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

class FirstLetterUpperCaseFormatter extends TextInputFormatter {
  final int maxLength;

  // Constructor to set maximum length
  FirstLetterUpperCaseFormatter({required this.maxLength});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove any non-alphabetic characters except spaces
    String filteredValue = newValue.text.replaceAll(RegExp(r'[^a-zA-Z ]'), '');

    // Ensure the first character is not a space
    if (filteredValue.startsWith(' ')) {
      filteredValue = filteredValue.trimLeft();
    }

    if (filteredValue.isEmpty) return const TextEditingValue(text: '');

    // Enforce maximum length
    if (filteredValue.length > maxLength) {
      filteredValue = filteredValue.substring(0, maxLength);
    }

    // Capitalize the first letter and make the rest lowercase
    String formattedValue = filteredValue[0].toUpperCase() +
        filteredValue.substring(1).toLowerCase();

    // Calculate the new cursor position after formatting
    int cursorPosition = newValue.selection.baseOffset;
    cursorPosition = cursorPosition.clamp(0, formattedValue.length);

    // Return the updated text with the cursor at the adjusted position
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

class MobileNoValidation extends TextInputFormatter {
  final int maxLength;

  // Constructor to set maximum length
  MobileNoValidation({this.maxLength = 10});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove any non-numeric characters
    String filteredValue = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Enforce maximum length
    if (filteredValue.length > maxLength) {
      filteredValue = filteredValue.substring(0, maxLength);
    }

    // Calculate the new cursor position based on the old cursor position
    int cursorPosition = newValue.selection.baseOffset;
    if (cursorPosition > filteredValue.length) {
      cursorPosition = filteredValue.length;
    }

    // Return the filtered numeric value with the adjusted cursor position
    return TextEditingValue(
      text: filteredValue,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

class LowerCaseNoSpacesFormatter extends TextInputFormatter {
  final int maxLength;

  // Constructor to set maximum length
  LowerCaseNoSpacesFormatter({required this.maxLength});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove any non-alphabetic characters and spaces
    String filteredValue = newValue.text.replaceAll(RegExp(r'[^a-zA-Z]'), '');

    // Enforce maximum length
    if (filteredValue.length > maxLength) {
      filteredValue = filteredValue.substring(0, maxLength);
    }

    // Convert to lowercase
    String formattedValue = filteredValue.toLowerCase();

    // Calculate the new cursor position after formatting
    int cursorPosition = newValue.selection.baseOffset;
    cursorPosition = cursorPosition.clamp(0, formattedValue.length);

    // Return the updated text with the cursor at the adjusted position
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

class Terantandusername extends TextInputFormatter {
  final int maxLength;

  // Constructor to set maximum length
  Terantandusername({required this.maxLength});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove any non-alphanumeric characters (no special characters, allow spaces and numbers)
    String filteredValue =
        newValue.text.replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), '');

    // Ensure the first character is not a space
    if (filteredValue.startsWith(' ')) {
      filteredValue = filteredValue.trimLeft();
    }

    // If filtered value is empty, return empty string
    if (filteredValue.isEmpty) return const TextEditingValue(text: '');

    // Enforce maximum length
    if (filteredValue.length > maxLength) {
      filteredValue = filteredValue.substring(0, maxLength);
    }

    // We don't want to capitalize the first letter, so just make the rest lowercase
    String formattedValue =
        filteredValue[0] + filteredValue.substring(1).toLowerCase();

    // Calculate the new cursor position after formatting
    int cursorPosition = newValue.selection.baseOffset;
    cursorPosition = cursorPosition.clamp(0, formattedValue.length);

    // Return the updated text with the cursor at the adjusted position
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

class NumbersOnlyFormatter extends TextInputFormatter {
  final int maxLength;

  // Constructor to set maximum length
  NumbersOnlyFormatter({required this.maxLength});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove any non-numeric characters
    String filteredValue = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Enforce maximum length
    if (filteredValue.length > maxLength) {
      filteredValue = filteredValue.substring(0, maxLength);
    }

    // Adjust cursor position to maintain its correct place
    int cursorPosition = newValue.selection.baseOffset -
        (newValue.text.length - filteredValue.length);

    // Ensure cursor position is within valid bounds
    cursorPosition = cursorPosition.clamp(0, filteredValue.length);

    return TextEditingValue(
      text: filteredValue,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

class AlphanumericWithSpacesFormatter extends TextInputFormatter {
  final int maxLength;

  // Constructor to set maximum length
  AlphanumericWithSpacesFormatter({required this.maxLength});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow only letters (a-z, A-Z), numbers (0-9), and spaces
    String filteredValue =
        newValue.text.replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), '');

    // Enforce maximum length
    if (filteredValue.length > maxLength) {
      filteredValue = filteredValue.substring(0, maxLength);
    }

    // Preserve the cursor position by adjusting it properly
    int cursorPosition = newValue.selection.baseOffset -
        (newValue.text.length - filteredValue.length);

    // Ensure cursor position is within valid bounds
    cursorPosition = cursorPosition.clamp(0, filteredValue.length);

    return TextEditingValue(
      text: filteredValue,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

class AlphaWithSpacesFormatter extends TextInputFormatter {
  final int maxLength;

  // Constructor to set maximum length
  AlphaWithSpacesFormatter({required this.maxLength});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow only letters (a-z, A-Z), numbers (0-9), and spaces
    String filteredValue = newValue.text.replaceAll(RegExp(r'[^a-zA-Z ]'), '');

    // Enforce maximum length
    if (filteredValue.length > maxLength) {
      filteredValue = filteredValue.substring(0, maxLength);
    }

    // Preserve the cursor position by adjusting it properly
    int cursorPosition = newValue.selection.baseOffset -
        (newValue.text.length - filteredValue.length);

    // Ensure cursor position is within valid bounds
    cursorPosition = cursorPosition.clamp(0, filteredValue.length);

    return TextEditingValue(
      text: filteredValue,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

class LengthRestrictedFormatter extends TextInputFormatter {
  final int maxLength;

  // Constructor to set the maximum length
  LengthRestrictedFormatter({required this.maxLength});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If text exceeds maxLength, trim it
    if (newValue.text.length > maxLength) {
      String trimmedText = newValue.text.substring(0, maxLength);

      // Adjust cursor position to stay at the end
      int cursorPosition = trimmedText.length;

      return TextEditingValue(
        text: trimmedText,
        selection: TextSelection.collapsed(offset: cursorPosition),
      );
    }

    // If within limit, return normally
    return newValue;
  }
}
