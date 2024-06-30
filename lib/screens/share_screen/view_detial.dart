import 'package:dialog_alert/dialog_alert.dart';
import 'package:dialog_alert_transition/dialog_alert_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wambe/blocs/media_bloc/media_bloc.dart';
import 'package:wambe/global_widget/custom_image_selector.dart';
import 'package:wambe/global_widget/mymessage_handler.dart';
import 'package:wambe/models/media.dart';
import 'package:wambe/screens/main_screen/Home_screen/Home_screen.dart';
import 'package:wambe/screens/share_screen/provider.dart';
import 'package:wambe/screens/share_screen/share_function.dart';
import 'package:wambe/settings/dev_function.dart';
import 'package:wambe/settings/hive.dart';
import 'package:wambe/settings/palette.dart';

class ViewTag extends StatefulWidget {
  const ViewTag({super.key, required this.tag, required this.eventId});
  final String tag;
  final String eventId;
  static String id = 'viee_tag';
  @override
  State<ViewTag> createState() => _ViewTagState();
}

class _ViewTagState extends State<ViewTag> {
  final ScrollController _scrollController = ScrollController();
  final double _scrollThreshold = 20.0; // Adjust this value as needed
  int pageNumber = 1;
  int pageSize = 10;
  bool isEditing = false;
  toogleEdit() {}
  bool fetching = false;

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
    var shareProvider = Provider.of<ShareProvider>(context, listen: false);

    ShareFunction.fetchTagMedia(
      eventId: widget.eventId,
      page: 1,
      pageSize: pageSize,
      add: false,
      context: context,
      tag: widget.tag,
    );
    // pageSize = (shareProvider.media?[widget.tag] ?? []).length;
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() async {
    print("jeeede");
    var shareProvider = Provider.of<ShareProvider>(context, listen: false);

    if (_scrollController.position.extentAfter < _scrollThreshold) {
      int size = (shareProvider.media?[widget.tag] ?? []).length;

      pageNumber = (size / pageSize).ceil();
      // if (pageSize == 1) return;
      setState(() {
        fetching = true;
      });
      await ShareFunction.fetchTagMedia(
        eventId: widget.eventId,
        page: pageNumber,
        pageSize: pageSize,
        add: false,
        context: context,
        tag: widget.tag,
      );
      setState(() {
        fetching = false;
      });
      // context.read<MediaBloc>().add(MediaTag(
      //     pageNumber: pageNumber, tag: widget.tag, add: pageSize != 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    var shareProvider = Provider.of<ShareProvider>(context, listen: true);
    List<Media> medialist = shareProvider.media?[widget.tag] ?? [];
    if (shareProvider.media == null) {
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
                Text(widget.tag,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Palette.purple,
                    )),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ShareFunction.fetchTagMedia(
            eventId: widget.eventId,
            page: 1,
            pageSize: pageSize,
            add: false,
            context: context,
            tag: widget.tag,
          );

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
                                images: medialist,
                                index: mediaIndex,
                                shareEnabled: false,
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
              if (fetching) ...[
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
  }
}
