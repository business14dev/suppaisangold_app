import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:suppaisangold_app/src/my_app.dart';
import 'package:suppaisangold_app/src/utils/appconstants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD2YSFjMceEYVoj4xvcYxZWq0CAE2JqIk0",
        authDomain: "gs-suppaisan.firebaseapp.com",
        projectId: "gs-suppaisan",
        storageBucket: "gs-suppaisan.firebasestorage.app",
        messagingSenderId: "36247841784",
        appId: "1:36247841784:web:1ec329240e0c52a684c40d",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

//Remove this method to stop OneSignal Debugging
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize(AppConstant.OneSignalAppId);

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);

  runApp(const MyApp());
}
