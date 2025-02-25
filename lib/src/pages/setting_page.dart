import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suppaisangold_app/src/pages/contact_page.dart';
import 'package:suppaisangold_app/src/pages/home_page.dart';
import 'package:suppaisangold_app/src/pages/loginscreen_page.dart';
import 'package:suppaisangold_app/src/utils/appconstants.dart';
import 'package:suppaisangold_app/src/utils/appvariables.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String version = "";

  @override
  void initState() {
    super.initState();
    print('initState called');
    _getAppVersion(); // เรียกฟังก์ชันดึงเวอร์ชันตอนเริ่มต้น
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print("App Version: ${packageInfo.version}");
    print("Build Number: ${packageInfo.buildNumber}");
    setState(() {
      version = packageInfo.version; // บันทึกเวอร์ชันในตัวแปร
    });
  }

  Future<void> openNotificationSettings() async {
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.settings.APP_NOTIFICATION_SETTINGS',
        arguments: {
          'android.provider.extra.APP_PACKAGE':
              'com.suppaisangold.suppaisangoldapp', // เปลี่ยนเป็น package name ของแอปคุณ
        },
      );
      await intent.launch();
    } else if (Platform.isIOS) {
      // สำหรับ iOS คุณสามารถเปิดหน้า settings หลักได้ แต่ไม่สามารถเปิดหน้าการแจ้งเตือนโดยตรง
      final Uri url = Uri.parse('app-settings:');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg-white.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 60,
            ),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(right: 30, left: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLogo(),
                    ..._buildComName(),
                    SizedBox(height: 10),
                    _buildSetting(),
                    ..._buildLogInOut(context),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _buildSetting() {
    return Column(
      children: [
        Divider(),
        // ListTile(
        //   leading: Icon(Icons.notifications, color: Colors.white),
        //   title: Text('การแจ้งเตือน', style: TextStyle(fontSize: 20), textScaler: TextScaler.linear(1)),
        //   trailing: Icon(
        //     Icons.arrow_forward_ios,
        //     color: Color(0xFFFFC107),
        //   ),
        //   onTap: () {
        //     openNotificationSettings();
        //   },
        // ),
        // ListTile(
        //   leading: Icon(Icons.phone, color: Colors.white),
        //   title: Text('ติดต่อเรา', style: TextStyle(fontSize: 20), textScaler: TextScaler.linear(1)),
        //   trailing: Icon(
        //     Icons.arrow_forward_ios,
        //     color: Color(0xFFFFC107),
        //   ),
        //   onTap: () {
        //     Navigator.push(context, MaterialPageRoute(builder: ((context) => ContactPage())));
        //   },
        // ),
        ListTile(
          leading: Icon(Icons.notifications, color: Color(0xFFFFC107)),
          title: Stack(
            children: [
              // ขอบสีขาว
              Text(
                'การแจ้งเตือน',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = Colors.black, // สีขอบตัวหนังสือ
                ),
              ),
              // ตัวหนังสือสีแดง (วางทับด้านบน)
              const Text(
                'การแจ้งเตือน',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFC107), // สีตัวหนังสือ
                ),
              ),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFFFFC107),
          ),
          onTap: () {
            openNotificationSettings();
          },
        ),
        ListTile(
          leading: Icon(Icons.phone, color: Color(0xFFFFC107)),
          title: Stack(
            children: [
              // ขอบสีขาว
              Text(
                'ติดต่อเรา',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = Colors.black, // สีขอบตัวหนังสือ
                ),
              ),
              // ตัวหนังสือสีแดง (วางทับด้านบน)
              const Text(
                'ติดต่อเรา',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFC107), // สีตัวหนังสือ
                ),
              ),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFFFFC107),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: ((context) => ContactPage())));
          },
        ),
        ListTile(
          leading: const Icon(Icons.lock, color:Color(0xFFFFC107)),
          title: Stack(
            children: [
              // ขอบสีขาว
              Text(
                'นโยบายความเป็นส่วนตัว',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = Colors.black,// สีขอบตัวหนังสือ
                ),
              ),
              // ตัวหนังสือสีแดง (วางทับด้านบน)
              const Text(
                'นโยบายความเป็นส่วนตัว',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFC107), // สีตัวหนังสือ
                ),
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFFFC107)),
          onTap: () {
            _launchUrlPolicy();
          },
        ),
        ListTile(
          leading: Icon(
            Icons.lock,
            color: Color(0xFFFFC107),
          ),
          title: Stack(
            children: [
              // ขอบสีขาว
              Text(
                'ข้อตกลงและเงื่อนไข',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = Colors.black, // สีขอบตัวหนังสือ
                ),
              ),
              // ตัวหนังสือสีแดง (วางทับด้านบน)
              const Text(
                'ข้อตกลงและเงื่อนไข',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFC107), // สีตัวหนังสือ
                ),
              ),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFFFFC107),
          ),
          onTap: () {
            _launchUrlTerm();
          },
        ),
        // ListTile(
        //   leading: Icon(
        //     Icons.lock,
        //     color: Color(0xFFFFC107),
        //   ),
        //   title: Text('ข้อตกลงและเงื่อนไข', style: TextStyle(fontSize: 20), textScaler: TextScaler.linear(1)),
        //   trailing: Icon(
        //     Icons.arrow_forward_ios,
        //     color: Color(0xFFFFC107),
        //   ),
        //   onTap: () {
        //     _launchUrlTerm();
        //   },
        // ),
        // ListTile(
        //   leading: Icon(
        //     Icons.info,
        //     color: Color(0xFFFFC107),
        //   ),
        //   title: Text('เวอร์ชัน', style: TextStyle(fontSize: 20), textScaler: TextScaler.linear(1)),
        //   trailing: Text(version, style: TextStyle(fontSize: 20, color: Colors.red), textScaler: TextScaler.linear(1)),
        // ),
        ListTile(
          leading: Icon(
            Icons.info,
            color: Color(0xFFFFC107),
          ),
          title: Stack(
            children: [
              // ขอบสีขาว
              Text(
                'เวอร์ชัน',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = Colors.black, // สีขอบตัวหนังสือ
                ),
              ),
              // ตัวหนังสือสีแดง (วางทับด้านบน)
              const Text(
                'เวอร์ชัน',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFC107), // สีตัวหนังสือ
                ),
              ),
            ],
          ),
          trailing: Stack(
            children: [
              // ขอบสีขาว
              Text(
                version,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 1
                    ..color = Colors.black, // สีขอบตัวหนังสือ
                ),
              ),
              // ตัวหนังสือสีแดง (วางทับด้านบน)
              Text(
                version,
                style: const TextStyle(
                  fontSize: 26,
                  color: Color(0xFFFFC107), // สีตัวหนังสือ
                ),
              ),
            ],
          ),
        ),
        // _buildUserActionTile(context),
        Divider(),
      ],
    );
  }

  Container _buildLogo() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(5.0),
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/logo2.png")),
              // border: Border.all(color: Color(0xFFe4cc74), width: 2.0, style: BorderStyle.solid)
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildComName() {
    return <Widget>[
      Stack(
        children: [
          // ขอบสีขาว
          Text(
            "ห้างทองทรัพย์ไพศาล",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Chonburi",
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3
                ..color = Colors.black, // สีขอบตัวหนังสือ
            ),
          ),
          // ตัวหนังสือสีแดง (วางทับด้านบน)
          Text(
            "ห้างทองทรัพย์ไพศาล",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: "Chonburi",
              fontWeight: FontWeight.bold,
              color:Color(0xFFFFC107), // สีตัวหนังสือ
            ),
          ),
        ],
      ),
      Stack(
        children: [
          // ขอบสีขาว
          Text(
            "SUPPAISAN GOLDSMITH",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Chonburi",
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4
                ..color = Colors.black, // สีขอบตัวหนังสือ
            ),
          ),
          // ตัวหนังสือสีแดง (วางทับด้านบน)
          Text(
            "SUPPAISAN GOLDSMITH",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: "Chonburi",
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFC107), // สีตัวหนังสือ
            ),
          ),
        ],
      ),
      // InkWell(
      //   onTap: () {
      //     // _launchFacebook();
      //   },
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(vertical: 3),
      //     child: Row(
      //       children: <Widget>[
      //         Image.asset(
      //           "assets/images/facebook.png",
      //           height: 20,
      //         ),
      //         SizedBox(width: 8),
      //         Stack(
      //           children: [
      //             // ขอบสีขาว
      //             Text(
      //               "@suppaisangold",
      //               textAlign: TextAlign.center,
      //               style: TextStyle(
      //                 fontSize: 26,
      //                 fontWeight: FontWeight.bold,
      //                 foreground: Paint()
      //                   ..style = PaintingStyle.stroke
      //                   ..strokeWidth = 2
      //                   ..color = Colors.black, // สีขอบตัวหนังสือ
      //               ),
      //             ),
      //             // ตัวหนังสือสีแดง (วางทับด้านบน)
      //             Text(
      //               "@suppaisangold",
      //               textAlign: TextAlign.center,
      //               style: const TextStyle(
      //                 fontSize: 26,
      //                 fontWeight: FontWeight.bold,
      //                 color: Color(0xFFFFC107), // สีตัวหนังสือ
      //               ),
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      // InkWell(
      //   onTap: () {
      //     _launchLine();
      //   },
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(vertical: 3),
      //     child: Row(
      //       children: <Widget>[
      //         Image.asset(
      //           "assets/images/line.png",
      //           height: 20,
      //         ),
      //         SizedBox(width: 8),
      //         Stack(
      //           children: [
      //             // ขอบสีขาว
      //             Text(
      //               "@mgold789",
      //               textAlign: TextAlign.center,
      //               style: TextStyle(
      //                 fontSize: 26,
      //                 fontWeight: FontWeight.bold,
      //                 foreground: Paint()
      //                   ..style = PaintingStyle.stroke
      //                   ..strokeWidth = 2
      //                   ..color = Colors.black, // สีขอบตัวหนังสือ
      //               ),
      //             ),
      //             // ตัวหนังสือสีแดง (วางทับด้านบน)
      //             Text(
      //               "@mgold789",
      //               textAlign: TextAlign.center,
      //               style: const TextStyle(
      //                 fontSize: 26,
      //                 fontWeight: FontWeight.bold,
      //                 color: Color(0xFFFFC107), // สีตัวหนังสือ
      //               ),
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      // InkWell(
      //   onTap: () {
      //     _launchInstagram();
      //   },
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(vertical: 3),
      //     child: Row(
      //       children: <Widget>[
      //         Image.asset(
      //           "assets/images/ig.png",
      //           height: 20,
      //         ),
      //         SizedBox(width: 8),
      //         Stack(
      //           children: [
      //             // ขอบสีขาว
      //             Text(
      //               "mgold789",
      //               textAlign: TextAlign.center,
      //               style: TextStyle(
      //                 fontSize: 26,
      //                 fontWeight: FontWeight.bold,
      //                 foreground: Paint()
      //                   ..style = PaintingStyle.stroke
      //                   ..strokeWidth = 2
      //                   ..color = Colors.black, // สีขอบตัวหนังสือ
      //               ),
      //             ),
      //             // ตัวหนังสือสีแดง (วางทับด้านบน)
      //             Text(
      //               "mgold789",
      //               textAlign: TextAlign.center,
      //               style: const TextStyle(
      //                 fontSize: 26,
      //                 fontWeight: FontWeight.bold,
      //                 color: Color(0xFFFFC107), // สีตัวหนังสือ
      //               ),
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      // InkWell(
      //   onTap: () {
      //     _launchTiktok();
      //   },
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(vertical: 3),
      //     child: Row(
      //       children: <Widget>[
      //         Image.asset(
      //           "assets/images/tiktok.png",
      //           height: 20,
      //         ),
      //         SizedBox(width: 8),
      //         Stack(
      //           children: [
      //             // ขอบสีขาว
      //             Text(
      //               "@mgold789",
      //               textAlign: TextAlign.center,
      //               style: TextStyle(
      //                 fontSize: 26,
      //                 fontWeight: FontWeight.bold,
      //                 foreground: Paint()
      //                   ..style = PaintingStyle.stroke
      //                   ..strokeWidth = 2
      //                   ..color = Colors.black, // สีขอบตัวหนังสือ
      //               ),
      //             ),
      //             // ตัวหนังสือสีแดง (วางทับด้านบน)
      //             Text(
      //               "@mgold789",
      //               textAlign: TextAlign.center,
      //               style: const TextStyle(
      //                 fontSize: 26,
      //                 fontWeight: FontWeight.bold,
      //                 color: Color(0xFFFFC107), // สีตัวหนังสือ
      //               ),
      //             ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
      // ),
      SizedBox(
        height: 20,
      ),
    ];
  }

  ListTile _buildUserActionTile(BuildContext context) {
    if (AppVariables.CUSTID == "-") {
      // เมื่อผู้ใช้ยังไม่ได้เข้าสู่ระบบ
      return ListTile(
        leading: Icon(Icons.power_settings_new, color: Colors.black),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
        title: Text(
          "เข้าสู่ระบบ",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        onTap: () {
          print("ServerId CustomerId API :  ${AppVariables.ServerId}${AppVariables.CustomerId}${AppVariables.API}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreenPage(),
            ),
          );
        },
      );
    } else {
      // เมื่อผู้ใช้เข้าสู่ระบบแล้ว
      return ListTile(
        leading: Icon(Icons.logout_outlined, color: Colors.black),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
        title: Text(
          "ออกจากระบบ",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        onTap: () {
          AppConstant.delPayerId(AppVariables.CUSTTEL);
          AppVariables.IS_LOGIN = false;
          AppVariables.CUSTID = "-";
          AppVariables.CUSTNAME = "ลูกค้าทั่วไป";
          AppVariables.CUSTTEL = "-";
          _SaveLogin();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
            (Route<dynamic> route) => false,
          );
        },
      );
    }
  }

  List<Widget> _buildLogInOut(BuildContext context) {
    if (AppVariables.CUSTID == "-") {
      return <Widget>[
        Text(
          AppVariables.CUSTNAME,
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFC107), fontSize: 26),
          textScaler: TextScaler.linear(1),
        ),
        Text(
          AppVariables.CUSTID,
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFC107), fontSize: 26),
          textScaler: TextScaler.linear(1),
        ),
        SizedBox(
          height: 5,
        ),
        InkWell(
          onTap: () {
            print("ServerId CustomerId API :  ${AppVariables.ServerId}${AppVariables.CustomerId}${AppVariables.API}");
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreenPage(),
                ));
          },
          child: Padding(
            padding: EdgeInsets.only(
              right: 130,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.login,
                  size: 30, // ปรับขนาดไอคอน
                  color: Color(0xFFFFC107), // สีขอบไอคอน
                ),
                SizedBox(width: 8),
                Text(
                  "เข้าสู่ระบบ",
                  style: TextStyle(
                    fontSize: 26, color: Color(0xFFFFC107),
                    fontWeight: FontWeight.bold,
//                  color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        )
      ];
    } else {
      return <Widget>[
        Text(
          AppVariables.CUSTNAME,
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFC107), fontSize: 26),
          textScaler: TextScaler.linear(1),
        ),
        Text(
          AppVariables.CUSTID,
          style: TextStyle(fontWeight: FontWeight.bold, color:Color(0xFFFFC107), fontSize: 26),
          textScaler: TextScaler.linear(1),
        ),
        SizedBox(
          height: 5,
        ),
        InkWell(
          onTap: () {
            AppConstant.delPayerId(AppVariables.CUSTTEL);
            AppVariables.IS_LOGIN = false;
            AppVariables.CUSTID = "-";
            AppVariables.CUSTNAME = "ลูกค้าทั่วไป";
            AppVariables.CUSTTEL = "-";
            _SaveLogin();

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
                (Route<dynamic> route) => false);
          },
          child: Padding(
            padding: EdgeInsets.only(
              right: 130,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.logout_outlined,
                  size: 30, // ปรับขนาดไอคอน
                  color: Color(0xFFFFC107), // สีขอบไอคอน
                ),
                SizedBox(width: 8),
                Text(
                  "ออกจากระบบ",
                  style: TextStyle(
                    fontSize: 26,
                     color: Color(0xFFFFC107),
                     fontWeight: FontWeight.bold,
//                  color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ];
    }
  }

  // ignore: non_constant_identifier_names
  void _SaveLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(AppConstant.IS_LOGIN_PREF, AppVariables.IS_LOGIN);
    prefs.setString(AppConstant.CUSTID_PREF, AppVariables.CUSTID);
    prefs.setString(AppConstant.CUSTNAME_PREF, AppVariables.CUSTNAME);
    prefs.setString(AppConstant.CUSTTEL_PREF, AppVariables.CUSTTEL);

    AppConstant.savePayerId(AppVariables.CUSTTEL);
  }
}

_makePhoneCall(String phoneNumber) async {
  final Uri url = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication); // ใช้ externalApplication
  } else {
    throw 'Could not launch $url';
  }
}

_launchUrlPolicy() async {
  Uri url = Uri.parse('https://sites.google.com/view/spsgold/privacy-policy');

  if (await canLaunchUrl(url)) {
    return await launchUrl(url, mode: LaunchMode.externalApplication);
  }
  throw 'Could not launch url';
}

_launchUrlTerm() async {
  Uri url = Uri.parse('https://sites.google.com/view/spsgold/terms-conditions');

  if (await canLaunchUrl(url)) {
    return await launchUrl(url, mode: LaunchMode.externalApplication);
  }
  throw 'Could not launch url';
}

_launchFacebook() async {
  String fbProtocolUrl;
  //officail account
//    lineProtocolUrl = "https://line.me/R/oaMessage/${Constant.LINE_ID}/";

  fbProtocolUrl = "https://www.facebook.com/mgold789";
  print(fbProtocolUrl);
//    String fallbackUrl = 'https://www.line.com/page_name';
//    String fallbackUrl = "https://www.Line.com/ห้างทองรัตนไชยเยาวราช";
  if (await canLaunch(fbProtocolUrl)) {
    return await launch(fbProtocolUrl);
  }

  throw 'Could not launch url';
}

_launchLine() async {
  String lineProtocolUrl;
  //officail account
//    lineProtocolUrl = "https://line.me/R/oaMessage/${Constant.LINE_ID}/";

  lineProtocolUrl = "https://lin.ee/bUV9O7Y";
  print(lineProtocolUrl);
//    String fallbackUrl = 'https://www.line.com/page_name';
//    String fallbackUrl = "https://www.Line.com/ห้างทองรัตนไชยเยาวราช";
  if (await canLaunch(lineProtocolUrl)) {
    return await launch(lineProtocolUrl);
  }

  throw 'Could not launch url';
}

_launchInstagram() async {
  String lineProtocolUrl;
  if (Platform.isIOS) {
    lineProtocolUrl = "https://www.instagram.com/${AppVariables.INSTAGRAM}/";
  } else {
    lineProtocolUrl = "https://www.instagram.com/${AppVariables.INSTAGRAM}/";
  }

//    String fallbackUrl = 'https://www.line.com/page_name';
//    String fallbackUrl = "https://www.Line.com/ห้างทองรัตนไชยเยาวราช";
  if (await canLaunch(lineProtocolUrl)) {
    return await launch(lineProtocolUrl);
  }

  throw 'Could not launch url';
}

_launchTiktok() async {
  String tikkokProtocolUrl = "https://www.tiktok.com/@mgold789";

  if (await canLaunch(tikkokProtocolUrl)) {
    return await launch(tikkokProtocolUrl, forceSafariVC: false);
  }
  throw 'Could not launch url';

  // const nativeUrl = "tiktok://user?username=@nomchok1668";
  // const webUrl = "https://www.tiktok.com/@nomchok1668/";
  // if (await canLaunch(nativeUrl)) {
  //   await launch(nativeUrl);
  // } else if (await canLaunch(webUrl)) {
  //   await launch(webUrl);
  // } else {
  //   print("can't open Tiktok");
  // }
}
