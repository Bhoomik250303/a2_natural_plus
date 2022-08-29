import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HorizontalBannerScrollWidget extends StatefulWidget {
  List<Widget> listOfImagesUrls;
  double height;
  HorizontalBannerScrollWidget(
      {required this.listOfImagesUrls, required this.height});

  @override
  _HorizontalBannerScrollWidgetState createState() =>
      _HorizontalBannerScrollWidgetState();
}

class _HorizontalBannerScrollWidgetState
    extends State<HorizontalBannerScrollWidget> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    return CarouselSlider(
      items: widget.listOfImagesUrls,
      options: CarouselOptions(
        enlargeCenterPage: false,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(
          milliseconds: 500,
        ),
        viewportFraction: 1,
      ),
    );
  }
}
