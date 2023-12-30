import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:toastification/toastification.dart';

import '../../../../../core/utils/helper.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../data/repository/message_repository.dart';
import '../../bloc/message_bloc.dart';

class RegisterCommentBottomSheet extends StatefulWidget {
  final String id;

  const RegisterCommentBottomSheet({
    super.key,
    required this.id,
  });

  @override
  State<RegisterCommentBottomSheet> createState() =>
      _RegisterCommentBottomSheetState();
}

class _RegisterCommentBottomSheetState
    extends State<RegisterCommentBottomSheet> {
  final commentTextEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessageBloc>(
      create: (context) => MessageBloc(
        repository: multimediaRepository,
        context: context,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(32),
              topLeft: Radius.circular(32),
            ),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          Container(
                            height: 4,
                            width: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xffdcdcdc),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          16,
                          16,
                          20,
                        ),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                Text(
                                  'متن دیدگاه :',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(16),
                            CustomTextFormField(
                              controller: commentTextEditingController,
                              onTap: () => FocusScope.of(context).unfocus(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'دیدگاه خود را ثبت کنید',
                              hintStyle: const TextStyle(
                                fontSize: 14,
                              ),
                              maxLines: 4,
                              fillColor: Colors.grey.shade200,
                              keyboardType: TextInputType.text,
                              filled: true,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'دیدگاه خود را وارد کنید';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const Gap(16),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: BlocConsumer<MessageBloc, MessageState>(
                          listener: (context, state) {
                            if (state is MessageAddCommentError) {
                              Helper.showToast(
                                title: 'خطا!',
                                description: state.exception.message ??
                                    'خطا در ثبت اطلاعات',
                                context: context,
                                type: ToastificationType.error,
                              );
                            } else if (state is MessageAddCommentSuccess) {
                              Navigator.of(context).pop(true);
                            }
                          },
                          builder: (context, state) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xfffe5722),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0.3,
                              ),
                              onPressed: state is MessageAddCommentLoading
                                  ? null
                                  : () {
                                      if (formKey.currentState!.validate()) {
                                        BlocProvider.of<MessageBloc>(context)
                                            .add(
                                          MessageAddCommentStarted(
                                            id: widget.id,
                                            comment:
                                                commentTextEditingController
                                                    .text,
                                          ),
                                        );
                                      }
                                    },
                              child: state is MessageAddCommentLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'ثبت دیدگاه',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                            );
                          },
                        ),
                      ),
                    ],
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
