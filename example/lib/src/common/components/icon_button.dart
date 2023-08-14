

import 'package:face_camera_example/src/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// `AppIconButton` is a custom IconButton with customizable fields.

class AppIconButton extends StatefulWidget {
  // Constructor for the widget.
  const AppIconButton({
    Key? key,
    required this.icon,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.buttonSize,
    this.fillColor,
    this.disabledColor,
    this.disabledIconColor,
    this.hoverColor,
    this.hoverIconColor,
    required this.onPressed,
    this.showLoadingIndicator = false,
  }) : super(key: key);

  final Widget icon;
  final double? borderRadius;
  final double? buttonSize;
  final Color? fillColor;
  final Color? disabledColor;
  final Color? disabledIconColor;
  final Color? hoverColor;
  final Color? hoverIconColor;
  final Color? borderColor;
  final double? borderWidth;
  final bool showLoadingIndicator;
  final Function()? onPressed;

  // Creates and returns a new instance of the state associated with this widget.
  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

// Private state class for the AppIconButton.
class _AppIconButtonState extends State<AppIconButton> {
  // Indicates whether or not the button is currently in a loading state.
  bool loading = false;
  // Stores the size of the icon being displayed on the button.
  late double? iconSize;
  // Stores the color of the icon being displayed on the button.
  late Color? iconColor;
  // The effective icon being displayed on the button (either a FaIcon or a regular Icon).
  late Widget effectiveIcon;

  @override
  void initState() {
    super.initState();
    // Initializes the state of the widget by updating the icon.
    _updateIcon();
  }

  @override
  void didUpdateWidget(AppIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Updates the state of the widget when it has been updated with new properties.
    _updateIcon();
  }

  // Updates the icon being displayed based on whether or not the given icon is a FontAwesome icon.
  void _updateIcon() {
    final isFontAwesome = widget.icon is Icon;
    if (isFontAwesome) {
      Icon icon = widget.icon as Icon;
      effectiveIcon = Icon(
        icon.icon,
        size: icon.size,
      );
      iconSize = icon.size;
      iconColor = icon.color;
    } else {
      effectiveIcon = widget.icon;
      iconSize = widget.buttonSize;
      iconColor = AppColors.gray600;
    }
  }

  // Builds and returns the widget tree for this widget.
  @override
  Widget build(BuildContext context) {
    // Defines the ButtonStyle to be used for this button.
    ButtonStyle style = ButtonStyle(
      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
        (states) => RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 100),
          side: BorderSide(
            color: widget.borderColor ?? Colors.transparent,
            width: widget.borderWidth ?? 0,
          ),
        ),
      ),
      iconColor: MaterialStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            return widget.disabledIconColor ?? iconColor;
          }
          if (states.contains(MaterialState.hovered)) {
            return widget.hoverIconColor ?? iconColor;
          }
          return iconColor;
        },
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            return widget.disabledColor ?? widget.fillColor;
          }
          if (states.contains(MaterialState.hovered)) {
            return widget.hoverColor ?? widget.fillColor;
          }
          return widget.fillColor;
        },
      ),
    );

    // Returns the button.
    return SizedBox(
      width: widget.buttonSize,
      height: widget.buttonSize,
      child: (widget.showLoadingIndicator && loading)
          ? Center(
              child: Container(
                width: iconSize,
                height: iconSize,
                color: widget.onPressed != null ? widget.fillColor : widget.disabledColor,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    iconColor ?? Colors.white,
                  ),
                ),
              ),
            )
          : IconButton(
              icon: effectiveIcon,
              splashColor: AppColors.splashColor,
              highlightColor: AppColors.splashColor,
              onPressed: widget.onPressed == null
                  ? null
                  : () async {
                      if (loading) {
                        return;
                      }
                      setState(() => loading = true);
                      try {
                        await widget.onPressed!();
                      } finally {
                        if (mounted) {
                          setState(() => loading = false);
                        }
                      }
                    },
              splashRadius: widget.buttonSize,
              style: style,
            ),
    );
  }
}
