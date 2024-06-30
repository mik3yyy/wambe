import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:dialog_alert/dialog_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wambe/blocs/media_bloc/media_bloc.dart';
import 'package:wambe/global_widget/custom_image_selector.dart';
import 'package:wambe/global_widget/image_render_widget.dart';
import 'package:wambe/global_widget/mymessage_handler.dart';
import 'package:wambe/screens/main_screen/Home_screen/Home_screen.dart';
import 'package:wambe/screens/main_screen/Home_screen/view_time.dart';
import 'package:wambe/settings/dev_function.dart';
import 'package:wambe/settings/hive.dart';
import 'package:wambe/settings/palette.dart';

import '../local_widget/upload_image_popup.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ScrollController _scrollController = ScrollController();
  final double _scrollThreshold = 10.0; // Adjust this value as needed

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<MediaBloc>().add(EventMediaTag());
    // if (context.read<MediaBloc>().state.media == null) {
    //   context.read<MediaBloc>().add(
    //         LoadMediaEvent(eventId: HiveFunction.getEvent().eventId.toString()),
    //       );
    // }
  }

  void _onScroll() {
    // if (_scrollController.position.extentAfter < _scrollThreshold) {
    //   if (context.read<MediaBloc>().state is! MediaProcessing &&
    //       DevFunctions.checkMediaCount(HiveFunction.getTotalUpload(),
    //               int.parse(HiveFunction.getEvent().uploadLimit)) ==
    //           false) {
    //     context.read<MediaBloc>().add(
    //           LoadMediaEvent(
    //             add: true,
    //             eventId: HiveFunction.getEvent().eventId.toString(),
    //           ),
    //         );
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MediaBloc, MediaState>(
      listener: (context, state) {
        if (state is MediaError) {
          MyMessageHandler.showSnackBar(context, state.message);
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        // final mediaEntries = state.media?.entries.toList() ?? [];
        final mediaEntries = state.media?.entries.where(
              (element) {
                // bool check = false;
                // for (Media media in element.value) {
                //   if (media.uuid == HiveFunction.getUser().userId) {
                //     return true;
                //   }
                // }
                print(element);
                return state.media?[element.key]?.isNotEmpty ?? false;
              },
            ).toList() ??
            [];

        if (state is MediaProcessing &&
            state.isFetching &&
            state.media == null &&
            mediaEntries.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Text(
                  "My Moments",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              actions: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Icon(
                    Icons.share,
                    color: Palette.darkAsh,
                  ),
                ),
                Gap(20),
              ],
            ),
            body: ListView.builder(
              controller: _scrollController,
              itemCount: 20,
              itemBuilder: (context, index) {
                // final time = mediaEntries.reversed.toList()[index].key;
                // var mediaList = mediaEntries.reversed.toList()[index].value;
                // mediaList = mediaList
                //     .where(
                //       (element) => element.uuid == HiveFunction.getUser().userId,
                //     )
                //     .toList();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          child: Text("Photos",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 10,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                        ),
                        itemBuilder: (context, mediaIndex) {
                          return SizedBox(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  color: Palette.grey,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: CircleBorder(),
              child: Icon(Icons.add),
              //params
              onPressed: () {
                if (DevFunctions.checkMediaCount(HiveFunction.getTotalUpload(),
                    int.parse(HiveFunction.getEvent().uploadLimit))) {
                  MyMessageHandler.showSnackBar(
                      context, "Maximum User Upload Reached");
                  return;
                }
              },
            ),
          );
        }
        print(HiveFunction.getTags().isEmpty);
        print(" VIVKFDBIOVBNR;E");
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(
              "Let’s share your moment",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                fontFamily: "Norms",
              ),
            ),
            actions: [
              if (HiveFunction.getEvent().eventPublic ||
                  HiveFunction.getUser().eventOwner)
                IconButton(
                  onPressed: () async {
                    await DevFunctions.shareUrl(
                      "https://beta.wambe.co/share/${HiveFunction.getEvent().eventId}",
                      context,
                    );
                  },
                  icon: Icon(
                    Icons.share,
                    color: Palette.darkAsh,
                  ),
                ),
              Gap(20),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<MediaBloc>().add(EventMediaTag());

                await Future.delayed(Duration(seconds: 2));
              },
              child: Column(
                children: [
                  if (HiveFunction.getTags().isEmpty) ...[
                    Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ImageRenderWidget.asset(
                            imagePath: 'assets/images/empty.png',
                            width: 280,
                            height: 240,
                            fit: BoxFit.cover,
                          ),
                          // GifView.asset(
                          //   'assets/gifs/empty_home.gif',
                          //   width: 200,
                          //   height: 280,
                          //   fit: BoxFit.cover,

                          //   // frameRate: 30, // default is 15 FPS
                          // ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    Text(
                      "Add images from your favourite moments",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600),
                    ),
                  ] else ...[
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          int indexList = 0;
                          return MasonryGridView.count(
                            itemCount: mediaEntries.length,
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 10,
                            itemBuilder: (ctx, index) {
                              final tag = mediaEntries.toList()[index].key;
                              var mediaList =
                                  mediaEntries.toList()[index].value;
                              // mediaList = mediaList
                              //     .where(
                              //       (element) =>
                              //           element.uuid ==
                              //           HiveFunction.getUser().userId,
                              //     )
                              //     .toList();
                              int postion = index % 4;
                              print(postion);
                              // if (skeys.isNotEmpty) {
                              //   if (skeys.contains(time) == false) {
                              //     return Container();
                              //   }
                              // }
                              return GestureDetector(
                                onTap: () {
                                  context.pushNamed(
                                    ViewTimeMoment.id,
                                    queryParameters: {'time': tag},
                                  );
                                },
                                child: postion == 1 || postion == 3
                                    ? Container(
                                        height: 176,
                                        child: Stack(
                                          children: [
                                            Positioned.fill(
                                              child: SizedBox(
                                                // height: 176,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child:
                                                      ImageRenderWidget.network(
                                                    imageUrl:
                                                        mediaList.first.url,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 10,
                                              left: 10,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                      spreadRadius: 2,
                                                      blurRadius: 20,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  tag,
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w600,
                                                    color: Palette.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox(
                                        height: 246,
                                        child: Stack(
                                          children: [
                                            Positioned.fill(
                                              child: SizedBox(
                                                // height: 176,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child:
                                                      ImageRenderWidget.network(
                                                    imageUrl:
                                                        mediaList.first.url,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 10,
                                              left: 10,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                      spreadRadius: 2,
                                                      blurRadius: 20,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  tag,
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w600,
                                                    color: Palette.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: DevFunctions.checkMediaCount(
          //               HiveFunction.getTotalUpload(),
          //               int.parse(HiveFunction.getEvent().uploadLimit)) ||
          //           (HiveFunction.getEvent().eventEnd)
          //       ? Theme.of(context).colorScheme.primary.withOpacity(.5)
          //       : Theme.of(context).colorScheme.primary,
          //   shape: CircleBorder(),
          //   child: Icon(Icons.add),
          //   //params
          //   onPressed: () {
          //     if (DevFunctions.checkMediaCount(HiveFunction.getTotalUpload(),
          //         int.parse(HiveFunction.getEvent().uploadLimit))) {
          //       if (HiveFunction.getUser().eventOwner) {
          //         MyMessageHandler.showSnackBar(
          //             context, "Your event has reached totalMedia limit");
          //         return;
          //       }
          //       MyMessageHandler.showSnackBar(
          //           context, "Maximum User Upload Reached");
          //       return;
          //     }
          //     if (HiveFunction.getEvent().eventEnd) {
          //       MyMessageHandler.showSnackBar(context, "Event has Ended");
          //       return;
          //     }
          //     showFlexibleBottomSheet(
          //       // minHeight: 0,
          //       // initHeight: 0.5,
          //       // maxHeight: 1,
          //       // isExpand: false,
          //       bottomSheetColor: Colors.transparent,
          //       initHeight: 0.3,
          //       context: context,
          //       builder: (context, scrollController, bottomSheetOffset) {
          //         return UploadImage();
          //       },
          //       anchors: [0, 0.5, 1],
          //       isSafeArea: true,
          //     );
          //   },
          // ),
        );
      },
    );
  }
}
