import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

bool isSvg({required String url}) {
  return url.toLowerCase().endsWith('.svg');
}

Widget createImageNetwork({required String url, Color? color}) {
  if (isSvg(url: url)) {
    return SvgPicture.network(url, fit: BoxFit.cover,
    color: color,
    );
  } else {
    return Image.network(url, fit: BoxFit.cover, color: color);
  }
}