import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextSize {
  static const double title1 = 64;
  static const double heading1 = 42;
  static const double heading2 = 32;
  static const double heading3 = 24;
  static const double heading4 = 18;
  static const double body1 = 20;
  static const double body2 = 16;
  static const double body3 = 13;
}

class AppColor {
  static const Color darkPrimaryColor = Color.fromARGB(255, 42, 63, 37);
  static const Color primaryColor = Color.fromARGB(255, 94, 139, 83);
  static const Color lightPrimaryColor = Color.fromARGB(255, 137, 203, 121);
  static const Color shadowColor = Color.fromARGB(255, 216, 216, 216);
  static const Color whiteBackround = Color.fromARGB(255, 250, 250, 250);
  static const Color text = Color.fromARGB(255, 49, 59, 47);
  static const Color textSecondary = Color.fromARGB(255, 140, 140, 140);
  static const Color iconSecondary = Color.fromARGB(255, 99, 110, 91);
  static Color textDanger = Color(Colors.redAccent[200].hashCode);
}

class AppStyle {
  static BoxShadow defaultShadow = BoxShadow(
    color: AppColor.shadowColor.withOpacity(0.5),
    offset: const Offset(1, 1),
    blurRadius: 15,
  );
}
/* Color Theme Swatches in RGBA */
// .ShadesOfGreen-1-rgba { color: rgba(42, 63, 37, 1); }
// .ShadesOfGreen-2-rgba { color: rgba(137, 203, 121, 1); }
// .ShadesOfGreen-3-rgba { color: rgba(94, 139, 83, 1); }
// .ShadesOfGreen-4-rgba { color: rgba(85, 126, 75, 1); }
// .ShadesOfGreen-5-rgba { color: rgba(68, 102, 61, 1); }

/* Color Theme Swatches in RGBA */
// .Fatigue-Green-1-rgba { color: rgba(226, 249, 208, 1); }
// .Fatigue-Green-2-rgba { color: rgba(168, 186, 154, 1); }
// .Fatigue-Green-3-rgba { color: rgba(99, 110, 91, 1); }
// .Fatigue-Green-4-rgba { color: rgba(111, 123, 102, 1); }
// .Fatigue-Green-5-rgba { color: rgba(75, 84, 70, 1); }

/* Color Theme Swatches in RGBA */
// .SAVVINA-1-rgba { color: rgba(242, 242, 242, 1); }
// .SAVVINA-2-rgba { color: rgba(216, 216, 216, 1); }
// .SAVVINA-3-rgba { color: rgba(191, 191, 191, 1); }
// .SAVVINA-4-rgba { color: rgba(165, 165, 165, 1); }
// .SAVVINA-5-rgba { color: rgba(140, 140, 140, 1); }