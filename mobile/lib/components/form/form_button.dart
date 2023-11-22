import 'package:flutter/material.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:src/utils/string.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class FormButton extends StatefulWidget {
  final String text;
  final bool isFailure;
  double width;
  double height;
  bool isNbr;
  bool isDelay;
  bool isDate;
  String miniText;
  bool isMiniText;
  bool hintTextTop;
  final TextEditingController controller;

  FormButton(
      {required this.text,
      this.isDelay = false,
      this.isNbr = false,
      this.isDate = false,
      this.miniText = "",
      this.hintTextTop = false,
      this.isMiniText = false,
      required this.controller,
      required this.isFailure,
      this.width = 320,
      this.height = 50});

  @override
  _FormButton createState() => _FormButton();
}

class _FormButton extends State<FormButton> {
  DateTime selectedDate = DateTime.now();
  final FocusNode _focusNode = FocusNode();

  _FormButton() {
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    void limitToMinimumValue() {
      final text = widget.controller.text;
      final value = int.tryParse(text) ?? 0;
      if (value < 60) {
        widget.controller.text = '60';
      } else if (value > 86400) {
        widget.controller.text = '86400';
      }
    }

    if (widget.isDelay) {
      widget.controller.addListener(limitToMinimumValue);
    }

    @override
    void dispose() {
      _focusNode.dispose();
      if (widget.isDelay == true) {
        widget.controller.removeListener(limitToMinimumValue);
        widget.controller.dispose();
      }
      super.dispose();
    }

    String formatDateTime(String originalDateTime) {
      final inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
      final outputFormat = DateFormat("MM/dd/yyyy, h:mm a");

      final dateTime = inputFormat.parse(originalDateTime);
      final formattedDateTime = outputFormat.format(dateTime);

      return formattedDateTime;
    }

    Future<void> selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (picked != null) {
        final DateTime combinedDate = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          picked.hour,
          picked.minute,
        );
        setState(() {
          selectedDate = combinedDate;
        });
        widget.controller.text = formatDateTime(selectedDate.toString());
      }
    }

    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2024),
      );

      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
        });

        selectTime(context);
      }
    }

    final capitalizeText = capitalizeFirstLetter(widget.text);
    final newText = addSpacesToCamelCase(capitalizeText);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      widget.isMiniText
          ? Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 2),
              child: Text(
                widget.miniText != "" ? widget.miniText : newText,
                style: TextStyle(
                  color: widget.isFailure ? Colors.red : Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                ),
              ))
          : Container(),
      Container(
          width: widget.width,
          height: widget.height,
          child: TextField(
            focusNode: _focusNode,
            onTap: () {
              if (widget.isDate) {
                selectDate(context);
              }
            },
            inputFormatters: widget.isDelay || widget.isNbr
                ? [FilteringTextInputFormatter.digitsOnly]
                : [],
            controller: widget.controller,
            decoration: InputDecoration(
              labelText: isFocused ? '' : newText,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: widget.isFailure
                        ? Colors.red
                        : const Color.fromRGBO(156, 156, 156, 100)),
                borderRadius: BorderRadius.circular(100),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: widget.isFailure
                        ? Colors.red
                        : const Color.fromRGBO(23, 23, 12, 1)),
                borderRadius: BorderRadius.circular(100),
              ),
              labelStyle: TextStyle(
                color: widget.isFailure
                    ? Colors.red
                    : Color.fromRGBO(53, 58, 64, 150),
              ),
              contentPadding: const EdgeInsets.only(left: 20),
              fillColor: Colors.white70,
              filled: true,
            ),
            cursorColor: const Color.fromRGBO(53, 58, 64, 0),
          ))
    ]);
  }
}

class ShowButtonWidget extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  bool isFailure;
  final void Function() onPressed;

  ShowButtonWidget(
      {required this.text,
      this.isFailure = false,
      required this.onPressed,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: isFailure ? Colors.red : const Color.fromRGBO(53, 58, 64, 150),
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}

class PasswordButtonWidget extends StatefulWidget {
  final String text;
  final bool isFailure;
  final TextEditingController controller;

  PasswordButtonWidget(
      {required this.text, required this.controller, required this.isFailure});

  @override
  _PasswordButtonWidgetState createState() => _PasswordButtonWidgetState();
}

class _PasswordButtonWidgetState extends State<PasswordButtonWidget> {
  bool obscureText = true;

  final FocusNode _focusNode = FocusNode();

  _PasswordButtonWidgetState() {
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  bool isFocused = false;

    @override
    void dispose() {
      _focusNode.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 50,
      child: TextField(
        obscureText: obscureText,
        focusNode: _focusNode,
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: isFocused ? "" : widget.text,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: widget.isFailure
                    ? Colors.red
                    : const Color.fromRGBO(156, 156, 156, 100)),
            borderRadius: BorderRadius.circular(100),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: widget.isFailure
                    ? Colors.red
                    : const Color.fromRGBO(23, 23, 12, 1)),
            borderRadius: BorderRadius.circular(100),
          ),
          labelStyle: TextStyle(
            color: widget.isFailure
                ? Colors.red
                : const Color.fromRGBO(53, 58, 64, 150),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Inter',
          ),
          contentPadding: const EdgeInsets.only(left: 20),
          fillColor: Colors.white70,
          filled: true,
          suffixIcon: ShowButtonWidget(
            text: 'Show',
            isFailure: widget.isFailure,
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
            controller: widget.controller,
          ),
        ),
        cursorColor: const Color.fromRGBO(53, 58, 64, 0),
      ),
    );
  }
}
