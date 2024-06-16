import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
import 'package:wambe/global_widget/custom_button.dart';
import 'package:wambe/settings/palette.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(40),
              Stack(
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height * .55,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: ScrollLoopAutoScroll(
                            duplicateChild: 12,
                            scrollDirection: Axis.vertical,
                            child: ListView.separated(
                              separatorBuilder: (context, index) => Gap(20),
                              // physics: AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/images/onboarding/Image (${index + 1}).png',
                                    height: 150,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Gap(10),
                        Expanded(
                          child: ScrollLoopAutoScroll(
                            duplicateChild: 12,
                            scrollDirection: Axis.vertical,
                            child: ListView.separated(
                              separatorBuilder: (context, index) => Gap(20),
                              // physics: AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/images/onboarding/Image (${3 + index + 1}).png',
                                    height: 200,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Gap(10),
                        Expanded(
                          child: ScrollLoopAutoScroll(
                            duplicateChild: 12,
                            scrollDirection: Axis.vertical,
                            child: ListView.separated(
                              separatorBuilder: (context, index) => Gap(20),
                              // physics: AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/images/onboarding/Image (${5 + index + 1}).png',
                                    height: 150,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Theme.of(context).colorScheme.onBackground,
                            Colors.transparent
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "Capture every \nmoment",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                  color: Palette.white,
                ),
              ),
              Text(
                "Life in motion, through your eyes, one frame at a time.",
                style: TextStyle(
                  color: Palette.white,
                ),
              ),
              Gap(20),
              CustomButton(
                onTap: () {
                  context.go('/login');
                },
                color: Theme.of(context).colorScheme.secondary,
                textColor: Theme.of(context).colorScheme.primary,
                title: "Get Started",
              )
            ],
          ),
        ),
      ),
    );
  }
}
