import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:suppaisangold_app/src/models/pawn_response.dart';
import 'package:suppaisangold_app/src/pages/uploadslipint2_page.dart';
import 'package:suppaisangold_app/src/pages/uploadslipint_page.dart';
import 'package:suppaisangold_app/src/services/app_service.dart';
import 'package:suppaisangold_app/src/utils/appconstants.dart';
import 'package:suppaisangold_app/src/utils/appcontroller.dart';
import 'package:suppaisangold_app/src/utils/appformatters.dart';
import 'package:suppaisangold_app/src/utils/appvariables.dart';
import 'package:suppaisangold_app/src/utils/banknameandimage.dart';
import 'package:http/http.dart' as http;

class PawnDtPage extends StatefulWidget {
  final PawnResponse pawnMt;

  PawnDtPage(this.pawnMt);

  @override
  _PawnDtPageState createState() => _PawnDtPageState();
}

class _PawnDtPageState extends State<PawnDtPage> {
  FirebaseStorage _storage = FirebaseStorage.instance;
  var amountGet = 0;

  void initState() {
    super.initState();
    AppVariables.PawnId = widget.pawnMt.pawnId!;
    AppVariables.PawnBranch = widget.pawnMt.branchName!;
    AppService().pawnDt();
  }

  Future<void> checkWaitingApprovalMobileAppPaymentInt(String billid, String branchName, BuildContext context) async {
    try {
      print("checkWaitingApprovalMobileAppPaymentInt");
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'serverId': AppVariables.ServerId,
        'customerId': AppVariables.CustomerId
      };
      final url =
          "${AppVariables.API}/CheckWaitingApprovalMobileAppPaymentInt?billid=${billid}&branchname=${branchName}";
      final response = await http.get(Uri.parse(url), headers: requestHeaders);
      print(url);
      if (response.statusCode == 204) {
        print("checkWaitingApprovalMobileAppPaymentInt 204 Complete");
//เช็คแล้วว่าไม่มีรายการรออนุมัติ
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UploadSlipIntPage(widget.pawnMt.pawnId!),
            ));
      } else {
        print("checkWaitingApprovalMobileAppPaymentInt ${response.statusCode}");
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
          print(appController.pawnDts);
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
                backgroundColor:Colors.black,
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
                // title: Text(
                //   "ขายฝาก เลขที่ ${widget.pawnMt.pawnId}",
                //   style: TextStyle(color: Colors.white),
                // ),
                title: Stack(
                  children: [
                    // ขอบสีขาว
                    Text(
                      "ขายฝาก เลขที่ ${widget.pawnMt.pawnId}",
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
                      "ขายฝาก เลขที่ ${widget.pawnMt.pawnId}",
                      style: const TextStyle(
                        fontSize:26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // สีตัวหนังสือ
                      ),
                    ),
                  ],
                ),
                iconTheme: IconThemeData(color: Colors.white),
                // backgroundColor: Color(0xFF990000),
              ),
              body: ListView(
                children: [pawnMt(), pawnDescription(), pawnDt(appController, context)],
                
              ),
              
            ),
          );
        });
  }

  Widget pawnDt(AppController appController, BuildContext context) {
    return Container(
        child: appController.pawnDts.isEmpty
            ? Center(
                heightFactor: 5,
                child: Text(
                  "ไม่พบข้อมูลชำระดอกเบี้ย",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 26),
                ),
              )
            : Column(
                children: [
                  Container(
                    color: Colors.grey.shade300,
                    width: MediaQuery.of(context).size.width * 1,
                    // height: MediaQuery.of(context).size.width * 0.15,
                    height: 55,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text("  รายการต่อดอก",
                            style: TextStyle(color: Colors.grey.shade700,fontWeight: FontWeight.bold, fontSize: 22), textScaleFactor: 1),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: appController.pawnDts.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {},
                        child: Container(
                          color: Colors.grey.shade100,
                          width: MediaQuery.of(context).size.width * 1,
                          // height: MediaQuery.of(context).size.width * 0.19,
                          height: 80,
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "  ${AppFormatters.formatDate.format((appController.pawnDts[index].payDate!))}",
                                    style: TextStyle(fontSize: 22),
                                    textScaleFactor: 1,
                                  ),
                                  Text(
                                    "${AppFormatters.formatNumber.format((appController.pawnDts[index].amountPay))}  ",
                                    style: TextStyle(fontSize: 22, color: Colors.green, fontWeight: FontWeight.bold),
                                    textScaleFactor: 1,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "  ${AppFormatters.formatNumber.format((appController.pawnDts[index].monthPay))} เดือน ต่อดอกถึง ${AppFormatters.formatDate.format((appController.pawnDts[index].dueDate!))}",
                                    style: TextStyle(fontSize: 22, color: Colors.grey),
                                    textScaleFactor: 1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ));
  }

  Container pawnDescription() {
    return Container(
      color: Colors.grey.shade100,
      width: MediaQuery.of(context).size.width * 1,
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text("  สาขาที่ทำรายการ : ${widget.pawnMt.branchName}",
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 26), textScaleFactor: 1),
          Text("  สินค้า : ${widget.pawnMt.sumDescription}",
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 26), textScaleFactor: 1),
          Text("  จำนวนรวม : ${widget.pawnMt.sumItemQty} ชิ้น",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 26), textScaleFactor: 1),
          Text("  น้ำหนักรวม : ${widget.pawnMt.sumItemwt} กรัม",
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 26), textScaleFactor: 1),
          Text("  วันที่ขายฝาก : ${AppFormatters.formatDate.format(widget.pawnMt.inDate!)}",
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 26), textScaleFactor: 1),
          Text("  วันที่ครบกำหนด : ${AppFormatters.formatDate.format(widget.pawnMt.duedate!)}",
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 26), textScaleFactor: 1),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 5),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                  Colors.black87,
                )),
                onPressed: () {
                  AppVariables.MobileAppPaymentIntBranchName = widget.pawnMt.branchName!;
                  AppVariables.MobileAppPaymentIntCustId = AppVariables.CUSTID;
                  AppVariables.MobileAppPaymentIntType = "ต่อดอก";
                  AppVariables.MobileAppPaymentIntBillId = widget.pawnMt.pawnId!;
                  AppVariables.IntPerMonth = AppFormatters.formatNumber2.format(widget.pawnMt.intpay);
                  AppVariables.BankInt = widget.pawnMt.mobileTranBankInt!;
                  AppVariables.BankAcctNameInt = widget.pawnMt.mobileTranBankAcctNameInt!;
                  AppVariables.BankAcctNoInt = widget.pawnMt.mobileTranBankAcctNoInt!;
                  AppVariables.Month = AppFormatters.formatNumber.format(widget.pawnMt.months);
                  AppVariables.DueDate = AppFormatters.formatDate.format(widget.pawnMt.duedate!);

                  AppVariables.BankAccInt = getBankName(widget.pawnMt.mobileTranBankInt);

                  AppVariables.Amountget = AppFormatters.formatNumber2.format(widget.pawnMt.amountget);

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) =>
                  //           UploadSlipInt2Page("Pawn-${widget.pawnMt.branchName}-${widget.pawnMt.pawnId}"),
                  //     ));
                  checkWaitingApprovalMobileAppPaymentInt(widget.pawnMt.pawnId!, widget.pawnMt.branchName!, context);
                },
                child: Text(
                  "แนบสลิป ต่อดอก",
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 26),
                ),
              ),
              SizedBox(width: 5),
              // ElevatedButton(
              //   style: ButtonStyle(
              //       backgroundColor: WidgetStateProperty.all(
              //     Colors.black87,
              //   )),
              //   onPressed: () {
              //     AppVariables.MobileAppPaymentIntBranchName =
              //         widget.pawnMt.branchName!;
              //     AppVariables.MobileAppPaymentIntCustId = AppVariables.CUSTID;
              //     AppVariables.MobileAppPaymentIntType = "ลดเงินต้น";

              //     AppVariables.MobileAppPaymentIntBillId =
              //         widget.pawnMt.pawnId!;
              //     AppVariables.Amountget = AppFormatters.formatNumber2
              //         .format(widget.pawnMt.amountget);
              //     AppVariables.IntPerMonth =
              //         AppFormatters.formatNumber2.format(widget.pawnMt.intpay);
              //     AppVariables.IntCal = 0;
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => UploadSlipInt2Page(
              //               "Pawn-${widget.pawnMt.branchName}-${widget.pawnMt.pawnId}"),
              //         ));
              //   },
              //   // child: Text(
              //   //   "แนบสลิป ลดต้น",
              //   //  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 26),
              //   // ),
              // ),
              // SizedBox(width: 5)
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Container pawnMt() {
    return Container(
      color: Colors.grey.shade300,
      width: MediaQuery.of(context).size.width * 1,
      // height: MediaQuery.of(context).size.width * 0.4,
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            // height: MediaQuery.of(context).size.width * 0.35,
            height: 145,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text("   เลขที่ขายฝาก", style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold, fontSize: 26), textScaleFactor: 1),
                // SizedBox(height: 10),
                Text("   ${widget.pawnMt.pawnId}",
                    style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold, fontSize: 26), textScaleFactor: 1),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("${AppFormatters.formatNumber.format(widget.pawnMt.amountget)}",
                        style: TextStyle(color: Colors.black, fontSize: 36,fontWeight: FontWeight.bold), textScaleFactor: 1),
                    SizedBox(width: 20),
                  ],
                )
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
    // barrierColor:Colors.black,
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
                color: Color(0xFFFFC107),
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
