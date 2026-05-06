import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAbUudw83mIXX4wILk-p1OdZCvrmMK_YUM',
    appId: '1:1074842337903:web:b3b1f4842fa3241733839a',
    messagingSenderId: '1074842337903',
    projectId: 'verifi-poc-hackathon',
    authDomain: 'verifi-poc-hackathon.firebaseapp.com',
    storageBucket: 'verifi-poc-hackathon.firebasestorage.app',
    measurementId: 'G-5EMDESZ9KY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCKmtqBOvllBOcSQZddlxwOeS3yf82O3-s',
    appId: '1:1074842337903:android:cbbd15ec78866a5f33839a',
    messagingSenderId: '1074842337903',
    projectId: 'verifi-poc-hackathon',
    storageBucket: 'verifi-poc-hackathon.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFBBbkawYZKzSB6aIOF-tJsoqW_gLMpTw',
    appId: '1:1074842337903:ios:8087489790f25d2a33839a',
    messagingSenderId: '1074842337903',
    projectId: 'verifi-poc-hackathon',
    storageBucket: 'verifi-poc-hackathon.firebasestorage.app',
    iosBundleId: 'com.example.verifi',
  );

}