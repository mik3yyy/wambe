import 'dart:convert';
// import 'dart:html' as html;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wambe/settings/constants.dart';
import 'package:dio/dio.dart';
import 'package:wambe/settings/hive.dart';
import 'dart:typed_data';

class MediaDataProvider {
  static Future<http.Response> signIn(
    String event,
  ) async {
    try {
      final res = await http.post(
        Uri.parse(
          '${Constants.url}/onboard-event',
        ),
        headers: {
          "accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": Constants.token
        },
        body: json.encode(
          {
            'eventId': event,
          },
        ),
      );

      return res;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<http.Response> deleteMedia(
    List<int> ids,
  ) async {
    try {
      final res = await http.delete(
        Uri.parse(
          '${Constants.url}/delete-media',
        ),
        headers: {
          "accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": Constants.token
        },
        body: json.encode({
          "mediaIds": ids,
          "uuid": HiveFunction.getUser().userId,
          "eventId": HiveFunction.getEvent().eventId
        }),
      );

      return res;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<Response> uploadFiles({
    required List<Map<String, String>> files,
    required String tag,
    // required String eventId,
  }) async {
    var dio = Dio();

    // Create a list of MultipartFile objects for images
    List<MultipartFile> imageFiles = [];
    if (true) {
      for (Map<String, String> file in files) {
        // print(file);
        Uint8List bytes = await XFile(file['path']!).readAsBytes();
        // print(type);
        // print("BYTES");
        // print(bytes);
        print("------------");
        print(
          "${file['path']!.split('/').last}.${file['type']!}",
        );
        print("------------");

        imageFiles.add(
          MultipartFile.fromBytes(
            bytes,
            filename:
                "${file['path']!.split('/').last}.${file['type']!.split('/').last}",
            contentType: MediaType('application', 'json'),
          ),
        );
      }
    } else {
      for (Map<String, String> file in files) {
        imageFiles.add(
          await MultipartFile.fromFile(
            file['path']!,
            filename: file['path']!.split('/').last + ".${file['type']!}",
          ),
        );
      }
    }
    print("FILE");
    print(imageFiles.first.contentType);
    var formData = FormData.fromMap(
      {
        'eventId': HiveFunction.getEvent().eventId,
        'uuid': HiveFunction.getUser().userId,
        'media': imageFiles,
        'tag': tag
      },
    );

    try {
      Response response = await dio.post(
        '${Constants.url}/upload-media',
        options: Options(
          headers: {
            "Authorization": Constants.token,
            'Content-Type': 'multipart/form-data',
          },
        ),
        data: formData,
      );

      return response;
    } catch (e) {
      throw e.toString();
    }

    // for (String path in files) {
    //   print(path);
    //   final result = await FilePicker.platform.pickFiles();
    //   final bytess = result?.files.single.bytes;
    //   // // print(bytess);
    //   // // final result = await FilePicker.platform.pickFiles();
    //   // final bytes = await XFile(path).readAsBytes();
    //   // print("BYTES");
    //   // // print(bytes);
    //   // print("------------");

    //   // imageFiles.add(
    //   //   MultipartFile.fromBytes(
    //   //     bytess!,
    //   //     filename: path.split('/').last,
    //   //     contentType: MultipartFile
    //   //   ),
    //   // );
    // }
    // } else {
    //   throw 'file upload failed';

    //   for (String path in files) {
    //     imageFiles.add(
    //       await MultipartFile.fromFile(
    //         path,
    //         filename: path.split('/').last,
    //       ),
    //     );
    //   }
    // }
    // print("FILE");
    // print(imageFiles.first.contentType);
    // var formData = FormData.fromMap(
    //   {
    //     'eventId': HiveFunction.getEvent().eventId,
    //     'uuid': HiveFunction.getUser().userId,
    //     'media': imageFiles,
    //     'tag': tag
    //   },
    // );

    // try {
    //   print(formData.boundary);
    //   print(formData.boundaryName);
    //   print(formData.fields);
    //   print(formData.files);
    //   Response response = await dio.post(
    //     '${Constants.url}/upload-media',
    //     options: Options(
    // headers: {
    //   'Access-Control-Allow-Origin': '*',
    //   'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    //   'Access-Control-Allow-Headers': 'multipart/form-data',
    //   "Authorization": Constants.token,
    //   'Content-Type': 'multipart/form-data',
    // },
    //     ),
    //     data: formData,
    //   );

    // return response;
    // } catch (e) {
    // throw e.toString();
    // }
  }
}
      // kIsWeb
      //       ? MultipartFile.fromString(path, filename: path.split('/').last)
      //       : 
//blob:http://localhost:62972/02fd5091-0459-4859-becd-83c4a46c6bff

  // static Future<http.StreamedResponse> uploadFiles({
  //   required List<String> files,
  //   required String tag,
  //   // required String eventId,
  // }) async {
  //   try {
  //     List<int>? _selectedFile;
  //     Uint8List? _bytesData;

  //     // Create a list of MultipartFile objects for images
  //     // if (kIsWeb) {
  //     html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  //     uploadInput.multiple = true;
  //     uploadInput.draggable = true;
  //     uploadInput.click();

  //     uploadInput.onChange.listen((event) {
  //       final files = uploadInput.files;
  //       final file = files![0];
  //       print(file.type);
  //       final reader = html.FileReader();

  //       reader.onLoadEnd.listen((event) {
  //         // setState(() {
  //         _bytesData =
  //             Base64Decoder().convert(reader.result.toString().split(",").last);
  //         _selectedFile = _bytesData;
  //         // });
  //       });
  //       reader.readAsDataUrl(file);
  //     });
  //     await Future.delayed(Duration(seconds: 4));
  //     var request = http.MultipartRequest(
  //       "POST",
  //       Uri.parse('${Constants.url}/upload-media'),
  //     );
  //     request.headers.addAll(
  //       {
  //         // 'Access-Control-Allow-Origin': '*',
  //         // 'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  //         // 'Access-Control-Allow-Headers': 'multipart/form-data',
  //         "Authorization": Constants.token,
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //     print("------FILE____");
  //     request.files.add(
  //       http.MultipartFile.fromBytes(
  //         'file',
  //         _selectedFile!,
          // contentType: MediaType('application', 'json'),
  //         filename: "Any_name",
  //       ),
  //     );
  //     request.fields.addAll({
  //       'eventId': HiveFunction.getEvent().eventId,
  //       'uuid': HiveFunction.getUser().userId,
  //       'tag': tag,
  //       'mimetype':files.first.
  //     });
  //     request.send().then((response) {
  //       print(response.statusCode);
  //       print(response.toString());
  //       print(response);
  //       print(response.reasonPhrase);
  //       print(response.headers);
  //       print(response.request);
  //       print(response);

  //       if (response.statusCode == 200) {
  //         return response;
  //       } else {
  //         print("-----------");
  //         throw 'file upload failed';
  //       }
  //     });

  //     throw "d";
  //   } catch (e) {
  //     throw "file upload failed";
  //   }

  //   // for (String path in files) {
  //   //   print(path);
  //   //   final result = await FilePicker.platform.pickFiles();
  //   //   final bytess = result?.files.single.bytes;
  //   //   // // print(bytess);
  //   //   // // final result = await FilePicker.platform.pickFiles();
  //   //   // final bytes = await XFile(path).readAsBytes();
  //   //   // print("BYTES");
  //   //   // // print(bytes);
  //   //   // print("------------");

  //   //   // imageFiles.add(
  //   //   //   MultipartFile.fromBytes(
  //   //   //     bytess!,
  //   //   //     filename: path.split('/').last,
  //   //   //     contentType: MultipartFile
  //   //   //   ),
  //   //   // );
  //   // }
  //   // } else {
  //   //   throw 'file upload failed';

  //   //   for (String path in files) {
  //   //     imageFiles.add(
  //   //       await MultipartFile.fromFile(
  //   //         path,
  //   //         filename: path.split('/').last,
  //   //       ),
  //   //     );
  //   //   }
  //   // }
  //   // print("FILE");
  //   // print(imageFiles.first.contentType);
  //   // var formData = FormData.fromMap(
  //   //   {
  //   //     'eventId': HiveFunction.getEvent().eventId,
  //   //     'uuid': HiveFunction.getUser().userId,
  //   //     'media': imageFiles,
  //   //     'tag': tag
  //   //   },
  //   // );

  //   // try {
  //   //   print(formData.boundary);
  //   //   print(formData.boundaryName);
  //   //   print(formData.fields);
  //   //   print(formData.files);
  //   //   Response response = await dio.post(
  //   //     '${Constants.url}/upload-media',
  //   //     options: Options(
  //   // headers: {
  //   //   'Access-Control-Allow-Origin': '*',
  //   //   'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  //   //   'Access-Control-Allow-Headers': 'multipart/form-data',
  //   //   "Authorization": Constants.token,
  //   //   'Content-Type': 'multipart/form-data',
  //   // },
  //   //     ),
  //   //     data: formData,
  //   //   );

  //   // return response;
  //   // } catch (e) {
  //   // throw e.toString();
  //   // }
  // }
