import 'dart:io';

import 'package:android_package_installer/android_package_installer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/core.dart';
import '../auth/data/model/app_version.dart';

class UpdateScreen extends StatefulWidget {
  final AppVersion appVersion;

  const UpdateScreen({
    super.key,
    required this.appVersion,
  });

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  ValueNotifier<int> receivedNotifier = ValueNotifier<int>(0);
  ValueNotifier<int> totalNotifier = ValueNotifier<int>(0);
  ValueNotifier<bool> completeNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> startNotifier = ValueNotifier<bool>(false);

  bool isInstalling = false;

  @override
  void initState() {
    _deleteCacheDir();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff1f2b39),
              Color(0xff0a121d),
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
              valueListenable: startNotifier,
              builder: (context, value, child) {
                if (startNotifier.value) {
                  return downloadView(context);
                } else {
                  return ValueListenableBuilder(
                    valueListenable: completeNotifier,
                    builder: (context, value, child) {
                      if (completeNotifier.value) {
                        return completeView(context);
                      } else {
                        return updateView(context);
                      }
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget downloadView(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      padding: const EdgeInsets.symmetric(
        horizontal: 48,
        vertical: 48,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.black38,
      ),
      child: Column(
        children: [
          ValueListenableBuilder(
            builder: (context, value, child) {
              return CircularPercentIndicator(
                radius: 64.0,
                lineWidth: 8.0,
                percent:
                    !(((receivedNotifier.value) / (totalNotifier.value) * 100) /
                                100)
                            .isNaN
                        ? (((receivedNotifier.value) /
                                (totalNotifier.value) *
                                100) /
                            100)
                        : 0.0,
                center: !((receivedNotifier.value / totalNotifier.value * 100)
                        .isNaN)
                    ? Text(
                        "${(receivedNotifier.value / totalNotifier.value * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          wordSpacing: 1.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "0%",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          wordSpacing: 1.5,
                          color: Colors.white,
                        ),
                      ),
                progressColor: Colors.blue,
              );
            },
            valueListenable: receivedNotifier,
          ),
          const SizedBox(height: 24),
          const Text(
            'در حال دانلود',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget completeView(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 48,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.black38,
      ),
      child: Column(
        children: [
          const Text(
            'اپلیکیشن آماده نصب است',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            '- جهت نصب بروزرسانی باید دسترسی نصب اپلیکیشن را فعال کنید.',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              wordSpacing: 1.5,
              height: 2,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '- بعد از نصب برنامه، برنامه به صورت خودکار بسته خواهد شد',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              wordSpacing: 1.5,
              height: 2,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 48),
          if (!isInstalling)
            CustomButton(
              width: 164,
              height: 50,
              onPressed: () async {
                final status = await PermissionHandler.getStoragePermission();

                if (status.isGranted) {
                  var tempDir = await getTemporaryDirectory();
                  String basename = widget.appVersion.url!.split('/').last;
                  String fullPath = "${tempDir.path}/$basename";
                  Helper.log('full path $fullPath');

                  if (!await File(fullPath).exists()) {
                    if (mounted) {
                      Helper.showSnackBar(
                        'فایل مورد نظر یافت نشد',
                        context,
                      );
                    }
                  }

                  final requestInstallPackageStatus = await PermissionHandler
                      .getRequestInstallPackagePermission();

                  if (requestInstallPackageStatus.isPermanentlyDenied) {
                    if (mounted) {
                      Helper.showSnackBar(
                        'مجوز نصب برنامه به صورت دائمی مسدود است',
                        context,
                      );
                      return;
                    }
                  } else if (!requestInstallPackageStatus.isGranted) {
                    if (mounted) {
                      Helper.showSnackBar(
                        'بروزرسانی برنامه نیاز به مجوز نصب اپلیکیشن دارد',
                        context,
                      );
                    }
                    return;
                  }
                  setState(() {
                    isInstalling = true;
                  });
                  int? statusCode = await AndroidPackageInstaller.installApk(
                    apkFilePath: fullPath,
                  );

                  Helper.log('statusCode => $statusCode');
                  if (statusCode != null) {
                    setState(() {
                      isInstalling = false;
                    });
                    PackageInstallerStatus installationStatus =
                        PackageInstallerStatus.byCode(statusCode);
                  }
                } else {
                  if (mounted) {
                    Helper.showSnackBar(
                      'مجوز خواندن و نوشتن تخصیص داده نشده است',
                      context,
                    );
                  }
                }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.install_mobile_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'نصب برنامه',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          if (isInstalling)
            const Column(
              children: [
                CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 6,
                ),
                SizedBox(height: 8),
                Text(
                  'در حال نصب',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget updateView(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 48,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.black38,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'بروزرسانی اپلیکیشن',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                widget.appVersion.description ?? '',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  wordSpacing: 1.5,
                  height: 2,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    width: 164,
                    height: 50,
                    showShadow: false,
                    onPressed: () async {
                      final status =
                          await PermissionHandler.getStoragePermission();

                      Helper.log(status.toString());
                      if (status.isGranted) {
                        await _deleteCacheDir();
                        var tempDir = await getTemporaryDirectory();
                        String basename =
                            widget.appVersion.url!.split('/').last;
                        String fullPath = "${tempDir.path}/$basename";
                        Helper.log('full path $fullPath');

                        download2(Dio(), widget.appVersion.url!, fullPath);
                      } else if (status.isDenied) {
                        if (mounted) {
                          Helper.showSnackBar(
                            'برای دانلود بروزرسانی نیاز به مجوز فایل داریم',
                            context,
                          );
                        }
                        return;
                      } else if (!status.isGranted) {
                        if (mounted) {
                          Helper.showSnackBar(
                            'مجوز فایل به صورت دائم مسدود شده است',
                            context,
                          );
                          return;
                        }
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'دانلود بروزرسانی',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future download2(
    Dio dio,
    String url,
    String savePath,
  ) async {
    try {
      receivedNotifier.value = 0;
      totalNotifier.value = 0;
      startNotifier.value = true;
      completeNotifier.value = false;
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      Helper.log(response.headers.toString());
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
      completeNotifier.value = true;
      startNotifier.value = false;
    } catch (e) {
      receivedNotifier.value = 0;
      totalNotifier.value = 0;
      startNotifier.value = false;
      completeNotifier.value = false;
      if (e is DioException) {
        Helper.showSnackBar('خطا در دانلود بروزرسانی', context);
      }
      Helper.log(e.toString());
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      Helper.log(received.toString());
      Helper.log(total.toString());
      Helper.log((received / total * 100).toStringAsFixed(0) + "%");

      receivedNotifier.value = received;
      totalNotifier.value = total;
    }
  }

  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }
}
