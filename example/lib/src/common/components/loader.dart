import 'package:face_camera_example/src/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// `LoadingComponent` returns a CircularProgressIndicator widget with some customization.
class LoadingComponent extends StatelessWidget {
  // Constructor for the LoadingComponent.
  const LoadingComponent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Returns a CircularProgressIndicator widget with a strokeWidth of 3 and color set to primaryColor obtained from AppColors.
    return const CircularProgressIndicator(
      strokeWidth: 3, // Customize the width of the progress indicator.
      color: AppColors.primaryColor, // Set the color of the progress indicator to primaryColor defined in AppColors.
    );
  }
}
