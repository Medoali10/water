import 'package:flutter/material.dart';

const bgColor = Color(0XFF021B3A);

const curveGradient = RadialGradient(
  colors: <Color>[
    Color(0XFF313F70),
    Color(0XFF203063),
  ],
  focalRadius: 16,
);

const vpnStyle = TextStyle(
  fontWeight: FontWeight.w600,
  color: Colors.white,
  fontSize: 34,
);

const txtSpeedStyle = TextStyle(
  fontWeight: FontWeight.w300,
  fontSize: 15,
  color: Color(0XFF6B81BD),
);

const greenGradient = LinearGradient(
  colors: <Color>[
    Color(0XFF00D58D),
    Color(0XFF00C2A0),
  ],
);


const connectedStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.w600,
  height: 1.6,
  color: Colors.white,
);
const connectedGreenStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.w600,
  color: Colors.greenAccent,
);
const connectedSubtitle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);
const locationTitleStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: Color(0XFF9BB1BD),
);

class Utils {
  static bool isToday(DateTime date) {
    var today = DateTime.now();

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return true;
    }

    return false;
  }

  static String formatNumberWithShortcuts(double number, int maxFractionDigits) {
    var thousandsNum = number / 1000;
    var millionNum = number / 1000000;

    if (number >= 1000 && number < 1000000) {
      return '${thousandsNum.toStringAsFixed(maxFractionDigits)}k';
    }

    if (number >= 1000000) {
      return '${millionNum.toStringAsFixed(maxFractionDigits)}M';
    }

    return number.toStringAsFixed(maxFractionDigits);
  }
}
