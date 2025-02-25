import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:suppaisangold_app/src/models/mobileappnotisent_response.dart';
import 'package:suppaisangold_app/src/search/search_notisentdate.dart';
import 'package:suppaisangold_app/src/services/app_service.dart';
import 'package:suppaisangold_app/src/utils/appvariables.dart';
import 'package:suppaisangold_app/src/utils/appconstants.dart';
import 'package:suppaisangold_app/src/utils/appcontroller.dart';
import 'package:suppaisangold_app/src/utils/appformatters.dart';

class MobileAppNotiSentPage extends StatefulWidget {
  @override
  _MobileAppNotiSentPageState createState() => _MobileAppNotiSentPageState();
}

class _MobileAppNotiSentPageState extends State<MobileAppNotiSentPage> {
  @override
  void initState() {
    super.initState();
    AppService().mobileAppNotiSentByDate();
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg-home.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.black54,
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
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "แจ้งเตือน",
                      style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          AppVariables.searchNotiDateStart = DateTime(
                              DateTime.now().year, DateTime.now().month, 1);
                          AppVariables.searchNotiDateEnd = DateTime.now();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchNotiSentDatePage()),
                          ).then((value) {
                            setState(() {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MobileAppNotiSentPage()));
                            });
                          });
                        }),
                  ],
                ),
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
                backgroundColor: Colors.black38,
              ),
              body: _buildList(appController, context),
            ),
          );
        });
  }

  Widget _buildList(AppController appController, BuildContext context) {
    return Container(
        child: appController.mobileAppNotiSents.isEmpty
            ? SizedBox(
                height: 580,
                child: Center(
                  child: Text(
                    "ไม่พบรายการแจ้งเตือน",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.PRIMARY_COLOR,
                      height: 1.5,
                    ),
                  ),
                ),
              )
            : ListView.separated(
                padding: EdgeInsets.only(bottom: 70),
                itemCount: appController.mobileAppNotiSents.length,
                itemBuilder: (context, index) {
                  return PostWidget(
                      post: appController.mobileAppNotiSents[index]);
                },
                separatorBuilder: (context, index) {
                  return Container(
                    child: _buildDivider(),
                  );
                },
              ));
  }

  _buildDivider() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [AppConstant.PRIMARY_COLOR, AppConstant.SECONDARY_COLOR],
              stops: [0.0, 1.0],
            )),
            width: MediaQuery.of(context).size.width,
            height: 2,
          ),
        ],
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final MobileAppNotiSentResponse post;

  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Container(
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  showText(post, MediaQuery.of(context).size.width)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showText(MobileAppNotiSentResponse post, double width) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: width * 1,
//   width: MediaQuery.of(context).size.width * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          ListTile(
            title: Container(
              width: width * 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(color: Colors.white)),
                    child: Icon(
                      Icons.notifications,
                      color:   Color(0xFFFFC107),
                    ),
                  ),
                  Container(
                    width: width * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(" ${post.notiTitle}",
                            style: TextStyle(
                                fontSize: 24,
                                color: AppConstant.PRIMARY_COLOR,
                                fontWeight: FontWeight.bold)),
                        Text(
                            "${AppFormatters.formatDate.format(post.notiDate!)} ${post.notiTime}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppConstant.PRIMARY_COLOR,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text("เลขที่ ${post.notiRefNo}",
                    style: TextStyle(
                        fontSize: 18,
                        color: AppConstant.PRIMARY_COLOR,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(post.notiDetail!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.PRIMARY_COLOR,
                    )),
              ],
            ),
          ),
          // SizedBox(
          //   height: 50,
          // ),
        ],
      ),
    );
  }
}
