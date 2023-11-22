import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading(
      {Key? key,
      this.width = double.infinity,
      this.height = 50,
      this.borderRadius = 10})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
            width: width,
            height: height,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
              ),
            )));
  }
}
