import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/messages/data/model/message_model.dart';
import '../consts/app_environment.dart';

class ShowImageFullScreen extends StatefulWidget {
  final String? imageUrl;
  final String? baseUrl;
  final bool isBase64;
  final Uint8List? base64Image;
  final List? images;
  final int selectedImageFromList;

  const ShowImageFullScreen({
    super.key,
    this.imageUrl,
    this.isBase64 = false,
    this.base64Image,
    this.images,
    this.selectedImageFromList = 0,
    this.baseUrl,
  });

  @override
  State<ShowImageFullScreen> createState() => _ShowImageFullScreenState();
}

class _ShowImageFullScreenState extends State<ShowImageFullScreen> {
  int selectedPage = 0;

  PageController? controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.selectedImageFromList);
    selectedPage = widget.selectedImageFromList;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images?.isEmpty ?? true) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            if (!widget.isBase64)
              IconButton(
                onPressed: () async {
                  final url = Uri.parse(widget.imageUrl ?? '');

                  await launchUrl(
                    url,
                    mode: LaunchMode.externalNonBrowserApplication,
                  );
                },
                icon: const Icon(Icons.download),
              ),
          ],
        ),
        body: !widget.isBase64
            ? Center(
                child: PhotoView(
                  imageProvider: NetworkImage(widget.imageUrl!),
                ),
              )
            : Center(
                child: PhotoView(
                  imageProvider: MemoryImage(widget.base64Image!),
                ),
              ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            if (!widget.isBase64 && (widget.images?.isNotEmpty ?? false))
              IconButton(
                onPressed: () async {
                  final String baseUrl =
                      (widget.baseUrl ?? AppEnvironment.projectStatusBaseUrl);
                  final String path = widget.images![selectedPage] is Images
                      ? (widget.images![selectedPage] as Images).fileName!
                      : widget.images![selectedPage]['fileName'];

                  final url = Uri.parse(baseUrl + path);

                  await launchUrl(
                    url,
                    mode: LaunchMode.externalNonBrowserApplication,
                  );
                },
                icon: const Icon(Icons.download),
              ),
          ],
        ),
        body: PageView.builder(
          scrollDirection: Axis.horizontal,
          controller: controller,
          itemCount: widget.images?.length ?? 0,
          itemBuilder: (context, index) {
            return Center(
              child: PhotoView(
                imageProvider: NetworkImage(
                  (widget.baseUrl ?? AppEnvironment.projectStatusBaseUrl) +
                      (widget.images![index] is Images
                          ? (widget.images![index] as Images).fileName
                          : widget.images![index]['fileName']),
                ),
              ),
            );
          },
          onPageChanged: (page) {
            setState(() {
              selectedPage = page;
            });
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
