import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../styles/app_theme.dart';
import 'package:text_scroll/text_scroll.dart';

class InfoRectangle extends StatelessWidget {
  String service;
  String action;

  InfoRectangle({required this.service, required this.action});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(197, 255, 195, 100),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(service,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: "Rockwell",
                  fontWeight: FontWeight.bold,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 120),
            child: Text(action,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: "Rockwell",
                  fontWeight: FontWeight.bold,
                )),
          )
        ],
      ),
    );
  }
}

class LogRectangle extends StatelessWidget {
  String id;
  String area;
  String message;
  bool status;
  String date;

  LogRectangle(
      {this.id = "",
      this.area = "",
      this.message = "",
      this.status = false,
      this.date = ""});

  @override
  Widget build(BuildContext context) {
    String logoSuccess =
        status ? "assets/images/check.svg" : "assets/images/xmark.svg";
    Color colorSuccess = status ? Colors.green : Colors.red;
    DateTime parsedDate = DateTime.parse(date);

    String formattedDate = "${parsedDate.day}/${parsedDate.month}";
    return Container(
      width: 350,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:
            Theme.of(context).textTheme.displayLarge?.color?.withOpacity(0.9),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Container(
                width: 30,
                child: Text(
                  area,
                  style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: 16,
                    fontFamily: "Rockwell",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                width: 185,
                child: TextScroll(
                  message,
                  intervalSpaces: 10,
                  velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                  fadedBorder: false,
                  fadeBorderVisibility: FadeBorderVisibility.auto,
                  fadeBorderSide: FadeBorderSide.both,
                  style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: 16,
                    fontFamily: "Rockwell",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 0, right: 10),
              child: Container(
                width: 20,
                child: SvgPicture.asset(logoSuccess,
                    width: 30, height: 30, color: colorSuccess),
              )),
          Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                width: 50,
                child: Text(
                  formattedDate,
                  style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: 16,
                    fontFamily: "Rockwell",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
