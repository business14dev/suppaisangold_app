import 'package:flutter/material.dart';
import 'package:suppaisangold_app/src/utils/appconstants.dart';
import 'package:suppaisangold_app/src/utils/appvariables.dart';
import 'package:suppaisangold_app/src/utils/saveimagepromptpay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:promptpay_qrcode_generate/promptpay_qrcode_generate.dart';
import 'package:screenshot/screenshot.dart';

class QRCodePromptpayIntPage extends StatefulWidget {
  final String title;
  final double amount; // จำนวนเงินที่ต้องการชำระ

  // Constructor ที่บังคับให้ต้องใส่ค่า
  QRCodePromptpayIntPage({required this.title, required this.amount});

  @override
  _QRCodePromptpayIntPageState createState() => _QRCodePromptpayIntPageState();
}

class _QRCodePromptpayIntPageState extends State<QRCodePromptpayIntPage> {
  final ScreenshotController controller = ScreenshotController();

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  Widget build(BuildContext context) => Screenshot(
        controller: controller,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "QR PromptPay ",
              style: TextStyle(color: AppConstant.PRIMARY_COLOR),
            ),
            iconTheme: IconThemeData(
              color: AppConstant.PRIMARY_COLOR,
            ),
            backgroundColor: Colors.white,
          ),
          body: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/logo2.png"))),
                  ),
                  Text(
                    "ห้างทองทรัพย์ไพศาล",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: Color(0xFFDC143C),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFF660000),
                      Color(0xFFDC143C),
                    ],
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.93,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      " ${widget.title}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: QRCodeGenerate(
                  promptPayId: AppConstant.promptPayId,
                  amount: widget.amount,
                  width: 400,
                  height: 400,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                  Color(0xFFe8aa24),
                )),
                onPressed: () async {
                  final image = await controller.capture();
                  if (image != null) {
                    await SaveImagePromptpay.saveImage(image, context);
                  }
                },
                child: Text("บันทึก QR Code",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      );
}
