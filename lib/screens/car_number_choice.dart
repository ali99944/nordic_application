import 'dart:ui';

import 'package:car_app/helpers/theme_helper.dart';
import 'package:car_app/screens/MainScreen.dart';
import 'package:car_app/screens/kilometers.dart';
import 'package:car_app/screens/qrcode_scanner.dart';
import 'package:car_app/screens/shift_selection%20screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'info_dialog.dart';

class CarNumberChoiceScreen extends StatefulWidget {
  static const String route = '/cars';

  @override
  _CarNumberChoiceScreenState createState() => _CarNumberChoiceScreenState();
}

class _CarNumberChoiceScreenState extends State<CarNumberChoiceScreen> {
  List<dynamic> carDataList = [];

  bool _isToggled = false;
  bool _isInfoToggled = false;

  @override
  void initState() {
    super.initState();
    // Fetch car data from the API when the screen is initialized
    getCarData();
  }

  Future<void> getCarData() async {
    try {
      // Replace 'https://test.bilsjekk.in/api/cars' with your API endpoint
      var response = await http.get(Uri.parse('https://test.bilsjekk.in/api/cars'));
      if (response.statusCode == 200) {
        // Parse the response body and update the carDataList
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          carDataList = data;
        });
      } else {
        // Handle the error if the API call fails
        print('Failed to fetch car data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred while fetching car data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(
              context: context,
              barrierColor: Colors.black.withOpacity(0.7),
              barrierDismissible: false,
              builder: (context) => BackdropFilter(
                child: InfoDialog(part: 'car',),
                filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              ), // Show the custom info dialog
            );
          },
          shape: CircleBorder(),
          child: Icon(Icons.info_outline,size: 30,color: Colors.black,),
          backgroundColor: Colors.amber,
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        body: Stack(
          children: [
            Container(
              child: Padding(
                padding: _isToggled ?  EdgeInsets.all(0) : EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _isToggled ? QrCodeScanner() : RefreshIndicator(
                        onRefresh: () async{
                          setState(() {

                          });
                        },
                        child: ListView.builder(
                          itemCount: carDataList.length + 1,
                          itemBuilder: (context, index) {
                            if(index == carDataList.length)
                              return SizedBox(height: 70,);
                            return buildCarCard(carDataList[index], context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    _isToggled = !_isToggled;
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(70)
                  ),
                  alignment: Alignment.center,
                  height: 60,
                  width: 60,
                  padding: EdgeInsets.all(12.0),
                  child: Icon(_isToggled ? Icons.car_repair : Icons.qr_code,size: 30,color: Colors.black,),
                ),
              ),
            )
          ],
        ),


      ),
    );
  }

  Widget buildCarCard(Map<String, dynamic> carData, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return KilometerScreen(
                selectedCarNumber: carData['boardNumber'],
                selectedPrivateNumber: carData['privateNumber'],
                carId:carData['_id']
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
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: ThemeHelper.buttonPrimaryColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5.0,
              spreadRadius: 1.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bilnummer',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      carData['boardNumber']!,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color:  Colors.white),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tjeneste',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      carData['privateNumber']!,
                      style: TextStyle(fontSize: 14,color: Colors.white),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward,
                  color: ThemeHelper.buttonPrimaryColor,
                  size: 24,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(carData['kilometers'] != null)
                Text("Kilometers: ${carData['kilometers'].toString()}",style: TextStyle(
                  color: Colors.white
                ),),

                if(carData['kilometers'] != null)
                Text("drevet: ${carData['currentKilometers'].toString()}",style: TextStyle(
                    color: Colors.white
                ),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
