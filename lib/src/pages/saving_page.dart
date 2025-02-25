import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:get/get.dart';

import 'package:suppaisangold_app/src/models/savingmt_response.dart';
import 'package:suppaisangold_app/src/pages/uploadslip_page.dart';
import 'package:suppaisangold_app/src/services/app_service.dart';
import 'package:suppaisangold_app/src/utils/appconstants.dart';
import 'package:suppaisangold_app/src/utils/appcontroller.dart';
import 'package:suppaisangold_app/src/utils/appformatters.dart';
import 'package:suppaisangold_app/src/utils/appvariables.dart';
import 'package:http/http.dart' as http;
import 'package:suppaisangold_app/src/utils/banknameandimage.dart';

class SavingPage extends StatefulWidget {
  final SavingMtResponse savingMt;

  SavingPage(this.savingMt);

  @override
  _SavingPage createState() => _SavingPage();
}

class _SavingPage extends State<SavingPage> {
  void initState() {
    super.initState();
    AppVariables.SavingId = widget.savingMt.savingId!;
    AppService().savingDt();
  }

  Future<void> checkWaitingApprovalMobileAppPayment(String billid, String branchName, BuildContext context) async {
    try {
      print("checkWaitingApprovalMobileAppPayment");
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'serverId': AppVariables.ServerId,
        'customerId': AppVariables.CustomerId
      };
      final url = "${AppVariables.API}/CheckWaitingApprovalMobileAppPayment?billid=${billid}&branchname=${branchName}";
      final response = await http.get(Uri.parse(url), headers: requestHeaders);
      print(url);
      if (response.statusCode == 204) {
        print("checkWaitingApprovalMobileAppPayment 204 Complete");
//เช็คแล้วว่าไม่มีรายการรออนุมัติ
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UploadSlipPagePage(widget.savingMt.savingId!),
            ));
      } else {
        print("checkWaitingApprovalMobileAppPayment ${response.statusCode}");
        //มีรายการอนุมัติ ตาลทำไปข้อความแจ้งเตือน
        showDialogWaiting(context);
      }
    } catch (_) {
      print("${_}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print(appController.savingMts);
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg-home.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  
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
                    // title: Container(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         "ออมทอง",
                    //         style: TextStyle(color: Colors.white),
                    //         textScaleFactor: 1.0,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    title: Stack(
                      children: [
                        // ขอบสีขาว
                        Text(
                          "ออมทอง",
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
                        Text(
                          "ออมทอง",
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // สีตัวหนังสือ
                          ),
                        ),
                      ],
                    ),
                    iconTheme: IconThemeData(
                      color: Colors.white,
                    ),
                    backgroundColor:  Colors.black),
                body: ListView(
                  children: [
                    savingMt(),
                    savingDescription(),
                    savingDt(appController, context),
                  ],
                )),
          );
        });
  }

  Widget savingDt(AppController appController, BuildContext context) {
    return Container(
      child: appController.savingDts.isEmpty
          ? SizedBox()
          : Column(
              children: [
                Container(
                  color: Colors.grey.shade300,
                  width: MediaQuery.of(context).size.width * 1,
                  // height: MediaQuery.of(context).size.width * 0.17,
                  height: 55,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text("  รายการบัญชีออมทอง",
                          style: TextStyle(color: Colors.black, fontSize: 24,fontWeight: FontWeight.bold), textScaleFactor: 1),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: appController.savingDts.length,
                    itemBuilder: (context, index) {
                        // ก่อนแสดงข้อมูลให้เรียงลำดับ
                        appController.savingDts.value.sort((a, b) => (a.no ?? 0).compareTo(b.no ?? 0));
                        final item = appController.savingDts[index];
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                          child: Column(
                        
                          children: [
                            SizedBox(height: 10),
                            Row(
                              
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "  ครั้งที่ ${(appController.savingDts[index].no)}",
                                  style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),
                                  textScaleFactor: 1,
                                ),
                                Text(
                                  appController.savingDts[index].amountPay! > 0
                                      ? "+${AppFormatters.formatNumber.format((appController.savingDts[index].amountPay))}  "
                                      : "${AppFormatters.formatNumber.format((appController.savingDts[index].amountPay))}  ",
                                  style: TextStyle(fontSize: 26, color: Colors.green, fontWeight: FontWeight.bold),
                                  textScaleFactor: 1,
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "  ${AppFormatters.formatDate.format((appController.savingDts[index].payDate!))}",
                                  style: TextStyle(fontSize: 26, color: Colors.black,fontWeight: FontWeight.bold),
                                  textScaleFactor: 1,
                                ),
                                Text(
                                  "${AppFormatters.formatNumber.format((appController.savingDts[index].totalAmountPay))}  ",
                                  style: TextStyle(fontSize: 26, color: Colors.black,fontWeight: FontWeight.bold),
                                  textScaleFactor: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                        );
                      },
                    // itemBuilder: (context, index) => InkWell(
                    //   onTap: () {},
                    //   child: Container(
                    //     color: Colors.grey.shade100,
                    //     width: MediaQuery.of(context).size.width * 1,
                    //     // height: MediaQuery.of(context).size.width * 0.19,
                    //     height: 80,
                    //     child: Column(
                    //       children: [
                    //         SizedBox(height: 10),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Text(
                    //               "  ครั้งที่ ${(appController.savingDts[index].no)}",
                    //               style: TextStyle(fontSize: 20),
                    //               textScaleFactor: 1,
                    //             ),
                    //             Text(
                    //               appController.savingDts[index].amountPay! > 0
                    //                   ? "+${AppFormatters.formatNumber.format((appController.savingDts[index].amountPay))}  "
                    //                   : "${AppFormatters.formatNumber.format((appController.savingDts[index].amountPay))}  ",
                    //               style: TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
                    //               textScaleFactor: 1,
                    //             ),
                    //           ],
                    //         ),
                    //         SizedBox(height: 5),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Text(
                    //               "  ${AppFormatters.formatDate.format((appController.savingDts[index].payDate!))}",
                    //               style: TextStyle(fontSize: 20, color: Colors.grey),
                    //               textScaleFactor: 1,
                    //             ),
                    //             Text(
                    //               "${AppFormatters.formatNumber.format((appController.savingDts[index].totalAmountPay))}  ",
                    //               style: TextStyle(fontSize: 20, color: Colors.grey),
                    //               textScaleFactor: 1,
                    //             ),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ),
                )
              ],
            ),
    );
  }

  Container savingDescription() {
    return Container(
      color: Colors.grey.shade100,
      width: MediaQuery.of(context).size.width * 1,
      // height: MediaQuery.of(context).size.width * 0.35,
      height: 145,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text("  สาขาที่ทำรายการ : ${widget.savingMt.branchName}",
              style: TextStyle(color: Colors.black, fontSize: 26,fontWeight: FontWeight.bold), textScaleFactor: 1),
          Text("  วันที่เปิดออม : ${AppFormatters.formatDate.format(widget.savingMt.savingDate!)}",
              style: TextStyle(color: Colors.black, fontSize: 26,fontWeight: FontWeight.bold), textScaleFactor: 1),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
              Colors.black,
            )),
            onPressed: () {
              AppVariables.MobileAppPaymentBranchName = widget.savingMt.branchName!;
              AppVariables.MobileAppPaymentCustId = AppVariables.CUSTID;
              AppVariables.MobileAppPaymentType = "ออมทอง";
              AppVariables.MobileAppPaymentBillId = widget.savingMt.savingId!;
              AppVariables.BankAcctNameSaving = widget.savingMt.mobileTranBankAcctNameSaving!;
              AppVariables.BankAcctNoSaving = widget.savingMt.mobileTranBankAcctNoSaving!;

              AppVariables.BankAccSaving = getBankName(widget.savingMt.mobileTranBankSaving);

              checkWaitingApprovalMobileAppPayment(widget.savingMt.savingId!, widget.savingMt.branchName!, context);

              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => UploadSlipPagePage(
              //           "Saving-${widget.savingMt.savingId}"),
              //     ));
            },
            child: Text(
              "แนบสลิป ออมทอง",
              style: TextStyle(color: Colors.white, fontSize: 26,fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget savingMt() {
    return Container(
      color: Colors.grey.shade300,
      width: MediaQuery.of(context).size.width * 1,
      // height: MediaQuery.of(context).size.width * 0.42,
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            // height: MediaQuery.of(context).size.width * 0.36,
            height: 145,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text("   เลขที่ออมทอง", style: TextStyle(color: Colors.grey, fontSize: 26,fontWeight: FontWeight.bold), textScaleFactor: 1),
                // SizedBox(height: 10),
                Text("   ${widget.savingMt.savingId!}",
                    style: TextStyle(color: Colors.grey, fontSize: 26,fontWeight: FontWeight.bold), textScaleFactor: 1),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("${AppFormatters.formatNumber.format(widget.savingMt.totalPay)}",
                        style: TextStyle(color: Colors.black, fontSize: 38,fontWeight: FontWeight.bold), textScaleFactor: 1),
                    SizedBox(width: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showDialogWaiting(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    // false = user must tap button, true = tap outside dialog
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        content: Container(
          height: 200,
          child: Column(
            children: [
              Image.asset(
                "assets/images/waiting.png",
                height: 200,
                width: 250,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'ตกลง',
              style: TextStyle(
                fontSize: 20,
                color: AppConstant.FONT_COLOR_MENU,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Dismiss alert dialog
            },
          ),
        ],
      );
    },
  );
}
