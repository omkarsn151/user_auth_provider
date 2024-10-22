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
    apiKey: 'AIzaSyAmHWXHnMCroUmECUP7-8CTkG9IocNKkWI',
    appId: '1:891984243237:web:a5311edb5dd3084615adcc',
    messagingSenderId: '891984243237',
    projectId: 'login-pro-e9770',
    authDomain: 'login-pro-e9770.firebaseapp.com',
    storageBucket: 'login-pro-e9770.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDRs4MmXk_otPy1EkVgmz95LyCCoAqrxQY',
    appId: '1:891984243237:android:87720bebad79db3215adcc',
    messagingSenderId: '891984243237',
    projectId: 'login-pro-e9770',
    storageBucket: 'login-pro-e9770.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBISJ1Mx1o_rkxBHXBYiQdl9oq4tZlv5sc',
    appId: '1:891984243237:ios:4bee5c19b55dc54915adcc',
    messagingSenderId: '891984243237',
    projectId: 'login-pro-e9770',
    storageBucket: 'login-pro-e9770.appspot.com',
    iosBundleId: 'com.example.loginPro',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBISJ1Mx1o_rkxBHXBYiQdl9oq4tZlv5sc',
    appId: '1:891984243237:ios:4bee5c19b55dc54915adcc',
    messagingSenderId: '891984243237',
    projectId: 'login-pro-e9770',
    storageBucket: 'login-pro-e9770.appspot.com',
    iosBundleId: 'com.example.loginPro',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAmHWXHnMCroUmECUP7-8CTkG9IocNKkWI',
    appId: '1:891984243237:web:a64479ab96b9e36815adcc',
    messagingSenderId: '891984243237',
    projectId: 'login-pro-e9770',
    authDomain: 'login-pro-e9770.firebaseapp.com',
    storageBucket: 'login-pro-e9770.appspot.com',
  );
}