import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file_safe_plus/open_file_safe_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../core/service/file-manager-handler.dart';
import '../../core/service/permission-handler.dart';

class PdfScreen extends StatefulWidget {
  final PdfScreenParams params;

  const PdfScreen({
    super.key,
    required this.params,
  });

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text(
          widget.params.pageTitle,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () {
              _pdfViewerController.previousPage();
              setState(() {});
            },
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              '${_pdfViewerController.pageNumber}/${_pdfViewerController.pageCount}',
              style: const TextStyle(fontSize: 22),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: () {
              _pdfViewerController.nextPage();
              setState(() {});
            },
          ),
        ],
      ),
      body: SfPdfViewer.memory(
        widget.params.data,
        controller: _pdfViewerController,
        onDocumentLoaded: (details) {
          setState(() {});
        },
        onDocumentLoadFailed: (details) async {
          /*Helper.showToast(
            title: details.error,
            description: details.description,
            context: context,
          );*/
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

              OpenFileSafePlus.open(file.path);
            }
          }
        },
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

  @override
  void dispose() {
    super.dispose();
  }
}

class PdfScreenParams {
  final Uint8List data;
  final String name;
  final String pageTitle;

  PdfScreenParams({
    required this.data,
    required this.name,
    required this.pageTitle,
  });
}
