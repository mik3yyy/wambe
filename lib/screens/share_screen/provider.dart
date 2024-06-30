import 'package:flutter/material.dart';
import 'package:wambe/models/media.dart';

class ShareProvider extends ChangeNotifier {
  Map<String, List<Media>>? media;
  updateMedia(Map<String, List<Media>> m, {bool add = false}) {
    media = m;
    notifyListeners();
  }
}
