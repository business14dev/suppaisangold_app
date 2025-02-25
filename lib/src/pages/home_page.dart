import 'dart:io';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:suppaisangold_app/src/pages/homenew_page.dart';
import 'package:suppaisangold_app/src/pages/pawnmt_page.dart';
import 'package:suppaisangold_app/src/pages/point_page.dart';
import 'package:suppaisangold_app/src/pages/savingmt_page.dart';
import 'package:suppaisangold_app/src/pages/setting_page.dart';
import 'package:suppaisangold_app/src/utils/appconstants.dart';
import 'package:suppaisangold_app/src/utils/appvariables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  int _currentIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  final List<Widget> _pages = [
    HomeNew(),
    SavingmtPage(),
    // PointPage(),
    PawnmtPage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[_pages[_currentIndex]],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Colors.black87,
        selectedIndex: _currentIndex,
        showElevation: true, // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          _currentIndex = index;
        }),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title:Stack(children: [
                Text(
                  'หน้าหลัก',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 4 // ความหนาของขอบ
                      ..color = Colors.black, // สีขอบ
                  ),
                ),
                // ข้อความสีทอง (ด้านหน้า)
                Text(
                  'หน้าหลัก',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFC107), // สีทอง
                  ),
                ),
              ]),
              // Text(
              //   'หน้าหลัก',
              //   style: TextStyle(
              //     fontSize: 24,
              //   ),
              // ),
              // icon: Icon(Icons.home)
               icon: Stack(
    children: [
      // ไอคอนขอบดำ (ด้านหลัง)
      Icon(
       Icons.home,
        size: 32,
        color: Colors.black, // สีขอบดำ
      ),
      // ไอคอนสีทอง (ด้านหน้า)
      Positioned(
        left: 1, top: 1, // ขยับให้ตรงกัน
        child: Icon(
          Icons.home,
          size: 27,
          color: Color(0xFFFFC107), // สีทอง
        ),
      ),
    ],
  ),
              inactiveColor: Color(0xFFFFC107),
              activeColor: Color(0xFFFFC107)),
          BottomNavyBarItem(
              title:  Stack(children: [
                Text(
                  'ออมทอง',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 4 // ความหนาของขอบ
                      ..color = Colors.black, // สีขอบ
                  ),
                ),
                // ข้อความสีทอง (ด้านหน้า)
                Text(
                  'ออมทอง',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFC107), // สีทอง
                  ),
                ),
              ]),
              // Text(
              //   'ออมทอง',
              //   style: TextStyle(
              //     fontSize: 24,
              //   ),
              // ),
              icon: Stack(
    children: [
      // ไอคอนขอบดำ (ด้านหลัง)
      Icon(
        Icons.savings,
        size: 32,
        color: Colors.black, // สีขอบดำ
      ),
      // ไอคอนสีทอง (ด้านหน้า)
      Positioned(
        left: 1, top: 1, // ขยับให้ตรงกัน
        child: Icon(
          Icons.savings,
          size: 28,
          color: Color(0xFFFFC107), // สีทอง
        ),
      ),
    ],
  ),
              inactiveColor: Color(0xFFFFC107),
              activeColor: Color(0xFFFFC107)),
          // BottomNavyBarItem(
          // title: Text('คะแนน'),
          // icon: Icon(Icons.paypal),
          // inactiveColor: AppConstant.PRIMARY_COLOR,
          // activeColor: AppConstant.PRIMARY_COLOR),
          BottomNavyBarItem(
              title: Stack(children: [
                Text(
                  'ขายฝาก',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 4 // ความหนาของขอบ
                      ..color = Colors.black, // สีขอบ
                  ),
                ),
                // ข้อความสีทอง (ด้านหน้า)
                Text(
                  'ขายฝาก',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFC107), // สีทอง
                  ),
                ),
              ]),
              // Text(
              //   'ขายฝาก',
              //   style: TextStyle(
              //     fontSize: 24,
              //   ),
              // ),
              // icon: Icon(Icons.account_balance),
              icon: Stack(
    children: [
      // ไอคอนขอบดำ (ด้านหลัง)
      Icon(
       Icons.account_balance,
        size: 32,
        color: Colors.black, // สีขอบดำ
      ),
      // ไอคอนสีทอง (ด้านหน้า)
      Positioned(
        left: 1, top: 1, // ขยับให้ตรงกัน
        child: Icon(
          Icons.account_balance,
          size: 27,
          color: Color(0xFFFFC107), // สีทอง
        ),
      ),
    ],
  ),
              inactiveColor: Color(0xFFFFC107),
              activeColor: Color(0xFFFFC107)),
          BottomNavyBarItem(
              // title: Text('ติดต่อเรา',
              // style: TextStyle(
              //     fontSize: 24,
              //   ),
              //   ),
              title: Stack(children: [
                Text(
                  'ติดต่อเรา',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 4 // ความหนาของขอบ
                      ..color = Colors.black, // สีขอบ
                  ),
                ),
                // ข้อความสีทอง (ด้านหน้า)
                Text(
                  'ติดต่อเรา',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFC107), // สีทอง
                  ),
                ),
              ]),
              // icon: Icon(Icons.menu),
               icon: Stack(
    children: [
      // ไอคอนขอบดำ (ด้านหลัง)
      Icon(
       Icons.menu,
        size: 32,
        color: Colors.black, // สีขอบดำ
      ),
      // ไอคอนสีทอง (ด้านหน้า)
      Positioned(
        left: 1, top: 1, // ขยับให้ตรงกัน
        child: Icon(
          Icons.menu,
          size: 27,
          color: Color(0xFFFFC107), // สีทอง
        ),
      ),
    ],
  ),
              inactiveColor: Color(0xFFFFC107),
              activeColor: Color(0xFFFFC107)),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _mapGetLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppVariables.IS_LOGIN = prefs.getBool(AppConstant.IS_LOGIN_PREF) ?? false;
    AppVariables.CUSTID = prefs.getString(AppConstant.CUSTID_PREF) ?? "-";
    AppVariables.CUSTNAME =
        prefs.getString(AppConstant.CUSTNAME_PREF) ?? "ลูกค้าทั่วไป";
    AppVariables.CUSTTEL = prefs.getString(AppConstant.CUSTTEL_PREF) ?? "-";

    print(AppVariables.CUSTNAME);
  }
}
