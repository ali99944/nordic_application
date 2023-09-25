import 'package:car_app/screens/accident_question.dart';
import 'package:car_app/screens/shift_selection%20screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/theme_helper.dart';
import '../services/data_service.dart';

class KilometerScreen extends StatelessWidget {
  final String selectedCarNumber;
  final String selectedPrivateNumber;
  final String carId;

  KilometerScreen({
    Key? key,
    required this.selectedCarNumber,
    required this.selectedPrivateNumber, required this.carId,
  }) : super(key: key);

  final TextEditingController _kilometerController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Positioned(
              child: Image.asset('assets/bil.png',width: 100,height: 100,),
              top: 10,
              left: 10,
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Servicekilometer',style: TextStyle(
                    fontSize: 24
                  ),),
                  SizedBox(height: 12.0,),
                  FutureBuilder(
                    future: DataService.getInformationData(part: 'kilometer'),
                    builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(
                          child: Container(),
                        );
                      }

                      if(snapshot.hasError){
                        return Center(
                          child: Text('Something Went Wrong'),
                        );
                      }

                      if(snapshot.data != null){
                        return Container(
                          child: Text(
                            '${snapshot.data}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Birco', // Replace with your custom font's name
                              letterSpacing: 1.2,
                            ),
                          ),
                        );
                      }

                      return Container();
                    },
                  ),
                  SizedBox(height: 12.0,),
                  TextFormField(
                    controller: _kilometerController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return "Skriv inn noe først";
                        }
                      }
                      return null;
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Angi kilometer",
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) {
                                  return ShiftChoiceScreen(
                                    selectedCarNumber: selectedCarNumber,
                                    selectedPrivateNumber: selectedPrivateNumber,
                                    carId:carId,
                                    kilometers: int.parse(_kilometerController.text),
                                  );;
                                },
                                transitionsBuilder:
                                    (context, animation, secondaryAnimation, child) {
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
                          }
                        },
                        icon: Icon(Icons.arrow_forward),
                        label: Text('Sende inn',style: TextStyle(
                          color: Colors.white
                        ),),
                        style: ElevatedButton.styleFrom(
                          primary: ThemeHelper.buttonPrimaryColor,
                          textStyle: TextStyle(
                              fontSize: 20
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(width: 12,),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return ShiftChoiceScreen(
                                  selectedCarNumber: selectedCarNumber,
                                  selectedPrivateNumber: selectedPrivateNumber,
                                  carId:carId,
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
                        },
                        icon: Icon(Icons.skip_next),
                        label: Text('Hopp over',style: TextStyle(
                          color: Colors.white
                        ),),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          textStyle: TextStyle(
                            fontSize: 20
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

