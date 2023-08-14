import 'package:face_camera_example/src/constants/export.dart';
import 'package:face_camera_example/src/router/navigation.dart';
import 'package:face_camera_example/src/theme/app_colors.dart';
import 'package:face_camera_example/src/theme/app_style.dart';

AppBar buildFlexibleAppBar(
  BuildContext context, {
  String? title,
  bool centerTitle = false,
  Widget? actionIcon,
  Function()? action,
  Function()? onBack,
  bool leadingEnabled = true,
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    toolbarHeight: 49,
    flexibleSpace: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top, left: 4, right: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  leadingEnabled
                      ? IconButton(
                          splashRadius: 18,
                          style: AppStyles.iconButtonStyle,
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: AppColors.abyssColor,
                          ),
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            }
                            if (onBack != null) onBack();
                          },
                        )
                      : const SizedBox.shrink(),
                  title != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            title,
                            style: AppTextStyle.bodyMedium500(context).copyWith(fontSize: leadingEnabled ? 14 : 16),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              actionIcon ?? const SizedBox.shrink(),
            ],
          ),
        ),
        const Divider(
          color: AppColors.gray100,
          height: 1,
        ),
      ],
    ),
  );
}
