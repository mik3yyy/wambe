import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:wambe/blocs/user_bloc/user_bloc.dart';
import 'package:wambe/global_widget/custom_button.dart';
import 'package:wambe/global_widget/mymessage_handler.dart';
import 'package:wambe/global_widget/textfield.dart';
import 'package:wambe/settings/palette.dart';

class ChangeNamePopup extends StatefulWidget {
  const ChangeNamePopup({super.key});

  @override
  State<ChangeNamePopup> createState() => _ChangeNamePopupState();
}

class _ChangeNamePopupState extends State<ChangeNamePopup> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is userLoaded) {
          context.pop();
          MyMessageHandler.showSnackBar(context, "Name Edited sucessfully",
              option: options.success);
        } else if (state is UserError) {
          MyMessageHandler.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.sizeOf(context).height,
          decoration: BoxDecoration(
            color: Palette.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            // shape: BoxShape.circle,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                Gap(10),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "Change Name",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "Change your Wambe Name using the form below.",
                    style: TextStyle(
                      color: Palette.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
                Gap(10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name"),
                      Gap(10),
                      CustomTextField(
                        controller: nameController,
                        hintText: "*******",
                        onChange: () {
                          setState(() {});
                        },
                        borderColor: Palette.grey,
                      ),
                      Gap(30),
                      CustomButton(
                        enable: nameController.text.isNotEmpty,
                        loading: state is UserProcessing && state.isChangeName,
                        onTap: () {
                          context.read<UserBloc>().add(
                                ChangeNameEvent(name: nameController.text),
                              );
                        },
                        title: "Save",
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    ;
  }
}
