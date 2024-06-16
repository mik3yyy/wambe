import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:dialog_alert/dialog_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wambe/blocs/media_bloc/media_bloc.dart';
import 'package:wambe/global_widget/custom_image_selector.dart';
import 'package:wambe/global_widget/mymessage_handler.dart';
import 'package:wambe/screens/main_screen/Home_screen/Home_screen.dart';
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
    if (context.read<MediaBloc>().state.media == null) {
      context.read<MediaBloc>().add(
            LoadMediaEvent(eventId: HiveFunction.getEvent().eventId.toString()),
          );
    }
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < _scrollThreshold) {
      if (context.read<MediaBloc>().state is! MediaProcessing &&
          DevFunctions.checkMediaCount(HiveFunction.getTotalUpload(),
                  int.parse(HiveFunction.getEvent().uploadLimit)) ==
              false) {
        context.read<MediaBloc>().add(
              LoadMediaEvent(
                add: true,
                eventId: HiveFunction.getEvent().eventId.toString(),
              ),
            );
      }
    }
  }

  final Set<int> selectedImageIds = Set<int>();

  void toggleSelection(int id) {
    setState(() {
      if (selectedImageIds.contains(id)) {
        selectedImageIds.remove(id);
      } else {
        selectedImageIds.add(id);
      }
    });
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
        final mediaEntries = state.media?.entries.toList() ?? [];

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
                showFlexibleBottomSheet(
                  // minHeight: 0,
                  // initHeight: 0.5,
                  // maxHeight: 1,
                  // isExpand: false,
                  bottomSheetColor: Colors.transparent,
                  initHeight: 0.24,
                  context: context,
                  builder: (context, scrollController, bottomSheetOffset) {
                    return UploadImage();
                  },
                  anchors: [0, 0.5, 1],
                  isSafeArea: true,
                );
              },
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
              if (HiveFunction.getUser().eventOwner)
                InkWell(
                  onTap: () async {
                    final result = await showDialogAlert(
                      context: context,
                      title: 'Are you sure?',
                      message: 'Do you want to Delete?',
                      actionButtonTitle: 'Delete',
                      cancelButtonTitle: 'Cancel',
                      actionButtonTextStyle: const TextStyle(
                        color: Colors.red,
                      ),
                      cancelButtonTextStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    );
                    if (result == ButtonActionType.action) {
                      context.read<MediaBloc>().add(
                          DeleteMediaEvent(ids: selectedImageIds.toList()));
                    }
                  },
                  child: Container(
                    height: 30,
                    color: Colors.redAccent.withOpacity(.1),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                        child: Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    )),
                  ),
                ),
              Gap(20),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<MediaBloc>().add(
                    LoadMediaEvent(
                        eventId: HiveFunction.getEvent().eventId.toString()),
                  );
              await Future.delayed(Duration(seconds: 2));
            },
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: mediaEntries.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final time = mediaEntries.reversed.toList()[index].key;
                      var mediaList =
                          mediaEntries.reversed.toList()[index].value;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(time,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: mediaList.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 8.0,
                                crossAxisSpacing: 8.0,
                              ),
                              itemBuilder: (context, mediaIndex) {
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ImageDialog(
                                          images: mediaList,
                                          index: mediaIndex,
                                        );
                                      },
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: HiveFunction.getUser().eventOwner
                                            ? SelectableImageWidget(
                                                image: mediaList[mediaIndex],
                                                isSelected:
                                                    selectedImageIds.contains(
                                                        mediaList[mediaIndex]
                                                            .id),
                                                onSelect: toggleSelection,
                                                isVisible: false,
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                    mediaList[mediaIndex].url,
                                                    fit: BoxFit.cover),
                                              ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: Text(
                                          DevFunctions.searchByUUID(
                                              mediaList[mediaIndex].uuid),
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                if (state is MediaProcessing &&
                    state.isFetching &&
                    mediaEntries.isNotEmpty &&
                    DevFunctions.checkMediaCount(HiveFunction.getTotalUpload(),
                            int.parse(HiveFunction.getEvent().uploadLimit)) ==
                        false) ...[
                  LoadingAnimationWidget.waveDots(
                    color: Theme.of(context).colorScheme.primary,
                    // rightDotColor: Constant.generalColor,

                    size: 50,
                  )
                ],
              ],
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
