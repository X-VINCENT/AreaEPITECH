import 'package:flutter/material.dart';

Widget authButton({
  required String buttonText,
  required VoidCallback onPressed,
  Color? buttonColor,
  Color? borderColor,
  Color? textColor,
}) {
  return SizedBox(
    width: 320,
    height: 50,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? const Color.fromRGBO(0, 122, 255, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: BorderSide(color: borderColor ?? Colors.black, width: 1.0),
        ),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter'
        ),
      ),
    ),
  );
}
