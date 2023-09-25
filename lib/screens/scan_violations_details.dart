import 'package:car_app/helpers/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'scan_upload_violation_image.dart';

class ScanViolationsDetails extends StatefulWidget {
  static const String route = '/postal';

  const ScanViolationsDetails({Key? key}) : super(key: key);

  @override
  State<ScanViolationsDetails> createState() => _ViolationsDetailsState();
}

class _ViolationsDetailsState extends State<ScanViolationsDetails> {
  TextEditingController reasonController = TextEditingController();
  TextEditingController violationNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController pnidController = TextEditingController();

  @override
  void dispose() {
    reasonController.dispose();
    violationNumberController.dispose();
    pnidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32),
              Text(
                'K.S nr',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: violationNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  // for below version 2 use this
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                  FilteringTextInputFormatter.digitsOnly

                ],
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Vennligst skriv inn noe";
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Nr',
                  hintText: 'K.S nr',
                  border: OutlineInputBorder(),
                  fillColor: ThemeHelper.buttonPrimaryColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Pnid',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: pnidController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  // for below version 2 use this
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                  FilteringTextInputFormatter.digitsOnly

                ],
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Vennligst skriv inn noe";
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Pnid',
                  hintText: 'Pnid',
                  border: OutlineInputBorder(),
                  fillColor: ThemeHelper.buttonPrimaryColor,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Grunnen',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: reasonController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Vennligst skriv inn noe";
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Grunnen',
                  hintText: 'Grunnen',
                  border: OutlineInputBorder(),
                  fillColor: ThemeHelper.buttonPrimaryColor,
                ),
              ),
              SizedBox(height: 20,),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle the "Next" button click
                    String reason = reasonController.text;
                    String number = violationNumberController.text;
                    String pnid = pnidController.text;

                    if(_formKey.currentState!.validate()){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return ScanUploadViolationImage(
                              pnid: pnid,
                              number: number,
                              reason: reason,
                            );
                          },
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOut,
                                ),
                              ),
                              child: child,
                            );
                          },
                          transitionDuration: Duration(seconds: 1),
                        ),
                      );
                    }else{
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          title: Text('Feil'),
                          content: Text('Skriv inn nødvendige data først'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK',style: TextStyle(
                                  color: ThemeHelper.buttonPrimaryColor
                              ),),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: ThemeHelper.buttonPrimaryColor, // Button background color
                    minimumSize: Size(140,0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Neste',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

