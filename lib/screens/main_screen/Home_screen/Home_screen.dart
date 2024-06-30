import 'dart:io';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:dialog_alert/dialog_alert.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:gif_view/gif_view.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wambe/blocs/media_bloc/media_bloc.dart';
import 'package:wambe/blocs/user_bloc/user_bloc.dart';
import 'package:wambe/global_widget/custom_image_selector.dart';
import 'package:wambe/global_widget/image_render_widget.dart';
import 'package:wambe/global_widget/mymessage_handler.dart';
import 'package:wambe/models/media.dart';
import 'package:wambe/screens/main_screen/Home_screen/view_time.dart';
import 'package:wambe/screens/main_screen/local_widget/filter_mymoment.dart';
import 'package:wambe/screens/main_screen/local_widget/upload_image_popup.dart';
import 'package:wambe/screens/share_screen/share_function.dart';
import 'package:wambe/settings/constants.dart';
import 'package:wambe/settings/dev_function.dart';
import 'package:wambe/settings/hive.dart';
import 'package:wambe/settings/palette.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final double _scrollThreshold = 5.0; // Adjust this value as needed

  @override
  void initState() {
    super.initState();
    context.read<MediaBloc>().add(EventMediaTag());
    // if (context.read<MediaBloc>().state.media == null) {
    //   context.read<MediaBloc>().add(
    //         LoadMediaEvent(eventId: HiveFunction.getEvent().eventId.toString()),
    //       );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MediaBloc, MediaState>(
      listener: (context, state) {
        if (state is MediaError) {
          MyMessageHandler.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        final mediaEntries = state.media?.entries.where(
              (element) {
                bool check = false;
                for (Media media in element.value) {
                  if (media.uuid == HiveFunction.getUser().userId) {
                    return true;
                  }
                }
                return false;
              },
            ).toList() ??
            [];
        // final mediaEntries = state.media?.entries.toList() ?? [];

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
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          int indexList = 0;
                          return MasonryGridView.count(
                            itemCount: 10,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            itemBuilder: (ctx, index) {
                              int postion = index % 4;
                              return GestureDetector(
                                onTap: () {},
                                child: postion == 1 || postion == 3
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          height: 176,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                      )
                                    : Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          height: 246,
                                        ),
                                      ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

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
              if (HiveFunction.getEvent().eventPublic)
                IconButton(
                  onPressed: () async {
                    await DevFunctions.shareUrl(
                      "https://wambe.netlify.app/share/${HiveFunction.getEvent().eventId}",
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
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<MediaBloc>().add(EventMediaTag());

              await Future.delayed(Duration(seconds: 2));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                              final time = mediaEntries.toList()[index].key;
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
                                    queryParameters: {'time': time},
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
                                                  time,
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
                                                  time,
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

class ImageDialog extends StatefulWidget {
  final List<Media> images;
  final int index;
  final shareEnabled;

  ImageDialog(
      {required this.images, required this.index, this.shareEnabled = true});

  @override
  State<ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    _currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    _currentIndex = value;
                  });
                },
                controller: _pageController,
                itemBuilder: (context, index) {
                  return Hero(
                    tag: widget.images[index].url,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      // color: Colors.transparent,
                      child: Visibility(
                        visible: true,
                        child: ImageRenderWidget.network(
                          imageUrl: widget.images[index].url,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
                itemCount: widget.images.length,
              ),
            ),
            Positioned(
              top: 8.0,
              // right: 8.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                    Text(
                      DevFunctions.searchByUUID(
                        widget.images[_currentIndex].uuid,
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Palette.white,
                      ),
                    ),
                    widget.shareEnabled
                        ? IconButton(
                            onPressed: () async {
                              await ShareFunction.shareImage(
                                  widget.images[_currentIndex].url, context);
                              // await DevFunctions.shareUrl(
                              //     widget.images[_currentIndex].url, context);
                            },
                            icon: Icon(
                              Icons.share,
                              size: 30,
                              color: Palette.white,
                            ),
                          )
                        : Container(
                            width: 20,
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



  //  Expanded(
  //                   child: ListView.builder(
  //                     controller: _scrollController,
  //                     itemCount: mediaEntries.length,
  //                     physics: AlwaysScrollableScrollPhysics(),
  //                     itemBuilder: (context, index) {
  //                       final time = mediaEntries.toList()[index].key;
  //                       var mediaList = mediaEntries.toList()[index].value;
  //                       mediaList = mediaList
  //                           .where(
  //                             (element) =>
  //                                 element.uuid == HiveFunction.getUser().userId,
  //                           )
  //                           .toList();
  //                       return Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 10),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Text(time,
  //                                   style: const TextStyle(
  //                                       fontSize: 18,
  //                                       fontWeight: FontWeight.bold)),
  //                             ),
  //                             GridView.builder(
  //                               shrinkWrap: true,
  //                               physics: const NeverScrollableScrollPhysics(),
  //                               itemCount: mediaList.length,
  //                               gridDelegate:
  //                                   const SliverGridDelegateWithFixedCrossAxisCount(
  //                                 crossAxisCount: 3,
  //                                 mainAxisSpacing: 8.0,
  //                                 crossAxisSpacing: 8.0,
  //                               ),
  //                               itemBuilder: (context, mediaIndex) {
  //                                 return Builder(builder: (context) {
  //                                   return GestureDetector(
  //                                     onTap: () {
  //                                       showDialog(
  //                                         context: context,
  //                                         builder: (BuildContext context) {
  //                                           return ImageDialog(
  //                                             images: mediaList,
  //                                             index: mediaIndex,
  //                                           );
  //                                         },
  //                                       );
  //                                     },
  //                                     onLongPress: () {
  //                                       print("/jkb dvfkl kl fskl");
  //                                       toogleEdit();
  //                                     },
  //                                     child: SelectableImageWidget(
  //                                       image: mediaList[mediaIndex],
  //                                       isSelected: selectedImageIds
  //                                           .contains(mediaList[mediaIndex].id),
  //                                       onSelect: toggleSelection,
  //                                       isVisible: isEditing,
  //                                     ),
  //                                   );
  //                                 });
  //                               },
  //                             ),
  //                           ],
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
                


















                  //  Expanded(
                  //     child: DynamicHeightGridView(
                  //         itemCount: mediaEntries.length,
                  //         crossAxisCount: 2,
                  //         crossAxisSpacing: 20,
                  //         mainAxisSpacing: 10,
                          // builder: (ctx, index) {
                          //   final time = mediaEntries.toList()[index].key;
                          //   var mediaList = mediaEntries.toList()[index].value;
                          //   mediaList = mediaList
                          //       .where(
                          //         (element) =>
                          //             element.uuid ==
                          //             HiveFunction.getUser().userId,
                          //       )
                          //       .toList();
                          //   int postion = index % 4;
                          //   print(postion);
                          //   return GestureDetector(
                          //       onTap: () {
                          //         context.pushNamed(
                          //           ViewTimeMoment.id,
                          //           extra: mediaList,
                          //           queryParameters: {'time': time},
                          //         );
                          //       },
                          //       child: postion == 1 || postion == 2
                          //           ? Container(
                          //               height: 176,
                          //               child: Stack(
                          //                 children: [
                          //                   Positioned.fill(
                          //                     child: SizedBox(
                          //                       // height: 176,
                          //                       child: ClipRRect(
                          //                         borderRadius:
                          //                             BorderRadius.circular(8),
                          //                         child: Image.network(
                          //                           mediaList.first.url,
                          //                           fit: BoxFit.cover,
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                   Positioned(
                          //                     top: 10,
                          //                     left: 10,
                          //                     child: Container(
                          //                       decoration: BoxDecoration(
                          //                         boxShadow: [
                          //                           BoxShadow(
                          //                             color: Colors.black
                          //                                 .withOpacity(0.2),
                          //                             spreadRadius: 2,
                          //                             blurRadius: 20,
                          //                             offset: Offset(0, 1),
                          //                           ),
                          //                         ],
                          //                       ),
                          //                       child: Text(
                          //                         time,
                          //                         style: TextStyle(
                          //                           fontSize: 25,
                          //                           fontWeight: FontWeight.w600,
                          //                           color: Palette.white,
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //             )
                          //           : SizedBox(
                          //               height: 246,
                          //               child: Stack(
                          //                 children: [
                          //                   Positioned.fill(
                          //                     child: SizedBox(
                          //                       // height: 176,
                          //                       child: ClipRRect(
                          //                         borderRadius:
                          //                             BorderRadius.circular(8),
                          //                         child: Image.network(
                          //                           mediaList.first.url,
                          //                           fit: BoxFit.cover,
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                   Positioned(
                          //                     top: 10,
                          //                     left: 10,
                          //                     child: Container(
                          //                       decoration: BoxDecoration(
                          //                         boxShadow: [
                          //                           BoxShadow(
                          //                             color: Colors.black
                          //                                 .withOpacity(0.2),
                          //                             spreadRadius: 2,
                          //                             blurRadius: 20,
                          //                             offset: Offset(0, 1),
                          //                           ),
                          //                         ],
                          //                       ),
                          //                       child: Text(
                          //                         time,
                          //                         style: TextStyle(
                          //                           fontSize: 25,
                          //                           fontWeight: FontWeight.w600,
                          //                           color: Palette.white,
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ));

                  //           /// return your widget here.
                  //         }),
                      // ListView.builder(
                      //   controller: _scrollController,
                      //   itemCount: mediaEntries.length,
                      //   physics: AlwaysScrollableScrollPhysics(),
                      //   itemBuilder: (context, index) {
                          // final time = mediaEntries.toList()[index].key;
                      //     var mediaList = mediaEntries.toList()[index].value;
                      //     mediaList = mediaList
                      //         .where(
                      //           (element) =>
                      //               element.uuid == HiveFunction.getUser().userId,
                      //         )
                      //         .toList();
                      //     return Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 10),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Padding(
                      //             padding: const EdgeInsets.all(8.0),
                      //             child: Text(time,
                      //                 style: const TextStyle(
                      //                     fontSize: 18,
                      //                     fontWeight: FontWeight.bold)),
                      //           ),
                      //           GridView.builder(
                      //             shrinkWrap: true,
                      //             physics: const NeverScrollableScrollPhysics(),
                      //             itemCount: mediaList.length,
                      //             gridDelegate:
                      //                 const SliverGridDelegateWithFixedCrossAxisCount(
                      //               crossAxisCount: 3,
                      //               mainAxisSpacing: 8.0,
                      //               crossAxisSpacing: 8.0,
                      //             ),
                      //             itemBuilder: (context, mediaIndex) {
                      //               return Builder(builder: (context) {
                      //                 return GestureDetector(
                      //                   onTap: () {
                      //                     showDialog(
                      //                       context: context,
                      //                       builder: (BuildContext context) {
                      //                         return ImageDialog(
                      //                           images: mediaList,
                      //                           index: mediaIndex,
                      //                         );
                      //                       },
                      //                     );
                      //                   },
                      //                   onLongPress: () {
                      //                     print("/jkb dvfkl kl fskl");
                      //                     toogleEdit();
                      //                   },
                      //                   child: SelectableImageWidget(
                      //                     image: mediaList[mediaIndex],
                      //                     isSelected: selectedImageIds
                      //                         .contains(mediaList[mediaIndex].id),
                      //                     onSelect: toggleSelection,
                      //                     isVisible: isEditing,
                      //                   ),
                      //                 );
                      //               });
                      //             },
                      //           ),
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // ),
                    // ),
                 