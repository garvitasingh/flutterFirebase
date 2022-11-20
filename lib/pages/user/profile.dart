import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../login.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  User? user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final email = FirebaseAuth.instance.currentUser!.email;
  final name = FirebaseAuth.instance.currentUser!.displayName;
  var snapshot = FirebaseFirestore.instance.collection('Data');
  CollectionReference users = FirebaseFirestore.instance.collection('Data');

  verifyEmail() async {
    if (user! != null && !user!.emailVerified) {
      await user!.sendEmailVerification();
      print('Verification Email has been sent');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Check email for Verification',
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("fff ${users.doc(uid).get()}");
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: [
          const Spacer(),
          Text("Your detail here"),
          FutureBuilder<DocumentSnapshot>(
              future: users.doc(uid).get(),
              builder: (context, snapshot) {
                final docs = snapshot.data!;
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container(
                  child: Column(
                    children: [
                      Text("Name : ${docs['Name']}"),
                      Text("Age : ${docs['Age'].toString()}"),
                      Text("Address : ${docs['Address'].toString()}"),
                      Text("Other Details : ${docs['Other Details'].toString()}"),
                      Text("Phone Number : ${docs['Phone number']}"),
                    ],
                  ),
                );
                //   ListTile(
                //   title: Text(docs['Name']),
                //   trailing: Text(docs['Phone number']),
                //   leading: Text(docs['Age'].toString()),
                // );
              }),
          SizedBox(height: 30,),
          Text(
            "Hello  ${user!.displayName}",
            style: const TextStyle(fontSize: 18.0),
          ),
          const SizedBox(
            height: 10,
          ),
          user!.email != null
              ? user!.emailVerified
                  ? const Text(
                      'Email verified',
                      style: TextStyle(fontSize: 18.0, color: Colors.blueGrey),
                    )
                  : TextButton(
                      onPressed: () => {verifyEmail()},
                      child: const Text('Click here to Verify Email'))
              : const Text('Logged in with mobile number'),
          // Text(
          //   'Created on: $creationTime',
          //   style: TextStyle(fontSize: 18.0),
          // ),
          const Spacer(),
          ElevatedButton(
            onPressed: () async => {
              await FirebaseAuth.instance.signOut(),
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                  (route) => false)
            },
            child: const Text('LogOut'),
            style: ElevatedButton.styleFrom(
              primary: Colors.deepPurple.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27)),
            ),
          ),
          const Spacer(),
          ElevatedButton(
              onPressed: () async {
                await user!.delete();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                        (route) => false);
              },
              child: const Text('Delete User')),
        ],
      ),
    );
  }
}
