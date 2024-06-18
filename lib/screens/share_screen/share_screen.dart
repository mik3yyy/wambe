import 'package:flutter/material.dart';
import 'package:wambe/screens/main_screen/Home_screen/Home_screen.dart';
import 'package:wambe/screens/share_screen/share_function.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key, required this.id});
  final String id;
  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          ShareFunction.getData(id: widget.id, pageNumber: 1, pageSized: 20),
      builder: (context, snapshot) {
        var mediaEntries = snapshot.data?.entries.toList() ?? [];
        return Scaffold(
          appBar: AppBar(
            title: const Text("Event Highlight"),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              // context.read<MediaBloc>().add(
              //       LoadMediaEvent(
              //           eventId: Hi
              // veFunction.getEvent().eventId.toString()),
              //
              await Future.delayed(Duration(seconds: 2));
              //  );
              setState(() {});
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
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                              mediaList[mediaIndex].url,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      // Positioned(
                                      //   bottom: 10,
                                      //   right: 10,
                                      //   child: Text(
                                      //     DevFunctions.searchByUUID(
                                      //         mediaList[mediaIndex].uuid),
                                      //     style: TextStyle(fontSize: 10),
                                      //   ),
                                      // )
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
              ],
            ),
          ),
        );
      },
    );
  }
}
