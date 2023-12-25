import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';

import '../core.dart';

class ImageLoadingService extends StatefulWidget {
  final String imageUrl;
  final LoadingErrorWidgetBuilder? errorWidget;
  final BorderRadius? borderRadius;
  final bool placeholder;
  final BoxFit fit;
  final bool canZoom;
  final bool canView;
  final VoidCallback? onTap;

  const ImageLoadingService({
    super.key,
    required this.imageUrl,
    this.borderRadius,
    this.placeholder = true,
    this.canZoom = false,
    this.canView = false,
    this.errorWidget,
    this.fit = BoxFit.cover,
    this.onTap,
  });

  @override
  State<ImageLoadingService> createState() => _ImageLoadingServiceState();
}

class _ImageLoadingServiceState extends State<ImageLoadingService> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageBuilder: (context, imageProvider) {
        return InkWell(
          borderRadius: widget.borderRadius ?? BorderRadius.zero,
          onTap: widget.onTap ??
              () {
                if (!widget.canView) return;
                /* final imageProvider = Image.network(
              widget.imageUrl,
            ).image;
            showImageViewer(
              context,
              imageProvider,
              onViewerDismissed: () {},
              swipeDismissible: true,
              immersive: false,
              useSafeArea: true,
            );*/
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShowImageFullScreen(
                      imageUrl: widget.imageUrl,
                      isBase64: false,
                    ),
                  ),
                );
              },
          child: ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.zero,
            child: widget.canZoom
                ? PinchZoomImage(
                    image: Image(
                      image: imageProvider,
                      fit: widget.fit,
                    ),
                    zoomedBackgroundColor: const Color.fromRGBO(
                      240,
                      240,
                      240,
                      1.0,
                    ),
                    hideStatusBarWhileZooming: true,
                  )
                : Image(
                    image: imageProvider,
                    fit: widget.fit,
                    alignment: Alignment.center,
                  ),
          ),
        );
      },
      /*placeholder: widget.placeholder
          ? (context, url) => ShimmerWidget.rectangular(
                aspectRatio: 1,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: widget.borderRadius ?? BorderRadius.zero,
                ),
              )
          : null,*/
      imageUrl: widget.imageUrl,
      errorWidget: widget.errorWidget,
    );
  }
}
