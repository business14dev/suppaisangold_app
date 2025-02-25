import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:suppaisangold_app/src/utils/appconstants.dart';

class ContactPage extends StatelessWidget {
  final List<Map<String, dynamic>> branches = [
    {
      'name': 'สาขาทรายขาว',
      'numbers': ['086-4741355'],
      'openHours': '8.30-17.30 น.',
      'Stop':'หยุดทุกวันวันอาทิตย์'
    },
    {
      'name': 'สาขาคลองพน',
      'numbers': ['086-4743392'],
      'openHours': '8.30-17.30 น.',
      'Stop':'หยุดทุกวันวันอาทิตย์'
    },
    {
      'name': 'สาขาคลองท่อม',
      'numbers': ['0864739922'],
      'openHours': '8.30-17.30 น.',
      'Stop':'หยุดทุกวันวันอาทิตย์'
    },
    {
      'name': 'สาขาเหนือคลอง',
      'numbers': ['086-4741234'],
      'openHours': '8.30-17.30 น.',
      'Stop':'หยุดทุกวันวันอาทิตย์'
    },
    {
      'name': 'สาขาต้นทวย',
      'numbers': ['086-4741341'],
      'openHours': '8.30-17.30 น.',
      'Stop':'หยุดทุกวันวันอาทิตย์'
    },
    {
      'name': 'สาขาคลองหิน',
      'numbers': ['086-4741356'],
      'openHours': '8.30-17.30 น.',
      'Stop':'หยุดทุกวันวันอาทิตย์'
    },
    //-------------------
    {
      'name': 'สาขาเขาต่อ',
      'numbers': ['086-4741156'],
      'openHours': '8.30-17.30 น.',
      'Stop':'หยุดทุกวันวันอาทิตย์'
    },
    {
      'name': 'สาขาหนองทะเล',
      'numbers': ['086-4741354'],
      'openHours': '8.30-17.30 น.',
      'Stop':'หยุดทุกวันวันอาทิตย์'
    },
    {
      'name': 'สาขาคลองแห้ง',
      'numbers': ['086-4741421'],
      'openHours': '8.30-17.30 น.',
      'Stop':'หยุดทุกวันวันอาทิตย์'
    },
    {
      'name': 'สาขารัษฏา',
      'numbers': ['086-4741426'],
      'openHours': '8.30-17.30 น.',
      'Stop':'หยุดทุกวันวันอาทิตย์'
    },
    {
      'name': 'สาขาวังวิเศษ',
      'numbers': ['088-7773889'],
      'openHours': '8.30-17.30 น.',
      'Stop':'หยุดทุกวันวันอาทิตย์'
    },
    {
      'name': 'สาขาบางจาก',
      'numbers': ['086-4741343'],
      'openHours': '8.30-17.30 น.',
      'Stop':'หยุดทุกวันวันอาทิตย์'
    },
    {
      'name': 'สาขาสหไทย',
      'numbers': ['086-4741919'],
      'openHours': '8.30-17.30 น.',
      'Stop':'หยุดทุกวันวันอาทิตย์'
    },
    {
      'name': 'สาขาไทยสมบูรณ์2',
      'numbers': ['075-332747'],
      'openHours': '8.30-17.30 น.',
      'Stop':'หยุดทุกวันวันอาทิตย์'
    },
    
    // เพิ่มข้อมูลสาขาอื่นๆ ตามโครงสร้างนี้
  ];

  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print('Cannot make a phone call to $phoneNumber');
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Cannot open URL: $url');
    }
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
        backgroundColor: Colors.black12,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                   Colors.black54,
                        Colors.black45,
                        Color.fromARGB(137, 101, 99, 99),
                        Color.fromARGB(137, 101, 99, 99),
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
                "ติดต่อสาขา",
                style: TextStyle(
                  fontSize: 30,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 4
                    ..color = Colors.black, // สีขอบตัวหนังสือ
                ),
              ),
              // ตัวหนังสือสีแดง (วางทับด้านบน)
              Text(
                "ติดต่อสาขา",
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.red, // สีตัวหนังสือ
                ),
              ),
            ],
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black54,
        ),
        body: ListView.builder(
          itemCount: branches.length,
          itemBuilder: (context, index) {
            final branch = branches[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      branch['name'],
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 10),
                    ...branch['numbers'].map((number) => Row(
                          children: [
                            Icon(Icons.phone, color: Colors.blue),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => _makePhoneCall(number),
                              child: Text(
                                number,
                                style: TextStyle(
                                  fontSize: 26,
                                  color: Colors.blue,
                                  // decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        )),
                    // SizedBox(height: 10),
                    // Row(
                    //   children: [
                    //     Icon(FontAwesomeIcons.line, color: Colors.green),
                    //     SizedBox(width: 10),
                    //     GestureDetector(
                    //       onTap: () => _launchURL(branch['line']['url']),
                    //       child: Text(
                    //         branch['line']['name'],
                    //         style: TextStyle(
                    //           fontSize: 26,
                    //           color: Colors.green,
                    //           // decoration: TextDecoration.underline,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: 10),
                    // if (branch.containsKey('googleMap') && branch['googleMap'] != null)
                    //   Row(
                    //     children: [
                    //       Icon(FontAwesomeIcons.mapPin, color: Colors.red),
                    //       SizedBox(width: 10),
                    //       GestureDetector(
                    //         onTap: () => _launchURL(branch['googleMap']),
                    //         child: Text(
                    //           'Google Map',
                    //           style: TextStyle(
                    //             fontSize: 26,
                    //             color: Colors.red,
                    //             // decoration: TextDecoration.underline,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.orange),
                        SizedBox(width: 10),
                        Text(
                          'เวลา เปิด - ปิด : ${branch['openHours']}',
                          style: TextStyle(
                            fontSize: 26,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                       SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.access_time_filled_outlined, color: Colors.orange),
                        SizedBox(width: 10),
                        Text(
                         branch['Stop'],
                          style: TextStyle(
                            fontSize: 26,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ContactPage(),
  ));
}
