import 'package:dialog_alert/dialog_alert.dart';
import 'package:dialog_alert_transition/dialog_alert_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:wambe/blocs/media_bloc/media_bloc.dart';
import 'package:wambe/global_widget/custom_image_selector.dart';
import 'package:wambe/global_widget/mymessage_handler.dart';
import 'package:wambe/models/media.dart';
import 'package:wambe/screens/main_screen/Home_screen/Home_screen.dart';
import 'package:wambe/settings/palette.dart';

class ViewTimeMoment extends StatefulWidget {
  const ViewTimeMoment(
      {super.key, required this.medialist, required this.time});
  final String time;
  final List<Media> medialist;
  static String id = 'view_time';
  @override
  State<ViewTimeMoment> createState() => _ViewTimeMomentState();
}

class _ViewTimeMomentState extends State<ViewTimeMoment> {
  bool isEditing = false;
  toogleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
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
        // if (state is MediaLoaded) {
        //   MyMessageHandler.showSnackBar(context, "Media Deleted Successfully");
        // }
      },
      builder: (context, state) {
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
            leadingWidth: 120,
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
                              Size(MediaQuery.sizeOf(context).width * .5, 400),
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
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.medialist.length,
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
                                  images: widget.medialist,
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
                            image: widget.medialist[mediaIndex],
                            isSelected: selectedImageIds
                                .contains(widget.medialist[mediaIndex].id),
                            onSelect: toggleSelection,
                            isVisible: isEditing,
                          ),
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
