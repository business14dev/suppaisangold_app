import 'dart:math';

import 'package:suppaisangold_app/src/services/app_service.dart';
import 'package:suppaisangold_app/src/utils/appconstants.dart';
import 'package:suppaisangold_app/src/utils/appcontroller.dart';
import 'package:suppaisangold_app/src/utils/appformatters.dart';
import 'package:suppaisangold_app/src/utils/appvariables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PointPage extends StatefulWidget {
  const PointPage({super.key});

  @override
  State<PointPage> createState() => _PointPageState();
}

class _PointPageState extends State<PointPage> {
  @override
  void initState() {
    super.initState();
    AppService().poinT();
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print(appController.poinTs);
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Color(0xFF990000),
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
                              Text(
                                ' ห้างทองทรัพย์ไพศาล',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 0.8),
                                textScaler: TextScaler.linear(1),
                              ),
                              SizedBox(height: 10),
                              AppVariables.CUSTID == "-"
                                  ? SizedBox()
                                  : Row(
                                      children: [
                                        Text(
                                          ' สวัสดี ',
                                          style:
                                              TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          AppVariables.CUSTNAME,
                                          style: TextStyle(
                                              color: Color(0xFFfefca7), fontSize: 20, fontWeight: FontWeight.bold),
                                          textScaler: TextScaler.linear(1),
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
            body: ListView(children: [
              Column(
                children: [
                  SizedBox(height: 10),
                  // Text(
                  //   " สวัสดีคุณ ${AppVariables.CUSTNAME}",
                  //   style: TextStyle(color: Colors.black, fontSize: 20),
                  // ),
                  Container(
                    child: appController.poinTs.isEmpty
                        ? Column(children: [
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
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "รายการคะแนน",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 180,
                              child: Center(
                                child: Text(
                                  "ไม่พบคะแนนสะสม",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppConstant.PRIMARY_COLOR,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            )
                          ])
                        : Column(
                            children: [
                              SizedBox(height: 10),
                              Container(
                                height: 170,
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [AppConstant.PRIMARY_COLOR, AppConstant.SECONDARY_COLOR],
                                    ),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "   คะแนนสะสม", //todo
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFFFFFFF),
                                              fontSize: 26,
                                              height: 1),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${AppFormatters.formatNumber.format(appController.poinTs[0].custRemainPoint)}", //todo
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFFFFFFF),
                                              fontSize: 55,
                                              height: 1),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "คะแนน", //todo
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFFFFFFF),
                                              fontSize: 26,
                                              height: 1),
                                          textAlign: TextAlign.left,
                                        ),
                                        SizedBox(width: 10),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [AppConstant.PRIMARY_COLOR, AppConstant.SECONDARY_COLOR],
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '  ประวัติการทำรายการ',
                                      style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 24, height: 1),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              Container(
                                width: double.infinity,
                                child: DataTable(
                                  headingRowColor: WidgetStateColor.resolveWith((states) => AppConstant.PRIMARY_COLOR),
                                  dataRowColor: WidgetStateColor.resolveWith((states) => Colors.white),
                                  columns: [
                                    DataColumn(
                                        label: Text("วันที่", style: TextStyle(fontSize: 20, color: Colors.white))),
                                    DataColumn(
                                        label: Expanded(
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text("คะแนน", style: TextStyle(fontSize: 20, color: Colors.white))),
                                    ))
                                  ],
                                  rows: appController.poinTs.map((point) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(
                                          "${AppFormatters.formatDate.format(point.pointDate!)}",
                                          style: TextStyle(fontSize: 20),
                                        )),
                                        DataCell(Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text("${AppFormatters.formatNumber.format(point.point)}",
                                                textAlign: TextAlign.right, style: TextStyle(fontSize: 20)),
                                          ],
                                        )),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              )
                            ],
                          ),
                  )
                ],
              ),
            ]),
          );
        });
  }
}
