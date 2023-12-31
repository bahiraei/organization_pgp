import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/service/file-manager-handler.dart';
import '../../core/service/permission-handler.dart';

class SecondaryPdfScreen extends StatefulWidget {
  final SecondaryPdfScreenParams params;

  const SecondaryPdfScreen({
    super.key,
    required this.params,
  });

  @override
  State<SecondaryPdfScreen> createState() => _SecondaryPdfScreenState();
}

class _SecondaryPdfScreenState extends State<SecondaryPdfScreen> {
  static const int _initialPage = 1;
  PdfControllerPinch? _pdfControllerPinch;

  @override
  void initState() {
    _pdfControllerPinch = PdfControllerPinch(
      document: PdfDocument.openData(
        widget.params.data,
      ),
      initialPage: _initialPage,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pdfControllerPinch?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('نمایش فایل'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () {
              _pdfControllerPinch?.previousPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
          PdfPageNumber(
            controller: _pdfControllerPinch!,
            builder: (_, loadingState, page, pagesCount) => Container(
              alignment: Alignment.center,
              child: Text(
                '$page/${pagesCount ?? 0}',
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: () {
              _pdfControllerPinch?.nextPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _pdfControllerPinch?.loadDocument(
                PdfDocument.openData(
                  widget.params.data,
                ),
              );
            },
          ),
        ],
      ),
      body: PdfViewPinch(
        builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
            options: const DefaultBuilderOptions(),
            documentLoaderBuilder: (_) =>
                const Center(child: CircularProgressIndicator()),
            pageLoaderBuilder: (_) =>
                const Center(child: CircularProgressIndicator()),
            errorBuilder: (_, error) {
              return const Center(
                child: Text(
                  'درنمایش فایل مشکلی رخ داده است، بر روی دکمه دانلود کلیک نمایید',
                ),
              );
            }),
        controller: _pdfControllerPinch!,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (kIsWeb) {
            FileManagerHandler.saveFileInWeb(
              widget.params.data,
              '${widget.params.name}.pdf',
            );
          } else {
            final status = await PermissionHandler.getStoragePermission();

            if (status != PermissionStatus.granted) {
              return;
            }
            final file = await FileManagerHandler.saveFile(
              name: '${widget.params.name}.pdf',
              data: widget.params.data,

              /*'fish-${state.year}-${state.month}.pdf',*/
            );
            if (mounted && file != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'فایل با موفقیت ذخیره شد',
                  ),
                ),
              );
            }
          }
        },
        // ignore: prefer_const_constructors
        label: Row(
          children: const [
            Icon(Icons.download),
            SizedBox(width: 4),
            Text('دانلود'),
          ],
        ),
      ),
    );
  }
}

class SecondaryPdfScreenParams {
  final Uint8List data;
  final String name;
  final String pageTitle;

  SecondaryPdfScreenParams({
    required this.data,
    required this.name,
    required this.pageTitle,
  });
}
