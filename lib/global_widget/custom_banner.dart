import 'package:flutter/material.dart';
import 'dart:async';

class BannerWidget extends StatefulWidget {
  final List<String> images;

  BannerWidget({required this.images});

  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.images.length;
      });
    });
  }

  void _onImageTap(int index) {
    setState(() {
      _currentIndex = index;
      _timer.cancel();
      _startTimer();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double bannerWidth = screenWidth * 0.9;
    double expandedWidth = bannerWidth * 0.9;
    double imageWidth = (bannerWidth - expandedWidth) /
        (widget.images.length - 1); // widget.images.length;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.images.asMap().entries.map((entry) {
            int index = entry.key;
            String imageUrl = entry.value;

            return GestureDetector(
              onTap: () {
                _onImageTap(index);
              },
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                width: _currentIndex == index ? expandedWidth : imageWidth,
                height: 100,
                margin: EdgeInsets.symmetric(horizontal: 0.0),
                decoration: BoxDecoration(
                  borderRadius: index == widget.images.length - 1
                      ? BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )
                      : index == 0
                          ? BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            )
                          : null,
                  image: DecorationImage(
                    image: AssetImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: _currentIndex != index
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: index == widget.images.length - 1
                              ? BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                )
                              : index == 0
                                  ? BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    )
                                  : null,
                        ),
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}



// import 'package:flutter/material.dart';
// import 'dart:async';

// class BannerWidget extends StatefulWidget {
//   final List<String> images;

//   BannerWidget({required this.images});

//   @override
//   _BannerWidgetState createState() => _BannerWidgetState();
// }

// class _BannerWidgetState extends State<BannerWidget> {
//   int _currentIndex = 0;
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 5), (timer) {
//       setState(() {
//         _currentIndex = (_currentIndex + 1) % widget.images.length;
//       });
//     });
//   }

//   void _onImageTap(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double bannerWidth = screenWidth * 0.8;
//     double expandedWidth = bannerWidth * 0.6;
//     double imageWidth = (bannerWidth - expandedWidth) /
//         (widget.images.length - 1); // widget.images.length;

//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: widget.images.asMap().entries.map((entry) {
//             int index = entry.key;
//             String imageUrl = entry.value;

//             return GestureDetector(
//               onTap: () {
//                 _onImageTap(index);
//               },
//               child: AnimatedContainer(
//                 duration: Duration(seconds: 1),
//                 width: _currentIndex == index ? expandedWidth : imageWidth,
//                 height: 100,
//                 margin: EdgeInsets.symmetric(horizontal: 1),
//                 decoration: BoxDecoration(
//                   // borderRadius: BorderRadius.circular(10.0),
//                   image: DecorationImage(
//                     image: AssetImage(imageUrl),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: _currentIndex != index
//                     ? Container(
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.5),
//                           borderRadius:
//                               index == widget.images.length - 1 || index == 0
//                                   ? BorderRadius.circular(10.0)
//                                   : null,
//                         ),
//                       )
//                     : null,
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }
