import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wambe/settings/palette.dart';

class CustomButton extends StatefulWidget {
  const CustomButton(
      {super.key,
      this.loading = false,
      required this.onTap,
      this.title,
      this.enable = true,
      this.textSize,
      this.color,
      this.textColor,
      this.width,
      this.height,
      this.titleWidget,
      this.style,
      this.isshadow = false,
      this.border});

  final bool loading;
  final bool enable;
  final VoidCallback onTap;
  final String? title;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? textSize;
  final BoxBorder? border;
  final TextStyle? style;
  final Widget? titleWidget;
  final bool isshadow;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.loading || !widget.enable ? 0.5 : 1,
      child: MaterialButton(
        padding: EdgeInsets.zero,
        highlightColor: Palette.white,
        splashColor: Colors.transparent,
        onPressed:
            widget.loading || widget.enable == false ? () {} : widget.onTap,
        child: Container(
          width: widget.width ?? MediaQuery.of(context).size.width * 0.9,
          height: widget.height ?? 55,
          decoration: BoxDecoration(
            color: widget.enable
                ? widget.color ?? Theme.of(context).colorScheme.primary
                : Color(0xFFE3E4E8),
            borderRadius: BorderRadius.circular(8),
            border: widget.border,
            boxShadow: widget.isshadow
                ? [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .tertiary
                          .withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 23,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ]
                : [],
          ),
          child: Stack(
            children: [
              Center(
                child: widget.titleWidget ??
                    Text(
                      widget.title ?? "",
                      textAlign: TextAlign.center,
                      style: widget.style ??
                          TextStyle(
                            color: widget.enable
                                ? widget.textColor ??
                                    Theme.of(context).colorScheme.secondary
                                : Color(0xFF8692A6),
                            fontWeight: FontWeight.w500,
                            fontSize: widget.textSize ?? 16,
                          ),
                    ),
              ),
              if (widget.loading)
                Positioned(
                    right: 10,
                    top: 56 / 4,
                    child: LoadingAnimationWidget.bouncingBall(
                      color: Theme.of(context).colorScheme.secondary,
                      // rightDotColor: Constant.generalColor,
                      size: 20,
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
