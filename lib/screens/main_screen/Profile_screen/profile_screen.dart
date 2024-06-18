import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:dialog_alert/dialog_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:gap/gap.dart';
import 'package:gif_view/gif_view.dart';
import 'package:go_router/go_router.dart';
import 'package:wambe/blocs/media_bloc/media_bloc.dart';
import 'package:wambe/blocs/user_bloc/user_bloc.dart';
import 'package:wambe/global_widget/custom_button.dart';
import 'package:wambe/global_widget/custom_text_button.dart';
import 'package:wambe/global_widget/image_render_widget.dart';
import 'package:wambe/screens/main_screen/Home_screen/Home_screen.dart';
import 'package:wambe/screens/main_screen/Profile_screen/chnage_name.dart';
import 'package:wambe/settings/dev_function.dart';
import 'package:wambe/settings/hive.dart';
import 'package:wambe/settings/palette.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MediaBloc, MediaState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 250,
                  child: Stack(
                    children: [
                      Container(
                        height: 200,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/profile_bg.png'),
                              fit: BoxFit.cover),
                        ),
                        child: AppBar(
                          backgroundColor: Colors.transparent,
                          title: Text(
                            "My Profile",
                            style: TextStyle(
                              color: Palette.white,
                            ),
                          ),
                          actions: [
                            IconButton(
                              onPressed: () async {
                                if (kIsWeb) {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          surfaceTintColor: Palette.white,
                                          backgroundColor: Palette.white,
                                          title: Center(
                                              child: Text("Are you sure?")),
                                          content: Container(
                                            height: 70,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text('Do you want to Log out?'),
                                                Gap(20),
                                                Container(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          .4,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          child: Center(
                                                              child:
                                                                  CustomTextButton(
                                                        onPressed: () {
                                                          context.pop();
                                                        },
                                                        text: "Cancel",
                                                        color: Colors.black,
                                                      ))),
                                                      Expanded(
                                                          child: Center(
                                                              child:
                                                                  CustomTextButton(
                                                        onPressed: () {
                                                          while (context
                                                              .canPop()) {
                                                            context.pop();
                                                          }
                                                          context.replace('/');
                                                          context
                                                              .read<UserBloc>()
                                                              .add(
                                                                  ClearUserEvent());
                                                          context
                                                              .read<MediaBloc>()
                                                              .add(
                                                                  ClearMediaEvent());
                                                          HiveFunction
                                                              .DELETEALL();
                                                        },
                                                        text: 'Log out',
                                                        color: Colors.red,
                                                      ))),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                } else {
                                  final result = await showDialogAlert(
                                    context: context,
                                    title: 'Are you sure?',
                                    message: 'Do you want to Log out?',
                                    actionButtonTitle: 'Log out',
                                    cancelButtonTitle: 'Cancel',
                                    actionButtonTextStyle: const TextStyle(
                                      color: Colors.red,
                                    ),
                                    cancelButtonTextStyle: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  );
                                  if (result == ButtonActionType.action) {
                                    while (context.canPop()) {
                                      context.pop();
                                    }
                                    context.replace('/');
                                    context
                                        .read<UserBloc>()
                                        .add(ClearUserEvent());
                                    context
                                        .read<MediaBloc>()
                                        .add(ClearMediaEvent());
                                    HiveFunction.DELETEALL();
                                  }
                                }
                              },
                              icon: Icon(
                                Icons.logout,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: MediaQuery.of(context).size.width / 2 - 50,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FluttermojiCircleAvatar(
                                radius: 55,
                              )
                              //  Image.asset(
                              //   "assets/images/profile_bg.png",
                              //   width: 100,
                              //   height: 100,
                              //   fit: BoxFit.fill,
                              // ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(20),
                Column(
                  children: [
                    Text(DevFunctions.getAllMediaForUser(state.media)
                        .length
                        .toString()),
                  ],
                ),
                Text(
                  'Number of Uploads ',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                Gap(10),
                CustomButton(
                  onTap: () {
                    DraggableScrollableController controller =
                        DraggableScrollableController();

                    showFlexibleBottomSheet(
                      // minHeight: 0,
                      initHeight: 0.5,
                      maxHeight: 1,

                      // isExpand: false,
                      bottomSheetColor: Colors.transparent,
                      // initHeight: 0.3,
                      context: context,
                      draggableScrollableController: controller,
                      builder: (context, scrollController, bottomSheetOffset) {
                        return const ChangeNamePopup();
                      },
                      anchors: [0, 0.5, 1],
                      isSafeArea: true,
                    );
                  },
                  title: "Edit Details",
                ),
                Gap(20),
                // SvgPicture.asset(
                //   'assets/svgs/ani.svg',
                //   fit: BoxFit.fill,
                //   theme: SvgTheme(
                //     currentColor: Theme.of(context).colorScheme.primary,
                //   ),
                // ),
                if (DevFunctions.getAllMediaForUser(state.media).isEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GifView.asset(
                        'assets/gifs/empty_home.gif',
                        width: 200,
                        height: 280,
                        fit: BoxFit.cover,

                        // frameRate: 30, // default is 15 FPS
                      ),
                    ],
                  ),
                  const Gap(20),
                  Text(
                    "Add images from your favourite moments",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600),
                  ),
                ] else ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          DevFunctions.getAllMediaForUser(state.media).length,
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
                                    images: DevFunctions.getAllMediaForUser(
                                        state.media),
                                    index: mediaIndex,
                                  );
                                },
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: ImageRenderWidget.network(
                                imageUrl: DevFunctions.getAllMediaForUser(
                                        state.media)[mediaIndex]
                                    .url,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                ]
                // CustomButton(
                //   border: Border.all(color: Colors.red),
                //   onTap: () {},
                //   color: Palette.white,
                //   titleWidget: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 20),
                //     child: Row(
                //       children: [
                //         Icon(Icons.logout),
                //         Text(
                //           "  Log Out",
                //         ),
                //       ],
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        );
      },
    );
  }
}
