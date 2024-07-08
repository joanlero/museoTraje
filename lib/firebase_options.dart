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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCwPVAudUwgDSizeB3tqjunAlAo6RrNOkw',
    appId: '1:219069524146:web:6f13e1a56f23e7424e41ab',
    messagingSenderId: '219069524146',
    projectId: 'museotrajebogota-c16bf',
    authDomain: 'museotrajebogota-c16bf.firebaseapp.com',
    storageBucket: 'museotrajebogota-c16bf.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB3djkKbYwIQdp59WlFlYy30EYOnETzbOg',
    appId: '1:219069524146:android:927e22d31c84bb944e41ab',
    messagingSenderId: '219069524146',
    projectId: 'museotrajebogota-c16bf',
    storageBucket: 'museotrajebogota-c16bf.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAsXnatMXZoIl7jts7DvaeRpb-Itj89agI',
    appId: '1:219069524146:ios:519c28eef7d051ad4e41ab',
    messagingSenderId: '219069524146',
    projectId: 'museotrajebogota-c16bf',
    storageBucket: 'museotrajebogota-c16bf.appspot.com',
    androidClientId: '219069524146-ihf79n9bn380m6fqkpohcghgc5utfovt.apps.googleusercontent.com',
    iosClientId: '219069524146-57oel7616f7ra2tqjjb438316be0asu4.apps.googleusercontent.com',
    iosBundleId: 'com.adminmuseo.adminmuseo',
  );
}
