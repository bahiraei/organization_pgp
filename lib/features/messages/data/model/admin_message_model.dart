import '../../../../core/consts/app_environment.dart';

class AdminMessageModel {
/*{
        "title": "پتروشیمی بندرامام با کسب 3 عنوان برتر در همایش پتروفن 1402 درخشید",
        "fullText": "پتروشیمی بندرامام و دکتر انصاری نیک به عنوان «شرکت نوآور» و «مدیر نوآور» برگزیده شدند/ کارشناس پتروشیمی بندرامام «نوآور و مخترع در کلاس جهانی» شد\r\n\r\nدر آئین اختتامیه همایش ملی پتروفن 1402، شرکت پتروشیمی بندرامام به عنوان «شرکت نوآور»، دکتر سپهدار انصاری نیک به عنوان «مدیرنوآور» و احمد عبادی به عنوان «نوآور و مخترع در کلاس جهانی» برگزیده و مورد تقدیر قرار گرفتند.\r\n\r\nبه گزارش روابط عمومی شرکت پتروشیمی بندرامام، در آئین اختتامیه رویداد پتروفن 1402 که با حضور دکتر علی آقا محمدی رئیس گروه اقتصادی دفتر مقام معظم رهبری و عضو مجمع تشخیص مصلحت نظام، دکتر علی عسکری و مسئولین ارشد گروه صنایع پتروشیمی خلیج فارس، مدیران حاکمیتی و نمایندگان کمیسیون انرژی و مجلس شورای اسلامی در سالن همایش های بین المللی صداوسیما برگزار شد، شرکت پتروشیمی بندرامام به «شرکت نوآور»، دکتر سپهدار انصاری نیک به عنوان «مدیرنوآور» و احمد عبادی به عنوان «نوآور و مخترع در کلاس جهانی» برگزیده و مورد تقدیر قرار گرفتند.\r\n\r\nگفتنی ست؛ همایش ملی پتروفن 1402 با ارائه ی بیش از 230 خدمت و نیمی از شرکت های پتروشیمی کشور از هلدینگ های صنعت پتروشیمی و شرکت های دانش بنیان و فناور داخلی از 12تا 14 آذرماه در مرکز همایش های بین المللی صداوسیما برگزار شد و شرکت پتروشیمی بندرامام با کسب این موفقیت ها، نشان داد که در حوزه نوآوری و توسعه فناوری، از جایگاه ویژه ای برخوردار است.",
        "img": "8acc47e2-7591-4e20-a405-843d83386609.jpg",
        "fullImagePath": "imgserver/8acc47e2-7591-4e20-a405-843d83386609.jpg",
        "startShowFa": "1402/09/01",
        "endShowFa": "1402/10/30",
        "canYouComment": true,
        "isActive": true,
        "personGroupId": null,
        "eventId": null,
        "categoryPersoneOfficelId": null,
        "id": "e936e029-d990-ee11-ab38-000c298bb859"
      }*/

  final String title;
  final String? fullText;
  final String? img;
  final String? fullImagePath;
  final String startShowFa;
  final String endShowFa;
  final bool canYouComment;
  final bool isActive;
  final int? personGroupId;
  final String? eventId;
  final String? categoryPersonnelOfficeId;
  final String id;

  AdminMessageModel({
    required this.title,
    this.fullText,
    this.img,
    this.fullImagePath,
    required this.startShowFa,
    required this.endShowFa,
    required this.canYouComment,
    required this.isActive,
    this.personGroupId,
    this.eventId,
    this.categoryPersonnelOfficeId,
    required this.id,
  });

  factory AdminMessageModel.fromJson(dynamic json) {
    return AdminMessageModel(
      title: json['title'],
      img: json['img'],
      fullImagePath: json['fullImagePath'] != null
          ? AppEnvironment.baseUrl + json['fullImagePath']
          : json['fullImagePath'],
      startShowFa: json['startShowFa'],
      endShowFa: json['endShowFa'],
      canYouComment: json['canYouComment'],
      isActive: json['isActive'],
      id: json['id'],
      fullText: json['fullText'],
      categoryPersonnelOfficeId: json['categoryPersonelOfficeId'],
      eventId: json['eventId'],
      personGroupId: json['personGroupId'],
    );
  }
}
