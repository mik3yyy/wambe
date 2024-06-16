import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:grock/grock.dart';

// import 'package:top_snackbar_flutter/custom_snack_bar.dar
// t';
// import 'package:top_snackbar_flutter/safe_area_values.dart';
// import 'package:top_snackbar_flutter/tap_bounce_container.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';
// import '../settings/constants.dart';

enum options {
  success,
  failure,
}
// enum options { success, failure, warning, info }

class MyMessageHandler {
  static void showSnackBar(BuildContext context, String message,
      {options option = options.failure, String? title}) {
    SnackBar? snackBar;
    // Grock.snackBar(
    //   title: "Snackbar",
    //   description: "Snackbar content",
    //   blur: 20,
    //   opacity: 0.2,
    //   leading: Icon(Icons.error),
    //   curve: Curves.elasticInOut,
    //   // ... vs parameters
    // );

    switch (option) {
      case options.success:
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Row(
        //       children: [
        //         const Icon(Icons.check_circle, color: Colors.white),
        //         const SizedBox(width: 10),
        //         Expanded(
        //           child: Text("$message",
        //               style: const TextStyle(color: Colors.white)),
        //         ),
        //       ],
        //     ),
        //     backgroundColor: Colors.green,
        //   ),
        // );
        FloatingSnackBar(
          message: message,
          context: context,
          textColor: Colors.white,
          textStyle: const TextStyle(color: Colors.white, fontSize: 16),
          duration: const Duration(milliseconds: 4000),
          backgroundColor: Theme.of(context).primaryColor,
        );

        break;

      case options.failure:
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                SvgPicture.asset("assets/svgs/warning.svg"),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Error: $message",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
            backgroundColor: Color(0xFFFF003D),
          ),
        );
      // FloatingSnackBar(
      //   message: message,
      //   context: context,
      //   textColor: Colors.white,
      //   textStyle: const TextStyle(color: Colors.white, fontSize: 16),
      //   duration: const Duration(milliseconds: 4000),
      //   backgroundColor: Color(0xFFFF003D),
      // );

      default:
        FloatingSnackBar(
          message: message,
          context: context,
          textColor: Colors.white,
          textStyle: const TextStyle(color: Colors.white, fontSize: 16),
          duration: const Duration(milliseconds: 4000),
          backgroundColor: Color(0xFFFF003D),
        );
    }
    //   switch (option) {
    //     case options.success:
    //       AnimatedSnackBar.material(
    //         message,
    //         type: AnimatedSnackBarType.info,
    //         mobileSnackBarPosition: MobileSnackBarPosition.bottom,
    //       ).show(context);
    //     case options.failure:
    //       AnimatedSnackBar.material(
    //         message,
    //         type: AnimatedSnackBarType.error,
    //         mobileSnackBarPosition: MobileSnackBarPosition.bottom,
    //       ).show(context);

    //       break;
    //     case options.warning:
    //       AnimatedSnackBar.material(
    //         message,
    //         type: AnimatedSnackBarType.warning,
    //         mobileSnackBarPosition: MobileSnackBarPosition.bottom,
    //       ).show(context);
    //       break;
    //     case options.info:
    //       AnimatedSnackBar.material(
    //         message,
    //         type: AnimatedSnackBarType.info,
    //         mobileSnackBarPosition: MobileSnackBarPosition.bottom,
    //       ).show(context);

    //     default:
    //       AnimatedSnackBar.material(
    //         message,
    //         type: AnimatedSnackBarType.error,
    //         mobileSnackBarPosition: MobileSnackBarPosition.bottom,
    //       ).show(context);
    //   }
  }
}
