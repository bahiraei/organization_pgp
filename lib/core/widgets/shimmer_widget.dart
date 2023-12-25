/*class ShimmerWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? baseColor;
  final Color? highlightColor;
  final Color? color;
  final ShapeBorder shapeBorder;
  final double? aspectRatio;

  const ShimmerWidget.rectangular({
    Key? key,
    this.width,
    this.height,
    this.baseColor,
    this.highlightColor,
    this.color,
    this.shapeBorder = const RoundedRectangleBorder(),
    this.aspectRatio = 1,
  })  : assert(width == null || aspectRatio == null),
        assert(height == null || aspectRatio == null),
        super(key: key);

  const ShimmerWidget.circular({
    Key? key,
    this.width,
    this.height,
    this.baseColor,
    this.highlightColor,
    this.color,
    this.shapeBorder = const CircleBorder(),
    this.aspectRatio = 1,
  })  : assert(width == null || aspectRatio == null),
        assert(height == null || aspectRatio == null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (aspectRatio != null && width == null && height == null) {
      return AspectRatio(
        aspectRatio: aspectRatio!,
        child: Shimmer.fromColors(
          baseColor: baseColor ?? Colors.grey.shade300,
          highlightColor: highlightColor ?? Colors.grey.shade100,
          child: Container(
            decoration: ShapeDecoration(
              color: color ?? Colors.grey,
              shape: shapeBorder,
            ),
          ),
        ),
      );
    } else {
      return Shimmer.fromColors(
        baseColor: baseColor ?? Colors.grey.shade300,
        highlightColor: highlightColor ?? Colors.grey.shade100,
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: color ?? Colors.grey,
            shape: shapeBorder,
          ),
        ),
      );
    }
  }
}*/
