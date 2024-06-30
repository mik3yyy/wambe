import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wambe/models/media.dart';
import 'package:wambe/repository/media_repo/media_implementation.dart';
import 'package:wambe/screens/share_screen/provider.dart';
import 'package:wambe/settings/constants.dart';
import 'package:wambe/settings/hive.dart';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class ShareFunction {
  static Future<void> getData(
      {required String id, required BuildContext context}) async {
    var shareProvider = Provider.of<ShareProvider>(context, listen: false);

    final rese = await Dio().get(
      '${Constants.url}/event-tags-media',
      options: Options(
        headers: {
          "Authorization": Constants.token,
          // 'Content-Type': 'multipart/form-data',
        },
      ),
      queryParameters: {
        'eventId': id,
        // 'page': pageNumber,
        // 'pageSize': pageSized,
      },
    );

    final response = rese.data;

    Map<String, List<Media>> media = {};

    List<String> tags = (response['tags'] as List)
        .map(
          (e) => e.toString(),
        )
        .toList();
    print(tags);
    for (String tag in tags) {
      print(tag);
      media[tag] = (response['tagsMedia'][tag]['mediaItems'] as List)
          .map((item) => Media.fromJson(item))
          .toList();
    }

    shareProvider.updateMedia(media);
    print(shareProvider.media);
  }

  static Future<void> fetchTagMedia(
      {required String eventId,
      required int page,
      required int pageSize,
      required bool add,
      required BuildContext context,
      required String tag}) async {
    print("------");
    var shareProvider = Provider.of<ShareProvider>(context, listen: false);

    final res = await Dio().get(
      '${Constants.url}/tag-media',
      options: Options(
        headers: {
          "Authorization": Constants.token,
          // 'Content-Type': 'multipart/form-data',
        },
      ),
      queryParameters: {
        'eventId': eventId,
        'page': page,
        'tag': tag,
        'pageSize': pageSize,
      },
    );
    var response = res.data;
    print(response);
    Map<String, List<Media>> media = shareProvider.media ?? {};

    if (add) {
      media[tag]!.addAll((response['media'] as List)
          .map((item) => Media.fromJson(item))
          .toList());
    } else {
      media[tag] = (response['media'] as List)
          .map((item) => Media.fromJson(item))
          .toList();
    }
    shareProvider.updateMedia(media);

    // if (response.statusCode == 200) {
    //   return MediaResponse.fromJson(response.data['media']);
    // } else {
    //   throw Exception('Failed to load media');
    // }
  }

  static Future<void> shareImage(String url, BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final imageBytes = response.bodyBytes;

        final image = XFile.fromData(
          imageBytes,
          mimeType: 'image/png', // Adjust mimeType based on image format
          name: 'image.png', // Optional filename
        );

        await Share.shareXFiles(
          [image],
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
        );
      } else {
        debugPrint('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error occurred while sharing image: $e');
    }
  }
  // static Future<void> shareImage(String url) async {
  //   try {
  //     //To show loading
  //     // MyDialog.showLoadingDialog();

  //     // log('url: $url');

  //     final bytes = (await get(Uri.parse(url))).bodyBytes;
  //     // final dir = await getTemporaryDirectory();
  //     final file = await File('/ai_image.png').writeAsBytes(bytes);

  //     //hide loading

  //     await Share.shareXFiles(
  //       [XFile(file.path)],
  //     );
  //   } catch (e) {
  //     print(e);
  //     //hide loading
  //     // Get.back();
  //     // MyDialog.error('Something Went Wrong (Try again in sometime)!');
  //     // log('downloadImageE: $e');
  //   }
  // }
}
