import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organization_pgp/core/widgets/empty_view.dart';
import 'package:organization_pgp/features/secondary_pdf/secondary_pdf_screen.dart';

import '../../../core/utils/helper.dart';
import '../../../core/utils/routes.dart';
import '../../../core/widgets/app_bg.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/month_picker.dart';
import '../../../core/widgets/title_bar.dart';
import '../data/repository/fish_repository.dart';
import 'bloc/fish_bloc.dart';

class FishScreen extends StatefulWidget {
  const FishScreen({
    super.key,
  });

  @override
  State<FishScreen> createState() => _FishScreenState();
}

class _FishScreenState extends State<FishScreen> {
  String? selectYear;
  String? selectedMonth;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenSize = Screen.fromContext(context).screenSize;

    double mainMargin = 0;

    if (screenSize == ScreenSize.xsmall) {
      mainMargin = 8;
    } else if (screenSize == ScreenSize.small) {
      mainMargin = 70;
    } else if (screenSize == ScreenSize.medium) {
      mainMargin = 300;
    } else if (screenSize == ScreenSize.large) {
      mainMargin = 500;
    } else if (screenSize == ScreenSize.xlarge) {
      mainMargin = 600;
    }

    return BlocProvider(
      create: (context) {
        final bloc = FishBloc(
          repository: fishRepository,
          context: context,
        );

        return bloc;
      },
      child: SafeArea(
        child: Scaffold(
          body: AppBackground(
            size: size,
            child: Column(
              children: [
                TitleBar(
                  size: size,
                  title: 'فیش حقوقی',
                  onTap: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.fromLTRB(mainMargin, 0, mainMargin, 0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      child: Column(
                        children: [
                          BlocConsumer<FishBloc, FishState>(
                            listener: (context, state) {
                              if (state is FishSuccess) {
                                Navigator.of(context).pushNamed(
                                  Routes.secondaryPDF,
                                  arguments: SecondaryPdfScreenParams(
                                    data: state.file,
                                    name: 'fish-${state.year}-${state.month}',
                                    pageTitle: "فیش حقوقی",
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              return Container(
                                margin:
                                    const EdgeInsets.fromLTRB(16, 32, 16, 16),
                                padding:
                                    const EdgeInsets.fromLTRB(16, 12, 16, 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 3,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'لطفا یک تاریخ را انتخاب کنید:',
                                          style: TextStyle(),
                                        ),
                                        OutlinedButton(
                                          onPressed: () async {
                                            Helper.log(
                                                "$selectYear/$selectedMonth/01");

                                            String initialDate = "";
                                            if ((selectYear?.isNotEmpty ??
                                                    false) &&
                                                (selectedMonth?.isNotEmpty ??
                                                    false)) {
                                              initialDate =
                                                  '$selectYear/$selectedMonth/01';
                                            }
                                            final result = await showDialog(
                                              context: context,
                                              builder: (context) {
                                                return CustomMonthPicker(
                                                  initialDate: initialDate,
                                                );
                                              },
                                            );

                                            if (result != null) {
                                              selectYear = result['year'];
                                              selectedMonth = result['month'];

                                              setState(() {});
                                            }
                                          },
                                          child: const Text(
                                            'انتخاب تاریخ',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      selectYear == null ||
                                              selectedMonth == null
                                          ? ''
                                          : "$selectedMonth - $selectYear",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Builder(
                                      builder: (context) {
                                        return CustomButton(
                                          onPressed: () async {
                                            BlocProvider.of<FishBloc>(context)
                                                .add(
                                              FishStarted(
                                                year: selectYear!,
                                                month: selectedMonth!,
                                              ),
                                            );
                                          },
                                          borderRadius: 12,
                                          showShadow: false,
                                          elevation: 0,
                                          showLoading: true,
                                          isLoading: state is FishLoading,
                                          backgroundColor: false ||
                                                  selectYear == null ||
                                                  selectedMonth == null
                                              ? Colors.blueGrey
                                              : Colors.blue,
                                          isDisable: selectYear == null ||
                                              selectedMonth == null,
                                          height: 44,
                                          child: const Text(
                                            'محاسبه فیش',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          BlocBuilder<FishBloc, FishState>(
                            builder: (context, state) {
                              Helper.log(state.toString());
                              if (state is FishError) {
                                return Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        state.exception.message ??
                                            'خطایی رخ داده است',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (state is FishEmpty) {
                                return const Expanded(
                                  child: EmptyView(
                                    title: 'فیش مورد نظر یافت نشد.',
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
