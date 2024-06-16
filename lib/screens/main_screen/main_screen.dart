import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wambe/global_widget/mymessage_handler.dart';
import 'package:wambe/screens/main_screen/Explore_screen/explore_screen.dart';
import 'package:wambe/screens/main_screen/Home_screen/Home_screen.dart';
import 'package:wambe/screens/main_screen/Profile_screen/profile_screen.dart';
import 'package:wambe/screens/main_screen/local_widget/upload_image_popup.dart';
import 'package:wambe/screens/main_screen/roundup_screen/event_round_up.dart';
import 'package:wambe/screens/main_screen/roundup_screen/user_round_up.dart';
import 'package:wambe/settings/dev_function.dart';
import 'package:wambe/settings/hive.dart';
import 'package:wambe/settings/palette.dart';

class CustomMainScreen extends StatefulWidget {
  const CustomMainScreen({super.key});

  @override
  State<CustomMainScreen> createState() => _CustomMainScreenState();
}

class _CustomMainScreenState extends State<CustomMainScreen> {
  int _bottomNavIndex = 0;
  init() {
    if (HiveFunction.getEvent().eventEnd) {
      if (HiveFunction.getUser().eventOwner) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => EventRoundUp(),
        );
      } else {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => RoundupScreen(),
        );
      }
    }

    print(HiveFunction.getEvent().eventEnd);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Future.delayed(Duration(seconds: 1), () {
      init();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      const HomeScreen(),
      const ExploreScreen(),
      const ProfileScreen(),
      const ProfileScreen()
    ];

    return Scaffold(
      body: _screens[_bottomNavIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: DevFunctions.checkMediaCount(
                    HiveFunction.getTotalUpload(),
                    int.parse(HiveFunction.getEvent().uploadLimit)) ||
                (HiveFunction.getEvent().eventEnd)
            ? Theme.of(context).colorScheme.primary.withOpacity(.5)
            : Theme.of(context).colorScheme.primary,
        shape: CircleBorder(),
        child: Icon(Icons.add),
        //params
        onPressed: () {
          if (DevFunctions.checkMediaCount(HiveFunction.getTotalUpload(),
              int.parse(HiveFunction.getEvent().uploadLimit))) {
            if (HiveFunction.getUser().eventOwner) {
              MyMessageHandler.showSnackBar(
                  context, "Your event has reached totalMedia limit");
              return;
            }
            MyMessageHandler.showSnackBar(
                context, "Maximum User Upload Reached");
            return;
          }
          if (HiveFunction.getEvent().eventEnd) {
            MyMessageHandler.showSnackBar(context, "Event has Ended");
            return;
          }
          showFlexibleBottomSheet(
            bottomSheetColor: Colors.transparent,
            initHeight: 0.3,
            context: context,
            builder: (context, scrollController, bottomSheetOffset) {
              return UploadImage();
            },
            anchors: [0, 0.5, 1],
            isSafeArea: true,
          );
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: Palette.white,
        color: Colors.transparent,
        elevation: 10,
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              currentIndex: _bottomNavIndex,
              onTap: (value) {
                setState(() {
                  _bottomNavIndex = value;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.share),
                  label: 'Share',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              iconSize: 22,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Palette.darkAsh,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
            ),
          ),
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   // color: Palette.white,
      //   // surfaceTintColor: Palette.black.withOpacity(.1),
      //   shadowColor: Palette.black,
      //   elevation: 10,
      //   shape: CircularNotchedRectangle(),
      //   notchMargin: 8.0,
      //   child: ClipRRect(
      // borderRadius: BorderRadius.circular(30.0),
      //     child: BottomNavigationBar(
      //       backgroundColor: Palette.white,
      //       currentIndex: _bottomNavIndex,
      //       onTap: (valur) {},
      //       items: [
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.home),
      //           label: 'Home',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.explore),
      //           label: 'Explore',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.share),
      //           label: 'Share',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.person),
      //           label: 'Profile',
      //         ),
      //       ],
      //       iconSize: 22,
      //       selectedItemColor: Colors.purple,
      //       unselectedItemColor: Colors.grey,
      //       showSelectedLabels: true,
      //       showUnselectedLabels: true,
      //       type: BottomNavigationBarType.fixed,
      //     ),
      //   ),
      // ),
      // // bottomNavigationBar: BottomNavigationBar(
      //   elevation: 0,
      //   currentIndex: _bottomNavIndex,
      // selectedItemColor: Theme.of(context).colorScheme.primary,
      // unselectedItemColor: Palette.darkAsh,
      // onTap: (value) {
      //   setState(() {
      //     _bottomNavIndex = value;
      //   });
      // },
      //   type: BottomNavigationBarType.fixed,
      //   // selectedLabelStyle:
      //   //     currentIndex == 2 ? TextStyle(fontSize: 10) : null,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: _bottomNavIndex == 0
      //           ? SvgPicture.asset(
      //               'assets/svgs/home-1.svg',
      //               fit: BoxFit.fill,
      //               theme: SvgTheme(
      //                 currentColor: Theme.of(context).colorScheme.primary,
      //               ),
      //             )
      //           : SvgPicture.asset(
      //               'assets/svgs/home-2.svg',
      //               fit: BoxFit.fill,
      //             ),
      //       label: "Home",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: SizedBox(
      //         // width: 30,
      //         // height: 30,
      //         child: _bottomNavIndex == 1
      //             ? SvgPicture.asset(
      //                 'assets/svgs/explore-1.svg',
      //                 fit: BoxFit.fill,
      //                 theme: SvgTheme(
      //                   currentColor: Theme.of(context).colorScheme.primary,
      //                 ),
      //               )
      //             : SvgPicture.asset(
      //                 'assets/svgs/explore-2.svg',
      //                 fit: BoxFit.fill,
      //               ),
      //       ),
      //       label: "Explore",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: SizedBox(
      //         // width: 30,
      //         // height: 30,
      //         child: _bottomNavIndex == 2
      //             ? SvgPicture.asset(
      //                 'assets/svgs/profile-1.svg',
      //                 fit: BoxFit.fill,
      //                 theme: SvgTheme(
      //                   currentColor: Theme.of(context).colorScheme.primary,
      //                 ),
      //               )
      //             : SvgPicture.asset(
      //                 'assets/svgs/profile-2.svg',
      //                 fit: BoxFit.fill,
      //               ),
      //       ),
      //       label: "Profile",
      //     ),
      //   ],
      // ),
    );
  }
}
