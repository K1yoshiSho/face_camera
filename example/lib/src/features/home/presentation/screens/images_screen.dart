import 'dart:io';
import 'package:face_camera_example/src/theme/app_colors.dart';
import 'package:face_camera_example/src/theme/app_style.dart';
import 'package:intl/intl.dart';
import 'package:face_camera_example/src/common/components/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class ImagesScreen extends StatelessWidget {
  final List<File> images;
  const ImagesScreen({super.key, required this.images});

  static const String name = "Images";
  static const String routeName = "images";

  static const String paramImages = "paramImages";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: buildFlexibleAppBar(context, title: "Фотографии"),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ListView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) {
              DateTime createdAt = images[index].lastModifiedSync();
              return Padding(
                padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                child: Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.gray200,
                        width: 1.5,
                      ),
                      color: Colors.white,
                    ),
                    child: ListTile(
                      title: Text(
                        "Фото: ${index + 1}",
                        style: AppTextStyle.bodyMedium600(context),
                      ),
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      subtitle: Text(
                        DateFormat('dd.MM.yyyy HH:mm').format(createdAt),
                        style: AppTextStyle.bodyMedium400(context).copyWith(
                          color: AppColors.gray800,
                        ),
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          images[index],
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.open_in_new_rounded,
                          color: AppColors.gray600,
                        ),
                        onPressed: () {
                          OpenFile.open(images[index].path);
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
