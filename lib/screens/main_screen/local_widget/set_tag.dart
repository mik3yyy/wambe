import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wambe/blocs/media_bloc/media_bloc.dart';
import 'package:wambe/blocs/user_bloc/user_bloc.dart';
import 'package:wambe/global_widget/custom_button.dart';
import 'package:wambe/global_widget/mymessage_handler.dart';
import 'package:wambe/screens/main_screen/local_widget/upload_file_screen.dart';
import 'package:wambe/screens/main_screen/local_widget/upload_image_popup.dart';
import 'package:wambe/settings/dev_function.dart';
import 'package:wambe/settings/hive.dart';
import 'package:wambe/settings/palette.dart';

class SetTagSheet extends StatefulWidget {
  const SetTagSheet({super.key});

  @override
  State<SetTagSheet> createState() => _SetTagSheetState();
}

class _SetTagSheetState extends State<SetTagSheet> {
  String? _selectedItem; // Default selected item

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context
        .read<UserBloc>()
        .add(SigninEvent(event: HiveFunction.getEvent().eventId));
  }

  // .map((e) => e.toString())
  // .toList(); // Dropdown items
  @override
  Widget build(BuildContext context) {
    List<String> _dropdownItems = HiveFunction.getTags()
        .map((e) => e.toString())
        .toList(); // Dropdown items;

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
              const Gap(10),
              Padding(
                padding: EdgeInsets.zero, //only(left: 15),
                child: Text(
                  "Set Album",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ),
              const Gap(10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Palette.grey),
                ),
                child: DropdownButton<String>(
                  underline: Container(),
                  // hint: Text(""),
                  value: _selectedItem,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedItem = newValue!;
                    });
                  },
                  items: _dropdownItems
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          CustomButton(
            onTap: () {
              context.pop();
              showFlexibleBottomSheet(
                bottomSheetColor: Colors.transparent,
                initHeight: 0.3,
                context: context,
                builder: (context, scrollController, bottomSheetOffset) {
                  return UploadImage(
                    tag: _selectedItem!,
                  );
                },
                anchors: [0, 0.5, 1],
                isSafeArea: true,
              );
            },
            enable: _selectedItem != null,
            title: "Confirm",
          )
        ],
      ),
    );
    ;
  }
}
