import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wambe/blocs/media_bloc/media_bloc.dart';
import 'package:wambe/models/media_data.dart';
import 'package:wambe/settings/dev_function.dart';
import 'package:wambe/settings/hive.dart';
import 'package:wambe/settings/palette.dart';

class EventRoundUp extends StatefulWidget {
  const EventRoundUp({super.key});

  @override
  State<EventRoundUp> createState() => _EventRoundUpState();
}

class _EventRoundUpState extends State<EventRoundUp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<MediaBloc>().add(GetEventRoundup());
    init();
  }

  PageController _pageController = PageController(initialPage: 0);

  init() async {
    for (int i = 1; i < 5; i++) {
      await Future.delayed(
        Duration(seconds: 5),
        () {
          _pageController.animateToPage(
            i,
            duration: Duration(milliseconds: 1300),
            curve: Curves.linear,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MediaBloc, MediaState>(
      listener: (context, state) {
        print(state);
      },
      builder: (context, state) {
        if (state is MediaProcessing && state.isEventRoundup) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/recap/recap.png',
                    ),
                    Gap(20),
                    Container(
                      height: 100,
                      width: 168,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              'assets/images/recap/year_holder.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 13,
                            left: 35,
                            child: Text(
                              "2024",
                              style: TextStyle(
                                fontSize: 33,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(),
                Column(
                  children: [
                    Text(
                      " 🎉 Your Event in Focus!",
                      style: TextStyle(color: Palette.white, fontSize: 16),
                    ),
                    Gap(50),
                    Icon(
                      Icons.arrow_upward,
                      color: Palette.white,
                    ),
                    // Gap(40)
                  ],
                ),
              ],
            ),
          );
        }
        return Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xFF4158D0),
                  Color(0xFFC850C0),
                  Color(0xFFFFCC70),
                ],
              ),
            ),
            child: PageView(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                context.pop();
                              },
                              icon: Image.asset(
                                'assets/images/recap/cancel.png',
                                fit: BoxFit.cover,
                              ),
                            )
                          ],
                        ),
                        Gap(20),
                        Image.asset(
                          'assets/images/recap/recap.png',
                        ),
                        Gap(20),
                        Container(
                          height: 100,
                          width: 168,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  'assets/images/recap/year_holder.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 13,
                                left: 35,
                                child: Text(
                                  "${HiveFunction.getEventRoundu().startDate.year}",
                                  style: TextStyle(
                                    fontSize: 33,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(),
                    Column(
                      children: [
                        Text(
                          " 🎉 Your Event in Focus!",
                          style: TextStyle(color: Palette.white, fontSize: 16),
                        ),
                        Gap(50),
                        Icon(
                          Icons.arrow_upward,
                          color: Palette.white,
                        ),
                        // Gap(40)
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                context.pop();
                              },
                              icon: Image.asset(
                                'assets/images/recap/cancel.png',
                                fit: BoxFit.cover,
                              ),
                            )
                          ],
                        ),
                        Gap(20),
                        Image.asset(
                          'assets/images/recap/screen_2.png',
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "📸 Captured Moments:\nYou and your guests documented ${HiveFunction.getEventRoundu().totalMediaCount} amazing moments during the event!",
                          style: TextStyle(
                            color: Palette.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gap(50),
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            'assets/images/recap/share.png',
                            width: 100,
                            height: 50,
                          ),
                        ),
                        // Gap(40)
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(3),
                    Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                context.pop();
                              },
                              icon: Image.asset(
                                'assets/images/recap/cancel.png',
                                fit: BoxFit.cover,
                              ),
                            )
                          ],
                        ),
                        Gap(20),
                        Container(
                          height: 320,
                          // width: 361,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: HiveFunction.getEventRoundu()
                                            .topContributors
                                            .isNotEmpty &&
                                        DevFunctions.getAllMedia(state.media)
                                            .isNotEmpty &&
                                        DevFunctions.isAvailable(state.media)
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          DevFunctions.getAllMedia(state.media)
                                              .firstWhere(
                                                (element) =>
                                                    element.uuid ==
                                                    HiveFunction
                                                            .getEventRoundu()
                                                        .topContributors[0]
                                                        .uuid,
                                              )
                                              .url,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Image.asset(
                                        'assets/images/recap/image_placeholder.png',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Positioned(
                                bottom: 2,
                                left: 2,
                                child: Container(
                                  height: 73,
                                  width: 150,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Image.asset(
                                          'assets/images/recap/upload_num.png',
                                        ),
                                      ),
                                      Positioned(
                                        left: 43,
                                        top: 15,
                                        child: Text(
                                          "${HiveFunction.getEventRoundu().totalMediaCount}\nUploads",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Top Contributors:",
                          style: TextStyle(
                            fontSize: 32,
                            color: Palette.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: MediaQuery.sizeOf(context).height * .4,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: HiveFunction.getEventRoundu()
                                .topContributors
                                .length,
                            itemBuilder: (context, index) {
                              TopContributor contributor =
                                  HiveFunction.getEventRoundu()
                                      .topContributors[index];

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Palette.lightAsh,
                                  radius: 40,
                                  child: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  contributor.name,
                                  style: TextStyle(
                                    fontSize: 21,
                                    color: Palette.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  "${contributor.mediaCount} Uploads",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Palette.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Gap(10),
                    Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                context.pop();
                              },
                              icon: Image.asset(
                                'assets/images/recap/cancel.png',
                                fit: BoxFit.cover,
                              ),
                            )
                          ],
                        ),
                        Gap(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              'assets/images/recap/smily_face.png',
                              width: 60,
                              height: 60,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/recap/wow.png',
                              width: 251,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Gap(20),
                    Text.rich(TextSpan(
                        text: 'Crowd controller with over ',
                        style: TextStyle(
                          fontSize: 33,
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text:
                                '${HiveFunction.getEventRoundu().totalUserCount} attendees',
                            style: TextStyle(
                              fontSize: 33,
                              decoration: TextDecoration.underline,
                              decorationColor: Palette.white,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ])),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              'assets/images/recap/rainbow.png',
                              width: 155,
                              height: 104,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/recap/hand.png',
                              width: 94,
                              height: 94,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Gap(20),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Gap(20),
                        Icon(
                          Icons.arrow_upward,
                          color: Palette.white,
                        ),
                        // Gap(40)
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset(
                          'assets/images/recap/share_love.png',
                        ),
                        Gap(20),
                        Text(
                          'Share to friends\n & Family',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Palette.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                    Gap(10),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/recap/share.png',
                        width: 100,
                        height: 50,
                      ),
                    ),
                  ],
                ),
              ],
            ));
      },
    );
  }
}
