import 'package:dialog_alert/dialog_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:wambe/blocs/media_bloc/media_bloc.dart';
import 'package:wambe/global_widget/custom_image_selector.dart';
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
                  context
                      .read<MediaBloc>()
                      .add(DeleteMediaEvent(ids: selectedImageIds.toList()));
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
          Gap(20),
          Icon(
            Icons.share,
            color: Palette.darkAsh,
          ),
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
  }
}
