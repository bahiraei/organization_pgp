import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

import '../../../../core/core.dart';
import '../../data/model/slider_model.dart';

class HomeSlider extends StatelessWidget {
  final itemIndex = ValueNotifier<int>(0);
  final SliderModel? sliders;

  HomeSlider({
    super.key,
    required this.sliders,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Builder(
          builder: (context) {
            return AdaptiveBuilder.custom(
              defaultBuilder: (context, screen) {
                return CarouselSlider(
                  items: sliders?.data != null
                      ? sliders?.data!.map((slider) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowImageFullScreen(
                                    imageUrl:
                                        "${AppEnvironment.sliderBaseUrl}${slider.fileName}",
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: ImageLoadingService(
                                fit: BoxFit.fill,
                                imageUrl:
                                    "${AppEnvironment.sliderBaseUrl}${slider.fileName}",
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShowImageFullScreen(
                                        imageUrl:
                                            "${AppEnvironment.sliderBaseUrl}${slider.fileName}",
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }).toList()
                      : [],
                  options: CarouselOptions(
                    /* height: MediaQuery.of(context).size.width * 0.48,*/
                    autoPlay: true,
                    aspectRatio: 2.1,
                    autoPlayCurve: Curves.easeInOut,
                    autoPlayAnimationDuration: const Duration(
                      milliseconds: 800,
                    ),
                    onPageChanged: (index, reason) {
                      itemIndex.value = index;
                    },
                    autoPlayInterval: const Duration(
                      milliseconds: 8000,
                    ),
                    disableCenter: true,
                    enlargeCenterPage: true,
                    // bold item
                    pauseAutoPlayOnManualNavigate: true,
                    enableInfiniteScroll: true,
                    pauseAutoPlayOnTouch: true,
                    scrollDirection: Axis.horizontal,
                    scrollPhysics: const BouncingScrollPhysics(),
                    viewportFraction: 0.9,
                  ),
                );
              },
              allPlatformsDelegate: AdaptiveLayoutDelegateWithScreenSize(
                xSmall: (context, screen) {
                  return CarouselSlider(
                    items: sliders?.data != null
                        ? sliders?.data!.map((slider) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShowImageFullScreen(
                                      imageUrl:
                                          "${AppEnvironment.sliderBaseUrl}${slider.fileName}",
                                    ),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: ImageLoadingService(
                                  fit: BoxFit.fill,
                                  imageUrl:
                                      "${AppEnvironment.sliderBaseUrl}${slider.fileName}",
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ShowImageFullScreen(
                                          imageUrl:
                                              "${AppEnvironment.sliderBaseUrl}${slider.fileName}",
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }).toList()
                        : [],
                    options: CarouselOptions(
                      /*  height: MediaQuery.of(context).size.width * 0.48,*/
                      autoPlay: true,
                      aspectRatio: 2.1,
                      autoPlayCurve: Curves.easeInOut,
                      autoPlayAnimationDuration: const Duration(
                        milliseconds: 800,
                      ),
                      onPageChanged: (index, reason) {
                        itemIndex.value = index;
                      },
                      autoPlayInterval: const Duration(
                        milliseconds: 8000,
                      ),
                      disableCenter: true,
                      enlargeCenterPage: true,
                      // bold item
                      pauseAutoPlayOnManualNavigate: true,
                      enableInfiniteScroll: true,
                      pauseAutoPlayOnTouch: true,
                      scrollDirection: Axis.horizontal,
                      scrollPhysics: const BouncingScrollPhysics(),
                      viewportFraction: 0.9,
                    ),
                  );
                },
                small: (context, screen) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: CarouselSlider(
                          items: sliders?.data != null
                              ? sliders?.data!.map((slider) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ShowImageFullScreen(
                                            imageUrl:
                                                "${AppEnvironment.sliderBaseUrl}${slider.fileName}",
                                          ),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: ImageLoadingService(
                                        fit: BoxFit.fill,
                                        imageUrl:
                                            "${AppEnvironment.sliderBaseUrl}${slider.fileName}",
                                        borderRadius: BorderRadius.circular(16),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ShowImageFullScreen(
                                                imageUrl:
                                                    "${AppEnvironment.sliderBaseUrl}${slider.fileName}",
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }).toList()
                              : [],
                          options: CarouselOptions(
                            height: 250,
                            autoPlay: true,
                            aspectRatio: 2.1,
                            autoPlayCurve: Curves.easeInOut,
                            autoPlayAnimationDuration: const Duration(
                              milliseconds: 800,
                            ),
                            onPageChanged: (index, reason) {
                              itemIndex.value = index;
                            },
                            autoPlayInterval: const Duration(
                              milliseconds: 8000,
                            ),
                            disableCenter: true,
                            enlargeCenterPage: true,
                            // bold item
                            pauseAutoPlayOnManualNavigate: true,
                            enableInfiniteScroll: true,
                            pauseAutoPlayOnTouch: true,
                            scrollDirection: Axis.horizontal,
                            scrollPhysics: const BouncingScrollPhysics(),
                            viewportFraction: 0.9,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                medium: (context, screen) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: CarouselSlider(
                          items: sliders?.data != null
                              ? sliders?.data!.map((slider) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ShowImageFullScreen(
                                            imageUrl:
                                                "${AppEnvironment.sliderBaseUrl}${slider.fileName}",
                                          ),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: ImageLoadingService(
                                        fit: BoxFit.fill,
                                        imageUrl:
                                            "${AppEnvironment.sliderBaseUrl}${slider.fileName}",
                                        borderRadius: BorderRadius.circular(16),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ShowImageFullScreen(
                                                imageUrl:
                                                    "${AppEnvironment.sliderBaseUrl}${slider.fileName}",
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }).toList()
                              : [],
                          options: CarouselOptions(
                            height: 250,
                            autoPlay: true,
                            aspectRatio: 2.1,
                            autoPlayCurve: Curves.easeInOut,
                            autoPlayAnimationDuration: const Duration(
                              milliseconds: 800,
                            ),
                            onPageChanged: (index, reason) {
                              itemIndex.value = index;
                            },
                            autoPlayInterval: const Duration(
                              milliseconds: 8000,
                            ),
                            disableCenter: true,
                            enlargeCenterPage: true,
                            // bold item
                            pauseAutoPlayOnManualNavigate: true,
                            enableInfiniteScroll: true,
                            pauseAutoPlayOnTouch: true,
                            scrollDirection: Axis.horizontal,
                            scrollPhysics: const BouncingScrollPhysics(),
                            viewportFraction: 0.9,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                large: (context, screen) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: CarouselSlider(
                          items: sliders?.data != null
                              ? sliders?.data!.map((slider) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ShowImageFullScreen(
                                            imageUrl:
                                                "${AppEnvironment.sliderBaseUrl}${slider.fileName}",
                                          ),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: ImageLoadingService(
                                        fit: BoxFit.fill,
                                        imageUrl:
                                            "${AppEnvironment.sliderBaseUrl}${slider.fileName}",
                                        borderRadius: BorderRadius.circular(16),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ShowImageFullScreen(
                                                imageUrl:
                                                    "${AppEnvironment.sliderBaseUrl}${slider.fileName}",
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }).toList()
                              : [],
                          options: CarouselOptions(
                            height: 300,
                            autoPlay: true,
                            aspectRatio: 2.1,
                            autoPlayCurve: Curves.easeInOut,
                            autoPlayAnimationDuration: const Duration(
                              milliseconds: 800,
                            ),
                            onPageChanged: (index, reason) {
                              itemIndex.value = index;
                            },
                            autoPlayInterval: const Duration(
                              milliseconds: 8000,
                            ),
                            disableCenter: true,
                            enlargeCenterPage: true,
                            // bold item
                            pauseAutoPlayOnManualNavigate: true,
                            enableInfiniteScroll: true,
                            pauseAutoPlayOnTouch: true,
                            scrollDirection: Axis.horizontal,
                            scrollPhysics: const BouncingScrollPhysics(),
                            viewportFraction: 0.9,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                xLarge: (context, screen) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: CarouselSlider(
                          items: sliders?.data != null
                              ? sliders?.data!.map((slider) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ShowImageFullScreen(
                                            imageUrl:
                                                "${AppEnvironment.sliderBaseUrl}${slider.fileName}",
                                          ),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: ImageLoadingService(
                                        fit: BoxFit.fill,
                                        imageUrl:
                                            "${AppEnvironment.sliderBaseUrl}${slider.fileName}",
                                        borderRadius: BorderRadius.circular(16),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ShowImageFullScreen(
                                                imageUrl:
                                                    "${AppEnvironment.sliderBaseUrl}${slider.fileName}",
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }).toList()
                              : [],
                          options: CarouselOptions(
                            height: 300,
                            autoPlay: true,
                            aspectRatio: 2.1,
                            autoPlayCurve: Curves.easeInOut,
                            autoPlayAnimationDuration: const Duration(
                              milliseconds: 800,
                            ),
                            onPageChanged: (index, reason) {
                              itemIndex.value = index;
                            },
                            autoPlayInterval: const Duration(
                              milliseconds: 8000,
                            ),
                            disableCenter: true,
                            enlargeCenterPage: true,
                            // bold item
                            pauseAutoPlayOnManualNavigate: true,
                            enableInfiniteScroll: true,
                            pauseAutoPlayOnTouch: true,
                            scrollDirection: Axis.horizontal,
                            scrollPhysics: const BouncingScrollPhysics(),
                            viewportFraction: 0.9,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
