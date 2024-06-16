import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wambe/blocs/media_bloc/media_bloc.dart';
import 'package:wambe/global_widget/mymessage_handler.dart';
import 'package:wambe/models/media.dart';
import 'package:wambe/models/user.dart';
import 'package:wambe/settings/hive.dart';

class DevFunctions {
  static String getDayOfWeek(DateTime date) {
    // Define a DateFormat that only outputs the weekday
    DateFormat dateFormat = DateFormat('EEEE');

    // Format the date to get the day of the week
    String dayOfWeek = dateFormat.format(date);

    return dayOfWeek;
  }

  static String getFormattedDate(DateTime date) {
    // Define DateFormat for "day month"
    DateFormat dayMonthFormat = DateFormat('d MMMM');
    // Define DateFormat for "day of the week"

    // Format the date
    String dayMonth = dayMonthFormat.format(date);

    // Combine both
    return '$dayMonth';
  }

  static ImagePicker _picker = ImagePicker();

  static Future<List<String>> pickedImageFromGallery(
      BuildContext context) async {
    try {
      final pickedImage = await _picker.pickMultipleMedia(
        imageQuality: 100,
      );
      List<String> images = [];
      for (XFile image in pickedImage) {
        images.add(image.path);
      }
      return images;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<List<String>> pickImageFromCamera(BuildContext context) async {
    try {
      final pickedImage = await _picker.pickImage(
        source: ImageSource.camera,
        // maxHeight: 300,
        // maxWidth: 300,
        imageQuality: 100,
      );
      if (pickedImage != null) return [pickedImage.path];

      return [];
    } catch (e) {
      throw e.toString();
    }
  }

  static bool checkMediaCount(int totalMedia, int count) {
    return totalMedia >= count;
  }

  static String? checkMediaLeftCount(
      int totalMedia, int count, int uploadNumber) {
    // final mediaEntries = medias?.entries.where(
    //       (element) {
    //         bool check = false;
    //         for (Media media in element.value) {
    //           if (media.uuid == HiveFunction.getUser().userId) {
    //             return true;
    //           }
    //         }
    //         return false;
    //       },
    //     ).toList() ??
    //     [];
    print(totalMedia);
    print(count);
    print(uploadNumber);

    // int totalCount = mediaEntries.length;
    if (count >= totalMedia + uploadNumber) {
      return null;
    } else {
      if (count - totalMedia <= 0) {
        return "You cannot upload anymore photos";
      }
      return "You can only upload ${count - totalMedia} more photos";
    }
  }

  static List<Media> getAllMediaForUser(Map<String, List<Media>>? medias) {
    if (medias == null) {
      return [];
    }

    return medias.values
        .expand((mediaList) => mediaList)
        .toList()
        .where(
          (element) => element.uuid == HiveFunction.getUser().userId,
        )
        .toList();
  }

  static List<Media> getAllMedia(Map<String, List<Media>>? medias) {
    if (medias == null) {
      return [];
    }

    return medias.values.expand((mediaList) => mediaList).toList();
  }

  static bool isAvailable(Map<String, List<Media>>? media) {
    print(DevFunctions.getAllMedia(media).contains(
      // ignore: collection_methods_unrelated_type
      (element) =>
          element.uuid = HiveFunction.getEventRoundu().topContributors[0].uuid,
    ));
    bool isAvailabvle = false;
    DevFunctions.getAllMedia(media).forEach((element) {
      if (element.uuid ==
          HiveFunction.getEventRoundu().topContributors[0].uuid) {
        isAvailabvle = true;
        return;
      }
    }
        //     element.uuid = HiveFunction.getEventRoundu().topContributors[0].uuid,
        );
    return isAvailabvle;
  }

  static String searchByUUID(String uuid) {
    List<User> users = HiveFunction.getEventusers();
    for (User user in users) {
      if (user.userId == uuid) {
        return user.name;
      }
    }
    return "";
  }

  static Future<void> shareUrl(String url, BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;

    await Share.share(
      url,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }
}
