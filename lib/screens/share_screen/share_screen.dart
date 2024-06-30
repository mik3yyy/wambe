import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wambe/global_widget/image_render_widget.dart';
import 'package:wambe/screens/main_screen/Home_screen/Home_screen.dart';
import 'package:wambe/screens/share_screen/provider.dart';
import 'package:wambe/screens/share_screen/share_function.dart';
import 'package:wambe/screens/share_screen/view_detial.dart';
import 'package:wambe/settings/hive.dart';
import 'package:wambe/settings/palette.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key, required this.id});
  final String id;
  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  final ScrollController _scrollController = ScrollController();
  String name = "Event";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ShareFunction.getData(id: widget.id, context: context);
  }

  @override
  Widget build(BuildContext context) {
    var shareProvider = Provider.of<ShareProvider>(context, listen: true);
    if (shareProvider.media == null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Text(
              "Event Highlight",
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
    var mediaEntries = shareProvider.media?.entries.toList() ?? [];
    mediaEntries = mediaEntries.where(
          (element) {
            // bool check = false;
            // for (Media media in element.value) {
            //   if (media.uuid == HiveFunction.getUser().userId) {
            //     return true;
            //   }
            // }
            print(element);
            return shareProvider.media?[element.key]?.isNotEmpty ?? false;
          },
        ).toList() ??
        [];
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${HiveFunction.ueventExist() ? HiveFunction.getEvent().eventName : name} Highlight"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: RefreshIndicator(
          onRefresh: () async {
            ShareFunction.getData(id: widget.id, context: context);

            await Future.delayed(Duration(seconds: 2));
          },
          child: Column(
            children: [
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
                        var mediaList = mediaEntries.toList()[index].value;
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
                              ViewTag.id,
                              pathParameters: {
                                'tag': tag,
                                'id': widget.id,
                              },
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
                                            child: ImageRenderWidget.network(
                                              imageUrl: mediaList.first.url,
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
                                            child: ImageRenderWidget.network(
                                              imageUrl: mediaList.first.url,
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
            ],
          ),
        ),
      ),
    );
  }
}
