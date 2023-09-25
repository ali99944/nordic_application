import 'dart:ui';

import 'package:car_app/helpers/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/data_service.dart';
import 'MainScreen.dart';
import 'info_dialog.dart';

class ShiftChoiceScreen extends StatefulWidget {
  final String selectedCarNumber;
  final String selectedPrivateNumber;
  int? kilometers;
  final String carId;

  ShiftChoiceScreen({required this.selectedCarNumber, required this.selectedPrivateNumber,this.kilometers, required this.carId});

  @override
  _ShiftChoiceScreenState createState() => _ShiftChoiceScreenState();
}

class _ShiftChoiceScreenState extends State<ShiftChoiceScreen> {
  String selectedDay = '';
  String selectedPeriod = '';
  List<String> selectedZones = [];
  String trafficViolations = "";
  List<Map<String, dynamic>> zones = [];
  List<String> daysOfWeek = ['Mandag', 'Tirsdag','Onsdag', 'Torsdag', 'Fredag','Lørdag', 'Søndag'];
  List<String> periods = ['Dag','Kveld','Natt'];

  List<Map<String,dynamic>> filteredZones = [];

  @override
  void initState() {
    super.initState();
    getZoneData();
  }

  Future<void> getZoneData() async {
    try {
      var response = await http.get(Uri.parse('https://test.bilsjekk.in/api/locations'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          zones = List<Map<String,dynamic>>.from(data);
        });
      } else {
        print('Failed to fetch zone data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred while fetching zone data: $error');
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                child: InfoDialog(part: 'shift',),
                filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              ), // Show the custom info dialog
            );
          },
          shape: CircleBorder(),
          child: Icon(Icons.info_outline,size:30,color: Colors.black,),
          backgroundColor: Colors.amber,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Valgt bil',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Borde: ${widget.selectedCarNumber}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 20.0,),
                      Text(
                        'Bilnummer: ${widget.selectedPrivateNumber}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  if(widget.kilometers != null)
                    SizedBox(height: 20),
                  if(widget.kilometers != null)
                    Text(
                      'Kilometers: ${widget.kilometers}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Velg ukedag',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8,),

                    ],
                  ),
                  SizedBox(height: 8),
                  buildDayOfWeekButtons(),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Velg vakt',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8,),

                    ],
                  ),
                  SizedBox(height: 8),
                  buildPeriodButtons(),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text('Velg Sted',style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold
                      ),),
                      SizedBox(width: 8,),

                    ],
                  ),
                  SizedBox(height: 12),
                  buildMultiSelectZoneDropdown(),
                  SizedBox(height: 12),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          trafficViolations = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vennligst skriv inn antall K.S.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Antall K.S',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (selectedZones.isNotEmpty &&
                          selectedDay.isNotEmpty &&
                          selectedPeriod.isNotEmpty && _formKey.currentState!.validate()) {
                        Map data = {
                          'locations': selectedZones.join(','),
                          'day': selectedDay,
                          'period': selectedPeriod,
                          'boardNumber': widget.selectedCarNumber,
                          'privateNumber': widget.selectedPrivateNumber,
                          'trafficViolations': trafficViolations,
                          'kilometers':widget.kilometers,
                          'carId':widget.carId,
                          'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())
                        };

                        SharedPreferences shared = await SharedPreferences.getInstance();
                        await shared.setString('data', jsonEncode(data));

                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return Form1Screen();
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
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Feil'),
                            content: Text('Velg minst én sone, ukedag, periode, og skriv inn antall K.S.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeHelper.buttonPrimaryColor,
                    ),
                    child: Text(
                      'Sende inn',
                      style: TextStyle(fontSize: 18,color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMultiSelectZoneDropdown() {
    // return GestureDetector(
    //   onTap: _showMultiSelectZoneOptionsDialog,
    //   child: Container(
    //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //     decoration: BoxDecoration(
    //       border: Border.all(color: Colors.black),
    //       borderRadius: BorderRadius.circular(4),
    //     ),
    //     child: Row(
    //       children: [
    //         Expanded(
    //           child: selectedZones.isEmpty
    //               ? Text(
    //             'Velg rute',
    //             style: TextStyle(fontSize: 18),
    //           )
    //               : Text(
    //             selectedZones.join(','),
    //             style: TextStyle(fontSize: 18),
    //           ),
    //         ),
    //         Icon(Icons.arrow_drop_down),
    //       ],
    //     ),
    //   ),
    // );
    return selectedDay.isEmpty ? Container(
      alignment: Alignment.center,
      child: Text("Ingen valgt dag ennå",style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold,color:  Colors.red
      ),),
    ):
    (filteredZones.isEmpty ? Container(
      alignment: Alignment.center,
      child: Text("Denne dagen har ingen plasseringer",style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold,color:  Colors.red
      ),),
    ) : Wrap(
      spacing: 2.0,
      children: filteredZones.map((e){
        return ElevatedButton(
          onPressed: () {
            setState(() {
              if(selectedZones.contains(e['location'])){
                selectedZones.remove(e['location']);
              }else{
                selectedZones.add(e['location']);
              }
            });
          },
          style: ElevatedButton.styleFrom(
              primary: selectedZones.contains(e['location'])? ThemeHelper.buttonPrimaryColor : Colors.black54,
              minimumSize: Size(90,30)
          ),
          child: Text(e['location'],style: TextStyle(
            color: Colors.white
          ),),
        );
      }).toList(),
    ));
  }

  // void _showMultiSelectZoneOptionsDialog() async{
  //   await showDialog(
  //     context: context,
  //     builder: (context) => StatefulBuilder(
  //       builder: (context,setState){
  //         return AlertDialog(
  //           title: Text('Velg rute'),
  //           content: SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.stretch,
  //               children: [
  //                 Wrap(
  //                   spacing: 8,
  //                   runSpacing: 8,
  //                   children: selectedZones.map((zone) {
  //                     return Chip(
  //                       label: Text(zone),
  //                       onDeleted: () {
  //                         setState(() {
  //                           selectedZones.remove(zone);
  //                         });
  //                       },
  //                     );
  //                   }).toList(),
  //                 ),
  //                 SizedBox(height: 16),
  //                 Divider(),
  //                 SizedBox(height: 16),
  //                 ...zones.map((zone) {
  //                   bool isSelected = selectedZones.contains(zone);
  //                   return GestureDetector(
  //                     onTap: () {
  //                       setState(() {
  //                         if (isSelected) {
  //                           selectedZones.remove(zone);
  //                         } else {
  //                           if(!selectedZones.contains(zone)){
  //                             selectedZones.add(zone);
  //                           }
  //                         }
  //                       });
  //                     },
  //                     child: Container(
  //                       padding: EdgeInsets.symmetric(vertical: 16),
  //                       decoration: BoxDecoration(
  //                         border: Border(bottom: BorderSide(color: Colors.black)),
  //                       ),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Text(
  //                             zone,
  //                             style: TextStyle(fontSize: 18),
  //                           ),
  //                           Icon(
  //                             isSelected ? Icons.check_box : Icons.check_box_outline_blank,
  //                             color: isSelected ? ThemeHelper.buttonPrimaryColor : Colors.black,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   );
  //                 }).toList(),
  //               ],
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Text('Ferdig'),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  //
  //   setState(() {});
  // }

  void _showMultiSelectZoneOptionsDialog() async {
    List<String> initialSelectedZones = List.from(selectedZones);

    await showModalBottomSheet(
      context: context,
      enableDrag: true,
      builder: (context) {
        return MultiSelectChipDisplay(
          items: zones.cast()
              .map((zone) => MultiSelectItem<String>(zone['location'], zone['location']))
              .toList(),
          textStyle: TextStyle(
            color: Colors.white
          ),
          onTap: (value){
            if(selectedZones.contains(value)){
              selectedZones.remove(value);

              setState(() {

              });
            }else{
              selectedZones.add(value);
              setState(() {

              });
            }
          },
          chipColor: Theme.of(context).primaryColor, // Set the default chip color
        );
      },
    );
  }





  Widget buildDayOfWeekButtons() {
    return Wrap(
      spacing: 4.0,
      children: daysOfWeek.map((day) {
        return ElevatedButton(
          onPressed: () {
            setState(() {
              selectedDay = day;
              selectedPeriod = '';
              selectedZones.clear();
              filteredZones = zones.where((zone) {
                List<String> zoneDays = List<String>.from(zone['days']);
                print(zoneDays);
                bool containsDay = zoneDays.contains(selectedDay.toLowerCase());
                return containsDay;
              }).toList();
            });
          },
          style: ElevatedButton.styleFrom(
            primary: selectedDay == day ? ThemeHelper.buttonPrimaryColor : Colors.black54,
            minimumSize: Size(40,30)
          ),
          child: Text(day,style: TextStyle(color: Colors.white),),
        );
      }).toList(),
    );
  }

  Widget buildPeriodButtons() {

    return Wrap(
      spacing: 8.0,
      children: periods.map((period) {
        return ElevatedButton(
          onPressed: () {
            if(selectedDay == ''){
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Feil'),
                  content: Text('Velg Dag først'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            }else{
              setState(() {
                selectedPeriod = period;

                filteredZones = zones.where((zone){
                  return (zone['shifts'] as List).contains(selectedPeriod.toLowerCase())
                      && (zone['days'] as List).contains(selectedDay.toLowerCase());
                }).toList();
              });
            }
          },
          style: ElevatedButton.styleFrom(
              primary: selectedPeriod == period ? ThemeHelper.buttonPrimaryColor : Colors.black54,
              minimumSize: Size(50, 30)
          ),
          child: Text(period,style: TextStyle(color: Colors.white)),
        );

      }).toList(),
    );
  }}



