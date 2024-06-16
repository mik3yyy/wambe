import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wambe/blocs/media_bloc/media_bloc.dart';
import 'package:wambe/settings/hive.dart';
import 'package:wambe/settings/palette.dart';

class RoundupScreen extends StatefulWidget {
  const RoundupScreen({super.key});

  @override
  State<RoundupScreen> createState() => _RoundupScreenState();
}

class _RoundupScreenState extends State<RoundupScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MediaBloc>().add(GetuserRoundup());
  }

  final _pageController = PageController(initialPage: 0);
  int index = 0;
  @override
  Widget build(BuildContext context) {
    print(HiveFunction.getUserRoundu());
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: index == 0
          ? const Color(0xFF703EFF)
          : index == 1
              ? const Color(0xFFA63D40)
              : const Color(0xFFF72585),
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: PageView(
              onPageChanged: (value) {
                setState(() {
                  index = value;
                });
              },
              controller: _pageController,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/recap/page_1.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Center(
                    child: Transform.rotate(
                      angle: -9 *
                          3.1415926535897932 /
                          180, // Convert degrees to radians
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "You documented",
                          style: const TextStyle(
                            fontSize: 32,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  ' ${HiveFunction.getUserRoundu()?['totalMediaCount'] ?? ""}\n ',
                              style: const TextStyle(
                                  fontSize: 32, color: Color(0xFFACE894)),
                            ),
                            const TextSpan(
                              text: "amazing moments at the event!",
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Gap(70),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/images/recap/donut.png',
                              height: 104,
                              width: 103,
                            ),
                            SvgPicture.asset(
                                'assets/svgs/round_up/round_up.svg')
                          ],
                        ),
                      ),
                      const Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          text: "Your posts were liked and shared over",
                          style: TextStyle(
                              fontSize: 26,
                              color: Color(0xFF1D2B4F),
                              fontWeight: FontWeight.w600),
                          children: [
                            TextSpan(
                              text: " 200 times,",
                              style: TextStyle(
                                color: Color(0xFFACE894),
                              ),
                            ),
                            TextSpan(
                              text:
                                  " inspiring others and extending the event's reach!",
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/images/recap/dots.png',
                              height: 154,
                              width: 153,
                            ),
                            Image.asset(
                              'assets/images/recap/donut.png',
                              height: 104,
                              width: 103,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/images/recap/donut.png',
                              height: 104,
                              width: 103,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (HiveFunction.getUserRoundu()?['firstPictureByUser'] ??
                    false)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Gap(70),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/images/recap/forward.png',
                                height: 154,
                                width: 163,
                              ),
                              Image.asset(
                                'assets/images/recap/dots_3.png',
                                height: 154,
                                width: 163,
                              )
                            ],
                          ),
                        ),
                        const Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            text:
                                "Stickler for time- you recorded the first moments of the event",
                            style: TextStyle(
                                fontSize: 26,
                                color: Color(0xFF1D2B4F),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/images/recap/dots.png',
                                height: 154,
                                width: 153,
                              ),
                              Image.asset(
                                'assets/images/recap/donut.png',
                                height: 104,
                                width: 103,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/images/recap/donut.png',
                                height: 104,
                                width: 103,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
          Positioned(
            top: 80,
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: (HiveFunction.getUserRoundu()?['firstPictureByUser'] ??
                          false)
                      ? 3
                      : 2,
                  effect: WormEffect(
                    // radius: 10,
                    activeDotColor: Palette.white,
                    dotColor: Palette.grey,
                    dotHeight: 8,
                    dotWidth: 30,
                    spacing: 15,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: 20,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.cancel,
                color: Palette.white,
                size: 30,
              ),
            ),
          )
        ],
      ),
    );
  }
}
