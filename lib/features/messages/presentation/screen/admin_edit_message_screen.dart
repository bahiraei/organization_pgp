import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:organization_pgp/features/messages/presentation/bloc/message_bloc.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../../core/core.dart';
import '../../data/model/admin_message_model.dart';
import '../../data/repository/message_repository.dart';

class AdminEditMessageScreen extends StatefulWidget {
  final AdminEditMessageParam param;

  const AdminEditMessageScreen({
    super.key,
    required this.param,
  });

  @override
  State<AdminEditMessageScreen> createState() => _AdminEditMessageScreenState();
}

class _AdminEditMessageScreenState extends State<AdminEditMessageScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  bool canUserComment = true;
  bool isActive = true;

  Jalali? startShowFa;
  Jalali? endShowFa;
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  String? selectedEventId;
  int? selectedPersonnelGroupId;
  String? selectedPersonnelCategoryId;

  MessageCategoryType selectedMessageCategory = MessageCategoryType.all;

  final ImagePicker picker = ImagePicker();
  XFile? selectedImage;

  @override
  void initState() {
    titleController.text = widget.param.adminMessageModel.title;
    descriptionController.text = widget.param.adminMessageModel.fullText ?? '';
    isActive = widget.param.adminMessageModel.isActive;
    canUserComment = widget.param.adminMessageModel.canYouComment;

    selectedEventId = widget.param.adminMessageModel.eventId;
    selectedPersonnelGroupId = widget.param.adminMessageModel.personGroupId;
    selectedPersonnelCategoryId =
        widget.param.adminMessageModel.categoryPersonnelOfficeId;

    if (widget.param.adminMessageModel.eventId != null) {
      selectedMessageCategory = MessageCategoryType.event;
    } else if (widget.param.adminMessageModel.personGroupId != null) {
      selectedMessageCategory = MessageCategoryType.group;
    } else if (widget.param.adminMessageModel.categoryPersonnelOfficeId !=
        null) {
      selectedMessageCategory = MessageCategoryType.department;
    } else {
      selectedMessageCategory = MessageCategoryType.all;
    }

    final startDate = widget.param.adminMessageModel.startShowFa.split('/');
    final endDate = widget.param.adminMessageModel.endShowFa.split('/');

    startShowFa = Jalali(
      int.parse(startDate[0]),
      int.parse(startDate[1]),
      int.parse(startDate[2]),
    );
    endShowFa = Jalali(
      int.parse(endDate[0]),
      int.parse(endDate[1]),
      int.parse(endDate[2]),
    );

    fromDateController.text = startShowFa?.formatCompactDate() ?? '';
    toDateController.text = endShowFa?.formatCompactDate() ?? '';

    super.initState();

    Helper.log("Image Link => ${widget.param.adminMessageModel.fullImagePath}");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenSize = Screen.fromContext(context).screenSize;

    double mainMargin = 0.05;
    if (screenSize == ScreenSize.xsmall) {
      mainMargin = 0.05;
    } else if (screenSize == ScreenSize.small) {
      mainMargin = 0.1;
    } else if (screenSize == ScreenSize.medium) {
      mainMargin = 0.2;
    } else if (screenSize == ScreenSize.large) {
      mainMargin = 0.3;
    } else if (screenSize == ScreenSize.xlarge) {
      mainMargin = 0.3;
    }
    return BlocProvider<MessageBloc>(
      create: (context) {
        final bloc = MessageBloc(
          repository: multimediaRepository,
          context: context,
        );
        bloc.add(CreateMessageStarted());
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
                  title: "ویرایش پیام",
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      child: BlocConsumer<MessageBloc, MessageState>(
                        buildWhen: (previous, current) =>
                            current is! CreateMessageRequestSuccess &&
                            current is! CreateMessageRequestLoading &&
                            current is! CreateMessageRequestError,
                        listener: (context, state) {
                          if (state is CreateMessageRequestError) {
                            Helper.showToast(
                              title: 'خطا!',
                              description: state.exception.message ??
                                  'خطا در ویرایش پیام',
                              context: context,
                            );
                          } else if (state is CreateMessageRequestSuccess) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        },
                        builder: (context, state) {
                          Helper.log('state is $state');

                          if (state is CreateMessageLoading ||
                              state is MessageInitial) {
                            return const Center(
                              child: SizedBox(
                                height: 32,
                                width: 32,
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else if (state is CreateMessageError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    state.exception.message ??
                                        'خطایی رخ داده است',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 44),
                                  SizedBox(
                                    width: null,
                                    child: CustomButton(
                                      width: 120,
                                      height: 44,
                                      backgroundColor: Colors.red,
                                      showShadow: false,
                                      borderRadius: 20,
                                      onPressed: () {
                                        BlocProvider.of<MessageBloc>(context)
                                            .add(
                                          CreateMessageStarted(),
                                        );
                                      },
                                      child: const Text(
                                        'تلاش مجدد',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (state is CreateMessageSuccess) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * mainMargin,
                                  vertical: 32,
                                ),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        child: TextFormField(
                                          controller: titleController,
                                          validator: (value) {
                                            if (value?.isEmpty ?? true) {
                                              return "عنوان پیام را وارد کنید";
                                            }
                                            return null;
                                          },
                                          maxLines: 1,
                                          decoration: InputDecoration(
                                            hintText: 'عنوان پیام را وارد کنید',
                                            label: const Text(
                                              'عنوان پیام',
                                            ),
                                            errorStyle: const TextStyle(
                                              fontSize: 12,
                                            ),
                                            labelStyle: const TextStyle(
                                              fontSize: 14,
                                            ),
                                            hintStyle: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            alignLabelWithHint: true,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 16,
                                              horizontal: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Gap(16),
                                      SizedBox(
                                        child: TextFormField(
                                          controller: descriptionController,
                                          validator: (value) {
                                            if (value?.isEmpty ?? true) {
                                              return "متن پیام را وارد کنید";
                                            }
                                            return null;
                                          },
                                          maxLines: 6,
                                          decoration: InputDecoration(
                                            hintText: 'متن پیام را وارد کنید',
                                            label: const Text(
                                              'متن پیام',
                                            ),
                                            errorStyle: const TextStyle(
                                              fontSize: 12,
                                            ),
                                            labelStyle: const TextStyle(
                                              fontSize: 14,
                                            ),
                                            hintStyle: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            alignLabelWithHint: true,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 16,
                                              horizontal: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Gap(16),
                                      CheckboxListTile(
                                        value: canUserComment,
                                        title: const Text(
                                          'ثبت نظر توسط کاربران',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            canUserComment =
                                                value ?? canUserComment;
                                          });
                                        },
                                      ),
                                      CheckboxListTile(
                                        value: isActive,
                                        title: const Text(
                                          'پیام فعال است',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            isActive = value ?? isActive;
                                          });
                                        },
                                      ),
                                      const Gap(16),
                                      Column(
                                        children: [
                                          const Row(
                                            children: [
                                              Text(
                                                'بازه زمانی نمایش:',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Gap(8),
                                          const Divider(),
                                          const Gap(8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text('از:'),
                                                  const Gap(6),
                                                  Expanded(
                                                    flex: 1,
                                                    child: TextFormField(
                                                      controller:
                                                          fromDateController,
                                                      readOnly: true,
                                                      onTap: () async {
                                                        Jalali? picked =
                                                            await showPersianDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              Jalali.now(),
                                                          firstDate:
                                                              Jalali(1385, 8),
                                                          lastDate:
                                                              Jalali(1500, 01),
                                                        );

                                                        if (picked != null) {
                                                          fromDateController
                                                                  .text =
                                                              picked
                                                                  .formatCompactDate();
                                                          setState(() {
                                                            startShowFa =
                                                                picked;
                                                          });
                                                        }
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                        ),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 0,
                                                          horizontal: 0,
                                                        ),
                                                        alignLabelWithHint:
                                                            true,
                                                        hintText: 'از تاریخ',
                                                        hintStyle:
                                                            const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      keyboardType:
                                                          TextInputType.none,
                                                      textAlign:
                                                          TextAlign.center,
                                                      textDirection:
                                                          TextDirection.ltr,
                                                    ),
                                                  ),
                                                  const Gap(12),
                                                  const Text('تا:'),
                                                  const Gap(12),
                                                  Expanded(
                                                    flex: 1,
                                                    child: TextFormField(
                                                      controller:
                                                          toDateController,
                                                      readOnly: true,
                                                      onTap: () async {
                                                        Jalali? picked =
                                                            await showPersianDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              Jalali.now(),
                                                          firstDate:
                                                              Jalali(1385, 8),
                                                          lastDate:
                                                              Jalali(1500, 01),
                                                        );

                                                        if (picked != null) {
                                                          toDateController
                                                                  .text =
                                                              picked
                                                                  .formatCompactDate();
                                                          setState(() {
                                                            endShowFa = picked;
                                                          });
                                                        }
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                        ),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 0,
                                                          horizontal: 0,
                                                        ),
                                                        alignLabelWithHint:
                                                            true,
                                                        hintText: 'تا تاریخ',
                                                        hintStyle:
                                                            const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      keyboardType:
                                                          TextInputType.none,
                                                      textAlign:
                                                          TextAlign.center,
                                                      textDirection:
                                                          TextDirection.ltr,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Gap(24),
                                      Column(
                                        children: [
                                          const Row(
                                            children: [
                                              Text(
                                                'ارسال برای:',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Gap(8),
                                          const Divider(),
                                          Row(
                                            children: [
                                              Radio(
                                                value: MessageCategoryType.all,
                                                onChanged: (value) => setState(
                                                  () {
                                                    selectedMessageCategory = value
                                                        as MessageCategoryType;

                                                    setState(() {
                                                      selectedEventId = null;
                                                      selectedPersonnelGroupId =
                                                          null;
                                                      selectedPersonnelCategoryId =
                                                          null;
                                                    });
                                                  },
                                                ),
                                                groupValue:
                                                    selectedMessageCategory,
                                              ),
                                              const Text('همه'),
                                            ],
                                          ),
                                          const Gap(16),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  children: [
                                                    Radio(
                                                      value: MessageCategoryType
                                                          .group,
                                                      onChanged: (value) =>
                                                          setState(
                                                        () {
                                                          selectedMessageCategory =
                                                              value
                                                                  as MessageCategoryType;
                                                        },
                                                      ),
                                                      groupValue:
                                                          selectedMessageCategory,
                                                    ),
                                                    const Text('گروه'),
                                                  ],
                                                ),
                                              ),
                                              const Gap(8),
                                              Expanded(
                                                flex: 3,
                                                child: DropdownButtonFormField2<
                                                    int?>(
                                                  isExpanded: true,
                                                  decoration: InputDecoration(
                                                    // Add Horizontal padding using menuItemStyleData.padding so it matches
                                                    // the menu padding when button's width is not specified.
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 16),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    // Add more decoration..
                                                  ),
                                                  hint: const Text(
                                                    'انتخاب گروه',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  items: state
                                                      .info.personnelGroups
                                                      .map(
                                                    (e) {
                                                      return DropdownMenuItem<
                                                          int?>(
                                                        value: e.id,
                                                        child: Text(
                                                          e.title,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).toList(),
                                                  value:
                                                      selectedPersonnelGroupId,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedMessageCategory =
                                                          MessageCategoryType
                                                              .group;
                                                      selectedPersonnelGroupId =
                                                          value;
                                                    });
                                                  },
                                                  buttonStyleData:
                                                      const ButtonStyleData(
                                                    padding: EdgeInsets.only(
                                                        right: 8),
                                                  ),
                                                  iconStyleData:
                                                      const IconStyleData(
                                                    icon: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.black45,
                                                    ),
                                                    iconSize: 24,
                                                  ),
                                                  dropdownStyleData:
                                                      DropdownStyleData(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                  menuItemStyleData:
                                                      const MenuItemStyleData(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Gap(16),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  children: [
                                                    Radio(
                                                      value: MessageCategoryType
                                                          .department,
                                                      onChanged: (value) =>
                                                          setState(
                                                        () {
                                                          selectedMessageCategory =
                                                              value
                                                                  as MessageCategoryType;
                                                        },
                                                      ),
                                                      groupValue:
                                                          selectedMessageCategory,
                                                    ),
                                                    const Text('اداره'),
                                                  ],
                                                ),
                                              ),
                                              const Gap(8),
                                              Expanded(
                                                flex: 3,
                                                child: DropdownButtonFormField2<
                                                    String?>(
                                                  isExpanded: true,
                                                  decoration: InputDecoration(
                                                    // Add Horizontal padding using menuItemStyleData.padding so it matches
                                                    // the menu padding when button's width is not specified.
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 16),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    // Add more decoration..
                                                  ),
                                                  hint: const Text(
                                                    'انتخاب اداره',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  items: state
                                                      .info.personnelCategories
                                                      .map(
                                                    (e) {
                                                      return DropdownMenuItem<
                                                          String?>(
                                                        value: e.id,
                                                        child: Text(
                                                          e.title,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).toList(),
                                                  value:
                                                      selectedPersonnelCategoryId,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedMessageCategory =
                                                          MessageCategoryType
                                                              .department;
                                                      selectedPersonnelCategoryId =
                                                          value;
                                                    });
                                                  },
                                                  buttonStyleData:
                                                      const ButtonStyleData(
                                                    padding: EdgeInsets.only(
                                                        right: 8),
                                                  ),
                                                  iconStyleData:
                                                      const IconStyleData(
                                                    icon: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.black45,
                                                    ),
                                                    iconSize: 24,
                                                  ),
                                                  dropdownStyleData:
                                                      DropdownStyleData(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                  menuItemStyleData:
                                                      const MenuItemStyleData(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Gap(16),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  children: [
                                                    Radio(
                                                      value: MessageCategoryType
                                                          .event,
                                                      onChanged: (value) =>
                                                          setState(
                                                        () {
                                                          selectedMessageCategory =
                                                              value
                                                                  as MessageCategoryType;
                                                        },
                                                      ),
                                                      groupValue:
                                                          selectedMessageCategory,
                                                    ),
                                                    const Text('رویداد'),
                                                  ],
                                                ),
                                              ),
                                              const Gap(8),
                                              Expanded(
                                                flex: 3,
                                                child: DropdownButtonFormField2<
                                                    String?>(
                                                  isExpanded: true,
                                                  decoration: InputDecoration(
                                                    // Add Horizontal padding using menuItemStyleData.padding so it matches
                                                    // the menu padding when button's width is not specified.
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      vertical: 16,
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    // Add more decoration..
                                                  ),
                                                  hint: const Text(
                                                    'انتخاب رویداد',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  items: state.info.events.map(
                                                    (e) {
                                                      return DropdownMenuItem<
                                                          String?>(
                                                        value: e.id,
                                                        child: Text(
                                                          e.title,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).toList(),
                                                  value: selectedEventId,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedMessageCategory =
                                                          MessageCategoryType
                                                              .event;
                                                      selectedEventId = value;
                                                    });
                                                  },
                                                  buttonStyleData:
                                                      const ButtonStyleData(
                                                    padding: EdgeInsets.only(
                                                        right: 8),
                                                  ),
                                                  iconStyleData:
                                                      const IconStyleData(
                                                    icon: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.black45,
                                                    ),
                                                    iconSize: 24,
                                                  ),
                                                  dropdownStyleData:
                                                      DropdownStyleData(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                  menuItemStyleData:
                                                      const MenuItemStyleData(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Gap(16),
                                          const Divider(),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      if (selectedImage != null)
                                        Container(
                                          height: 60,
                                          padding: const EdgeInsets.fromLTRB(
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
                                                offset: const Offset(0, 3),
                                                blurRadius: 6,
                                              ),
                                            ],
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 40,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xff0090FF),
                                                ),
                                                child: const Icon(
                                                  Icons.file_present_rounded,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      selectedImage!.name,
                                                      style: const TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color:
                                                            Color(0xff0090FF),
                                                        fontSize: 13,
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedImage = null;
                                                  });
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
                                      if (selectedImage != null)
                                        const SizedBox(height: 24),
                                      if (selectedImage == null)
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            maxHeight: 300,
                                          ),
                                          child: ImageLoadingService(
                                            imageUrl: widget
                                                    .param
                                                    .adminMessageModel
                                                    .fullImagePath ??
                                                '',
                                            fit: BoxFit.cover,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            errorWidget: (context, url, error) {
                                              return Image.asset(
                                                'assets/images/project/image.png',
                                              );
                                            },
                                          ),
                                        ),
                                      if (selectedImage == null)
                                        const SizedBox(height: 32),
                                      if (selectedImage == null)
                                        DottedBorder(
                                          color: Colors.black38,
                                          strokeWidth: 1,
                                          radius: const Radius.circular(32),
                                          borderType: BorderType.RRect,
                                          dashPattern: const [12, 4, 12, 4],
                                          child: Container(
                                            height: 140,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(32),
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
                                                      'تصویر شاخص',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    OutlinedButton(
                                                      onPressed: () async {
                                                        // Pick an image.
                                                        final XFile? image =
                                                            await picker
                                                                .pickImage(
                                                          source: ImageSource
                                                              .gallery,
                                                          imageQuality: 50,
                                                          maxWidth: 1920,
                                                          maxHeight: 1080,
                                                          requestFullMetadata:
                                                              true,
                                                        );

                                                        /*FilePickerResult? result =
                                                          await FilePicker
                                                              .platform
                                                              .pickFiles(
                                                        allowMultiple: false,
                                                        type: FileType.image,
                                                        allowCompression: true,
                                                        allowedExtensions: [
                                                          'png',
                                                          'jpg',
                                                          'jpeg',
                                                        ],
                                                      );*/

                                                        if (image != null) {
                                                          setState(() {
                                                            selectedImage =
                                                                image;
                                                          });
                                                          // دستکاری و استفاده از فایل‌های انتخاب شده در اینجا
                                                        } else {
                                                          // کاربر فایلی انتخاب نکرده است
                                                        }
                                                      },
                                                      child: const Text(
                                                        'انتخاب تصویر',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 24),
                                      BlocBuilder<MessageBloc, MessageState>(
                                        builder: (context, state) {
                                          return AppButton(
                                            text: 'ثبت درخواست',
                                            onClick: () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                if (startShowFa == null ||
                                                    endShowFa == null) {
                                                  Helper.showSnackBar(
                                                      'تاریخ شروع و پایان اجباری است',
                                                      context);
                                                  return;
                                                }

                                                BlocProvider.of<MessageBloc>(
                                                        context)
                                                    .add(
                                                  EditMessageStarted(
                                                    id: widget.param
                                                        .adminMessageModel.id,
                                                    title: titleController.text,
                                                    description:
                                                        descriptionController
                                                            .text,
                                                    departmentId:
                                                        selectedPersonnelCategoryId,
                                                    eventId: selectedEventId,
                                                    groupId:
                                                        selectedPersonnelGroupId,
                                                    canUserComment:
                                                        canUserComment,
                                                    isActive: isActive,
                                                    startDate: startShowFa!,
                                                    endDate: endShowFa!,
                                                    image: selectedImage,
                                                  ),
                                                );
                                              }
                                            },
                                            height: 54,
                                            isLoading: state
                                                is CreateMessageRequestLoading,
                                          );
                                        },
                                      ),
                                      const Gap(76),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }

                          throw Exception('state $state not found!');
                        },
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

enum MessageCategoryType {
  all,
  event,
  department,
  group,
}

class AdminEditMessageParam {
  final AdminMessageModel adminMessageModel;

  AdminEditMessageParam({
    required this.adminMessageModel,
  });
}
