import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyA-hlFumuzvnWgsInqZLWanNVpBWiCbgp4',
    appId: '1:14606244615:web:f50b4f0d70e692b7fc43a2',
    messagingSenderId: '14606244615',
    projectId: 'my-dream-connect-ee670',
    authDomain: 'my-dream-connect-ee670.firebaseapp.com',
    storageBucket: 'my-dream-connect-ee670.firebasestorage.app',
    measurementId: 'G-P373V061GJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDummy-Key-For-Testing-Replace-With-Real',
    appId: '1:123456789:android:dummy-app-id',
    messagingSenderId: '123456789',
    projectId: 'my-dream-connect-ee670',
    storageBucket: 'my-dream-connect-ee670.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDummy-Key-For-Testing-Replace-With-Real',
    appId: '1:123456789:ios:dummy-app-id',
    messagingSenderId: '123456789',
    projectId: 'my-dream-connect-ee670',
    storageBucket: 'my-dream-connect-ee670.appspot.com',
    iosBundleId: 'com.example.mdcAdmin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDummy-Key-For-Testing-Replace-With-Real',
    appId: '1:123456789:ios:dummy-app-id',
    messagingSenderId: '123456789',
    projectId: 'my-dream-connect-ee670',
    storageBucket: 'my-dream-connect-ee670.appspot.com',
    iosBundleId: 'com.example.mdcAdmin',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA-hlFumuzvnWgsInqZLWanNVpBWiCbgp4',
    appId: '1:14606244615:web:f50b4f0d70e692b7fc43a2',
    messagingSenderId: '14606244615',
    projectId: 'my-dream-connect-ee670',
    authDomain: 'my-dream-connect-ee670.firebaseapp.com',
    storageBucket: 'my-dream-connect-ee670.firebasestorage.app',
    measurementId: 'G-P373V061GJ',
  );
}