import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suppaisangold_app/src/models/mobileappnotisentcountunread_response.dart';
import 'package:suppaisangold_app/src/pages/mobileappnotisent_page.dart';
import 'package:suppaisangold_app/src/pages/productrecommend_page.dart';
import 'package:suppaisangold_app/src/services/app_service.dart';
import 'package:suppaisangold_app/src/utils/appvariables.dart';
import 'package:suppaisangold_app/src/utils/appcontroller.dart';
import 'package:suppaisangold_app/src/utils/appformatters.dart';
import 'package:suppaisangold_app/src/widgets/goldprice.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;

import 'package:suppaisangold_app/src/utils/appconstants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeNew extends StatefulWidget {
  @override
  State<HomeNew> createState() => _HomeNewState();
}

class _HomeNewState extends State<HomeNew> {
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
    final directory =
        await getApplicationDocumentsDirectory(); // หา directory ที่แอปจะสามารถบันทึกไฟล์ได้
    final fileName = path.basename(image.path); // ดึงชื่อไฟล์
    final savedImage =
        await image.copy('${directory.path}/$fileName'); // ทำการบันทึกไฟล์

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

    AppService().promotionBannerP1();
    AppService().newProductP1();
    AppService().savingMtList();
    AppService().pawnMtList();
    AppService().mobileAppNotiSent();
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print(appController.mobileAppNotiSents);
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
                                  //       color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 0.8),
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
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Chonburi",
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
                                  Stack(),
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
                    goldPrice(context),
                    whatNew(context, appController)
                  ],
                )),
          );
        });
  }

  Column whatNew(BuildContext context, AppController appController) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black54,
            //   gradient: LinearGradient(
            //     begin: Alignment.bottomCenter,
            //     end: Alignment.topCenter,
            //     colors: [Colors.black, Colors.black ,Colors.black],
            //   ),
          ),
          height: 60,
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // กระจายปุ่มเท่ากัน
            children: [
              // "มีอะไรใหม่" Button
              Expanded(
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      AppVariables.StatusNewsNoti = "News";
                    });

                    await AppService().mobileAppNotiSent();
                  },
                  child: Container(
                    alignment: Alignment.center, // จัดข้อความให้อยู่กลาง
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: AppVariables.StatusNewsNoti == "News"
                            ? BorderSide(color: Colors.white, width: 3)
                            : BorderSide.none,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // ขอบสีขาว
                        Text(
                          " มีอะไรใหม่",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4
                              ..color = Colors.black, // สีขอบตัวหนังสือ
                          ),
                        ),
                        // ตัวหนังสือสีแดง (วางทับด้านบน)
                        Text(
                          " มีอะไรใหม่",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFC107) // สีตัวหนังสือ
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // "แจ้งเตือน" Button
              Expanded(
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      AppVariables.StatusNewsNoti = "Noti";
                    });
                    await AppService().mobileAppNotiSent();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: AppVariables.StatusNewsNoti == "Noti"
                            ? BorderSide(color: Colors.white, width: 3)
                            : BorderSide.none,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // ขอบสีขาว
                        Text(
                          " แจ้งเตือน",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4
                              ..color = Colors.black, // สีขอบตัวหนังสือ
                          ),
                        ),
                        // ตัวหนังสือสีแดง (วางทับด้านบน)
                        Text(
                          " แจ้งเตือน",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFC107), // สีตัวหนังสือ
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // ปุ่มแจ้งเตือน (notiButton)
              notiButton(),
            ],
          ),
        ),
        Container(
            child: appController.mobileAppNotiSents.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Text("ท่านยังไม่ได้ เข้าสู่ระบบ เข้าใช้งาน",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppConstant.FONT_COLOR_MENU,
                            ),
                            textScaler: TextScaler.linear(1)),
                        Text("กรุณากดเข้าสู่ระบบเพื่อแสดงรายการ",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppConstant.FONT_COLOR_MENU,
                            ),
                            textScaler: TextScaler.linear(1)),
                      ],
                    ),
                  )
                : SizedBox(
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: appController.mobileAppNotiSents.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {},
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Container(
                              width: MediaQuery.of(context).size.width * 1,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.notifications),
                                            Text(
                                                appController
                                                    .mobileAppNotiSents[index]
                                                    .notiTitle!,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24),
                                                textAlign: TextAlign.left),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              AppFormatters.formatDate.format(
                                                  appController
                                                      .mobileAppNotiSents[index]
                                                      .notiDate!),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              appController
                                                  .mobileAppNotiSents[index]
                                                  .notiTime!,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    appController.mobileAppNotiSents[index]
                                                .notiRefNo ==
                                            ""
                                        ? SizedBox()
                                        : Text(
                                            "เลขที่ ${appController.mobileAppNotiSents[index].notiRefNo}",
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                    Text(
                                      appController.mobileAppNotiSents[index]
                                          .notiDetail!,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
      ],
    );
  }

  Padding notiButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FutureBuilder(
          future: getNotiUnread(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                return Container(
                    //color: Constant.FONT_COLOR_MENU,
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        // color: AppConstant.PRIMARY_COLOR,
                        borderRadius: BorderRadius.all(Radius.circular(
                          15,
                        )),
                        border: Border.all(color: Color(0xFFDAA520))),
                    child: AppVariables.CountUnreadNoti == 0
                        ? IconButton(
                            icon: Icon(
                              Icons.notifications,
                              color: Color(0xFFDAA520),
                              //color: Constant.PRIMARY_COLOR,
                            ),
                            onPressed: () {
                              AppVariables.searchNotiDateStart = null;
                              AppVariables.searchNotiDateEnd = null;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MobileAppNotiSentPage(),
                                  ));
                            })
                        : IconButton(
                            icon: badges.Badge(
                              position:
                                  badges.BadgePosition.topEnd(top: -7, end: -7),
                              badgeContent:
                                  Text(AppVariables.CountUnreadNoti.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          //color: Constant.PRIMARY_COLOR,
                                          fontWeight: FontWeight.bold)),
                              child: Icon(
                                Icons.notifications,
                                color: Color(0xFF79682d),
                                //color: Constant.PRIMARY_COLOR,
                              ),
                            ),
                            onPressed: () async {
                              try {
                                print("updateNotiUnread");
                                Map<String, String> requestHeaders = {
                                  'Content-type': 'application/json',
                                  'serverId': AppVariables.ServerId,
                                  'customerId': AppVariables.CustomerId
                                };
                                final url =
                                    "${AppVariables.API}/MobileAppNotiSentUpdateCount?searchCustTel=${AppVariables.CUSTTEL}";
                                final response = await http.put(Uri.parse(url),
                                    headers: requestHeaders);
                                print(response.statusCode);
                                print("MobileAppNotiSentUpdateCount : ${url}");
                              } catch (_) {
                                print("${_}");
                              }

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MobileAppNotiSentPage(),
                                  ));
                              setState(() {
                                AppVariables.CountUnreadNoti = 0;
                              });
                            }));
              } else {
                return CircularProgressIndicator();
              }
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Widget menuHit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 10),
        Container(
          height: 30,
          width: MediaQuery.of(context).size.width * 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "รายการยอดฮิต",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  height: 1,
                ),
                textScaler: TextScaler.linear(1),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      'assets/images/btnsaving.png',
                      height: 80,
                    )),
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: ((context) => SavingPage())));
                },
              ),
              InkWell(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      'assets/images/btnpawn.png',
                      height: 80,
                    )),
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: ((context) => PawnPage())));
                },
              ),
              InkWell(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      'assets/images/btnsetting.png',
                      height: 80,
                    )),
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: ((context) => ProfilePage())));
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget goldPrice(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      // height: MediaQuery.of(context).size.width * 0.30,
      height: 150,
        decoration: BoxDecoration(
          
            ),
      child: FutureBuilder(
          future: fetchGoldPrice(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Text(
                          "ราคาทองคำแท่งวันที่ ${AppVariables.GoldPriceText}",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4 // ความหนาของขอบ
                              ..color = Colors.black, // สีขอบ
                          ),
                        ),
                        Text(
                          "ราคาทองคำแท่งวันที่ ${AppVariables.GoldPriceText}",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFC107), // สีทอง
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFf0e19b),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        width: MediaQuery.of(context).size.width * 0.89,
                        height: 110,
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  int.parse(AppVariables.GoldPriceUpDown) > 0
                                      ? Icon(
                                          Icons.arrow_upward,
                                          size: 30,
                                          color: Colors.green,
                                        )
                                      : int.parse(AppVariables
                                                  .GoldPriceUpDown) ==
                                              0
                                          ? Text("")
                                          : Icon(
                                              Icons.arrow_downward,
                                              size: 30,
                                              color: Colors.red,
                                            ),
                                  int.parse(AppVariables.GoldPriceUpDown) > 0
                                      ? Text(" ${AppVariables.GoldPriceUpDown}",
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textScaler: TextScaler.linear(1))
                                      : int.parse(AppVariables
                                                  .GoldPriceUpDown) ==
                                              0
                                          ? Text(
                                              " ${AppVariables.GoldPriceUpDown}",
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textScaler: TextScaler.linear(1))
                                          : Text(
                                              " ${AppVariables.GoldPriceUpDown}",
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textScaler: TextScaler.linear(1)),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                // color: Constant.PRIMARY_COLOR,
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black,
                                     Colors.black87,
                                   Colors.black87,
                                    Colors.black
                                  ],
                                ),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                              ),
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 110,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: Text(
                                          " ขายออก",
                                          style: TextStyle(
                                            color: Color(0xFFFFD700),
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textScaler: TextScaler.linear(1),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        child: Text(
                                          AppVariables.GoldPriceSale,
                                          style: TextStyle(
                                            color: Color(0xFFFFD700),
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textScaler: TextScaler.linear(1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // SizedBox(
                                  //   height: 5,
                                  // ),
                                  Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: Text(
                                          " รับซื้อ",
                                          style: TextStyle(
                                            color: Color(0xFFFFD700),
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textScaler: TextScaler.linear(1),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        child: Text(
                                          AppVariables.GoldPriceBuy,
                                          style: TextStyle(
                                            color: Color(0xFFFFD700),
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textScaler: TextScaler.linear(1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Widget promotionBanner(AppController appController) {
    return Container(
      child: appController.productModels.isEmpty
          ? SizedBox()
          : Column(
              children: [
                // SizedBox(height: 5),
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width * 1,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ข่าวสารและโปรโมชั่น",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          height: 1.5,
                        ),
                        textScaler: TextScaler.linear(1),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: appController.productModels.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => TimeLineImagePage(
                        //           post: appController.productModels[index]),
                        //     ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          // decoration: BoxDecoration(
                          //     border: const GradientBoxBorder(
                          //       gradient: LinearGradient(
                          //           colors: [
                          //             Color(0xFFb57e10),
                          //             Color(0xFFf9df7b),
                          //             Color(0xFFb57e10)
                          //           ],
                          //           begin: Alignment.bottomLeft,
                          //           end: Alignment.topRight),
                          //       width: 3,
                          //     ),
                          //     borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(
                              appController.productModels[index]
                                  .mobileAppPromotionCoverLink,
                              // width: 280,
                              // height: 180,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // Widget savingMt(AppController appController) {
  //   return Container(
  //     child: appController.savingMts.isEmpty
  //         ? Column(children: [
  //             // SizedBox(height: 5),
  //             Container(
  //               height: 30,
  //               width: MediaQuery.of(context).size.width * 1,
  //               decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                   begin: Alignment.bottomCenter,
  //                   end: Alignment.topCenter,
  //                   colors: [
  //                     Color(0xFF660000),
  //                     Color(0xFFDC143C),
  //                   ],
  //                 ),
  //               ),
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     "รายการออมทอง",
  //                     style: TextStyle(
  //                       fontSize: 20,
  //                       color: Colors.white,
  //                       height: 1.5,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(
  //               height: 180,
  //               child: Center(
  //                 child: Text(
  //                   "ไม่พบรายการออมทอง",
  //                   style: TextStyle(
  //                     fontSize: 20,
  //                     color: AppConstant.PRIMARY_COLOR,
  //                     height: 1.5,
  //                   ),
  //                 ),
  //               ),
  //             )
  //           ])
  //         : Column(
  //             children: [
  //               // SizedBox(height: 5),
  //               Container(
  //                 height: 30,
  //                 width: MediaQuery.of(context).size.width * 1,
  //                 decoration: BoxDecoration(
  //                   gradient: LinearGradient(
  //                     begin: Alignment.bottomCenter,
  //                     end: Alignment.topCenter,
  //                     colors: [
  //                       Color(0xFF660000),
  //                       Color(0xFFDC143C),
  //                     ],
  //                   ),
  //                 ),
  //                 child: Row(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text(
  //                       "รายการออมทอง",
  //                       style: TextStyle(
  //                         fontSize: 20,
  //                         color: Colors.white,
  //                         height: 1.5,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(height: 10),
  //               SizedBox(
  //                 height: 180,
  //                 child: Column(
  //                   children: [
  //                     SizedBox(
  //                       height: 160,
  //                       child: GetBuilder<AppController>(builder: (controller) {
  //                         // ฟังการเลื่อน
  //                         controller.saivngScrollController.addListener(() {
  //                           controller.updateIndexOnScroll();
  //                         });
  //                         return ListView.builder(
  //                           controller: controller.saivngScrollController,
  //                           physics: const ClampingScrollPhysics(),
  //                           shrinkWrap: true,
  //                           scrollDirection: Axis.horizontal,
  //                           itemCount: appController.savingMts.length,
  //                           itemBuilder: (context, index) => InkWell(
  //                             onTap: () {
  //                               appController.savingMts[index].savingId!;
  //                               print("${appController.savingMts[index].savingId}");
  //                               Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                     builder: (context) => SavingPage(appController.savingMts[index]),
  //                                   ));
  //                             },
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(4.0),
  //                               child: Container(
  //                                 decoration: BoxDecoration(
  //                                     image: DecorationImage(
  //                                       image: AssetImage("assets/images/saving.png"),
  //                                       opacity: 0.30,
  //                                     ),
  //                                     border: const GradientBoxBorder(
  //                                       gradient: LinearGradient(
  //                                           colors: [Color(0xFFb57e10), Color(0xFFf9df7b), Color(0xFFb57e10)],
  //                                           begin: Alignment.bottomLeft,
  //                                           end: Alignment.topRight),
  //                                       width: 3,
  //                                     ),
  //                                     gradient: LinearGradient(
  //                                       colors: [
  //                                         Colors.redAccent.withOpacity(0.2),
  //                                         Colors.redAccent.withOpacity(0.2),
  //                                       ],
  //                                     ),
  //                                     borderRadius: BorderRadius.circular(20)),
  //                                 child: Column(
  //                                   mainAxisAlignment: MainAxisAlignment.start,
  //                                   children: [
  //                                     SizedBox(height: 10),
  //                                     Container(
  //                                       height: 130,
  //                                       child: Row(
  //                                         mainAxisAlignment: MainAxisAlignment.start,
  //                                         children: <Widget>[
  //                                           SizedBox(width: 10),
  //                                           _buildTitelSaving(),
  //                                           _buildDetailSaving(appController, index, MediaQuery.of(context).size.width)
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         );
  //                       }),
  //                     ),
  //                     GetBuilder<AppController>(builder: (controller) {
  //                       return Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: List.generate(
  //                           appController.savingMts.length,
  //                           (index) => Padding(
  //                             padding: const EdgeInsets.symmetric(horizontal: 2.0),
  //                             child: Container(
  //                               width: 8,
  //                               height: 8,
  //                               decoration: BoxDecoration(
  //                                   shape: BoxShape.circle,
  //                                   color: index == appController.selectedIndexSaving ? Colors.redAccent : Colors.grey),
  //                             ),
  //                           ),
  //                         ),
  //                       );
  //                     }),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //   );
  // }

  Widget _buildTitelSaving() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 5),
          Text(
            "เลขที่ออมทอง  :",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstant.SECONDARY_COLOR,
                fontSize: 24),
            textScaler: TextScaler.linear(1),
          ),
          SizedBox(height: 10),
          Text(
            "ยอดออมทอง  :",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstant.SECONDARY_COLOR,
                fontSize: 24),
            textScaler: TextScaler.linear(1),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildDetailSaving(
      AppController appController, int index, double width) {
    return Container(
      width: width * 0.35,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5),
          Text(
            "  ${appController.savingMts[index].savingId}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstant.SECONDARY_COLOR,
                fontSize: 24),
            textScaler: TextScaler.linear(1),
          ),
          SizedBox(height: 10),
          Text(
            "  ${AppFormatters.formatNumber.format(appController.savingMts[index].totalPay)} บาท",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstant.SECONDARY_COLOR,
                fontSize: 24),
            textScaler: TextScaler.linear(1),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildTitelPawnMt(double width) {
    return Container(
      width: width * 0.35,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 5),
          Text(
            "เลขที่ขายฝาก :",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstant.SECONDARY_COLOR,
                fontSize: 22),
            textScaler: TextScaler.linear(1),
          ),
          Text(
            "จำนวนเงิน :",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstant.SECONDARY_COLOR,
                fontSize: 22),
            textScaler: TextScaler.linear(1),
          ),
          // Text(
          //   "วันที่ครบกำหนด :",
          //   style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       color: Color(0xFFFFD700),
          //       fontSize: 22),
          //   textScaleFactor: 1,
          // ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildDetailPawnMt(
      AppController appController, int index, double width) {
    return Container(
      width: width * 0.35,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5),
          Text(
            " ${appController.pawnMts[index].pawnId}",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstant.SECONDARY_COLOR,
                fontSize: 22),
            textScaler: TextScaler.linear(1),
          ),
          Text(
            " ${AppFormatters.formatNumber.format(appController.pawnMts[index].amountget)} บาท",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstant.SECONDARY_COLOR,
                fontSize: 22),
            textScaler: TextScaler.linear(1),
          ),
          // Text(
          //   " ${Constant.formatDate.format(appController.pawnMts[index].duedate)}",
          //   style: TextStyle(
          //       fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22),
          //   textScaleFactor: 1,
          // ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  // Widget pawnMT(AppController appController) {
  //   return Container(
  //     child: appController.pawnMts.isEmpty
  //         ? Column(children: [
  //             // SizedBox(height: 5),
  //             Container(
  //               height: 30,
  //               width: MediaQuery.of(context).size.width * 1,
  //               decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                   begin: Alignment.bottomCenter,
  //                   end: Alignment.topCenter,
  //                   colors: [
  //                     Color(0xFF660000),
  //                     Color(0xFFDC143C),
  //                   ],
  //                 ),
  //               ),
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     "รายการขายฝาก",
  //                     style: TextStyle(
  //                       fontSize: 20,
  //                       color: Colors.white,
  //                       height: 1.5,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(
  //               height: 180,
  //               child: Center(
  //                 child: Text(
  //                   "ไม่พบรายการขายฝาก",
  //                   style: TextStyle(
  //                     fontSize: 20,
  //                     color: AppConstant.PRIMARY_COLOR,
  //                     height: 1.5,
  //                   ),
  //                 ),
  //               ),
  //             )
  //           ])
  //         : Column(
  //             children: [
  //               // SizedBox(height: 5),
  //               Container(
  //                 height: 30,
  //                 width: MediaQuery.of(context).size.width * 1,
  //                 decoration: BoxDecoration(
  //                   gradient: LinearGradient(
  //                     begin: Alignment.bottomCenter,
  //                     end: Alignment.topCenter,
  //                     colors: [
  //                       Color(0xFF660000),
  //                       Color(0xFFDC143C),
  //                     ],
  //                   ),
  //                 ),
  //                 child: Row(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text(
  //                       "รายการขายฝาก",
  //                       style: TextStyle(
  //                         fontSize: 20,
  //                         color: Colors.white,
  //                         height: 1.5,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(height: 10),
  //               SizedBox(
  //                 height: 180,
  //                 child: Column(
  //                   children: [
  //                     SizedBox(
  //                       height: 160,
  //                       child: GetBuilder<AppController>(builder: (controller) {
  //                         // ฟังการเลื่อน
  //                         controller.pawnScrollController.addListener(() {
  //                           controller.updateIndexOnScroll();
  //                         });
  //                         return ListView.builder(
  //                           controller: controller.pawnScrollController,
  //                           physics: const ClampingScrollPhysics(),
  //                           shrinkWrap: true,
  //                           scrollDirection: Axis.horizontal,
  //                           itemCount: appController.pawnMts.length,
  //                           itemBuilder: (context, index) => InkWell(
  //                             onTap: () {
  //                               print("${appController.pawnMts[index].pawnId}");
  //                               Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                   builder: (context) => PawnDtPage(appController.pawnMts[index]),
  //                                 ),
  //                               );
  //                             },
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(4.0),
  //                               child: Container(
  //                                 decoration: BoxDecoration(
  //                                     image: DecorationImage(
  //                                       image: AssetImage("assets/images/pawn.png"),
  //                                       opacity: 0.2,
  //                                     ),
  //                                     border: const GradientBoxBorder(
  //                                       gradient: LinearGradient(
  //                                           colors: [Color(0xFFb57e10), Color(0xFFf9df7b), Color(0xFFb57e10)],
  //                                           begin: Alignment.bottomLeft,
  //                                           end: Alignment.topRight),
  //                                       width: 3,
  //                                     ),
  //                                     gradient: LinearGradient(
  //                                       colors: [
  //                                         Colors.redAccent.withOpacity(0.2),
  //                                         Colors.redAccent.withOpacity(0.2),
  //                                       ],
  //                                     ),
  //                                     borderRadius: BorderRadius.circular(20)),
  //                                 child: Column(
  //                                   mainAxisAlignment: MainAxisAlignment.start,
  //                                   children: [
  //                                     SizedBox(height: 10),
  //                                     Container(
  //                                       height: 130,
  //                                       child: Row(
  //                                         mainAxisAlignment: MainAxisAlignment.start,
  //                                         children: <Widget>[
  //                                           SizedBox(width: 10),
  //                                           _buildTitelPawnMt(MediaQuery.of(context).size.width),
  //                                           _buildDetailPawnMt(appController, index, MediaQuery.of(context).size.width)
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         );
  //                       }),
  //                     ),
  //                     GetBuilder<AppController>(builder: (controller) {
  //                       return Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: List.generate(
  //                           appController.pawnMts.length,
  //                           (index) => Padding(
  //                             padding: const EdgeInsets.symmetric(horizontal: 2.0),
  //                             child: Container(
  //                               width: 8,
  //                               height: 8,
  //                               decoration: BoxDecoration(
  //                                   shape: BoxShape.circle,
  //                                   color: index == appController.selectedIndexPawn ? Colors.redAccent : Colors.grey),
  //                             ),
  //                           ),
  //                         ),
  //                       );
  //                     }),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //   );
  // }

  Widget newProduct(AppController appController) {
    return Container(
      child: appController.newProductP1s.isEmpty
          ? SizedBox()
          : Column(
              children: [
                SizedBox(height: 10),
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width * 1,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "  สินค้าแนะนำ",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Text(
                            "ดูสินค้าทั้งหมด  ",
                            style: TextStyle(
                                color: Colors.white, fontSize: 20, height: 1.5),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductRecommendPage(),
                              ));
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.8,
                  child: GridView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 2.7),
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => TimeLineImagePage(
                        //           post: appController.newProductP1s[index]),
                        //     ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: const GradientBoxBorder(
                                    gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFb57e10),
                                          Color(0xFFf9df7b),
                                          Color(0xFFb57e10)
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight),
                                    width: 4,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.network(
                                    appController.newProductP1s[index]
                                        .mobileAppPromotionLink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

Future<bool> getNotiUnread() async {
  AppVariables.CountUnreadNoti = 0;
  try {
    print("getNotiUnread");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'serverId': AppVariables.ServerId,
      'customerId': AppVariables.CustomerId
    };
    final url =
        "${AppVariables.API}/GetMobileAppNotiSentCountUnread?searchCustTel=${AppVariables.CUSTTEL}";
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    print(url);
    print("MobileAppNotiSentCountUnreadResponse : ${url}");
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final MobileAppNotiSentCountUnreadResponse
          mobileAppNotiSentCountUnreadResponse =
          MobileAppNotiSentCountUnreadResponse.fromJson(
              json.decode(response.body));
      AppVariables.CountUnreadNoti =
          mobileAppNotiSentCountUnreadResponse.countUnread!;
      print("MobileAppNotiSentCountUnreadResponse Complete");
      return true;
    } else {
      print("Failed to load SummaryResponse ${response.statusCode}");
      return false;
    }
  } catch (_) {
    print("${_}");
    return false;
  }
}
