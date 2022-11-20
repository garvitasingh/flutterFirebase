import 'package:firebase/pages/user/user_main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  OTPScreen(this.phone);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  var _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  User? user;
  String verificationID = "";
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify +91 ${widget.phone}'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Center(
              child: Text(
                'Enter OTP',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Pinput(
              length: 6,
              controller: _pinPutController,
              pinAnimationType: PinAnimationType.fade,
              onCompleted: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: _verificationCode, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => UserMain(),),
                          (route) => false);
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  const SnackBar(
                    backgroundColor: Colors.orangeAccent,
                    content: Text(
                      "Invalid OTP",
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 40,),
          Container(
            alignment: Alignment.center,
            child: const Text("Please wait for auto-verification of OTP"),
          )
        ],
      ),
    );
  }

  Future<void> _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => UserMain()),
                  (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
          const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Verification Failed",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: const Duration(seconds: 120),
        codeSent: (String verificationId, int? forceResendingToken) {
          setState(() {
            _verificationCode = verificationId;
          });
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
}
