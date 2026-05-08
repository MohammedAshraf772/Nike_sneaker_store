import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.

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
    apiKey: 'AIzaSyDVPOrK3y9EWfTjivjWRpgmoYF92ydbJC4',
    appId: '1:562972037674:web:72580cbcd8e8838dc92953',
    messagingSenderId: '562972037674',
    projectId: 'nike-82365',
    authDomain: 'nike-82365.firebaseapp.com',
    storageBucket: 'nike-82365.firebasestorage.app',
    measurementId: 'G-ZG3QR61GL0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAf0ek41acJNHbIiCsOLmZf4MMCZl9IgMw',
    appId: '1:562972037674:android:6372797a21fdd399c92953',
    messagingSenderId: '562972037674',
    projectId: 'nike-82365',
    storageBucket: 'nike-82365.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCogIL0ETsnjIkZI4Kbny08BjIFMjhAwPU',
    appId: '1:562972037674:ios:321532dab719d387c92953',
    messagingSenderId: '562972037674',
    projectId: 'nike-82365',
    storageBucket: 'nike-82365.firebasestorage.app',
    iosBundleId: 'com.example.nikeSneakerStore',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCogIL0ETsnjIkZI4Kbny08BjIFMjhAwPU',
    appId: '1:562972037674:ios:321532dab719d387c92953',
    messagingSenderId: '562972037674',
    projectId: 'nike-82365',
    storageBucket: 'nike-82365.firebasestorage.app',
    iosBundleId: 'com.example.nikeSneakerStore',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDVPOrK3y9EWfTjivjWRpgmoYF92ydbJC4',
    appId: '1:562972037674:web:c25be093a42d9190c92953',
    messagingSenderId: '562972037674',
    projectId: 'nike-82365',
    authDomain: 'nike-82365.firebaseapp.com',
    storageBucket: 'nike-82365.firebasestorage.app',
    measurementId: 'G-SJD4MCXLMM',
  );
}
