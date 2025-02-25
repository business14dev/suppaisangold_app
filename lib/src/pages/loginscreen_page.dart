import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suppaisangold_app/src/models/customer_response.dart';
import 'package:suppaisangold_app/src/pages/home_page.dart';
import 'package:suppaisangold_app/src/utils/appconstants.dart';
import 'package:suppaisangold_app/src/utils/appvariables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenPage extends StatefulWidget {
  @override
  _LoginScreenPageState createState() => _LoginScreenPageState();
}

class _LoginScreenPageState extends State<LoginScreenPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _idCardController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPhoneNumberRegistered = false;
  bool _showPasswordField = false; // ตัวแปรสำหรับแสดงช่องใส่รหัสผ่าน
  bool _showForgotPasswordFields = false; // ตัวแปรสำหรับแสดงช่องลืมรหัสผ่าน

  // ฟังก์ชันสำหรับตรวจสอบว่าหมายเลขโทรศัพท์ลงทะเบียนแล้วหรือไม่
  void _checkPhoneNumber() async {
    final phoneNumber = _phoneController.text;

    // ตรวจสอบว่าหมายเลขโทรศัพท์มี 10 หลัก
    if (phoneNumber.length == 10) {
      try {
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'serverId': AppVariables.ServerId,
          'customerId': AppVariables.CustomerId
        };

        print("ServerId CustomerId API :  ${AppVariables.ServerId}${AppVariables.CustomerId}${AppVariables.API}");
        print("${AppVariables.API}/Customer/${phoneNumber}");

        final response =
            await http.get(Uri.parse('${AppVariables.API}/Customer/${phoneNumber}'), headers: requestHeaders);

        if (response.statusCode == 200) {
          // สมมติว่าการตอบกลับจาก API แสดงว่าหมายเลขนี้ลงทะเบียนแล้ว
          setState(() {
            final CustomerResponse customerResponse = CustomerResponse.fromJson(json.decode(response.body));
            print("fetchCustomer CustID" + customerResponse.custId!);

            AppVariables.CUSTIDTEMP = customerResponse.custId!;
            AppVariables.CUSTNAMETEMP = customerResponse.custName!;
            AppVariables.CUSTTELTEMP = customerResponse.custTel!;
            AppVariables.CUSTTHAIIDTEMP = customerResponse.custThaiId!;
            AppVariables.MEMBERIDTEMP = customerResponse.memberId!;
            AppVariables.MOBILEAPPPASSWORDTEMP = customerResponse.mobileAppPassword!;

            _isPhoneNumberRegistered = true; // หมายเลขลงทะเบียนแล้ว
            _showPasswordField = true; // แสดงช่องรหัสผ่าน
          });
        } else {
          // สมมติว่าหมายเลขยังไม่ได้ลงทะเบียน
          setState(() {
            AppVariables.CUSTIDTEMP = "";
            AppVariables.CUSTNAMETEMP = "";
            AppVariables.CUSTTELTEMP = "";
            AppVariables.CUSTTHAIIDTEMP = "";
            AppVariables.MEMBERIDTEMP = "";
            AppVariables.MOBILEAPPPASSWORDTEMP = "";

            _isPhoneNumberRegistered = false; // หมายเลขยังไม่ได้ลงทะเบียน
            _showPasswordField = false; // ไม่แสดงช่องรหัสผ่าน
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('หมายเลขโทรศัพท์นี้ยังไม่ได้ลงทะเบียน'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // กรณีที่เกิดข้อผิดพลาดจากการเชื่อมต่อกับ API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('กรุณาใส่หมายเลขโทรศัพท์ให้ครบ 10 หลัก'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ฟังก์ชันเข้าสู่ระบบ
  void _login() {
    if (_formKey.currentState!.validate()) {
      final password = _passwordController.text;

      // ตรวจสอบรหัสผ่านที่กรอกกับค่าที่เก็บใน AppVariables
      if (password == AppVariables.MOBILEAPPPASSWORDTEMP) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เข้าสู่ระบบสำเร็จ!',style: TextStyle(
              fontSize: 26,
            ),),
            backgroundColor: Colors.green,
          ),
        );
        // Logic สำหรับเข้าสู่ระบบ (เปลี่ยนหน้า หรือต่อ API)

        AppVariables.IS_LOGIN = true;
        AppVariables.CUSTID = AppVariables.CUSTIDTEMP;
        AppVariables.CUSTNAME = AppVariables.CUSTNAMETEMP;
        AppVariables.CUSTTEL = AppVariables.CUSTTELTEMP;
        AppVariables.MEMBERID = AppVariables.MEMBERIDTEMP;
        AppVariables.CUSTTHAIID = AppVariables.CUSTTHAIIDTEMP;
        _SaveLogin();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
            (Route<dynamic> route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('รหัสผ่านไม่ถูกต้อง')),
        );
      }
    }
  }

  void _SaveLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(AppConstant.IS_LOGIN_PREF, AppVariables.IS_LOGIN);
    prefs.setString(AppConstant.CUSTID_PREF, AppVariables.CUSTID);
    prefs.setString(AppConstant.CUSTNAME_PREF, AppVariables.CUSTNAME);
    prefs.setString(AppConstant.CUSTTEL_PREF, AppVariables.CUSTTEL);

    AppConstant.savePayerId(AppVariables.CUSTTEL);

    prefs.setString(AppConstant.MEMBERID_PREF, AppVariables.MEMBERID);
    prefs.setString(AppConstant.CUSTTHAIID_PREF, AppVariables.CUSTTHAIID);

    // Constant.savePayerId(Constant.CUSTTEL);
  }

  // ฟังก์ชันสำหรับเปิดช่องลืมรหัสผ่าน
  void _forgotPassword() {
    setState(() {
      _showForgotPasswordFields = true;
    });
  }

  // ฟังก์ชันสำหรับเปลี่ยนรหัสผ่าน
  Future<void> _resetPassword() async {
    final idCard = _idCardController.text;
    final newPassword = _newPasswordController.text;

    if (idCard == AppVariables.CUSTTHAIIDTEMP) {
      if (newPassword.length == 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เปลี่ยนรหัสผ่านสำเร็จ!')),
        );
        // Logic สำหรับบันทึกรหัสผ่านใหม่ (API call หรืออื่นๆ)
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'serverId': AppVariables.ServerId,
          'customerId': AppVariables.CustomerId
        };
        final url =
            "${AppVariables.API}/customer/resetpassword?searchCustTel=${AppVariables.CUSTTELTEMP}&searchCustThaiId=${AppVariables.CUSTTHAIIDTEMP}&searchMobileAppPassword=${newPassword}";
        final response = await http.put(Uri.parse(url), headers: requestHeaders);
        print(url);
        if (response.statusCode == 204) {
          print("Reset Password");
          AppVariables.IS_LOGIN = true;
          AppVariables.CUSTID = AppVariables.CUSTIDTEMP;
          AppVariables.CUSTNAME = AppVariables.CUSTNAMETEMP;
          AppVariables.CUSTTEL = AppVariables.CUSTTELTEMP;
          AppVariables.MEMBERID = AppVariables.MEMBERIDTEMP;
          AppVariables.CUSTTHAIID = AppVariables.CUSTTHAIIDTEMP;
          _SaveLogin();

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
              (Route<dynamic> route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ไม่สามารถเปลี่ยนรหัสผ่านได้ กรุณาลองใหม่อีกครั้ง')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('รหัสผ่านใหม่ต้องมี 6 หลัก')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เลขบัตรประชาชนไม่ถูกต้อง')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // ปิดคีย์บอร์ดเมื่อกดนอก TextField
        FocusScope.of(context).unfocus();
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg-home.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.black45,
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
            title: Text('เข้าสู่ระบบ',
                style: TextStyle(
                  color:  Color(0xFFFFC107),
                  fontSize: 26,
                )),
            iconTheme: IconThemeData(
              color:  Color(0xFFFFC107),
            ),
            backgroundColor: Colors.black54,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ช่องกรอกหมายเลขโทรศัพท์
                  TextFormField(
                    style: TextStyle(fontSize: 26, color: Color(0xFFFFC107)),
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      labelText: 'หมายเลขโทรศัพท์',
                      labelStyle: TextStyle(fontSize: 26, color: Color(0xFFFFC107)),
                      border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFFFC107), width: 2.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFFC107),
                          width: 2.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกหมายเลขโทรศัพท์';
                      } else if (value.length != 10) {
                        return 'หมายเลขโทรศัพท์ต้องมี 10 หลัก';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  // ปุ่มตรวจสอบหมายเลขโทรศัพท์
                  ElevatedButton(
                    onPressed: _checkPhoneNumber,
                    child: Text(
                      'ตรวจสอบการลงทะเบียน',
                      style: TextStyle(color: Colors.red, fontSize: 26),
                    ),
                  ),
                  SizedBox(height: 10),
                  // แสดงผลลัพธ์การตรวจสอบ
                  if (_isPhoneNumberRegistered)
                    Text(
                      'หมายเลขโทรศัพท์นี้ลงทะเบียนแล้ว',
                      style: TextStyle(color: Colors.green, fontSize: 26),
                    )
                  else if (_phoneController.text.length > 0)
                    Text(
                      'หมายเลขโทรศัพท์นี้ยังไม่ได้ลงทะเบียน',
                      style: TextStyle(color: Colors.red, fontSize: 26),
                    ),
                  SizedBox(height: 20),
                  // ช่องใส่รหัสผ่าน จะปรากฏเมื่อหมายเลขโทรศัพท์ถูกต้อง
                  if (_showPasswordField && !_showForgotPasswordFields)
                    Column(
                      children: [
                        TextFormField(
                          style: TextStyle(fontSize: 26, color: Color(0xFFFFC107)),
                          controller: _passwordController,
                          keyboardType: TextInputType.number,
                          obscureText: true,

                          maxLength: 6, //  จำกัดความยาวรหัสผ่านเป็น 6 หลัก
                          decoration: InputDecoration(
                            labelText: 'รหัสผ่าน (6 หลัก)',
                            labelStyle: TextStyle(fontSize: 26, color: Color(0xFFFFC107)),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFFFC107), width: 2.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFFC107),
                                width: 2.0,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกรหัสผ่าน';
                            } else if (value.length != 6) {
                              return 'รหัสผ่านต้องมี 6 หลัก';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        // ปุ่มเข้าสู่ระบบ
                        ElevatedButton(
                          onPressed: _login,
                          child: Text(
                            'เข้าสู่ระบบ',
                            style: TextStyle(color: Colors.red, fontSize: 26),
                          ),
                        ),
                        SizedBox(height: 10),
                        // ปุ่มลืมรหัสผ่าน
                        TextButton(
                          onPressed: _forgotPassword,
                          child: Text(
                            'ตั้งรหัสใหม่/ลืมรหัสผ่าน?',
                            style: TextStyle(color: Color(0xFFFFC107), fontSize: 26),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 20),
                  // ช่องสำหรับการลืมรหัสผ่าน (เมื่อกดปุ่มลืมรหัสผ่าน)
                  if (_showForgotPasswordFields)
                    Column(
                      children: [
                        // ช่องกรอกเลขบัตรประชาชน
                        TextFormField(
                          style: TextStyle(fontSize: 26, color: Color(0xFFFFC107)),
                          controller: _idCardController,
                          keyboardType: TextInputType.number,
                          maxLength: 13,
                          decoration: InputDecoration(
                            labelText: 'หมายเลขบัตรประชาชน',
                            labelStyle: TextStyle(fontSize: 26, color: Color(0xFFFFC107)),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFFFC107), width: 2.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFFC107),
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // ช่องกรอกรหัสผ่านใหม่
                        TextFormField(
                          style: TextStyle(fontSize: 26, color: Color(0xFFFFC107)),
                          controller: _newPasswordController,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          maxLength: 6,
                          decoration: InputDecoration(
                            labelText: 'รหัสผ่านใหม่ (6 หลัก)',
                            labelStyle: TextStyle(fontSize: 26, color: Color(0xFFFFC107)),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFFFC107), width: 2.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFFC107),
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // ปุ่มยืนยันการเปลี่ยนรหัสผ่าน
                        ElevatedButton(
                          onPressed: _resetPassword,
                          child: Text('ยืนยันการเปลี่ยนรหัสผ่าน', style: TextStyle(color: Color(0xFFFFC107), fontSize: 26)),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
