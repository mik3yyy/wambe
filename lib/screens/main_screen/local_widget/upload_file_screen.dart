import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wambe/blocs/media_bloc/media_bloc.dart';
import 'package:wambe/global_widget/mymessage_handler.dart';
import 'package:wambe/settings/dev_function.dart';
import 'package:wambe/settings/hive.dart';
import 'package:wambe/settings/palette.dart';

class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({
    super.key,
  });
  static String id = 'Upload_sreen';
  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  chooseGallery() async {
    try {
      var images = await DevFunctions.pickedImageFromGallery(context);
      if (images.isNotEmpty) {
        context.read<MediaBloc>().add(AddImageEvent(images: images));
        setState(() {});

        // context.read<MediaBloc>().add(UploadFilesEvent());
      }
    } catch (e) {
      MyMessageHandler.showSnackBar(context, "Error Adding Image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MediaBloc, MediaState>(
      listener: (context, state) {
        if (state is MediaLoaded) {
          if (state.message == "Uploaded Images Succesfully") {
            context.pop();
            MyMessageHandler.showSnackBar(context, state.message,
                option: options.success);
          }
        } else if (state is MediaError) {
          MyMessageHandler.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        List<String> images = state.selectedImages ?? [];

        if (state is MediaProcessing && state.isUploading) {
          return Scaffold(
            backgroundColor: Color(0xFF0C0B0B),
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
                          'uploading…',
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
          backgroundColor: Color(0xFF0C0B0B),
          body: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<MediaBloc>().add(ClearMediaEvent());
                        context.pop();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Palette.white,
                        size: 40,
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (value) {
                      setState(() {
                        _currentIndex = value;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        // height: 200,
                        child: Image.file(
                          File(
                            images[index],
                          ),
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.none,
                        ),
                      );
                    },
                    itemCount: images.length,
                  ),
                ),
                Center(
                  child: Text(
                    "${_currentIndex + 1}/${images.length}",
                    style: TextStyle(color: Palette.white),
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              height: 100,
              color: Color(0xFF0C0B0B),
              child: Row(
                children: [
                  MaterialButton(
                    splashColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      chooseGallery();
                    },
                    child: Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Palette.white,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: Palette.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  // Gap(),
                  Expanded(
                    child: Container(
                      height: 70,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const Gap(3),
                        itemCount: images.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return _currentIndex == index
                              ? GestureDetector(
                                  onTap: () {
                                    context.read<MediaBloc>().add(
                                        RemoveImageEvent(index: _currentIndex));

                                    setState(() {
                                      _currentIndex = -1;
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        child: Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Palette.white,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              File(
                                                images[index],
                                              ),
                                              fit: BoxFit.cover,
                                              filterQuality: FilterQuality.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                          child: Center(
                                        child: Icon(
                                          Icons.delete,
                                          color: Palette.white,
                                          size: 30,
                                        ),
                                      ))
                                    ],
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _currentIndex = index;
                                    });
                                    _pageController.jumpToPage(
                                      _currentIndex,
                                    );
                                    // duration: Duration(milliseconds: 500),
                                    // curve: Curves.decelerate);
                                  },
                                  child: Container(
                                    // height: 60,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(
                                          images[index],
                                        ),
                                        fit: BoxFit.cover,
                                        filterQuality: FilterQuality.none,
                                      ),
                                    ),
                                  ),
                                );
                        },
                      ),
                    ),
                  ),
                  Gap(3),
                  MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      String? res = DevFunctions.checkMediaLeftCount(
                          HiveFunction.getTotalUpload(),
                          int.parse(HiveFunction.getEvent().uploadLimit),
                          state.selectedImages?.length ?? 0);
                      print(res);
                      if (res != null) {
                        MyMessageHandler.showSnackBar(context, res);
                      } else {
                        context.read<MediaBloc>().add(UploadFilesEvent());
                      }
                    },
                    child: Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                        // border: Border.all(
                        //   color: Palette.white,
                        // ),
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.chevron_right_outlined,
                          color: Palette.black,
                          size: 50,
                        ),
                      ),
                    ),
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
