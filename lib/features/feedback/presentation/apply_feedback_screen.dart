import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/helper.dart';
import '../../../core/widgets/app_bg.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/custom_text_form_field.dart';
import '../../../core/widgets/title_bar.dart';
import '../data/enum/department_enum.dart';
import '../data/repository/feedback_repository.dart';
import 'bloc/feedback_bloc.dart';

class ApplyFeedbackScreen extends StatefulWidget {
  const ApplyFeedbackScreen({super.key});

  @override
  State<ApplyFeedbackScreen> createState() => _ApplyFeedbackScreenState();
}

class _ApplyFeedbackScreenState extends State<ApplyFeedbackScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  List<PlatformFile> files = [];

  DepartmentsEnum? selectedDepartment;

  bool isUnknown = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider<FeedbackBloc>(
      create: (context) {
        final bloc = FeedbackBloc(
          repository: feedbackRepository,
          context: context,
        );

        return bloc;
      },
      child: Scaffold(
        body: SafeArea(
          child: AppBackground(
            size: size,
            child: Column(
              children: [
                TitleBar(
                  size: size,
                  title: 'ثبت انتقادات و یشنهادات',
                  onTap: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                    child: Container(
                      width: size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 48, 0, 0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32),
                                  child:
                                      DropdownButtonFormField2<DepartmentsEnum>(
                                    value: selectedDepartment,
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      // Add Horizontal padding using menuItemStyleData.padding so it matches
                                      // the menu padding when button's width is not specified.
                                      prefixIcon: const Icon(
                                        Icons.workspaces,
                                      ),
                                      errorStyle: const TextStyle(
                                        fontSize: 12,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      // Add more decoration..
                                    ),
                                    hint: const Text(
                                      'انتخاب اداره',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    items: departments
                                        .map((item) =>
                                            DropdownMenuItem<DepartmentsEnum>(
                                              value: item,
                                              child: Text(
                                                item.value,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'اداره مرتبط را انتخاب نمایید';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDepartment = value;
                                      });
                                    },
                                    onSaved: (value) {
                                      setState(() {
                                        selectedDepartment = value;
                                      });
                                    },
                                    buttonStyleData: const ButtonStyleData(
                                      padding: EdgeInsets.only(right: 8),
                                    ),
                                    iconStyleData: const IconStyleData(
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black45,
                                      ),
                                      iconSize: 24,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32),
                                  child: CustomTextFormField(
                                    label: const Text(
                                      'عنوان',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    hintText: 'عنوان را وارد کنید',
                                    keyboardType: TextInputType.text,
                                    controller: titleController,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    hintStyle: const TextStyle(
                                      fontSize: 15,
                                    ),
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'عنوان درخواست را وارد کنید';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32),
                                  child: CustomTextFormField(
                                    label: const Text(
                                      'شرح درخواست',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    hintText: 'شرح درخواست را وارد کنید',
                                    maxLines: 4,
                                    controller: descriptionController,
                                    showClearButton: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    hintStyle: const TextStyle(
                                      fontSize: 15,
                                    ),
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'شرح درخواست را وارد کنید';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 24),
                                if (files.isNotEmpty)
                                  SizedBox(
                                    height: 80,
                                    child: ListView.builder(
                                      itemCount: files.length,
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final PlatformFile file = files[index];

                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 60,
                                                width: 190,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                  16,
                                                  8,
                                                  16,
                                                  8,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.20),
                                                      offset:
                                                          const Offset(0, 3),
                                                      blurRadius: 6,
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color:
                                                            Color(0xff0090FF),
                                                      ),
                                                      child: const Icon(
                                                        Icons
                                                            .file_present_rounded,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        file.name,
                                                        style: const TextStyle(
                                                          overflow:
                                                              TextOverflow.fade,
                                                          color:
                                                              Color(0xff0090FF),
                                                          fontSize: 13,
                                                        ),
                                                        maxLines: 1,
                                                        textDirection:
                                                            TextDirection.ltr,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    InkWell(
                                                      onTap: () {
                                                        files.removeAt(index);
                                                        setState(() {});
                                                      },
                                                      child: const Icon(
                                                        Icons.delete,
                                                        size: 22,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                if (files.isNotEmpty)
                                  const SizedBox(height: 24),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32),
                                  child: DottedBorder(
                                    color: Colors.black38,
                                    strokeWidth: 1,
                                    radius: const Radius.circular(32),
                                    borderType: BorderType.RRect,
                                    dashPattern: const [12, 4, 12, 4],
                                    child: Container(
                                      height: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(32),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'آپلود فایل ضمیمه',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              OutlinedButton(
                                                onPressed: () async {
                                                  FilePickerResult? result =
                                                      await FilePicker.platform
                                                          .pickFiles(
                                                    allowMultiple: true,
                                                    type: FileType.custom,
                                                    allowCompression: true,
                                                    allowedExtensions: [
                                                      'pdf',
                                                      'png',
                                                      'zip',
                                                      'rar',
                                                      'jpg',
                                                      'jpeg',
                                                      'doc',
                                                      'docx',
                                                      'rtf',
                                                      'xls',
                                                      'xlsx',
                                                      'pptx',
                                                      'ppt',
                                                      'txt',
                                                    ],
                                                  );

                                                  if (result != null) {
                                                    for (PlatformFile file
                                                        in result.files) {
                                                      if (file.size <=
                                                          4 * 1024 * 1024) {
                                                        // 4 MB in bytes
                                                        files.add(file);
                                                      } else {
                                                        if (mounted) {
                                                          Helper.showToast(
                                                            title: 'پیام!',
                                                            description:
                                                                "حجم فایل انتخابی باید کمتر از 4 مگابایت باشد",
                                                            context: context,
                                                          );
                                                        }
                                                      }
                                                    }
                                                    setState(() {});
                                                    // دستکاری و استفاده از فایل‌های انتخاب شده در اینجا
                                                  }
                                                },
                                                child: const Text(
                                                  'انتخاب فایل',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: isUnknown,
                                        onChanged: (value) {
                                          setState(() {
                                            isUnknown = !isUnknown;
                                          });
                                        },
                                      ),
                                      const Text(
                                        'ارسال به صورت ناشناس',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                BlocConsumer<FeedbackBloc, FeedbackState>(
                                  listener: (context, state) {
                                    if (state is FeedbackApplyUserSuccess) {
                                      Navigator.of(context).pop(true);
                                    } else if (state
                                        is FeedbackApplyUserError) {
                                      Helper.showToast(
                                        title: 'پیام!',
                                        description: state.exception.message ??
                                            'حطا در ثبت بازخورد',
                                        context: context,
                                      );
                                    }
                                  },
                                  builder: (context, state) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32),
                                      child: AppButton(
                                        text: 'ثبت اطلاعات',
                                        isLoading:
                                            state is FeedbackApplyUserLoading,
                                        onClick: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            BlocProvider.of<FeedbackBloc>(
                                                    context)
                                                .add(
                                              FeedbackApplyUserStarted(
                                                title: titleController.text,
                                                description:
                                                    descriptionController.text,
                                                type: selectedDepartment!.index,
                                                files: files,
                                              ),
                                            );
                                          }
                                        },
                                        height: 54,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 48),
                              ],
                            ),
                          ),
                        ),
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
