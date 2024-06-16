import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wambe/blocs/media_bloc/media_bloc.dart';
import 'package:wambe/global_widget/mymessage_handler.dart';
import 'package:wambe/screens/main_screen/local_widget/upload_file_screen.dart';
import 'package:wambe/settings/dev_function.dart';
import 'package:wambe/settings/palette.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  @override
  Widget build(BuildContext context) {
    chooseImage() async {
      try {
        var images = await DevFunctions.pickImageFromCamera(context);
        if (images.isNotEmpty) {
          context.read<MediaBloc>().add(AddImageEvent(images: images));
          context.pop();
          context.goNamed(
            UploadFileScreen.id,
          );
        } else {
          MyMessageHandler.showSnackBar(context, "No Image added");
        }
      } catch (e) {
        MyMessageHandler.showSnackBar(context, "Error Adding Image");
      }
    }

    chooseGallery() async {
      try {
        var images = await DevFunctions.pickedImageFromGallery(context);
        if (images.isNotEmpty) {
          context.read<MediaBloc>().add(AddImageEvent(images: images));
          context.pop();

          context.goNamed(
            UploadFileScreen.id,
          );

          // context.read<MediaBloc>().add(UploadFilesEvent());
        }
      } catch (e) {
        MyMessageHandler.showSnackBar(context, "Error Adding Image");
      }
    }

    return Container(
      padding: EdgeInsets.all(10),
      // height: 60,
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        // shape: BoxShape.circle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 5,
                width: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Palette.darkAsh,
                ),
                child: Container(),
              )
            ],
          ),
          Gap(10),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              "Upload Photo",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            onTap: () async {
              chooseImage();

              // context.go('/main_screen/add/url');
            },
            leading: Icon(CupertinoIcons.camera, color: Palette.darkAsh),
            title: Text(
              "Camera",
              style: TextStyle(color: Palette.darkAsh),
            ),
          ),
          ListTile(
            onTap: () async {
              chooseGallery();
              // context.go('/main_screen/add/recipe');
            },
            leading: Icon(Icons.photo_size_select_actual_rounded,
                color: Palette.darkAsh),
            title: Text(
              "Gallery",
              style: TextStyle(color: Palette.darkAsh),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
