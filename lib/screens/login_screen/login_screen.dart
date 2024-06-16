import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wambe/blocs/user_bloc/user_bloc.dart';
import 'package:wambe/global_widget/custom_button.dart';
import 'package:wambe/global_widget/mymessage_handler.dart';
import 'package:wambe/settings/palette.dart';

class Eventlogin extends StatefulWidget {
  const Eventlogin({super.key});

  @override
  State<Eventlogin> createState() => _EventloginState();
}

class _EventloginState extends State<Eventlogin> {
  bool loading = false;
  bool enable = false;
  FocusNode focusNode = FocusNode();
  TextEditingController codeController = TextEditingController();

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
      int? num = int.tryParse(barcodeScanRes);
      if (num != null) {
        if (barcodeScanRes.length == 5) {
          setState(() {
            codeController.text = barcodeScanRes;
          });
        } else {
          MyMessageHandler.showSnackBar(context, "Invalid Barcode");
        }
      } else {
        MyMessageHandler.showSnackBar(context, "Error Scanning Barcode");
      }
    } on PlatformException {
      MyMessageHandler.showSnackBar(context, "Error Scanning Barcode");
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        print(state);
        if (state is userLoaded) {
          context.go('/login/welcome');
        } else if (state is UserError) {
          MyMessageHandler.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is UserProcessing && state.isSignInEvent) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/login_screen/scan.svg',
                        fit: BoxFit.fill,
                        height: 40,
                        width: 40,
                      ),
                      Gap(20),
                    ],
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SafeArea(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * .25,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Gap(10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svgs/login_screen/grid.svg',
                                        fit: BoxFit.fill,
                                      ),
                                    ],
                                  ),
                                  // Gap(30),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svgs/login_screen/grid.svg',
                                        fit: BoxFit.fill,
                                        height: 56,
                                        width: 60,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Text(
                                  loading ? "" : "Event ID",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Gap(20),
                              SizedBox(
                                child: Text(
                                  loading
                                      ? ""
                                      : "Enter the Event ID sent to you.",
                                  style: TextStyle(
                                      fontSize: 14, color: Palette.darkAsh),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                                child: Opacity(
                                  opacity: 0,
                                  child: TextField(
                                    focusNode: focusNode,
                                    controller: codeController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 5,
                                    onChanged: (valu) {
                                      if (valu.length == 5) {
                                        setState(() {
                                          enable = true;
                                        });
                                      } else {
                                        setState(() {
                                          enable = false;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  OTPView(
                                    text: codeController.text.length > 0
                                        ? codeController.text[0]
                                        : "",
                                    onTap: () => focusNode.hasFocus
                                        ? focusNode.unfocus()
                                        : focusNode.requestFocus(),
                                  ),
                                  OTPView(
                                    text: codeController.text.length > 1
                                        ? codeController.text[1]
                                        : "",
                                    onTap: () => focusNode.hasFocus
                                        ? focusNode.unfocus()
                                        : focusNode.requestFocus(),
                                  ),
                                  OTPView(
                                    text: codeController.text.length > 2
                                        ? codeController.text[2]
                                        : "",
                                    onTap: () => focusNode.hasFocus
                                        ? focusNode.unfocus()
                                        : focusNode.requestFocus(),
                                  ),
                                  OTPView(
                                    text: codeController.text.length > 3
                                        ? codeController.text[3]
                                        : "",
                                    onTap: () => focusNode.hasFocus
                                        ? focusNode.unfocus()
                                        : focusNode.requestFocus(),
                                  ),
                                  OTPView(
                                    text: codeController.text.length > 4
                                        ? codeController.text[4]
                                        : "",
                                    onTap: () => focusNode.hasFocus
                                        ? focusNode.unfocus()
                                        : focusNode.requestFocus(),
                                  ),
                                ],
                              ),
                              Gap(40),
                              CustomButton(
                                loading: state is UserProcessing &&
                                    state.isSignInEvent,
                                enable: codeController.text.length == 5,
                                onTap: () {
                                  context.read<UserBloc>().add(
                                      SigninEvent(event: codeController.text));
                                  // context.go('/login/welcome');
                                },
                                title: "Access Event",
                              ),
                            ],
                          ),
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
          appBar: AppBar(
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () async {
                      await scanBarcodeNormal();
                      // String barcodeScanRes =
                      //     await FlutterBarcodeScanner.scanBarcode(
                      //         COLOR_CODE, "Cance;", true, ScanMode.DEFAULT);
                    },
                    icon: SvgPicture.asset(
                      'assets/svgs/login_screen/scan.svg',
                      fit: BoxFit.fill,
                      height: 40,
                      width: 40,
                    ),
                  ),
                  Gap(20),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SafeArea(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * .25,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Gap(10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: SvgPicture.asset(
                                      'assets/svgs/login_screen/grid.svg',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ],
                              ),
                              // Gap(30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svgs/login_screen/grid.svg',
                                    fit: BoxFit.fill,
                                    height: 56,
                                    width: 60,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Text(
                              loading ? "" : "Event ID",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Gap(20),
                          SizedBox(
                            child: Text(
                              loading ? "" : "Enter the Event ID sent to you.",
                              style: TextStyle(
                                  fontSize: 14, color: Palette.darkAsh),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            child: Opacity(
                              opacity: 0,
                              child: TextField(
                                focusNode: focusNode,
                                controller: codeController,
                                keyboardType: TextInputType.number,
                                maxLength: 5,
                                onChanged: (valu) {
                                  if (valu.length == 5) {
                                    setState(() {
                                      enable = true;
                                    });
                                  } else {
                                    setState(() {
                                      enable = false;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OTPView(
                                text: codeController.text.length > 0
                                    ? codeController.text[0]
                                    : "",
                                onTap: () => focusNode.hasFocus
                                    ? focusNode.unfocus()
                                    : focusNode.requestFocus(),
                              ),
                              OTPView(
                                text: codeController.text.length > 1
                                    ? codeController.text[1]
                                    : "",
                                onTap: () => focusNode.hasFocus
                                    ? focusNode.unfocus()
                                    : focusNode.requestFocus(),
                              ),
                              OTPView(
                                text: codeController.text.length > 2
                                    ? codeController.text[2]
                                    : "",
                                onTap: () => focusNode.hasFocus
                                    ? focusNode.unfocus()
                                    : focusNode.requestFocus(),
                              ),
                              OTPView(
                                text: codeController.text.length > 3
                                    ? codeController.text[3]
                                    : "",
                                onTap: () => focusNode.hasFocus
                                    ? focusNode.unfocus()
                                    : focusNode.requestFocus(),
                              ),
                              OTPView(
                                text: codeController.text.length > 4
                                    ? codeController.text[4]
                                    : "",
                                onTap: () => focusNode.hasFocus
                                    ? focusNode.unfocus()
                                    : focusNode.requestFocus(),
                              ),
                            ],
                          ),
                          Gap(40),
                          CustomButton(
                            loading:
                                state is UserProcessing && state.isSignInEvent,
                            enable: codeController.text.length == 5,
                            onTap: () {
                              context
                                  .read<UserBloc>()
                                  .add(SigninEvent(event: codeController.text));
                              // context.go('/login/welcome');
                            },
                            title: "Access Event",
                          ),
                        ],
                      ),
                      SizedBox()
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class OTPView extends StatefulWidget {
  const OTPView({
    super.key,
    required this.text,
    required this.onTap,
  });
  final String text;
  final VoidCallback onTap;

  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Color(0xFFCACACA).withOpacity(.3),
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: Palette.black),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              color: Color(0xFF8692A6),
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
