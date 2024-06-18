import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wambe/blocs/media_bloc/media_bloc.dart';
import 'package:wambe/global_widget/custom_button.dart';
import 'package:wambe/global_widget/custom_text_button.dart';
import 'package:wambe/global_widget/mymessage_handler.dart';
import 'package:wambe/screens/main_screen/local_widget/upload_file_screen.dart';
import 'package:wambe/settings/dev_function.dart';
import 'package:wambe/settings/palette.dart';

class FilterMyMoment extends StatefulWidget {
  const FilterMyMoment(
      {super.key, required this.onApply, this.currentSelectedKeys});
  final Function(List<String> keys) onApply;
  final List<String>? currentSelectedKeys;
  @override
  State<FilterMyMoment> createState() => _FilterMyMomentState();
}

class _FilterMyMomentState extends State<FilterMyMoment> {
  List<String> selectedKeys = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedKeys = widget.currentSelectedKeys ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MediaBloc, MediaState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(10),
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
                  Gap(10),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Filter Moments",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const Gap(10),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * .3,
                    child: ListView.builder(
                      itemCount: state.media?.length ?? 0,
                      itemBuilder: ((context, index) {
                        String key = state.media!.keys.toList()[index];
                        return ListTile(
                          leading: Checkbox(
                            value: selectedKeys.contains(key),
                            onChanged: (val) {
                              if (selectedKeys.contains(key)) {
                                selectedKeys.remove(key);
                              } else {
                                selectedKeys.add(key);
                              }
                              setState(() {});
                            },
                          ),
                          title: Text(
                            key,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        );
                      }),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextButton(
                            text: "Reset",
                            onPressed: () {
                              widget.onApply
                                  .call(state.media?.keys.toList() ?? []);
                              context.pop();
                            }),
                      ),
                      Expanded(
                          child: CustomButton(
                        onTap: () {
                          widget.onApply.call(selectedKeys);
                          context.pop();
                        },
                        title: "Apply",
                      ))
                    ],
                  ),
                  const Gap(
                    20,
                  )
                ],
              ),
            ],
          ),
        );
      },
    );

    ;
  }
}
