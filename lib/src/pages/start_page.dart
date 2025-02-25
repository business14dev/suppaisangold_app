import 'dart:io';

import 'package:flutter/material.dart';
import 'package:suppaisangold_app/src/utils/appconstants.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: _buildLogo(),
      ),
    );
  }

  Container _buildLogo() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(50.0),
                width: 200,
                height: 200,
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/logo2.png"))),
              ),
            ],
          ),
          // Text(
          //   "ห้างทองทรัพย์ไพศาล",
          //   style: TextStyle(
          //     fontSize: 26,
          //     color: AppConstant.FONT_COLOR_MENU,
          //   ),
          // ),
          Stack(
            children: [
              // ขอบสีขาว
              Text(
                " SPS GOLD",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Chonburi",
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 4
                    ..color = Colors.black, // สีขอบตัวหนังสือ
                ),
              ),
              // ตัวหนังสือสีแดง (วางทับด้านบน)
              Text(
                " SPS GOLD",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontFamily: "Chonburi",
                  fontWeight: FontWeight.bold,
                  color:    Color(0xFFFFC107), // สีตัวหนังสือ
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
