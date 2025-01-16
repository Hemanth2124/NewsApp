// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCHgZa-zfqLscOOWFVIzDLmQJ0otQAEAiY',
    appId: '1:282822831576:web:a94565c17ea9a988e356ad',
    messagingSenderId: '282822831576',
    projectId: 'firstapp-adc8b',
    authDomain: 'firstapp-adc8b.firebaseapp.com',
    storageBucket: 'firstapp-adc8b.firebasestorage.app',
    measurementId: 'G-GNFG21BJ4D',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCNp3YTpSemoD5_W6G36JG1x1I3VdZNJ10',
    appId: '1:282822831576:android:946826e068fcbdfae356ad',
    messagingSenderId: '282822831576',
    projectId: 'firstapp-adc8b',
    storageBucket: 'firstapp-adc8b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOhFuwA95ex2q6cZ3U7PZD_TpGmRl5xWA',
    appId: '1:282822831576:ios:6368dc436894b678e356ad',
    messagingSenderId: '282822831576',
    projectId: 'firstapp-adc8b',
    storageBucket: 'firstapp-adc8b.firebasestorage.app',
    iosClientId: '282822831576-mfvkhjru14cufnlfr2pngnmdif31o14l.apps.googleusercontent.com',
    iosBundleId: 'com.example.firstapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBOhFuwA95ex2q6cZ3U7PZD_TpGmRl5xWA',
    appId: '1:282822831576:ios:6368dc436894b678e356ad',
    messagingSenderId: '282822831576',
    projectId: 'firstapp-adc8b',
    storageBucket: 'firstapp-adc8b.firebasestorage.app',
    iosClientId: '282822831576-mfvkhjru14cufnlfr2pngnmdif31o14l.apps.googleusercontent.com',
    iosBundleId: 'com.example.firstapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCHgZa-zfqLscOOWFVIzDLmQJ0otQAEAiY',
    appId: '1:282822831576:web:55a3466a39ecb555e356ad',
    messagingSenderId: '282822831576',
    projectId: 'firstapp-adc8b',
    authDomain: 'firstapp-adc8b.firebaseapp.com',
    storageBucket: 'firstapp-adc8b.firebasestorage.app',
    measurementId: 'G-0M0TW5HQWY',
  );
}
