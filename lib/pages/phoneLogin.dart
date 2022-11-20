
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'otp.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({Key? key}) : super(key: key);

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login with phone number"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 50, left: 50),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Phone Number',
                prefix: Padding(
                  padding: EdgeInsets.all(4),
                  child: Text('+91'),
                ),
              ),
              maxLength: 10,
              keyboardType: TextInputType.number,
              controller: _controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Phone number';
                }
                return null;
              },
            ),
          ),
      Container(
        margin: const EdgeInsets.only(top: 40, right: 100, left: 100),
        width: double.infinity,
        child: ElevatedButton(
          // color: Colors.blue,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OTPScreen(_controller.text)));
          },
          child: const Text(
            'Next',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),

        ],
      ),
    );
  }
}
