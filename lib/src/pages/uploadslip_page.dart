import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:suppaisangold_app/src/models/mobileapppayment_response.dart';
import 'package:suppaisangold_app/src/pages/home_page.dart';
import 'package:intl/intl.dart';
import 'package:suppaisangold_app/src/pages/qrcodepromptpay_page.dart';
import 'package:suppaisangold_app/src/utils/appconstants.dart';
import 'package:suppaisangold_app/src/utils/appformatters.dart';
import 'package:suppaisangold_app/src/utils/banknameandimage.dart';
import 'package:suppaisangold_app/src/widgets/selectdatetime.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:suppaisangold_app/src/utils/appvariables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadSlipPagePage extends StatefulWidget {
  final String savingId;

  UploadSlipPagePage(this.savingId);
  @override
  _UploadSlipPagePageState createState() => _UploadSlipPagePageState();
}

TextEditingController timeinput = TextEditingController();

class _UploadSlipPagePageState extends State<UploadSlipPagePage> {
  FirebaseStorage _storage = FirebaseStorage.instance;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();
  double? amountPay;
  String? promptPayID;
  MobileAppPaymentResponse _mobileAppPaymentResponse = MobileAppPaymentResponse();

  dynamic _imageFile;

  Future<void> _saveImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Uint8List bytesList = await image.readAsBytes();

      // สำหรับการแสดงข้อความยืนยันการบันทึก (ในที่นี้ สมมติว่าการบันทึกทำในส่วนอื่น)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('บันทึก QR Code เรียบร้อย'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ไม่สามารถ บันทึก QR Code ได้ โปรดลองอีกครั้ง'),
        ),
      );
    }
  }

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
    DateFormat dateFormat = DateFormat("HH:mm");
    timeinput.text = dateFormat.format(DateTime.now());

    _requestPermission();
  }

  @override
  Widget build(BuildContext context) {
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
                  backgroundColor: Colors.black,
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
          title: Stack(
            children: [
              // ขอบสีขาว
              Text(
                "เพิ่มรูปสลิปโอน ${AppVariables.MobileAppPaymentType} ${AppVariables.MobileAppPaymentBillId}",
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
                "เพิ่มรูปสลิปโอน ${AppVariables.MobileAppPaymentType} ${AppVariables.MobileAppPaymentBillId}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // สีตัวหนังสือ
                ),
              ),
            ],
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          // backgroundColor: Color(0xFF990000),
        ),
        body: Container(
          height: double.infinity,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextFormField(
                          onSaved: (price) {
                            _mobileAppPaymentResponse.price = double.parse(price!);
                          },
                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(
                                () {},
                              );
                            } else {
                              setState(() {
                                amountPay = double.parse(value);
                              });
                            }
                          },
                          validator: RequiredValidator(errorText: "กรุณาใส่จำนวนเงินที่โอน"),
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          decoration: InputDecoration(
                              labelText: "จำนวนเงินที่โอน", labelStyle: TextStyle(color: Colors.black, fontSize: 26,fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Container(
                          //margin: const EdgeInsets.all(40.0),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(image: new AssetImage(getBankImage(AppVariables.BankAccSaving)))),
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppVariables.BankAccSaving,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF030088),
                              ),
                            ),
                            Text(
                              AppVariables.BankAcctNameSaving,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF030088),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  AppVariables.BankAcctNoSaving,
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF030088),
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.copy,
                                      size: 20,
                                      color: Color(0xFF030088),
                                    ),
                                    onPressed: () async {
                                      await Clipboard.setData(ClipboardData(text: AppVariables.BankAcctNoSaving));
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
                  //           foregroundColor:
                  //               MaterialStateProperty.all<Color>(Colors.white),
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
                  //           promptPayID = "0849726380";

                  //           if (amountPay != null && amountPay! > 0) {
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                 builder: (context) => QRCodePromptpayIntPage(
                  //                     title:
                  //                         "${AppVariables.MobileAppPaymentType} ${AppVariables.MobileAppPaymentBillId}",
                  //                     amount: amountPay!),
                  //               ),
                  //             );
                  //           } else {
                  //             ScaffoldMessenger.of(context).showSnackBar(
                  //               SnackBar(
                  //                   content:
                  //                       Text("กรุณาใส่จำนวนเงินที่ถูกต้อง")),
                  //             );
                  //           }
                  //         },
                  //         //padding: EdgeInsets.all(16.0),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 30),
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
                              Text("เลือกรูป หรือ ถ่ายรูป สลิป",
                                  style: TextStyle(color: Color(0xFF030088), fontSize: 20,fontWeight: FontWeight.bold))
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
                                    ..strokeWidth = 4
                                    ..color = Colors.black, // สีขอบตัวหนังสือ
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
                                    ..strokeWidth = 4
                                    ..color = Colors.black, // สีขอบตัวหนังสือ
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
                            foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFf7c664)),
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
                                    ..strokeWidth = 4
                                    ..color = Colors.black, // สีขอบตัวหนังสือ
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
                          onPressed: () async {
                            DateTime? selectedDate = await selectDate(context, DateTime.now());
                            if (selectedDate != null) {
                              setState(() {
                                print("Selected date: $selectedDate");
                              });
                            }
                          },
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
                            _mobileAppPaymentResponse.timeTran = timeTran;
                          },
                          validator: RequiredValidator(errorText: "กรุณาใส่เวลาโอน"),
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF030088),
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.text,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: "เวลาโอน",
                            labelStyle: TextStyle(
                              fontSize: 26, // ขนาดตัวอักษร
                              fontWeight: FontWeight.bold, // ตัวหนา (ถ้าต้องการ)
                              color: Color(0xFF030088), // เปลี่ยนสีตัวอักษร (ถ้าต้องการ)
                            ),
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
                            _mobileAppPaymentResponse.remark = remark;
                          },
                          style: TextStyle(fontSize: 24, color: Colors.black),
                          keyboardType: TextInputType.text,
                          autofocus: true,
                          // decoration: InputDecoration(
                          //   labelText: "หมายเหตุ (ถ้ามี)",
                          // ),
                          decoration: InputDecoration(
                            labelText: "หมายเหตุ (ถ้ามี)",
                            labelStyle: TextStyle(
                              fontSize: 20, // ขนาดตัวอักษร
                              fontWeight: FontWeight.bold, // ตัวหนา (ถ้าต้องการ)
                              color: Color(0xFF030088), // เปลี่ยนสีตัวอักษร (ถ้าต้องการ)
                            ),
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
                            foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFf7c664)),
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
                                    ..strokeWidth = 4
                                    ..color = Colors.black, // สีขอบตัวหนังสือ
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
                                if (amountPay == null) {
                                  showDialogUploadFail(context);
                                } else if (amountPay! < 0) {
                                  showDialogUploadFail1(context);
                                } else {
                                  try {
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

                                    print(
                                        "${_mobileAppPaymentResponse.price} ${AppFormatters.formatDateToDatabase.format(AppVariables.SelectDate)} ${_mobileAppPaymentResponse.timeTran}");

                                    String fileName =
                                        "${widget.savingId}_${AppFormatters.formatDateAll.format(DateTime.now())}";
                                    Reference storageRef = _storage
                                        .ref()
                                        .child(AppFormatters.formatDateYYYY.format(DateTime.now()))
                                        .child("suppaisangold_app")
                                        .child(fileName);

                                    UploadTask uploadTask;

                                    // สำหรับเว็บ ใช้ putData(), สำหรับ Android/iOS ใช้ putFile()
                                    if (kIsWeb) {
                                      uploadTask = storageRef.putData(
                                        _imageFile!,
                                        SettableMetadata(contentType: 'image/jpeg'),
                                      );
                                    } else {
                                      uploadTask = storageRef.putFile(_imageFile!); // ใช้ File สำหรับ Android/iOS
                                    }

                                    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
                                      print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
                                    }, onError: (e) {
                                      print('Error during upload: $e');
                                    });

                                    TaskSnapshot taskSnapshot = await uploadTask;
                                    print("Upload completed");

                                    if (taskSnapshot.state == TaskState.success) {
                                      String downloadURL = await storageRef.getDownloadURL();
                                      print("Download URL: $downloadURL");

                                      Map<String, String> headers = {
                                        "Accept": "application/json",
                                        "content-type": "application/json",
                                        'serverId': AppVariables.ServerId,
                                        'customerId': AppVariables.CustomerId
                                      };

                                      var requestBody = jsonEncode({
                                        "branchName": AppVariables.MobileAppPaymentBranchName,
                                        "type": AppVariables.MobileAppPaymentType,
                                        "status": "รออนุมัติ",
                                        "custId": AppVariables.MobileAppPaymentCustId,
                                        "custName": AppVariables.CUSTNAME,
                                        "billId": AppVariables.MobileAppPaymentBillId,
                                        "picLink": downloadURL,
                                        "price": _mobileAppPaymentResponse.price.toString(),
                                        "tranBank": "",
                                        "tranBankAccNo": "",
                                        "dateTran": AppFormatters.formatDateToDatabase.format(selectedDate!),
                                        "timeTran": _mobileAppPaymentResponse.timeTran
                                      });

                                      final response = await http.post(
                                        Uri.parse("${AppVariables.API}/AddMobileAppPayment"),
                                        headers: headers,
                                        body: requestBody,
                                      );

                                      statusCode = response.statusCode;
                                      print("statuscode ${statusCode.toString()}");

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
                                                "${AppVariables.API}/AddMobileAppNotiSent?BranchName=${AppVariables.MobileAppPaymentBranchName}&NotiTitle=ออมทอง&NotiRefNo=${AppVariables.MobileAppPaymentBillId}&NotiDetail=รออนุมัติ ยอดเงิน ${AppFormatters.formatNumber.format(_mobileAppPaymentResponse.price)} บาท&CustTel=${AppVariables.CUSTTEL}"),
                                            headers: headersSendnoti);

                                        print(
                                            "${AppVariables.API}/AddMobileAppNotiSent?BranchName=${AppVariables.MobileAppPaymentBranchName}&NotiTitle=ออมทอง&NotiRefNo=${AppVariables.MobileAppPaymentBillId}&NotiDetail=รออนุมัติ ยอดเงิน ${AppFormatters.formatNumber.format(_mobileAppPaymentResponse.price)} บาท&CustTel=${AppVariables.CUSTTEL}");

                                        print("AddMobileAppNotiSent complete");

                                        _formKey.currentState!.reset();
                                        setState(() {
                                          _imageFile = null;
                                        });
                                      } else {
                                        showDialogNotUpload(context);
                                        print("Failed AddMobileAppPayment data api ${statusCode}");
                                      }
                                    }
                                  } catch (_) {
                                    showDialogNotUpload(context);
                                    print("${_}");
                                  }
                                }
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
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

  void showDialogCantCopy(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            "❗️ไม่สามารถคัดลอกเลขที่บัญชีได้" + "\n" + "\n" + "เนื่องจากยังไม่ได้กรอกจำนวนเงิน" + "\n" + "\n" + "",
            style: TextStyle(color: Colors.red),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'ตกลง',
                style: TextStyle(
                  fontSize: 28,
                  height: 1,
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

  void showDialogCantCopy1(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            "❗️ไม่สามารถคัดลอกเลขที่บัญชีได้" + "\n" + "\n" + "เนื่องจากยอดเงินน้อยกว่า 0 บาท" + "\n" + "\n" + "",
            style: TextStyle(color: Colors.red),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'ตกลง',
                style: TextStyle(
                  fontSize: 28,
                  height: 1,
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

  void showDialogUploadFail(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            "❗️ไม่สามารถบันทึกได้" + "\n" + "\n" + "เนื่องจากยังไม่ระบุยอดเงิน" + "\n" + "\n" + "",
            style: TextStyle(color: Colors.red),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'ตกลง',
                style: TextStyle(
                  fontSize: 28,
                  height: 1,
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

  void showDialogUploadFail1(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            "❗️ไม่สามารถบันทึกได้" + "\n" + "\n" + "เนื่องจากยอดเงินน้อยกว่า 0 บาท" + "\n" + "\n" + "",
            style: TextStyle(color: Colors.red),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'ตกลง',
                style: TextStyle(
                  fontSize: 28,
                  height: 1,
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

  void showDialogUploadComplete(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          // title: Text(
          //   'แจ้งเข้าระบบเรียบร้อยแล้วค่ะ 😊',
          //   style: TextStyle(color: Colors.red),
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
                // Text(
                //   "กรุณารออัพเดทจากทางร้าน ภายใน 24 ชั่วโมง",
                //   style: TextStyle(
                //       fontSize: 15,
                //       height: 1.2,
                //       color: Constant.FONT_COLOR_MENU),
                // ),
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
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                    (route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}
