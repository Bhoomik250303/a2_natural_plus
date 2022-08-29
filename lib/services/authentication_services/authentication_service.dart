import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart';
import 'package:a2_natural/services/database_services/database_service.dart';
import 'package:a2_natural/services/location_services.dart';

String? verificationID;
int? resendToken;

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSign = GoogleSignIn();

  Future signingInAnonymously() async {
    try {
      UserCredential userCred = await _auth.signInAnonymously();
      String userUid = userCred.user!.uid;
      print(userUid);
    } catch (e) {
      print(
          'signing Anonymously failed due to the exception : ${e.toString()}');
      return null;
    }
  }

  Future googleSignIn(LocationData location) async {
    try {
      GoogleSignInAccount? googleAccount = await googleSign.signIn();
      if (googleAccount != null) {
        GoogleSignInAuthentication? googleAuth =
            await googleAccount.authentication;
        final OAuthCredential? userCredential = GoogleAuthProvider?.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        var userCred;
        if (userCredential != null) {
          userCred = await _auth.signInWithCredential(userCredential);
        } else {
          Fluttertoast.showToast(msg: 'Login Failed, Try Again.');
          return null;
        }
        bool? isNew = userCred.additionalUserInfo?.isNewUser;
        String name = userCred.user?.displayName;
        print(isNew);
        // Fluttertoast.showToast(msg : '${isNew}');
        if (isNew!) {
          await DatabaseServices(uid: userCred.user?.uid)
              .setUserData(location, userCred.user?.email, "", name);
        }
        // Fluttertoast.showToast(msg: location.toString());

        return userCred;
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: 'Error code ${e.toString()}');
    }
  }

  Future mobilePhoneSetup(String phone) async {
    try {
      return await _auth.verifyPhoneNumber(
          phoneNumber: '+91' + phone,
          timeout: Duration(seconds: 30),
          forceResendingToken: resendToken,
          verificationCompleted: (AuthCredential authCred) {},
          verificationFailed: (FirebaseAuthException exception) {
            print(exception);
          },
          codeSent: (String vID, int? forceResendingToken) {
            verificationID = vID;
            Fluttertoast.showToast(msg: 'code sent');
          },
          codeAutoRetrievalTimeout: (String vID) {
            verificationID = vID;
          });
    } catch (e) {
      print(e.toString());
    }
  }

  Future mobilePhoneSignIn(String smsCode, LocationData location) async {
    try {
      var userCred;
      if (verificationID != null) {
        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
            verificationId: verificationID!, smsCode: smsCode);

        userCred = await _auth.signInWithCredential(phoneAuthCredential);
        bool? isNew = userCred.additionalUserInfo?.isNewUser;
        if (isNew!) {
          DatabaseServices(uid: userCred.user?.uid)
              .setUserData(location, "", userCred.user?.phoneNumber, "");
        } else {
          Fluttertoast.showToast(msg: 'verification is still null');
        }
      } else {
        Fluttertoast.showToast(msg: 'error');
      }
      return userCred;
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOutGoogle() async {
    await googleSign.disconnect();
    await _auth.signOut();
  }

  Future signOutMobile() async {
    await _auth.signOut();
  }

  Future registerWithEmailAndPin(String email, String pin) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: pin);
      print(userCredential.user?.uid);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future loginWithEmailAndPin(String email, String pin) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: pin);
      print(userCredential.user?.uid);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signingOutGoogle() async {
    try {
      await _auth.signOut();
      await googleSign.signOut();
    } catch (e) {
      print('signing-out failed due to the exception : ${e.toString()}');
      null;
    }
  }

  Stream<User?> get userLoginStream {
    return _auth.authStateChanges();
  }
}
