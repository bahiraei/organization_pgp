import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:gap/gap.dart';

class PolicyDialog extends StatelessWidget {
  const PolicyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = Screen.fromContext(context).screenSize;

    double mainMargin = 0.95;
    if (screenSize == ScreenSize.xsmall) {
      mainMargin = 0.95;
    } else if (screenSize == ScreenSize.small) {
      mainMargin = 0.8;
    } else if (screenSize == ScreenSize.medium) {
      mainMargin = 0.45;
    } else if (screenSize == ScreenSize.large) {
      mainMargin = 0.35;
    } else if (screenSize == ScreenSize.xlarge) {
      mainMargin = 0.35;
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 0,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * mainMargin,
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      12,
                      16,
                      24,
                      0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'شرایط و قوانین',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    endIndent: 24,
                    indent: 24,
                    color: Colors.grey,
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
                  children: const [
                    Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'شرایط استفاده از خدمات',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(6),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                '''متن پیش رو توضیحی دربارهٔ شرایط استفاده از برنامه و وب‌سایت شرکت هدایت کشتی خلیج فارس به آدرس pgpilotco.ir و تمام خدمات و سرویس‌های ارائه شده از طریق آن است.

استفاده از خدمات ما، به این معنی است که با این شرایط موافقت کرده‌اید. لطفاً برای آشنایی با شرایط استفاده از شرکت هدایت کشتی خلیج فارس این سند را مطالعه کنید و چنانچه سؤالی برایتان پیش آمد خوشحال می‌شویم با ما تماس بگیرید.''',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Gap(16),
                    Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'حریم خصوصی',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(6),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'سیاست‌نامهٔ حریم شخصی کاربران شرکت هدایت کشتی خلیج فارس، که در این بخش قابل مشاهده است، رویکرد شرکت هدایت کشتی خلیج فارس را در این‌باره به صورت شفاف توضیح می‌دهد. این سیاست‌نامه بخشی از شرایط استفاده از سرویس‌های شرکت هدایت کشتی خلیج فارس را تشکیل می‌دهد.',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Gap(16),
                    Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'عواقب تخلف از شرایط',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(6),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                '''سوءاستفاده از سرویس‌های شرکت هدایت کشتی خلیج فارس به هر شکل، استفاده از اختلال سرویس‌ها، استفاده از برنامه‌های مخرب و جاسوسی، پس‌ دادن غیرمنصفانهٔ محصولات خریداری‌ شده، تلاش برای ورود به حساب‌ کاربری غیر از روش معمول برای کاربران، استفاده از ربات‌ها و هر نوع روش مخرب برای دسترسی به اطلاعات سایت، برنامه و محتویات آن از طریق هر سیستم و شبکه، ایجاد اختلال و تحمیل بار اضافی به هر یک از سرویس‌ها و سرورهای بازار ممنوع است و شرکت هدایت کشتی خلیج فارس درصورت مشاهدهٔ چنین فعالیت‌هایی از راه‌های قانونی، مورد را پیگیری می‌کند.

استفاده از سرویس‌های شرکت هدایت کشتی خلیج فارس در راستای نقض حقوق افراد و قانون جاری در کشور، ممنوع است و شرکت هدایت کشتی خلیج فارس در این‌باره هیچ مسئولیتی ندارد.

در صورت تخلف از این شرایط شرکت هدایت کشتی خلیج فارس حساب کاربر متخلف را مسدود می‌کند و مورد را به صورت قانونی پیگیری خواهد کرد.

اگر اقدامات لازم در این راه بلافاصله انجام نشد، به این معنی نیست که تخلفات را نادیده گرفته‌ایم یا از احقاق حقوق مطرح‌ شده دست کشیده‌ایم.''',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Gap(16),
                    Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'تغییرات این سند',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(6),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'مطالب ذکر شده در این سند دائمی نیستند و ممکن است با تغییر در سیاست‌های بازار، دستخوش تغییر و تجدید نظر شوند. در صورتی که این تغییرات مهم باشند، از طریق حساب کاربری به همۀ کاربران اطلاع داده خواهد شد.',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Gap(16),
                    Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'نظرات و اطلاعات',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(6),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'سوال ها، انتقادها و پیشنهادهای خود را از طریق ایمیل یا تلفن با ما در میان بگذارید. مطمئن باشید که در اسرع وقت به شما پاسخ می‌دهیم و از نظرات مفید شما در بهبود خدمات خود استفاده می کنیم.',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Gap(32),
                    Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'تاریخ آخرین به‌روزرسانی: آبان ماه 1402',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
