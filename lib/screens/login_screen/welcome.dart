// import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wambe/blocs/user_bloc/user_bloc.dart';
import 'package:wambe/global_widget/custom_button.dart';
import 'package:wambe/global_widget/textfield.dart';
import 'package:wambe/settings/palette.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class WelcomScreen extends StatefulWidget {
  const WelcomScreen({super.key});

  @override
  State<WelcomScreen> createState() => _WelcomScreenState();
}

class _WelcomScreenState extends State<WelcomScreen> {
  TextEditingController welcomeController = TextEditingController();
  TextEditingController emailontroller = TextEditingController();
  // static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    // initPlatformState();
  }

  // Future<void> initPlatformState() async {
  //   var deviceData = <String, dynamic>{};

  //   try {
  //     if (defaultTargetPlatform == TargetPlatform.android) {
  //       deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
  //     } else if (defaultTargetPlatform == TargetPlatform.iOS) {
  //       deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
  //     }
  //   } on PlatformException {
  //     deviceData = <String, dynamic>{
  //       'Error:': 'Failed to get platform version.'
  //     };
  //   }

  //   if (!mounted) return;

  //   setState(() {
  //     _deviceData = deviceData;
  //   });
  //   print(_deviceData);
  // }

  // Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  //   return <String, dynamic>{
  //     'version.securityPatch': build.version.securityPatch,
  //     'version.sdkInt': build.version.sdkInt,
  //     'version.release': build.version.release,
  //     'version.previewSdkInt': build.version.previewSdkInt,
  //     'version.incremental': build.version.incremental,
  //     'version.codename': build.version.codename,
  //     'version.baseOS': build.version.baseOS,
  //     'board': build.board,
  //     'bootloader': build.bootloader,
  //     'brand': build.brand,
  //     'device': build.device,
  //     'display': build.display,
  //     'fingerprint': build.fingerprint,
  //     'hardware': build.hardware,
  //     'host': build.host,
  //     'id': build.id,
  //     'manufacturer': build.manufacturer,
  //     'model': build.model,
  //     'product': build.product,
  //     'supported32BitAbis': build.supported32BitAbis,
  //     'supported64BitAbis': build.supported64BitAbis,
  //     'supportedAbis': build.supportedAbis,
  //     'tags': build.tags,
  //     'type': build.type,
  //     'isPhysicalDevice': build.isPhysicalDevice,
  //     'systemFeatures': build.systemFeatures,
  //     'serialNumber': build.serialNumber,
  //     'isLowRamDevice': build.isLowRamDevice,
  //   };
  // }

  // Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  //   return <String, dynamic>{
  //     'name': data.name,
  //     'systemName': data.systemName,
  //     'systemVersion': data.systemVersion,
  //     'model': data.model,
  //     'localizedModel': data.localizedModel,
  //     'identifierForVendor': data.identifierForVendor,
  //     'isPhysicalDevice': data.isPhysicalDevice,
  //     'utsname.sysname:': data.utsname.sysname,
  //     'utsname.nodename:': data.utsname.nodename,
  //     'utsname.release:': data.utsname.release,
  //     'utsname.version:': data.utsname.version,
  //     'utsname.machine:': data.utsname.machine,
  //   };
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is userLoaded) {
          while (context.canPop()) {
            context.pop();
          }
          context.replace('/main');
        }
      },
      builder: (context, state) {
        if (state is UserProcessing && state.isInputingName) {
          return Scaffold(
            body: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          child: Text(
                            "Welcome",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const Gap(10),
                        SizedBox(
                          child: Text(
                            "Enter your details to access the event,",
                            style:
                                TextStyle(fontSize: 14, color: Palette.darkAsh),
                          ),
                        ),
                        const Gap(40),
                        const SizedBox(
                          child: Text(
                            "Your name",
                          ),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller: welcomeController,
                          hintText: '',
                          onChange: () {
                            setState(() {});
                          },
                        ),
                        const Gap(30),
                        CustomButton(
                          enable: welcomeController.text.isNotEmpty,
                          loading: state.isSignInEvent,
                          onTap: () {},
                          title: "Continue",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      "Enter your details to access the event,",
                      style: TextStyle(fontSize: 14, color: Palette.darkAsh),
                    ),
                    const Gap(40),
                    const Text(
                      "Your name",
                    ),
                    const Gap(5),
                    CustomTextField(
                      controller: welcomeController,
                      hintText: '',
                      onChange: () {
                        setState(() {});
                      },
                    ),
                    const Gap(10),
                    const Text(
                      "Email",
                    ),
                    const Gap(5),
                    CustomTextField(
                      controller: emailontroller,
                      hintText: '',
                      onChange: () {
                        setState(() {});
                      },
                    ),
                    const Gap(30),
                    CustomButton(
                      enable: welcomeController.text.isNotEmpty &&
                          emailontroller.text.isNotEmpty,
                      loading: state is UserProcessing && state.isSignInEvent,
                      onTap: () {
                        context.read<UserBloc>().add(
                              WelcomeUserEvent(
                                eventId: state.event!.eventId.toString(),
                                name: welcomeController.text.trim(),
                                email: emailontroller.text.trim(),
                              ),
                            );
                        // context.replace('/main');
                      },
                      title: "Continue",
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
