import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _formKey = GlobalKey<FormState>();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final detailController = TextEditingController();
  final nameController = TextEditingController();
  int _currentIntValue = 20;
  var date = DateTime.now();
  User? user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ListView(
            children: [
              Container(
                height: 120.0,
                width: 50.0,
                decoration: BoxDecoration(
                  image:
                      DecorationImage(image: NetworkImage("${user!.photoURL}")),
                  shape: BoxShape.rectangle,
                ),
              ),
              Text(
                "Name : ${user!.displayName}",
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Email: ${user!.email}',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(
                height: 50,
              ),
              Text("PLEASE ADD/UPDATE YOUR DETAIL"),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: 'Name: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                    TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Name';
                    }
                    return null;
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: 'Address: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: addressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Address';
                    }
                    return null;
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Phone number: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Phone number';
                    }
                    return null;
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Other Details: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: detailController,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("AGE : "),
                  NumberPicker(
                    value: _currentIntValue,
                    minValue: 0,
                    maxValue: 100,
                    step: 1,
                    haptics: true,
                    onChanged: (value) =>
                        setState(() => _currentIntValue = value),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        FirebaseFirestore.instance
                            .collection('Data')
                            .doc(uid)
                            .set({
                          'Name': nameController.text,
                          'Address': addressController.text,
                          'Phone number': phoneController.text,
                          'Other Details': detailController.text,
                          'Age': _currentIntValue,
                          // 'Date' : date.toString()
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.orangeAccent,
                              content: Text(
                                "Details Updated",
                                style: TextStyle(fontSize: 18.0, color: Colors.black),
                              ),
                            ));
                      }
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
