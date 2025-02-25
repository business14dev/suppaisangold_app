import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:suppaisangold_app/src/models/intredeem_response.dart';
import 'package:suppaisangold_app/src/models/mobileapppaymentint_response.dart';
import 'package:suppaisangold_app/src/pages/home_page.dart';
import 'package:suppaisangold_app/src/pages/qrcodepromptpay_page.dart';
import 'package:suppaisangold_app/src/utils/appconstants.dart';
import 'package:suppaisangold_app/src/utils/appformatters.dart';
import 'package:suppaisangold_app/src/utils/appvariables.dart';
import 'package:suppaisangold_app/src/utils/banknameandimage.dart';
import 'package:suppaisangold_app/src/widgets/selectdatetime.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UploadSlipInt2Page extends StatefulWidget {
  final String branchNameAndPawnId;

  UploadSlipInt2Page(this.branchNameAndPawnId);

  @override
  _UploadSlipInt2PageState createState() => _UploadSlipInt2PageState();
}

TextEditingController timeinput = TextEditingController();
TextEditingController amountPay = TextEditingController();
TextEditingController amountGetReduce = TextEditingController();

class _UploadSlipInt2PageState extends State<UploadSlipInt2Page> {
  FirebaseStorage _storage = FirebaseStorage.instance;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();
  MobileAppPaymentIntResponse _mobileAppPaymentIntResponse = MobileAppPaymentIntResponse();

  dynamic _imageFile;
  DateTime _selectedDate = DateTime.now();
  int _counterValue = 1;
  String? _AmountGetNew;
  double? _AmountPayCal;

  Future<bool> getIntRedeem() async {
    AppVariables.DayCal = 0;
    AppVariables.MonthCal = 0;
    AppVariables.IntCal = 0;
    try {
      print("getIntRedeem");
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'serverId': AppVariables.ServerId,
        'customerId': AppVariables.CustomerId
      };
      final url =
          "${AppVariables.API}/Calculator/intredeem?branchname=${AppVariables.MobileAppPaymentIntBranchName}&pawnid=${AppVariables.MobileAppPaymentIntBillId}";
      final response = await http.get(Uri.parse(url), headers: requestHeaders);
      print(url);
      print("getIntRedeem : ${url}");
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        final IntRedeemResponse intRedeemResponse = IntRedeemResponse.fromJson(json.decode(response.body));
        AppVariables.DayCal = intRedeemResponse.dayCal!;
        AppVariables.MonthCal = intRedeemResponse.monthCal!;
        AppVariables.IntCal = intRedeemResponse.intCal!;
        print("IntRedeemResponse Complete");
        return true;
      } else {
        print("Failed to load IntRedeemResponse ${response.statusCode}");
        return false;
      }
    } catch (_) {
      print("${_}");
      return false;
    }
  }

  late Future<bool> _futureData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    DateFormat dateFormat = DateFormat("HH:mm");
    timeinput.text = dateFormat.format(DateTime.now());
    amountPay.text =
        AppFormatters.formatNumber.format(double.parse(AppVariables.IntCal.toString().replaceAll(",", "")));

    amountPay.text = "";
    _futureData = getIntRedeem();

    _futureData.then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          // title: Text(
          //   "กรุณารอสักครู่ ...",
          //   style: TextStyle(color: Colors.blue),
          // ),
          title: Stack(
              children: [
                // ขอบสีขาว
                Text(
                  "กรุณารอสักครู่ ...",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2
                      ..color = Colors.white, // สีขอบตัวหนังสือ
                  ),
                ),
                // ตัวหนังสือสีแดง (วางทับด้านบน)
                Text(
                  "กรุณารอสักครู่ ...",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.red, // สีตัวหนังสือ
                  ),
                ),
              ],
            ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg-slip.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF030088), Color(0xFF00469FF), Color(0xFF030088)], // ไล่เฉดสีฟ้า
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            title: Stack(
              children: [
                // ขอบสีขาว
                Text(
                  "เพิ่มรูปสลิปโอน ${AppVariables.MobileAppPaymentIntType} ${AppVariables.MobileAppPaymentIntBillId}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2
                      ..color = Colors.white, // สีขอบตัวหนังสือ
                  ),
                ),
                // ตัวหนังสือสีแดง (วางทับด้านบน)
                Text(
                  "เพิ่มรูปสลิปโอน ${AppVariables.MobileAppPaymentIntType} ${AppVariables.MobileAppPaymentIntBillId}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red, // สีตัวหนังสือ
                  ),
                ),
              ],
            ),
            iconTheme: IconThemeData(
              color: Color(0xFFFFFFFF),
            ),
            backgroundColor: Color(0xFF990000),
          ),
          body: Container(
            height: double.infinity,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Container(
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Container(
                            //margin: const EdgeInsets.all(40.0),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                image: DecorationImage(image: new AssetImage(getBankImage(AppVariables.BankAccInt)))),
                          ),
                          SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppVariables.BankAccInt,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF030088),
                                ),
                              ),
                              // SizedBox(height: 10),
                              Text(
                                AppVariables.BankAcctNameInt,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF030088),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    AppVariables.BankAcctNoInt,
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF030088),
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.copy,
                                        size: 26,
                                        color: Color(0xFF030088),
                                      ),
                                      onPressed: () async {
                                        await Clipboard.setData(ClipboardData(text: AppVariables.BankAcctNoInt));
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                          content: Text('Copied to clipboard'),
                                        ));
                                      }),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    // SizedBox(height: 10),
                    Column(
                      children: [
                        Text(
                          "จำนวนเงินต้น ${AppFormatters.formatNumber.format(double.parse(AppVariables.Amountget.toString().replaceAll(",", "")))} บาท",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppConstant.FONT_COLOR_MENU,
                          ),
                        ),
                        // SizedBox(height: 5),
                        Text(
                          "ระยะเวลา ${AppVariables.MonthCal} เดือน ${AppVariables.DayCal} วัน ",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppConstant.FONT_COLOR_MENU,
                          ),
                        ),
                        // SizedBox(height: 5),
                        Text(
                          "ดอกเบี้ยที่ต้องชำระ ${AppFormatters.formatNumber.format(AppVariables.IntCal)} บาท",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppConstant.FONT_COLOR_MENU,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: FutureBuilder(
                        future: getIntRedeem(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data == true) {
                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.blue))),
                                    height: 40,
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    child: Center(
                                      child: Text(
                                        "จำนวนเงินที่โอน ${AppFormatters.formatNumber.format(AppVariables.IntCal)} บาท",
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                    // SizedBox(height: 10),
                    // Container(
                    //   padding: EdgeInsets.only(left: 10, right: 10),
                    //   child: Center(
                    //     child: Container(
                    //       width: MediaQuery.of(context).size.width * 0.8,
                    //       decoration: BoxDecoration(
                    //         gradient: LinearGradient(
                    //           begin: Alignment.bottomCenter,
                    //           end: Alignment.topCenter,
                    //           colors: [
                    //             Color(0xFFe8aa24),
                    //             Color(0xFFe8aa24),
                    //           ],
                    //         ),
                    //         borderRadius: BorderRadius.all(Radius.circular(25)),
                    //       ),
                    //       child: TextButton(
                    //         style: ButtonStyle(
                    //           foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    //         ),
                    //         child: Text(
                    //           'สร้าง QR Code พร้อมเพย์',
                    //           style: TextStyle(
                    //             fontSize: 20.0,
                    //             fontWeight: FontWeight.bold,
                    //             color: Color(0xFFFFFFFF),
                    //           ),
                    //         ),
                    //         // ignore: missing_return

                    //         onPressed: () {
                    //           // แปลงค่า amountPay.text เป็น double เพื่อตรวจสอบจำนวนเงิน
                    //           final amount = double.tryParse(amountPay.text.replaceAll(",", ""));

                    //           if (amount != null && amount > 0) {
                    //             Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                 builder: (context) => QRCodePromptpayIntPage(
                    //                     title:
                    //                         "${AppVariables.MobileAppPaymentIntType} ${AppVariables.MobileAppPaymentIntBillId}",
                    //                     amount: amount),
                    //               ),
                    //             );
                    //           } else {
                    //             ScaffoldMessenger.of(context).showSnackBar(
                    //               SnackBar(content: Text("กรุณาใส่จำนวนเงินที่ถูกต้อง")),
                    //             );
                    //           }
                    //         },
                    //         //padding: EdgeInsets.all(16.0),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 10),
                    Container(
                      child: _imageFile == null
                          ? Column(
                              children: [
                                Container(
                                  height: 150,
                                  child: Center(
                                    child: Icon(
                                      Icons.image,
                                      size: 150,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                Text("เลือกรูป หรือ ถ่ายรูป สลิป", style: TextStyle(color: Color(0xFF030088),fontWeight: FontWeight.bold,fontSize: 20))
                              ],
                            )
                          : Container(
                              child: kIsWeb
                                  ? Image.memory(
                                      _imageFile!, // ใช้สำหรับเว็บ (Uint8List)
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      _imageFile!, // ใช้สำหรับ Android/iOS (File)
                                      fit: BoxFit.cover,
                                    ),
                            ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF030088), Color(0xFF00469FF), Color(0xFF030088)], // ไล่เฉดสีฟ้า
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: TextButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            ),
                            child: Stack(
                              children: [
                                // ขอบสีขาว
                                Text(
                                  "เลือกรูปสลิป",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 2
                                      ..color = Colors.white, // สีขอบตัวหนังสือ
                                  ),
                                ),
                                // ตัวหนังสือสีแดง (วางทับด้านบน)
                                Text(
                                  "เลือกรูปสลิป",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red, // สีตัวหนังสือ
                                  ),
                                ),
                              ],
                            ),
                            // ignore: missing_return
                            onPressed: () {
                              _getFromGallery();
                            },
                            //padding: EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF030088), Color(0xFF00469FF), Color(0xFF030088)], // ไล่เฉดสีฟ้า
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: TextButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFf7c664)),
                            ),
                            child: Stack(
                              children: [
                                // ขอบสีขาว
                                Text(
                                  "ถ่ายรูปสลิป",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 2
                                      ..color = Colors.white, // สีขอบตัวหนังสือ
                                  ),
                                ),
                                // ตัวหนังสือสีแดง (วางทับด้านบน)
                                Text(
                                  "ถ่ายรูปสลิป",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red, // สีตัวหนังสือ
                                  ),
                                ),
                              ],
                            ),
                            // ignore: missing_return
                            onPressed: () {
                              _getFromCamera();
                            },
                            //padding: EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF030088), Color(0xFF00469FF), Color(0xFF030088)], // ไล่เฉดสีฟ้า
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: TextButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            ),
                            child: Stack(
                              children: [
                                // ขอบสีขาว
                                Text(
                                  "วันที่โอน ${AppFormatters.formatDate.format(AppVariables.SelectDate)}",
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 2
                                      ..color = Colors.white, // สีขอบตัวหนังสือ
                                  ),
                                ),
                                // ตัวหนังสือสีแดง (วางทับด้านบน)
                                Text(
                                  "วันที่โอน ${AppFormatters.formatDate.format(AppVariables.SelectDate)}",
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red, // สีตัวหนังสือ
                                  ),
                                ),
                              ],
                            ),
                            // ignore: missing_return
                            onPressed: () async {
                              DateTime? selectedDate = await selectDate(context, DateTime.now());
                              if (selectedDate != null) {
                                setState(() {
                                  print("Selected date: $selectedDate");
                                });
                              }
                            },
                            //padding: EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            controller: timeinput,
                            onSaved: (timeTran) {
                              _mobileAppPaymentIntResponse.timeTran = timeTran;
                            },
                            validator: RequiredValidator(errorText: "กรุณาใส่เวลาโอน"),
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF030088),
                            ),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            decoration: InputDecoration(
                              labelText: "เวลาโอน",
                              labelStyle: TextStyle(
                                fontSize: 26,
                                color: Color(0xFF030088),
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            onSaved: (remark) {
                              _mobileAppPaymentIntResponse.remark = remark;
                            },
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: AppConstant.FONT_COLOR_MENU),
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            decoration: InputDecoration(
                              labelText: "หมายเหตุ (ถ้ามี)",
                              labelStyle: TextStyle(
                                color: Color(0xFF030088),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF030088), Color(0xFF00469FF), Color(0xFF030088)], // ไล่เฉดสีฟ้า
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: TextButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            ),
                            child: Stack(
                              children: [
                                // ขอบสีขาว
                                Text(
                                  "บันทึก",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 2
                                      ..color = Colors.white, // สีขอบตัวหนังสือ
                                  ),
                                ),
                                // ตัวหนังสือสีแดง (วางทับด้านบน)
                                Text(
                                  "บันทึก",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red, // สีตัวหนังสือ
                                  ),
                                ),
                              ],
                            ),
                            // ignore: missing_return
                            onPressed: () async {
                              var statusCode;

                              if (_imageFile != null) {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Container(
                                            padding: EdgeInsets.all(15),
                                            child: Row(
                                              children: [
                                                CircularProgressIndicator(),
                                                SizedBox(width: 10),
                                                Text("กำลังบันทึกข้อมูล")
                                              ],
                                            ),
                                          ),
                                        );
                                      });

                                  print("${_mobileAppPaymentIntResponse.price} ${_mobileAppPaymentIntResponse.remark}");

                                  String fileName = basename(_imageFile!.path);
                                  await _storage
                                      .ref()
                                      .child(AppFormatters.formatDateYYYY.format(DateTime.now()))
                                      .child("suppaisangold_app")
                                      .child(fileName)
                                      .putFile(_imageFile!)
                                      .then((taskSnapshot) async {
                                    print("upload pic to firebase complete");

                                    if (taskSnapshot.state == TaskState.success) {
                                      await _storage
                                          .ref()
                                          .child(AppFormatters.formatDateYYYY.format(DateTime.now()))
                                          .child("suppaisangold_app")
                                          .child(fileName)
                                          .getDownloadURL()
                                          .then((url) async {
                                        //ได้ url มาแล้วค่อยเอาไปบันทึกลง api
                                        print(url);

                                        try {
                                          print("upload data api");

                                          Map<String, String> headers = {
                                            "Accept": "application/json",
                                            "content-type": "application/json",
                                            'serverId': AppVariables.ServerId,
                                            'customerId': AppVariables.CustomerId
                                          };

                                          var requestBody = jsonEncode({
                                            "branchName": AppVariables.MobileAppPaymentIntBranchName,
                                            "type": AppVariables.MobileAppPaymentIntType,
                                            "status": "รออนุมัติ",
                                            "custId": AppVariables.MobileAppPaymentIntCustId,
                                            "custName": AppVariables.CUSTNAME,
                                            "billId": AppVariables.MobileAppPaymentIntBillId,
                                            "picLink": url,
                                            "price": AppVariables.IntCal,
                                            "remark": _mobileAppPaymentIntResponse.remark,
                                            "tranBank": "",
                                            "tranBankAccNo": "",
                                            "dateTran":
                                                AppFormatters.formatDateToDatabase.format(AppVariables.SelectDate),
                                            "timeTran": _mobileAppPaymentIntResponse.timeTran,
                                            "dayPay": AppVariables.DayCal,
                                            "monthPay": AppVariables.MonthCal
                                          });

                                          final response = await http.post(
                                            Uri.parse("${AppVariables.API}/AddMobileAppPaymentInt"),
                                            headers: headers,
                                            body: requestBody,
                                          );

                                          statusCode = response.statusCode;
                                        } catch (_) {
                                          showDialogNotUpload(context);
                                          print("${_}");
                                        }
                                      }).catchError((onError) {
                                        print("Got Error $onError");
                                      });
                                    }
                                  });

                                  Navigator.pop(context); //ปิด dialog กำลังบันทึกข้อมูล

                                  if (statusCode == 204) {
                                    showDialogUploadComplete(context);

                                    //sendnoti
                                    Map<String, String> headersSendnoti = {
                                      "Accept": "application/json",
                                      "content-type": "application/json",
                                      'serverId': AppVariables.ServerId,
                                      'customerId': AppVariables.CustomerId,
                                      'onesignalappid': AppConstant.OneSignalAppId,
                                      'onesignalrestkey': AppConstant.OneSignalRestkey
                                    };

                                    final responseSendnoti = await http.put(
                                        Uri.parse(
                                            "${AppVariables.API}/AddMobileAppNotiSent?BranchName=${AppVariables.MobileAppPaymentIntBranchName}&NotiTitle=ต่อดอก&NotiRefNo=${AppVariables.MobileAppPaymentIntBillId}&NotiDetail=รออนุมัติ ยอดเงิน ${AppFormatters.formatNumber.format(AppVariables.IntCal)} บาท&CustTel=${AppVariables.CUSTTEL}"),
                                        headers: headersSendnoti);

                                    print("AddMobileAppPaymentInt complete");
                                    _formKey.currentState!.reset();
                                    setState(() {
                                      _imageFile = null;
                                      _counterValue = 1;
                                      amountPay.text = AppFormatters.formatNumber.format(
                                          double.parse(AppVariables.IntPerMonth.toString().replaceAll(",", "")) *
                                              _counterValue);
                                    });
                                  } else {
                                    showDialogNotUpload(context);
                                    print("Failed AddMobileAppPaymentInt data api ${statusCode}");
                                  }
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  _getFromGallery() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          // อ่านข้อมูลเป็น Uint8List สำหรับเว็บ
          Uint8List imageBytes = await pickedFile.readAsBytes();
          setState(() {
            _imageFile = imageBytes;
          });
        } else {
          // สร้าง File สำหรับ Android/iOS
          File imageFile = File(pickedFile.path);
          setState(() {
            _imageFile = imageFile;
          });
        }
      }
    } catch (e) {
      print('Error occurred while picking image: $e');
      // แสดงข้อความ error ใน UI หรือแจ้งเตือนผู้ใช้ได้ตามต้องการ
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      if (kIsWeb) {
        // อ่านข้อมูลเป็น Uint8List สำหรับเว็บ
        Uint8List imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _imageFile = imageBytes;
        });
      } else {
        // สร้าง File สำหรับ Android/iOS
        File imageFile = File(pickedFile.path);
        setState(() {
          _imageFile = imageFile;
        });
      }
    }
  }

  void showDialogNotUpload(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'ไม่สามารถเพิ่มรูปได้กรุณาลองใหม่อีกครั้ง',
            style: TextStyle(color: Colors.red),
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

  void showDialogUploadComplete(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          // title: Text(
          //   'แจ้งเข้าระบบเรียบร้อยแล้วค่ะ 😊',
          //   style: TextStyle(color: Constant.FONT_COLOR_MENU),
          // ),
          content: Container(
            height: 250,
            child: Column(
              children: [
                Image.asset(
                  "assets/images/paymentsuccess.png",
                  height: 250,
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
                Navigator.of(dialogContext).pop(true); // Dismiss alert dialo
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                    (route) => false); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  void showDialogBeforeDueDate(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            "❗️ไม่สามารถทำรายการได้" + "\n" + "\n" + "จำนวนเงินลดต้น มากกว่าเงินต้นเดิม",
            style: TextStyle(color: Colors.red),
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
                Navigator.of(dialogContext).pop(true); // Dismiss alert dialo
              },
            ),
          ],
        );
      },
    );
  }
}
