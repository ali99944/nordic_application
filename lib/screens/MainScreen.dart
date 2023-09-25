import 'dart:convert';
import 'dart:io';

import 'package:car_app/helpers/theme_helper.dart';
import 'package:car_app/screens/LoginScreen.dart';
import 'package:car_app/screens/car_number_choice.dart';
import 'package:car_app/screens/notifications_screen.dart';
import 'package:car_app/screens/splash_screen.dart';
import 'package:car_app/screens/swipper_switch.dart';
import 'package:car_app/services/driver_service.dart';
import 'package:car_app/widgets/custom_bottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottom(),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/bil.png',
                  width: 220,
                  height: 220,
                ),
                FutureBuilder(
                  future: SharedPreferences.getInstance(),
                  builder: (BuildContext context,
                      AsyncSnapshot<SharedPreferences> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Noe gikk galt"),
                      );
                    }

                    if (snapshot.data != null) {
                      return Center(
                        child: Text(
                          'Hei ${snapshot.data!.getString('username')}',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    return Container();
                  },
                ),
                SizedBox(height: 10),
                Container(
                  height: 170,
                  padding: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      color: Color(0xFFECE9E9),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Text(
                    'Du skal alltid se over bilen og forsikre deg om at den er iht. Reglement før du kjører ut. Det erdu som sjåfør som er ansvarlig for at bilen du kjører er I forsvalig stand.Blir du stoppet av politi / bilsakkyndig I bil som ikke er I forsvarlig stand, er det du som sjåførsom blir holdt ansvarlig',
                    textAlign: TextAlign.justify,
                    textWidthBasis: TextWidthBasis.parent,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Birco',
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to Form 1 screen to fill the form
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CarNumberChoiceScreen()));
                          },
                          child: Container(
                            height: 60,
                            width: 80,
                            alignment: Alignment.center,
                            color: ThemeHelper.buttonPrimaryColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.drive_eta,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Skjema',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            if (await canLaunchUrl(Uri.parse(
                                'https://skademelding.naf.no/opprett'))) {
                              launchUrl(Uri.parse(
                                  'https://skademelding.naf.no/opprett'));
                            }
                          },
                          child: Container(
                              height: 60,
                              color: ThemeHelper.buttonPrimaryColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.web,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    'Skademelding',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences shared =
                            await SharedPreferences.getInstance();
                        if (shared.containsKey('token'))
                          await shared.remove('token');

                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return SplashScreen(token: null);
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity:
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
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
                        height: 40,
                        width: 40,
                        child: Icon(
                          Icons.logout,
                          color: Colors.red,
                          size: 40,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                    FutureBuilder(
                      future: SharedPreferences.getInstance(),
                      builder: (BuildContext context,
                          AsyncSnapshot<SharedPreferences> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.amber,
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              snapshot.error.toString(),
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        }

                        if (snapshot.data != null) {
                          return Badge(
                            child: IconButton(
                              onPressed: () async {
                                SharedPreferences shared =
                                    await SharedPreferences.getInstance();
                                await shared.remove('notified');
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return NotificationsScreen();
                                    },
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity:
                                            Tween<double>(begin: 0.0, end: 1.0)
                                                .animate(
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
                              icon: Icon(
                                Icons.notifications,
                                size: 40,
                                color: ThemeHelper.buttonPrimaryColor,
                              ),
                            ),
                          );
                        }

                        return Container();
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Form1Screen extends StatefulWidget {
  @override
  _Form1ScreenState createState() => _Form1ScreenState();
}

class _Form1ScreenState extends State<Form1Screen> {
  List<Map<String, dynamic>> form1Results = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      body: FutureBuilder(
        future: DriverService.getFormFields(formName: 'First'),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    backgroundColor: ThemeHelper.buttonPrimaryColor,
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    'Laster inn bilskjema',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Noe gikk galt"),
            );
          }

          if (snapshot.data != null) {
            return FormCard(
              formFields: snapshot.data!,
              results: form1Results,
              onFormSubmitted: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return Form2Screen(form1Results);
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
              },
            );
          } else {
            return Text('');
          }
        },
      ),
    );
  }
}

class Form2Screen extends StatefulWidget {
  final List<Map<String, dynamic>> form1Results;

  Form2Screen(this.form1Results);

  @override
  _Form2ScreenState createState() => _Form2ScreenState();
}

class _Form2ScreenState extends State<Form2Screen> {
  List<Map<String, dynamic>> form2Results = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      body: FutureBuilder(
        future: DriverService.getFormFields(formName: 'Second'),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    backgroundColor: ThemeHelper.buttonPrimaryColor,
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    'Laster inn dagenskjema',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Noe gikk galt"),
            );
          }

          return FormCard(
            formFields: snapshot.data!,
            results: form2Results,
            onFormSubmitted: () {
              // Merge Form 1 and Form 2 results before navigating to DriverProfileScreen
              List<Map<String, dynamic>> combinedResults = [
                ...widget.form1Results,
                ...form2Results
              ];

              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return DriverProfileScreen(combinedResults);
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
            },
          );
        },
      ),
    );
  }
}

class FormCard extends StatefulWidget {
  final List formFields;
  final List<Map<String, dynamic>> results;
  final VoidCallback onFormSubmitted;

  FormCard(
      {required this.formFields,
      required this.results,
      required this.onFormSubmitted});

  @override
  _FormCardState createState() => _FormCardState();
}

class _FormCardState extends State<FormCard> {
  Map<String, dynamic> _formValues = {};
  String? _imageFilePath;
  List _imageFilePaths = [];

  String _readFileName = "";
  String? _readFilePath;
  int currentIndex = 0;
  Map<String, bool> _showYesFields = {};
  GlobalKey<FormState>? _formKey;
  void nextPage() {
    if (currentIndex < widget.formFields.length - 1) {
      currentIndex++;
      _formKey = null;
      setState(() {});
      _pageController.nextPage(
          duration: Duration(milliseconds: 1000), curve: Curves.easeInOut);
    } else {
      widget.results.clear();
      _formKey = null;
      for (var key in _formValues.keys) {
        widget.results.add({
          'title': key,
          'value': _formValues[key],
          'answerDataType': widget.formFields
              .firstWhere((field) => field['title'] == key)['answerDataType'],
          'hasRequiredDescription': widget.formFields.firstWhere(
              (field) => field['title'] == key)['hasRequiredDescription'],
          'whenToGetDescription': widget.formFields.firstWhere(
              (field) => field['title'] == key)['whenToGetDescription'],
          'id': widget.formFields
              .firstWhere((field) => field['title'] == key)['_id'],
          'group': widget.formFields
              .firstWhere((field) => field['title'] == key)['group']['_id'],
          'form': widget.formFields
              .firstWhere((field) => field['title'] == key)['form'],
        });
      }

      widget.onFormSubmitted();
    }
  }

  void previousPage() {
    if (currentIndex > 0) {
      currentIndex--;
      _pageController.previousPage(
          duration: Duration(milliseconds: 1000), curve: Curves.easeInOutCubic);
      setState(() {});
    }
  }

  PageController _pageController = PageController();
  Color primaryColor = Color(0xFF3498db);
  Color accentColor = Color(0xFF2ecc71);
  Color backgroundColor = Colors.white;
  TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  TextStyle labelTextStyle = TextStyle(
    fontSize: 18,
    color: Colors.grey,
  );

  TextStyle buttonTextStyle = TextStyle(
    fontSize: 18,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> field_ =
        widget.formFields.isEmpty ? {} : widget.formFields[currentIndex];
    bool showYesField = _showYesFields[field_['title']] ?? false;
    _formKey = GlobalKey<FormState>();

    return Scaffold(
      bottomNavigationBar: Visibility(
          visible: currentIndex < widget.formFields.length ||
              widget.formFields.isNotEmpty,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentIndex > 0)
                  ElevatedButton(
                    child: Text(
                      'Tilbake'.toUpperCase(),
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    onPressed: previousPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                ElevatedButton(
                  child: Text(
                    'Neste'.toUpperCase(),
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  onPressed: () {
                    if (_formKey!.currentState!.validate()) {
                      nextPage();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                ),
              ],
            ),
          )),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: widget.formFields.map((field) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.formFields.isNotEmpty)
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (field['answerDataType'] == 'yes_no')
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check,
                                      size: 30, color: accentColor),
                                  Text(' -- ',
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.black)),
                                  Icon(Icons.close, color: Colors.red),
                                ],
                              ),
                            if (field['answerDataType'] == 'image')
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.image_outlined,
                                  size: 30,
                                ),
                              ),
                            if (field['answerDataType'] == 'text')
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.text_fields,
                                  size: 30,
                                ),
                              ),
                            SizedBox(height: 20),
                            Text(
                              field['title'],
                              style: titleStyle,
                            ),
                            SizedBox(height: 8),
                            Container(
                              child: Text(
                                field['requiredDescription'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily:
                                      'Birco', // Replace with your custom font's name
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            if (field['answerDataType'] == 'text')
                              TextFormField(
                                onChanged: (value) {
                                  _formValues[field['title']] = value;
                                },
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Vennligst skriv inn noe";
                                  }
                                  return null;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  labelText: 'Skriv inn tekst her',
                                  hintText: field['requiredDescription'],
                                  border: OutlineInputBorder(),
                                  fillColor: backgroundColor,
                                ),
                              ),
                            if (field['answerDataType'] == 'number')
                              TextFormField(
                                onChanged: (value) {
                                  _formValues[field['title']] = value;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (val) {
                                  // Add your number validation logic here
                                  return null; // Return null or an error message based on validation result
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Skriv nummer her',
                                  hintText: field['requiredDescription'],
                                  border: OutlineInputBorder(),
                                  fillColor: backgroundColor,
                                ),
                              ),
                            if (field['answerDataType'] == 'yes_no')
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        child:
                                            Text('Ja', style: buttonTextStyle),
                                        onPressed: () {
                                          if (field['hasRequiredDescription'] &&
                                              field['whenToGetDescription'] ==
                                                  true) {
                                            setState(() {
                                              _showYesFields[field['title']] =
                                                  true;
                                            });
                                          } else {
                                            _formValues[field['title']] = 'Ja';
                                            nextPage();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      ElevatedButton(
                                        child:
                                            Text('Nei', style: buttonTextStyle),
                                        onPressed: () {
                                          setState(() {
                                            if (field['whenToGetDescription'] ==
                                                false) {
                                              _showYesFields[field['title']] =
                                                  true;
                                            } else {
                                              _formValues[field['title']] =
                                                  'Nei';
                                              nextPage();
                                            }
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  if (showYesField)
                                    TextFormField(
                                      onChanged: (value) {
                                        _formValues[field['title']] = value;
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "Skriv inn noe";
                                        }
                                        return null;
                                      },
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                        labelText: 'Skriv det her',
                                        hintText: field['requiredDescription'],
                                        border: OutlineInputBorder(),
                                        fillColor: backgroundColor,
                                      ),
                                    ),
                                ],
                              ),
                            if (field['answerDataType'] == 'file')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      // Add your file picking logic here
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: accentColor,
                                    ),
                                    child: Text(
                                      'Velg Fil'.toUpperCase(),
                                      style: buttonTextStyle,
                                    ),
                                  ),
                                  Text(_readFileName),
                                  // Add file display or preview here if needed
                                ],
                              ),
                            if (field['answerDataType'] == 'image')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      await showModalBottomSheet(
                                        enableDrag: true,
                                        showDragHandle: true,
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            padding: EdgeInsets.all(16.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(
                                                          16.0)),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListTile(
                                                  leading: Icon(Icons.camera),
                                                  title: Text("Ta et bilde"),
                                                  onTap: () async {
                                                    final picker =
                                                        ImagePicker();
                                                    final pickedImage =
                                                        await picker.pickImage(
                                                            source: ImageSource
                                                                .camera);
                                                    if (pickedImage != null) {
                                                      setState(() {
                                                        _imageFilePaths.add(
                                                            pickedImage.path);
                                                        _formValues[field[
                                                                'title']] =
                                                            _imageFilePaths;
                                                      });
                                                    }
                                                    // Implement the logic for taking a picture
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                Divider(),
                                                ListTile(
                                                  leading:
                                                      Icon(Icons.photo_library),
                                                  title:
                                                      Text("Velg fra Galleri"),
                                                  onTap: () async {
                                                    final picker =
                                                        ImagePicker();
                                                    final pickedImages =
                                                        await picker
                                                            .pickMultiImage();
                                                    if (pickedImages
                                                        .isNotEmpty) {
                                                      setState(() {
                                                        for (var pickedImage
                                                            in pickedImages) {
                                                          _imageFilePaths.add(
                                                              pickedImage.path);
                                                          _formValues[field[
                                                                  'title']] =
                                                              _imageFilePaths;
                                                        }
                                                      });
                                                    }
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                SizedBox(height: 16.0),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Avbryt",
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                    ),
                                    child: Text(
                                      'Velg Bilde'.toUpperCase(),
                                      style: buttonTextStyle,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  if (_imageFilePaths.isNotEmpty)
                                    SizedBox(
                                      height: 200,
                                      child: GridView(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount:
                                                    _imageFilePaths.length > 3
                                                        ? 3
                                                        : _imageFilePaths
                                                            .length),
                                        children: _imageFilePaths.map((e) {
                                          return Container(
                                            width: double.infinity,
                                            height: 160,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: Image.file(
                                                  File(e!),
                                                  fit: BoxFit.cover,
                                                ).image,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                ],
                              ),
                            if (field['answerDataType'] == 'date')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    field['title'],
                                    style: titleStyle,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      // Add your date picking logic here
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: accentColor,
                                    ),
                                    child: Text(
                                      'Velg Dato',
                                      style: buttonTextStyle,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  if (_formValues[field['title']] != null)
                                    Text(
                                      'Valgt dato: ${DateTime.parse(_formValues[field['title']]).toLocal()}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                ],
                              ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
          Positioned(
            child: Image.asset(
              'assets/bil.png',
              width: 100,
              height: 100,
            ),
            top: 10,
            left: 10,
          )
        ],
      ),
    );
  }
}

class DriverProfileScreen extends StatelessWidget {
  final List<Map<String, dynamic>> results;

  DriverProfileScreen(this.results);

  void _showSuccessPopup(BuildContext context) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Takk skjemaet er sendt.'),
          content: Text(
            'ved å klikke ok blir du logget ut.',
            style: TextStyle(backgroundColor: ThemeHelper.buttonPrimaryColor),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                SharedPreferences shared =
                    await SharedPreferences.getInstance();
                if (shared.containsKey('token')) await shared.remove('token');

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => SignInScreen()),
                    (Route<dynamic> route) => false);
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
      animationType: DialogTransitionType.scale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 300),
    );
  }

  void _showErrorPopup(BuildContext context, dynamic error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Feil'),
        content: Text('En feil oppstod: $error'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _uploadData(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );

      await DriverService.createNewDriver(driverData: results).then((value) {
        // Hide the loading indicator whether the operation succeeds or fails
        Navigator.pop(context);

        _showSuccessPopup(context);
      }).catchError((onError) {
        _showErrorPopup(context, onError.toString());
      });
    } catch (error) {
      // Handle the error if the createNewDriver function throws an exception
      Navigator.pop(context); // Close the loading dialog
      _showErrorPopup(
          context, error); // Show an error popup or handle the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        padding: const EdgeInsets.all(8.0),
        child: SwipeToUnlockSwitch(
          onSwipeEnd: () {
            _uploadData(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilder(
                future: SharedPreferences.getInstance(),
                builder: (BuildContext context,
                    AsyncSnapshot<SharedPreferences> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Noe gikk galt"),
                    );
                  }

                  if (snapshot.data != null) {
                    Map data = jsonDecode(snapshot.data!.getString('data')!);
                    return Container(
                      color: Colors.black12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ListTile(
                            leading: Icon(Icons.location_city),
                            title: Text('plassering'),
                            subtitle: Text("${data['locations']}"),
                          ),
                          ListTile(
                            leading: Icon(Icons.local_taxi),
                            title: Text('Bil'),
                            subtitle: Text(
                                "${data['boardNumber']}  -  ${data['privateNumber']}"),
                          ),
                          ListTile(
                            leading: Icon(Icons.access_time),
                            title: Text('Skifte'),
                            subtitle:
                                Text("${data['day']}  -  ${data['period']}"),
                          ),
                          ListTile(
                            leading: Icon(Icons.error),
                            title: Text('K.S'),
                            subtitle: Text("${data['trafficViolations']}"),
                          ),
                          ListTile(
                            leading: Icon(Icons.date_range),
                            title: Text('Dato'),
                            subtitle: Text("${data['date']}"),
                          ),
                        ],
                      ),
                    );
                  }

                  return Container();
                },
              ),
              for (var entry in results)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (entry['answerDataType'] == 'text' ||
                        entry['answerDataType'] == 'number')
                      ListTile(
                        leading: Icon(Icons.text_fields),
                        title: Text(entry['title']),
                        subtitle: Text(entry['value'].toString()),
                      ),
                    if (entry['answerDataType'] == 'yes_no')
                      ListTile(
                        leading: Icon(Icons.check_box),
                        title: Text(entry['title']),
                        subtitle: Text(entry['value']),
                      ),
                    if (entry['answerDataType'] == 'file')
                      ListTile(
                        leading: Icon(Icons.attach_file),
                        title: Text(entry['title']),
                        subtitle: Text('Fil: ${entry['value']}'),
                      ),
                    if (entry['answerDataType'] == 'image')
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.image,
                                  color: Colors.black38,
                                ),
                                Text(entry['title'])
                              ],
                            ),
                            Row(
                              children: (entry['value'] as List).map((e) {
                                print(e);
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.file(
                                      File(e),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    Divider(),
                  ],
                ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
