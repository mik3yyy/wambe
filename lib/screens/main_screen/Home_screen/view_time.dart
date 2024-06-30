import 'package:dialog_alert/dialog_alert.dart';
import 'package:dialog_alert_transition/dialog_alert_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wambe/blocs/media_bloc/media_bloc.dart';
import 'package:wambe/global_widget/custom_image_selector.dart';
import 'package:wambe/global_widget/mymessage_handler.dart';
import 'package:wambe/models/media.dart';
import 'package:wambe/screens/main_screen/Home_screen/Home_screen.dart';
import 'package:wambe/settings/dev_function.dart';
import 'package:wambe/settings/hive.dart';
import 'package:wambe/settings/palette.dart';

class ViewTimeMoment extends StatefulWidget {
  const ViewTimeMoment(
      {super.key, required this.time, this.isMyMoment = false});
  final String time;
  final bool isMyMoment;
  static String id = 'view_time';
  @override
  State<ViewTimeMoment> createState() => _ViewTimeMomentState();
}

class _ViewTimeMomentState extends State<ViewTimeMoment> {
  final ScrollController _scrollController = ScrollController();
  final double _scrollThreshold = 20.0; // Adjust this value as needed
  int pageNumber = 1;
  int pageSize = 10;
  bool isEditing = false;
  toogleEdit() {
    print(HiveFunction.getUser().eventOwner);
    print(widget.isMyMoment);
    if (HiveFunction.getUser().eventOwner || widget.isMyMoment) {
      setState(() {
        isEditing = !isEditing;
      });
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
  void initState() {
    // TODO: implement initState
    super.initState();
    // pageSize =
    //     (context.read<MediaBloc>().state.media?[widget.time] ?? []).length;
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    print("jeeede");
    if (_scrollController.position.extentAfter < _scrollThreshold) {
      if (context.read<MediaBloc>().state is! MediaProcessing) {
        int size =
            (context.read<MediaBloc>().state.media?[widget.time] ?? []).length;

        pageNumber = (size / pageSize).ceil();
        // if (pageSize == 1) return;
        context.read<MediaBloc>().add(MediaTag(
            pageNumber: pageNumber, tag: widget.time, add: pageSize != 1));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MediaBloc, MediaState>(
      listener: (context, state) {
        // if (state is MediaLoaded) {
        //   MyMessageHandler.showSnackBar(context, "Media Deleted Successfully");
        // }
      },
      builder: (context, state) {
        List<Media> medialist = state.media?[widget.time] ?? [];
        if (widget.isMyMoment) {
          medialist = medialist
              .where((element) => element.uuid == HiveFunction.getUser().userId)
              .toList();
        }
        if (state is MediaProcessing && state.isDeleting) {
          return Scaffold(
            // backgroundColor: Color(0xFF0C0B0B),
            body: Center(
              child: Container(
                height: 200,
                width: 184,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/svgs/Upload_line.svg'),
                        const Gap(3),
                        Text(
                          'Deleting...',
                          style: TextStyle(
                            color: Palette.black,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            leadingWidth: 400,
            leading: GestureDetector(
              onTap: () {
                context.pop();
              },
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.chevron_left,
                      color: Palette.purple,
                      size: 30,
                    ),
                    Gap(10),
                    Text(widget.time,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Palette.purple,
                        )),
                  ],
                ),
              ),
            ),
            actions: [
              if (selectedImageIds.isNotEmpty)
                InkWell(
                  onTap: () async {
                    //  int token = controlAlertGo.generate();
                    if (kIsWeb) {
                      dialogAlertTransion(
                          context: context,
                          title: const Text(
                            'Are you sure?',
                          ),
                          content: const Column(
                            children: [Text("Do you want to Delete?")],
                          ),
                          size:
                              Size(MediaQuery.sizeOf(context).width * .7, 400),
                          alignment: Alignment.center,
                          // blur: true,
                          // duration: 1000,
                          // backgroundColor: Colors.black,
                          // transitionType: e,
                          // token: token,
                          transitionType: transitionType.FadeIn,
                          rejectString: 'Cancel',
                          acceptString: 'Delete',
                          rejectFunc: () {
                            // context.pop();
                          },
                          acceptFunc: () {
                            context.read<MediaBloc>().add(DeleteMediaEvent(
                                ids: selectedImageIds.toList()));
                          },
                          closeFunc: () {
                            // context.pop();
                          });
                    } else {
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
                    }
                  },
                  child: Container(
                    height: 30,
                    color: Colors.redAccent.withOpacity(.1),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: const Center(
                        child: Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    )),
                  ),
                ),
              // Gap(20),
              // Icon(
              //   Icons.share,
              //   color: Palette.darkAsh,
              // ),
              Gap(20),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              context
                  .read<MediaBloc>()
                  .add(MediaTag(pageNumber: 1, tag: widget.time, add: false));

              await Future.delayed(Duration(seconds: 2));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GridView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: medialist.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      ),
                      itemBuilder: (context, mediaIndex) {
                        return Builder(builder: (context) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ImageDialog(
                                    images: medialist,
                                    index: mediaIndex,
                                  );
                                },
                              );
                            },
                            onLongPress: () {
                              print("/jkb dvfkl kl fskl");
                              toogleEdit();
                            },
                            child: SelectableImageWidget(
                              image: medialist[mediaIndex],
                              isSelected: selectedImageIds
                                  .contains(medialist[mediaIndex].id),
                              onSelect: toggleSelection,
                              isVisible: isEditing,
                            ),
                          );
                        });
                      },
                    ),
                  ),
                  if (state is MediaProcessing &&
                      state.isMoreFetching &&
                      // mediaEntries.isNotEmpty &&
                      DevFunctions.checkMediaCount(
                              HiveFunction.getTotalUpload(),
                              int.parse(HiveFunction.getEvent().uploadLimit)) ==
                          false) ...[
                    Center(
                      child: LoadingAnimationWidget.waveDots(
                        color: Theme.of(context).colorScheme.primary,
                        // rightDotColor: Constant.generalColor,

                        size: 50,
                      ),
                    )
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
