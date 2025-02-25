import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suppaisangold_app/src/pages/pawndt_page.dart';
import 'package:suppaisangold_app/src/pages/productrecommend_page.dart';
import 'package:suppaisangold_app/src/pages/saving_page.dart';
import 'package:suppaisangold_app/src/services/app_service.dart';
import 'package:suppaisangold_app/src/utils/appvariables.dart';
import 'package:suppaisangold_app/src/utils/appcontroller.dart';
import 'package:suppaisangold_app/src/utils/appformatters.dart';
import 'package:suppaisangold_app/src/widgets/goldprice.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:suppaisangold_app/src/utils/appconstants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PawnmtPage extends StatefulWidget {
  @override
  State<PawnmtPage> createState() => _PawnmtPageState();
}

class _PawnmtPageState extends State<PawnmtPage> {
  @override
  File? _image;
  String _custId = AppVariables.CUSTID;

// ฟังก์ชันสำหรับเลือกรูปจาก gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File savedImage = await _saveImageToLocalDirectory(File(pickedFile.path));
      setState(() {
        _image = savedImage; // เซ็ตค่าให้แสดงรูปที่เลือก
      });
      _saveImagePath(savedImage.path);
    }
  }

  // ฟังก์ชันสำหรับบันทึกรูปภาพไปยัง Local Storage
  Future<File> _saveImageToLocalDirectory(File image) async {
    final directory = await getApplicationDocumentsDirectory(); // หา directory ที่แอปจะสามารถบันทึกไฟล์ได้
    final fileName = path.basename(image.path); // ดึงชื่อไฟล์
    final savedImage = await image.copy('${directory.path}/$fileName'); // ทำการบันทึกไฟล์

    return savedImage; // ส่งคืนไฟล์ที่ถูกบันทึก
  }

  Future<void> _saveImagePath(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatar_image_path', imagePath);
  }

  // โหลด path ของรูปจาก SharedPreferences และแสดงผลใน UI
  Future<void> _loadSavedImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('avatar_image_path');

    if (_custId != "-" && imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _image = File(imagePath); // โหลดรูปภาพจาก path ที่บันทึกไว้
      });
    }
  }

  void initState() {
    super.initState();
    _loadSavedImage();
    AppService().savingMtList();
    AppService().pawnMtList();
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
         return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg-home.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
                backgroundColor: Colors.black54,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black54,
                          Colors.black45,
                          Color.fromARGB(137, 101, 99, 99),
                          Colors.black45,
                          Colors.black54
                        ], // ไล่เฉดสีฟ้า
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  title: Container(
                    width: MediaQuery.of(context).size.width * 1,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/logo2.png",
                              height: 80,
                            ),
                            SizedBox(
                              height: 80,
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   ' ห้างทองทรัพย์ไพศาล',
                                  //   style: TextStyle(
                                  //       color: Colors.white,
                                  //       fontSize: 20,
                                  //       fontWeight: FontWeight.bold,
                                  //       height: 0.8),
                                  //   textScaler: TextScaler.linear(1),
                                  // ),
                                  Stack(
                                    children: [
                                      // ขอบสีขาว
                                      Text(
                                        " ห้างทองทรัพย์ไพศาล",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: "Chonburi",
                                          fontWeight: FontWeight.bold,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 4
                                            ..color =
                                                Colors.black, // สีขอบตัวหนังสือ
                                        ),
                                      ),
                                      // ตัวหนังสือสีแดง (วางทับด้านบน)
                                      Text(
                                        " ห้างทองทรัพย์ไพศาล",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: "Chonburi",
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color(0xFFFFC107), // สีตัวหนังสือ
                                        ),
                                      ),
                                    ],
                                  ),
                                  Stack(
                                    children: [
                                      // ขอบสีขาว
                                      Text(
                                        " SUPPAISAN GOLDSMITH",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: "Chonburi",
                                          fontWeight: FontWeight.bold,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 4
                                            ..color =
                                                Colors.black, // สีขอบตัวหนังสือ
                                        ),
                                      ),
                                      // ตัวหนังสือสีแดง (วางทับด้านบน)
                                      Text(
                                        " SUPPAISAN GOLDSMITH",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: "Chonburi",
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color(0xFFFFC107), // สีตัวหนังสือ
                                        ),
                                      ),
                                    ],
                                  ),
                                  // SizedBox(height: 10),
                                  AppVariables.CUSTID == "-"
                                      ? SizedBox()
                                      : Row(
                                          children: [
                                            Stack(
                                              children: [
                                                Text(
                                                  ' สวัสดี ',
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    foreground: Paint()
                                                      ..style =
                                                          PaintingStyle.stroke
                                                      ..strokeWidth =
                                                          4 // ความหนาของขอบ
                                                      ..color =
                                                          Colors.black, // สีขอบ
                                                  ),
                                                ),
                                                Text(
                                                  ' สวัสดี ',
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(
                                                        0xFFFFC107), // สีทอง
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Stack(
                                              children: [
                                                Text(
                                                  AppVariables.CUSTNAME,
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    foreground: Paint()
                                                      ..style =
                                                          PaintingStyle.stroke
                                                      ..strokeWidth =
                                                          4 // ความหนาของขอบ
                                                      ..color =
                                                          Colors.black, // สีขอบ
                                                  ),
                                                ),
                                                Text(
                                                  AppVariables.CUSTNAME,
                                                  style: TextStyle(
                                                    color: Color(0xFFFFC107),
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textScaler:
                                                      TextScaler.linear(1),
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
                      ],
                    ),
                  ),
                  toolbarHeight: 110,
                ),
                body: ListView(
                  children: [
                    SizedBox(height: 10),
                    pawnMT(appController),
                  ],
                )),
          );
        });
  }

  Widget _buildTitelPawnMt(double width) {
    return Container(
      width: width * 0.40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 5),
          Stack(
            children: [
              // ขอบสีขาว
              Text(
                "เลขที่ขายฝาก  :",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = Colors.black, // สีขอบตัวหนังสือ
                ),
              ),
              // ตัวหนังสือสีแดง (วางทับด้านบน)
              Text(
                "เลขที่ขายฝาก  :",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFC107), // สีตัวหนังสือ
                ),
              ),
            ],
          ),
          Stack(
            children: [
              // ขอบสีขาว
              Text(
                "สินค้า  :",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = Colors.black, // สีขอบตัวหนังสือ
                ),
              ),
              // ตัวหนังสือสีแดง (วางทับด้านบน)
              Text(
                "สินค้า  :",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFC107), // สีตัวหนังสือ
                ),
              ),
            ],
          ),
          Stack(
            children: [
              // ขอบสีขาว
              Text(
                "จำนวนเงิน  :",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = Colors.black, // สีขอบตัวหนังสือ
                ),
              ),
              // ตัวหนังสือสีแดง (วางทับด้านบน)
              Text(
                "จำนวนเงิน  :",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFC107), // สีตัวหนังสือ
                ),
              ),
            ],
          ),
          Stack(
            children: [
              // ขอบสีขาว
              Text(
                "วันที่ฝาก  :",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = Colors.black, // สีขอบตัวหนังสือ
                ),
              ),
              // ตัวหนังสือสีแดง (วางทับด้านบน)
              Text(
                "วันที่ฝาก  :",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFC107), // สีตัวหนังสือ
                ),
              ),
            ],
          ),
          Stack(
            children: [
              // ขอบสีขาว
              Text(
                "วันครบกำหนด  :",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = Colors.black, // สีขอบตัวหนังสือ
                ),
              ),
              // ตัวหนังสือสีแดง (วางทับด้านบน)
              Text(
                "วันครบกำหนด  :",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFC107), // สีตัวหนังสือ
                ),
              ),
            ],
          ),
          // Text(
          //   "วันที่ครบกำหนด :",
          //   style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       color: Color(0xFFfefca7),
          //       fontSize: 22),
          //   textScaleFactor: 1,
          // ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildDetailPawnMt(AppController appController, int index, double width) {
    return Container(
      width: width * 0.38,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5),
          Text(
            " ${appController.pawnMts[index].pawnId}",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF), fontSize: 22),
            textScaler: TextScaler.linear(1),
          ),
          Text(
            " ${appController.pawnMts[index].sumDescription}",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              // fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textScaler: TextScaler.linear(1),
          ),
          Text(
            " ${AppFormatters.formatNumber.format(appController.pawnMts[index].amountget)} บาท",
            style: TextStyle(
              // fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textScaler: TextScaler.linear(1),
          ),
          Text(
            " ${AppFormatters.formatDate.format(appController.pawnMts[index].inDate!)}",
            style: TextStyle(
              // fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
              fontSize: 22, fontWeight: FontWeight.bold,
            ),
            textScaler: TextScaler.linear(1),
          ),
          Text(
            " ${AppFormatters.formatDate.format(appController.pawnMts[index].duedate!)}",
            style: TextStyle(
              // fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
              fontSize: 22, fontWeight: FontWeight.bold,
            ),
            textScaler: TextScaler.linear(1),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget pawnMT(AppController appController) {
    return Container(
      child: appController.pawnMts.isEmpty
          ? Column(children: [
              // SizedBox(height: 5),
              Container(
                height: 35,
                width: MediaQuery.of(context).size.width * 1,
                 decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black54,
                        Colors.black45,
                        Color.fromARGB(137, 101, 99, 99),
                        Color.fromARGB(137, 101, 99, 99),
                        Color.fromARGB(137, 101, 99, 99),
                        Colors.black45,
                        Colors.black54
                      ],
                    ),
                  ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        // ขอบสีขาว
                        Text(
                          " รายการขายฝาก",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4
                              ..color = Colors.black, // สีขอบตัวหนังสือ
                          ),
                        ),
                        // ตัวหนังสือสีแดง (วางทับด้านบน)
                        Text(
                          " รายการขายฝาก",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFC107), // สีตัวหนังสือ
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 180,
                child: Center(
                  child: Text(
                    "ไม่พบรายการขายฝาก",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.PRIMARY_COLOR,
                      height: 1.5,
                    ),
                  ),
                ),
              )
            ])
          : Column(
              children: [
                // SizedBox(height: 5),
                Container(
                  height: 35,
                  width: MediaQuery.of(context).size.width * 1,
                   decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black54,
                        Colors.black45,
                        Color.fromARGB(137, 101, 99, 99),
                        Color.fromARGB(137, 101, 99, 99),
                        Color.fromARGB(137, 101, 99, 99),
                        Colors.black45,
                        Colors.black54
                      ],
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                  
                    children: [
                      Stack(
                        children: [
                          // ขอบสีขาว
                          Text(
                            " รายการขายฝาก",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 4
                                ..color = Colors.black, // สีขอบตัวหนังสือ
                            ),
                          ),
                          // ตัวหนังสือสีแดง (วางทับด้านบน)
                          Text(
                            " รายการขายฝาก",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFC107), // สีตัวหนังสือ
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 280,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 260,
                        child: GetBuilder<AppController>(builder: (controller) {
                          // ฟังการเลื่อน
                          controller.pawnScrollController.addListener(() {
                            controller.updatePawnIndexOnScroll();
                          });
                          return ListView.builder(
                            controller: controller.pawnScrollController,
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: appController.pawnMts.length,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                print("${appController.pawnMts[index].pawnId}");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PawnDtPage(appController.pawnMts[index]),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      // image: DecorationImage(
                                      //   image: AssetImage(
                                      //       "assets/images/pawn.png"),
                                      //   opacity: 0.30,
                                      // ),
                                      border: Border.all(color: Color(0xFFFFC107), width: 3, style: BorderStyle.solid),
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black54,
                        Colors.black45,
                        Color.fromARGB(137, 101, 99, 99),
                        Color.fromARGB(137, 101, 99, 99),
                        Color.fromARGB(137, 101, 99, 99),
                        Colors.black45,
                        Colors.black54
                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      Container(
                                        height: 220,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(width: 10),
                                            _buildTitelPawnMt(MediaQuery.of(context).size.width),
                                            _buildDetailPawnMt(appController, index, MediaQuery.of(context).size.width)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      GetBuilder<AppController>(builder: (controller) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            appController.pawnMts.length,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index == appController.selectedIndexPawn ? Colors.redAccent : Colors.grey),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
